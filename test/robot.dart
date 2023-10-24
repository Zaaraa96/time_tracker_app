

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:time_tracker_app/app/services/database.dart';
import 'package:time_tracker_app/routes.dart';


class AuthRobot {
  AuthRobot(this.tester);
  final WidgetTester tester;

  Future<void> pumpMaterialAppWithRouter(AuthBase mockAuth, Database mockDatabase) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: Consumer<AuthBase>(
          builder: (BuildContext context, AuthBase auth, Widget? child) {
            return MaterialApp.router(
              routerConfig: routers(auth, mockDatabase),
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

  Future<void> tapSignInButton() async {

    await tester.pump();
    final signInGoogleButton = find.text('Sign in with Google');
    expect(signInGoogleButton, findsOneWidget);
    await tester.tap(signInGoogleButton);
    await tester.pumpAndSettle();

  }

}
