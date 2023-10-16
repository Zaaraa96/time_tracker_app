import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/app/services/database.dart';

import '../../../../localization.dart';
import '../../../../navigation.dart';
import '../model/job.dart';


class EditJobPage extends StatefulWidget {
  const EditJobPage({Key? key, required this.database, this.job}) : super(key: key);
  final Database? database;
  final Job? job;

  @override
  State<EditJobPage> createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  String? _name;
  int? _ratePerHour;


  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job!.name;
      _ratePerHour = widget.job!.ratePerHour;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database!.jobsStream().first;
        final allNames = jobs.map((Job job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job!.name);
        }
        if (allNames.contains(_name)) {
          showAlertDialog(
            context,
            title: AppLocalizations.of(context).translate('Name already used'),
            content: AppLocalizations.of(context).translate('Please choose a different job name'),
            defaultActionText: AppLocalizations.of(context).translate('OK'), onActionsPressed: (bool? value) {  },
          );
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database!.setJob(job);
          pop(context);
        }
      } on FirebaseException catch (e) {
        showExceptionAlertDialog(
          context,
          title: AppLocalizations.of(context).translate('Operation failed'),
          exception: e,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.job == null ? AppLocalizations.of(context).translate('New Job') : AppLocalizations.of(context).translate('Edit Job')),
        actions: <Widget>[
          TextButton(
            onPressed: _submit,
            child: Text(
              AppLocalizations.of(context).translate('Save'),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('Job name')),
        initialValue: _name,
        validator: (value) => value!.isNotEmpty ? null : AppLocalizations.of(context).translate('Name can\'t be empty'),
        onSaved: (value) => _name = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('Rate per hour')),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value!) ?? 0,
      ),
    ];
  }
}
