import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_app/app/feature/sign_in/screen/sign_in_page.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';


import 'robot.dart';
@GenerateNiceMocks([MockSpec<AuthBase>(), MockSpec<NavigatorObserver>(), MockSpec<Database>()])
import 'sign_in_page_test.mocks.dart';

void main() {
  late MockAuthBase mockAuth;
  late MockNavigatorObserver mockNavigatorObserver;
  late MockDatabase mockDatabase;
  setUp(() {
    mockAuth = MockAuthBase();
    mockNavigatorObserver = MockNavigatorObserver();
    mockDatabase = MockDatabase();
  });

  testWidgets('email & password navigation', (WidgetTester tester) async {
    final r = AuthRobot(tester);

    when(mockAuth.currentUser).thenReturn(null);

    await r.pumpMaterialAppWithRouter(mockAuth, mockDatabase, observers: [mockNavigatorObserver] );

    verify(mockNavigatorObserver.didPush(any, any)).called(1);

    final emailSignInButton = find.byKey(SignInPage.emailPasswordKey);
    expect(emailSignInButton, findsOneWidget);

    await tester.tap(emailSignInButton);
    await tester.pumpAndSettle();

    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });
}
