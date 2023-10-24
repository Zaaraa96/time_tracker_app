import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_app/app/feature/jobs/model/job.dart';
import 'package:time_tracker_app/app/feature/jobs/screen/jobs_page.dart';
import 'package:time_tracker_app/app/feature/sign_in/screen/sign_in_page.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';

@GenerateNiceMocks([MockSpec<AuthBase>(), MockSpec<User>(), MockSpec<Database>()])
import 'landing_page_test.mocks.dart';
import 'robot.dart';

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


  void stubOnAuthStateChangedYields(Iterable<User?> onAuthStateChanged) {

    onAuthStateChangedController.addStream(
      Stream<User?>.fromIterable(onAuthStateChanged),
    );
    when(mockAuth.authStateChanges()).thenAnswer((_) {
      return onAuthStateChangedController.stream;
    });
  }

  testWidgets('stream waiting', (WidgetTester tester) async {
    final r = AuthRobot(tester);
    stubOnAuthStateChangedYields([]);

    await r.pumpMaterialAppWithRouter(mockAuth, mockDatabase);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('null user', (WidgetTester tester) async {
    final r = AuthRobot(tester);
    stubOnAuthStateChangedYields([null]);

    await r.pumpMaterialAppWithRouter(mockAuth, mockDatabase);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non-null user', (WidgetTester tester) async {
    final r = AuthRobot(tester);
    when(MockUser().uid).thenReturn('123');

    when( mockAuth.currentUser).thenReturn(MockUser());
    when(mockDatabase.jobsStream()).thenAnswer((_)=>Stream<List<Job>>.fromFutures([]));

    stubOnAuthStateChangedYields([MockUser()]);

    await r.pumpMaterialAppWithRouter(mockAuth, mockDatabase);

    expect(find.byType(JobsPage), findsOneWidget);
  });
}