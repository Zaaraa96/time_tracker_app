@Timeout(Duration(milliseconds: 500))

import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/feature/jobs/model/job.dart';
import 'package:time_tracker_app/app/feature/jobs/screen/jobs_page.dart';
import 'package:time_tracker_app/app/feature/sign_in/screen/sign_in_page.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';
import 'package:time_tracker_app/routes.dart';

import '../test/landing_page_test.mocks.dart';
import '../test/robot.dart';


void main() {
  late MockAuthBase mockAuth;
  late MockDatabase mockDatabase;
  late StreamController<User?> onAuthStateChangedController;

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
    mockAuth = MockAuthBase();
    mockDatabase = MockDatabase();
   onAuthStateChangedController = StreamController<User?>();


  tearDown(() {
    onAuthStateChangedController.close();
  });

  testWidgets('Sign in flow', (tester) async {

    final r = AuthRobot(tester);
    when(mockDatabase.jobsStream()).thenAnswer((_)=>Stream<List<Job>>.fromFutures([]));

    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });

    await r.pumpMaterialAppWithRouter(mockAuth, mockDatabase);
    expect(find.byType(SignInPage), findsOneWidget);

    await r.tapSignInButton();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    when(MockUser().uid).thenReturn('123');
    when(mockAuth.currentUser).thenReturn(MockUser());

    onAuthStateChangedController.add(MockUser());

    await tester.pump(Duration(seconds: 1));
    expect(find.byType(JobsPage), findsOneWidget);

  });
}