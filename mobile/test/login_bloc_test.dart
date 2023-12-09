import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/routes/login/bloc/login_bloc.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/login/model/login_request_model.dart';
import 'package:memories_app/routes/login/model/login_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static const String username = 'ayhanc';
  static const String invalidUsername = 'ayhan';
  static const String successPassword = '123456';
  static const String failPassword = '123457';
  static const String invalidPassword = '12345';

  static const String usernameCharLimitMessage =
      'Username should be between 6 and 10 characters';
  static const String usernameRequiredMessage = 'Username is required';

  static const String passwordCharLimitMessage =
      'Password should be 6 characters';
  static const String passswordRequiredMessage = 'Password is required';

  static final LoginResponseModel responseSuccess = LoginResponseModel(
      success: true,
      msg: 'Login success',
      refresh: "mockRefreshToken",
      access: "mockAccessToken");
  static final LoginResponseModel responseFailure =
      LoginResponseModel(success: false, msg: 'Invalid username or password');
}

class MockLoginRepository extends LoginRepository {
  @override
  Future<LoginResponseModel> login(LoginRequestModel model) async {
    if (model.password != _Constants.failPassword) {
      return _Constants.responseSuccess;
    } else {
      return _Constants.responseFailure;
    }
  }

  @override
  Future<UserDetailsResponseModel> getUserDetails() {
    return Future<UserDetailsResponseModel>.value(
      UserDetailsResponseModel(
        id: 1,
        username: "John Doe",
        email: "john.doe@example.com",
        followers: <dynamic>[2],
      ),
    );
  }
}

void main() {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late LoginBloc loginBloc;
  late LoginRepository loginInterface;

  setUp(() {
    loginInterface = MockLoginRepository();
    loginBloc = LoginBloc(repository: loginInterface);
  });

  blocTest<LoginBloc, LoginState>(
    'emits LoginDisplayState when LoginLoadDisplayEvent is added again',
    build: () => loginBloc,
    act: (LoginBloc bloc) => bloc.add(LoginLoadDisplayEvent()),
    expect: () => <LoginDisplayState>[
      const LoginDisplayState(
        isUsernameFieldFocused: false,
        usernameValidationMessage: null,
        isPasswordFieldFocused: false,
        passwordValidationMessage: null,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits LoginDisplayState with no validation message when LoginUsernameChangedEvent is added',
    build: () => loginBloc,
    act: (LoginBloc bloc) =>
        bloc.add(const LoginUsernameChangedEvent(_Constants.username)),
    expect: () => <LoginDisplayState>[
      const LoginDisplayState(
        isUsernameFieldFocused: true,
        usernameValidationMessage: '',
        isPasswordFieldFocused: false,
        passwordValidationMessage: null,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits LoginDisplayState with no validation message when LoginPasswordChangedEvent is added',
    build: () => loginBloc,
    act: (LoginBloc bloc) =>
        bloc.add(const LoginPasswordChangedEvent(_Constants.successPassword)),
    expect: () => <LoginDisplayState>[
      const LoginDisplayState(
        isUsernameFieldFocused: false,
        usernameValidationMessage: null,
        isPasswordFieldFocused: true,
        passwordValidationMessage: '',
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits LoginDisplayState when LoginErrorPopupClosedEvent is added',
    build: () => loginBloc,
    act: (LoginBloc bloc) => bloc.add(LoginErrorPopupClosedEvent()),
    expect: () => <LoginDisplayState>[
      const LoginDisplayState(
        isUsernameFieldFocused: false,
        usernameValidationMessage: null,
        isPasswordFieldFocused: false,
        passwordValidationMessage: null,
      ),
    ],
  );

  blocTest<LoginBloc, LoginState>(
    'emits LoginSucces when LoginPressLoginButtonEvent is added with correct credentials',
    build: () => loginBloc,
    act: (LoginBloc bloc) => bloc.add(const LoginPressLoginButtonEvent(
        username: _Constants.username, password: _Constants.successPassword)),
    expect: () => <TypeMatcher<LoginSuccess>>[isA<LoginSuccess>()],
  );

  blocTest<LoginBloc, LoginState>(
    'emits LoginFailure when LoginPressLoginButtonEvent is added with wrong credentials',
    build: () => loginBloc,
    act: (LoginBloc bloc) => bloc.add(const LoginPressLoginButtonEvent(
        username: _Constants.username, password: _Constants.failPassword)),
    expect: () => <TypeMatcher<LoginFailure>>[isA<LoginFailure>()],
  );

  test('validateUsername returns the correct validation message', () {
    expect(loginBloc.validateUsername(null),
        equals(_Constants.usernameRequiredMessage));
    expect(loginBloc.validateUsername(_Constants.invalidUsername),
        equals(_Constants.usernameCharLimitMessage));
    expect(loginBloc.validateUsername(_Constants.username), equals(''));
  });

  test('validatePassword returns the correct validation message', () {
    expect(loginBloc.validatePassword(null),
        equals(_Constants.passswordRequiredMessage));
    // expect(loginBloc.validatePassword(_Constants.invalidPassword),
    //     equals(_Constants.passwordCharLimitMessage));
    expect(loginBloc.validatePassword(_Constants.successPassword), equals(''));
  });
}
