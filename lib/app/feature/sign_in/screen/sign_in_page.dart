import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/app/feature/sign_in/screen/sign_in_button.dart';
import 'package:time_tracker_app/app/feature/sign_in/screen/social_sign_in_button.dart';
import '../../../../localization.dart';
import 'package:time_tracker_app/common_widgets/show_exception_alert_dialog.dart';
import 'package:time_tracker_app/app/services/auth.dart';

import '../../../../navigation.dart';
import '../bloc/sign_in_manager.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({
    Key? key,
    required this.manager,
    required this.isLoading,
  }) : super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static const Key emailPasswordKey = Key('email-password');

  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
            builder: (_, manager, __) =>
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
        ),
      ),
    );
  }

  void _showSignInError(BuildContext context, Exception exception) {
    if (exception is FirebaseException &&
        exception.code == 'ERROR_ABORTED_BY_USER') {
      return;
    }
    showExceptionAlertDialog(
      context,
      title: 'Sign in failed',
      exception: exception,
    );
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e) {
      _showSignInError(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Time Tracker')),
        elevation: 2.0,
      ),
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(
            height: 50.0,
            child: _buildHeader(context),
          ),
          SizedBox(height: 48.0),


          // buildSignInButton(
          //   onPressed: isLoading ? null : () => _signInWithGoogle(context),
          // ),
          if(!kIsWeb)
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: AppLocalizations.of(context).translate('Sign in with Google'),
            textColor: Colors.black87,
            color: Colors.white,
            onPressed: isLoading ? null : () => _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),

          SizedBox(height: 8.0),
          SignInButton(
            key: emailPasswordKey,
            text: AppLocalizations.of(context).translate('Sign in with email'),
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: isLoading ? null : () => goToSignIn(context),
          ),
          SizedBox(height: 8.0),
          Text(
            AppLocalizations.of(context).translate('or'),
            style: TextStyle(fontSize: 14.0, color: Colors.black87),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: AppLocalizations.of(context).translate('Go anonymous'),
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: isLoading ? null : () => _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      AppLocalizations.of(context).translate('Sign in'),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
