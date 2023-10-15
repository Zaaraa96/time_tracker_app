import 'dart:async';
import 'package:time_tracker_app/app/services/auth.dart';
import 'package:rxdart/rxdart.dart';
import '../model/password_reset_model.dart';


class PasswordResetBloc {
  PasswordResetBloc({required this.auth});
  final AuthBase? auth;

  final _modelSubject = BehaviorSubject<PasswordResetModel>.seeded(PasswordResetModel());
  Stream<PasswordResetModel> get modelStream => _modelSubject.stream;
  PasswordResetModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {

        await auth!.confirmResetPassword(_model.code, _model.newPassword);

    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    } finally{
      updateWith(showTextFields: false);
    }
  }
  Future<void> sendCode() async {
    updateWith(isLoading: true);
    try {
        await auth!.sendResetPasswordEmail(auth!.currentUser!.email!);
        updateWith(showTextFields: true);
    } catch (e) {
      rethrow;
    }
    updateWith(isLoading: false);
  }


  void updateCode(String code) => updateWith(code: code);

  void updatePassword(String password) => updateWith(newPassword: password);

  void updateWith({
    String? newPassword,
    String? code,
    bool? isLoading,
    bool? submitted,
    bool? showTextFields,
  }) {
    // update model
    _modelSubject.value = _model.copyWith(
      newPassword: newPassword,
      code: code,
      isLoading: isLoading,
      submitted: submitted,
      showTextFields: showTextFields,
    );
  }
}