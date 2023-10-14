import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_app/services/auth.dart';
import 'package:time_tracker_app/services/database.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key, required this.databaseBuilder}) : super(key: key);
  final Database? Function(String) databaseBuilder;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {

  late AuthBase auth;

  @override
  void initState() {
    auth = Provider.of<AuthBase>(context, listen: false);
    auth.authStateChanges().listen((User? user) {
      if(user !=null) {
          context.go('/jobs');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          if (user == null) {
            return SignInPage.create(context);
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
