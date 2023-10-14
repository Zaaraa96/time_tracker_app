import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/routes.dart';
import 'package:time_tracker_app/services/auth.dart';

import 'firebase_options.dart';

//todo: 1.add add routes with go_router
//todo: 2.put all navigation in one file
//todo: 3.add locale support for farsi
//todo: 4.add sign in with email and password and reset password in  account screen
//todo: 5.make app feature first
//todo: 6.add repository pattern
//todo: 7.add icon for app

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<AuthBase>(
      create: (context) => Auth(),
      child: MaterialApp.router(
      routerConfig: routers,
        title: 'Time Tracker',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
        // home: LandingPage(
        //   databaseBuilder: (uid) => FirestoreDatabase(uid: uid),
        // ),
      ),
    );
  }
}
