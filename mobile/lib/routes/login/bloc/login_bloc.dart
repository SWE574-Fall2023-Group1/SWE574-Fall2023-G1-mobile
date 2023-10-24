import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/login/model/login_request_model.dart';
import 'package:memories_app/routes/login/model/login_response_model.dart';
import 'package:memories_app/util/sp_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _repository;

  LoginBloc({required LoginRepository repository})
      : _repository = repository,
        super(LoginInitial()) {
    on<LoginLoadDisplayEvent>(_onLoadDisplayEvent);
    on<LoginUsernameChangedEvent>(_onUsernameChangedEvent);
    on<LoginPasswordChangedEvent>(_onPasswordChangedEvent);
    on<LoginPressLoginButtonEvent>(_onPressLoginButtonEvent);
  }

  bool _isUsernameFieldFocused = false;
  String? _usernameValidationMessage;
  bool _isPasswordFieldFocused = false;
  String? _passwordValidationMessage;

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 6 || value.length > 10) {
      return 'Username should be between 6 and 10 characters';
    }
    return ''; // Return empty if the validation is successful
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length != 6) {
      return 'Password should be 6 characters';
    }
    return ''; // Return empty if the validation is successful
  }

  LoginDisplayState _displayState() {
    return LoginDisplayState(
        isUsernameFieldFocused: _isUsernameFieldFocused,
        usernameValidationMessage: _usernameValidationMessage,
        isPasswordFieldFocused: _isPasswordFieldFocused,
        passwordValidationMessage: _passwordValidationMessage);
  }

  void _onUsernameChangedEvent(
      LoginUsernameChangedEvent event, Emitter<LoginState> emit) {
    _isUsernameFieldFocused = event.username.isNotEmpty;
    _usernameValidationMessage = validateUsername(event.username);
    emit(_displayState());
  }

  void _onPasswordChangedEvent(
      LoginPasswordChangedEvent event, Emitter<LoginState> emit) {
    _isPasswordFieldFocused = event.password.isNotEmpty;
    _passwordValidationMessage = validatePassword(event.password);
    emit(_displayState());
  }

  Future<void> _onLoadDisplayEvent(
      LoginLoadDisplayEvent event, Emitter<LoginState> emit) async {
    emit(_displayState());
  }

  Future<void> _saveRefreshToken(String refreshToken) async {
    await SPHelper.setString(SPKeys.refreshTokenKey, refreshToken);
  }

  Future<void> _saveLoginInfo() async {
    await SPHelper.setBool(SPKeys.isLoggedIn, true);
  }

  FutureOr<void> _onPressLoginButtonEvent(
      LoginPressLoginButtonEvent event, Emitter<LoginState> emit) async {
    LoginResponseModel? response;

    LoginRequestModel request = LoginRequestModel(
      username: event.username,
      password: event.password,
    );

    try {
      response = await _repository.login(request);
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }

    if (response != null &&
        response.success == true &&
        response.refresh != null) {
      /// INFO: save refresh token locally
      await _saveRefreshToken(response.refresh!);
      await _saveLoginInfo();
      emit(const LoginSuccess());
    } else {
      emit(LoginFailure(error: response?.msg.toString()));
    }
  }
}
