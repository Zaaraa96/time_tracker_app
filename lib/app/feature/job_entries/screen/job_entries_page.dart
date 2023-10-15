import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/app/services/database.dart';
import '../../../../common_widgets/list_items_builder.dart';
import '../../../../navigation.dart';
import '../../entries/model/entry.dart';
import '../../jobs/model/job.dart';
import 'entry_list_item.dart';

class JobEntriesPage extends StatelessWidget {
  const JobEntriesPage({super.key, required this.database, required this.job});
  final Database database;
  final Job job;

  Future<void> _deleteEntry(BuildContext context, Entry entry) async {
    try {
      await database.deleteEntry(entry);
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
    return StreamBuilder<Job>(
        stream: database.jobStream(jobId: job.id),
        builder: (context, snapshot) {
          final job = snapshot.data;
          final jobName = job?.name ?? '';
          return Scaffold(
            appBar: AppBar(
              elevation: 2.0,
              title: Text(jobName),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.white),
                  onPressed: () => goToEditJob(context, job: job,),
                ),
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () =>  goToEntryPage(context, job: job, entry: null,),
                ),
              ],
            ),
            body: _buildContent(context, job),
          );
        });
  }

  Widget _buildContent(BuildContext context, Job? job) {
    return StreamBuilder<List<Entry>>(
      stream: database.entriesStream(job: job),
      builder: (context, snapshot) {
        return ListItemsBuilder<Entry>(
          snapshot: snapshot,
          itemBuilder: (context, entry) {
            return DismissibleEntryListItem(
              key: Key('entry-${entry.id}'),
              entry: entry,
              job: job,
              onDismissed: () => _deleteEntry(context, entry),
              onTap: () => goToEntryPage(context, job: job, entry: entry,)
            );
          },
        );
      },
    );
  }
}
