import 'package:time_tracker_app/app/entries/model/entry.dart';
import 'package:time_tracker_app/app/jobs/model/job.dart';

class EntryJob {
  EntryJob(this.entry, this.job);

  final Entry entry;
  final Job? job;
}
