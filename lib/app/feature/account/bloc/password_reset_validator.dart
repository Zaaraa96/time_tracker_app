
import '../../../../utils.dart';

class PasswordResetValidators {
  final StringValidator passwordValidator = NonEmptyStringValidator();
  final StringValidator codeValidator = NonEmptyStringValidator();
  final String invalidCodeErrorText = 'code can\'t be empty';
  final String invalidPasswordErrorText = 'Password can\'t be empty';
}
