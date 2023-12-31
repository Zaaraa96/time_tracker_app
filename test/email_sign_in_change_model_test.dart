import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:time_tracker_app/app/feature/sign_in/model/email_sign_in_change_model.dart';
import 'package:time_tracker_app/app/services/auth.dart';

@GenerateNiceMocks([MockSpec<AuthBase>()])
import 'email_sign_in_change_model_test.mocks.dart';

void main() {
  MockAuthBase mockAuth;
  late EmailSignInChangeModel model;

  setUp(() {
    mockAuth = MockAuthBase();
    model = EmailSignInChangeModel(auth: mockAuth);
  });

  test('updateEmail', () {
    var didNotifyListeners = false;
    model.addListener(() => didNotifyListeners = true);
    const sampleEmail = 'email@email.com';
    model.updateEmail(sampleEmail);
    expect(model.email, sampleEmail);
    expect(didNotifyListeners, true);
  });
}