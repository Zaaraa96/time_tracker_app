import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/jobs/model/job.dart';
import 'package:time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/services/database.dart';
import '../../../navigation.dart';
import 'job_list_tile.dart';
import '../../../common_widgets/list_items_builder.dart';

class JobsPage extends StatelessWidget {
  const JobsPage({super.key, required this.uid});
  final String uid;


  Future<void> _delete(BuildContext context, Job job) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteJob(job);
    } on FirebaseException catch (e) {
      showExceptionAlertDialog(
        context,
        title: 'Operation failed',
        exception: e,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jobs'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () => goToEditJob(context,),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    return StreamBuilder<List<Job>>(
      stream: FirestoreDatabase(uid: uid).jobsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Job>(
          snapshot: snapshot,
          itemBuilder: (context, job) => Dismissible(
            key: Key('job-${job.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, job),
            child: JobListTile(
              job: job,
              onTap: () => goToJobEntries(context,job: job),
            ),
          ),
        );
      },
    );
  }
}
