
import '../bloc/password_reset_validator.dart';

class PasswordResetModel with PasswordResetValidators {
  PasswordResetModel({this.showTextFields = false,
    this.code='',
    this.newPassword = '',
    this.isLoading = false,
    this.submitted = false,
  });

  final String newPassword;
  final String code;
  final bool isLoading;
  final bool showTextFields;
  final bool submitted;


  bool get canSubmit {
    return codeValidator.isValid(code) &&
        passwordValidator.isValid(newPassword) &&
        !isLoading;
  }

  String? get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(newPassword);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String? get codeErrorText {
    bool showErrorText = submitted && !codeValidator.isValid(code);
    return showErrorText ? invalidCodeErrorText : null;
  }

  PasswordResetModel copyWith({
    String? newPassword,
    String? code,
    bool? isLoading,
    bool? submitted,
    bool? showTextFields,
  }) {
    return PasswordResetModel(
      newPassword: newPassword ?? this.newPassword,
      code: code ?? this.code,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
        showTextFields: showTextFields ?? this.showTextFields,
    );
  }

  @override
  int get hashCode =>
      Object.hash(code, newPassword, isLoading, submitted, showTextFields);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (other is PasswordResetModel) {
      if (runtimeType != other.runtimeType) return false;
      final PasswordResetModel otherModel = other;
      return code == otherModel.code &&
          newPassword == otherModel.newPassword &&
          isLoading == otherModel.isLoading &&
          submitted == otherModel.submitted &&
          showTextFields == otherModel.showTextFields;
    }
    return false;
  }

  @override
  String toString() =>
      'code: $code, newPassword: $newPassword, isLoading: $isLoading, submitted: $submitted, showTextFields: $showTextFields';

}
