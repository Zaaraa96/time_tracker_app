import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/feature/jobs/screen/jobs_page.dart';
import 'package:time_tracker_app/app/feature/sign_in/screen/sign_in_page.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/routes.dart';

import 'mocks.dart';
@GenerateNiceMocks([MockSpec<AuthBase>(), MockSpec<User>()])
import 'landing_page_test.mocks.dart';

void main() {
  late MockAuthBase mockAuth;
  late MockDatabase mockDatabase;
  late StreamController<User?> onAuthStateChangedController;

  setUp(() {
    mockAuth = MockAuthBase();
    mockDatabase = MockDatabase();
    onAuthStateChangedController = StreamController<User?>();
  });

  tearDown(() {
    onAuthStateChangedController.close();
  });

  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: Consumer<AuthBase>(
          builder: (BuildContext context, AuthBase auth, Widget? child) {
           return MaterialApp.router(
              routerConfig: routers(auth),
              // home: LandingPage(
              //   databaseBuilder: (_) => mockDatabase,
              // ),
            );
          },
        ),
      ),
    );
    await tester.pump();
  }

  void stubOnAuthStateChangedYields(Iterable<User?> onAuthStateChanged) {

    onAuthStateChangedController.addStream(
      Stream<User?>.fromIterable(onAuthStateChanged),
    );
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });
  }

  testWidgets('stream waiting', (WidgetTester tester) async {

    stubOnAuthStateChangedYields([]);

    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('null user', (WidgetTester tester) async {

    stubOnAuthStateChangedYields([null]);

    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (WidgetTester tester) async {
    when(MockUser().uid).thenReturn('123');

    stubOnAuthStateChangedYields([MockUser()]);

    await pumpLandingPage(tester);
    await tester.pumpAndSettle();

    expect(find.byType(JobsPage), findsOneWidget);
  });
}