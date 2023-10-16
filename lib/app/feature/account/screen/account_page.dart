
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/common_widgets/custom_raised_button.dart';
import 'package:time_tracker_app/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_app/app/services/auth.dart';
import '../../../../localization.dart';
import '../../../services/change_language.dart';
import '../bloc/password_reset_bloc.dart';
import '../model/password_reset_model.dart';
import 'user_info.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key, required this.bloc});
  final PasswordResetBloc bloc;
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    return Provider<PasswordResetBloc>(
      create: (_) => PasswordResetBloc(auth: auth),
      child: Consumer<PasswordResetBloc>(
        builder: (_, bloc, __) => AccountPage(bloc: bloc),
      ),
      dispose: (_, bloc) => bloc.dispose(),
    );
  }
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {

  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  bool? didRequestSignOut;

  @override
  void dispose() {
    _codeController.dispose();
    _passwordController.dispose();
    _codeFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _signOut() async {
    try {
      final auth = Provider.of<AuthBase>(context, listen: false);
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }

  void setValueOfAlertDialog(bool? val){
    setState(() {
      didRequestSignOut = val;
    });
  }

  Future<void> _confirmSignOut() async {
    await showAlertDialog(
      context,
      title: 'Logout',
      content: 'Are you sure that you want to logout?',
      cancelActionText: 'Cancel',
      defaultActionText: 'Logout', onActionsPressed: setValueOfAlertDialog,
    );
    if (didRequestSignOut == true) {
      _signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthBase>(context, listen: false);
    final appLanguage = Provider.of<AppLanguage>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Account')),
        actions: <Widget>[
          TextButton(
            onPressed: _confirmSignOut,
            child:  Text(
              AppLocalizations.of(context).translate('Logout'),
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(130),
          child: auth.currentUser!=null? UserInfoWidget(user: auth.currentUser!,) : Container(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StreamBuilder<PasswordResetModel>(
              stream: widget.bloc.modelStream,
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return CircularProgressIndicator();
                final PasswordResetModel model = snapshot.data!;
                if(model.isLoading)
                  return CircularProgressIndicator();
                if(model.submitted)
                  return Container(
                    child: Text(AppLocalizations.of(context).translate('password changed')),
                  );
                if(model.showTextFields)
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildNewPasswordTextField(model),
                      SizedBox(height: 8.0),
                      _buildCodeTextField(model),
                      SizedBox(height: 16.0),

                      CustomRaisedButton(onPressed: submit,child: Text(AppLocalizations.of(context).translate('confirm reset password')),),
                    ],
                  ),
                );
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomRaisedButton(onPressed: askToResetPassword,child: Text(AppLocalizations.of(context).translate('reset password')),),
                  ],
                );
              }
            ),
            Container(
              height: 100,
              width: 200,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.language),
                    SizedBox(width: 10,),
                    DropdownButton(items: [
                      for( Locale locale in [
                        Locale('en'), // English
                        Locale('fa'), // farsi
                      ])
                      DropdownMenuItem<Locale>(child: Text(locale.languageCode), value: locale,),
                    ],
                        value: appLanguage.appLocal,
                        onChanged:(val)=> onChangedLang(appLanguage,val!, )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  TextField _buildNewPasswordTextField(PasswordResetModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('Password'),
        errorText: model.passwordErrorText,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: () => _passwordEditingComplete(model),
    );
  }

  void _passwordEditingComplete(PasswordResetModel model) {
    final newFocus = model.passwordValidator.isValid(model.newPassword)
        ? _codeFocusNode
        : _passwordFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }


  TextField _buildCodeTextField(PasswordResetModel model) {
    return TextField(
      controller: _codeController,
      focusNode: _codeFocusNode,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context).translate('Code'),
        hintText: '123456',
        errorText: model.codeErrorText,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateCode,
      onEditingComplete: submit,

    );
  }

  Future<void> askToResetPassword() async {
    try {
      await widget.bloc.sendCode();
      showAlertDialog(
        context,
        title: AppLocalizations.of(context).translate('verification code sent!'),
         content: AppLocalizations.of(context).translate('the code has been sent to your email'),
        defaultActionText: AppLocalizations.of(context).translate('ok'), onActionsPressed: (bool? value) {  },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void submit() {

  }

  void onChangedLang(AppLanguage appLanguage,Locale value) {
    appLanguage.changeLanguage(value);
  }
}
