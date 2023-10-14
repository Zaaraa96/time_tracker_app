
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app/jobs/model/job.dart';

void goToEditJob(BuildContext context, {Job? job}){
  context.pushNamed('edit-job',extra: job);
}

void goToJobs(BuildContext context, {Job? job}){
  context.go('/jobs');
}