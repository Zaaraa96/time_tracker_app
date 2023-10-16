import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/routes.dart';
import 'package:time_tracker_app/app/services/auth.dart';

import 'firebase_options.dart';

// ignore:depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';

//1.add all routes with go_router
//2.put all navigation in one file
//todo: 3.add locale support for farsi
//4.add sign in with email and password and reset password in  account screen
//5.make app feature first
//todo: 6.add repository pattern
//7.add icon for app done
//todo: 8.test
//todo: 9.build for web
//todo: 10.update read me

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // turn off the # in the URLs on the web
  usePathUrlStrategy();
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
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'), // English
          Locale('fa'), // farsi
        ],
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
