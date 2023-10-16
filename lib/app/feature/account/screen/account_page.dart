
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_app/common_widgets/custom_raised_button.dart';
import 'package:time_tracker_app/common_widgets/show_alert_dialog.dart';
import 'package:time_tracker_app/app/services/auth.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        actions: <Widget>[
          TextButton(
            onPressed: _confirmSignOut,
            child: const Text(
              'Logout',
              style: TextStyle(
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
        child: StreamBuilder<PasswordResetModel>(
          stream: widget.bloc.modelStream,
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return CircularProgressIndicator();
            final PasswordResetModel model = snapshot.data!;
            if(model.isLoading)
              return CircularProgressIndicator();
            if(model.submitted)
              return Container(
                child: Text('password changed'),
              );
            if(model.showTextFields)
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildNewPasswordTextField(model),
                  SizedBox(height: 8.0),
                  _buildCodeTextField(model),
                  SizedBox(height: 16.0),

                  CustomRaisedButton(onPressed: submit,child: Text('confirm reset password'),),
                ],
              ),
            );
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomRaisedButton(onPressed: askToResetPassword,child: Text('reset password'),),
              ],
            );
          }
        ),
      ),
    );
  }
  TextField _buildNewPasswordTextField(PasswordResetModel model) {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
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
        labelText: 'Code',
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
        title: 'verification code sent!',
         content: 'the code has been sent to your email', defaultActionText: 'ok', onActionsPressed: (bool? value) {  },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  void submit() {

  }
}
