
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app/entries/model/entry.dart';
import 'app/jobs/model/job.dart';

//todo: add route names

void goToEditJob(BuildContext context, {Job? job}){
  context.pushNamed('edit-job',extra: job);
}
void goToSignIn(BuildContext context){
  context.pushNamed('signIn');
}
void goToLanding(BuildContext context){
  context.go('/');
}

void goToJobs(BuildContext context){
  context.go('/jobs');
}

void goToJobEntries(BuildContext context, {required Job job}){
  context.goNamed('job-entries',extra: job);
}

class EntryJobCombinedModel{
   Job? job;
   Entry? entry;
EntryJobCombinedModel({required this.job,required this.entry});
}

void goToEntryPage(BuildContext context, {required Job? job, required Entry? entry}){
  context.goNamed('job-entry',extra: EntryJobCombinedModel(job: job, entry: entry));
}

void pop(BuildContext context){
  context.pop();
}