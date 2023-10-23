import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_app/app/feature/jobs/model/job.dart';

void main() {
  group('fromMap', () {

    test('job with all properties', () {
      final job = Job.fromMap({
        'name': 'Blogging',
        'ratePerHour': 10,
      }, 'abc');
      expect(job, Job(name: 'Blogging', ratePerHour: 10, id: 'abc'));
    });

    test('missing name', () {
      final job = Job.fromMap({
        'ratePerHour': 10,
      }, 'abc');
      expect(job, Job(name: null, ratePerHour: 10, id: 'abc'));
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(name: 'Blogging', ratePerHour: 10, id: 'abc');
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });
}