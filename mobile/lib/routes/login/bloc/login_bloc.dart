import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/login/model/login_request_model.dart';
import 'package:memories_app/routes/login/model/login_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/util/sp_helper.dart';

part 'login_event.dart';

part 'login_state.dart';

class _Constants {
  static const String usernameRequiredMessage = 'Username is required';
  static const String usernameCharLimitMessage =
      'Username should be between 6 and 10 characters';
  static const String passswordRequiredMessage = 'Password is required';
  static const String passwordCharLimitMessage =
      'Password should be 6 characters';
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _repository;

  LoginBloc({required LoginRepository repository})
      : _repository = repository,
        super(const LoginInitial()) {
    on<LoginLoadDisplayEvent>(_onLoadDisplayEvent);
    on<LoginUsernameChangedEvent>(_onUsernameChangedEvent);
    on<LoginPasswordChangedEvent>(_onPasswordChangedEvent);
    on<LoginPressLoginButtonEvent>(_onPressLoginButtonEvent);
    on<LoginErrorPopupClosedEvent>(_onErrorPopupClosedEvent);
  }

  bool _isUsernameFieldFocused = false;
  String? _usernameValidationMessage;
  bool _isPasswordFieldFocused = false;
  String? _passwordValidationMessage;

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return _Constants.usernameRequiredMessage;
    }
    if (value.length < 6 || value.length > 10) {
      return _Constants.usernameCharLimitMessage;
    }
    return ''; // Return empty if the validation is successful
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return _Constants.passswordRequiredMessage;
    }
    // if (value.length != 6) {
    //   return _Constants.passwordCharLimitMessage;
    // }
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

  Future<void> _saveLoginInfo(
      UserDetailsResponseModel userDetailsResponseModel) async {
    await SPHelper.setBool(SPKeys.isLoggedIn, true);
    await SPHelper.setInt(SPKeys.currentUserId, userDetailsResponseModel.id);
  }

  FutureOr<void> _onPressLoginButtonEvent(
      LoginPressLoginButtonEvent event, Emitter<LoginState> emit) async {
    LoginResponseModel? loginResponseModel;
    UserDetailsResponseModel? userDetailsResponseModel;

    LoginRequestModel request = LoginRequestModel(
      username: event.username,
      password: event.password,
    );

    try {
      loginResponseModel = await _repository.login(request);
    } on SocketException {
      emit(const LoginOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }

    if (loginResponseModel != null) {
      if (loginResponseModel.success == true &&
          loginResponseModel.refresh != null) {
        /// INFO: save refresh token locally
        await _saveRefreshToken(loginResponseModel.refresh!);
        userDetailsResponseModel = await _repository.getUserDetails();
        await _saveLoginInfo(userDetailsResponseModel);
        emit(const LoginSuccess());
      } else {
        emit(LoginFailure(error: loginResponseModel.msg.toString()));
      }
    }
  }

  void _onErrorPopupClosedEvent(
      LoginErrorPopupClosedEvent event, Emitter<LoginState> emit) {
    emit(_displayState());
  }
}
