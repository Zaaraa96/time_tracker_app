
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/feature/entries/model/entry.dart';
import 'app/feature/jobs/model/job.dart';
const editJob = 'editJob';
void goToEditJob(BuildContext context, {Job? job}){
  context.pushNamed(editJob,extra: job);
}
const signIn = 'signIn';
void goToSignIn(BuildContext context){
  context.pushNamed(signIn);
}
const landing= 'landing';
void goToLanding(BuildContext context){
  context.goNamed(landing);
}
const jobs = 'jobs';
void goToJobs(BuildContext context){
  context.goNamed(jobs);
}
const jobEntries = 'jobEntries';
void goToJobEntries(BuildContext context, {required Job job}){
  context.goNamed(jobEntries,extra: job);
}

class EntryJobCombinedModel{
   Job? job;
   Entry? entry;
EntryJobCombinedModel({required this.job,required this.entry});
}
const jobEntry = 'jobEntry';
void goToEntryPage(BuildContext context, {required Job? job, required Entry? entry}){
  context.goNamed(jobEntry,extra: EntryJobCombinedModel(job: job, entry: entry));
}

void pop(BuildContext context){
  context.pop();
}

const account = 'account';
const entries = 'entries';