import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:memories_app/util/sp_helper.dart';
import 'package:equatable/equatable.dart';
import '../model/register_repository.dart';
import '../model/register_request_model.dart';
import '../model/register_response_model.dart';

part 'register_event.dart';

part 'register_state.dart';

class _Constants {
  static const String usernameRequiredMessage = 'Username is required';
  static const String usernameCharLimitMessage =
      'Username should be between 6 and 10 characters';
  static const String passwordRequiredMessage = 'Password is required';
  static const String passwordCharLimitMessage =
      'Password should be 6 characters';
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository _repository;

  RegisterBloc({required RegisterRepository repository})
      : _repository = repository,
        super(const RegisterInitial()) {
    on<RegisterLoadDisplayEvent>(_onLoadDisplayEvent);
    on<RegisterUsernameChangedEvent>(_onUsernameChangedEvent);
    on<RegisterPasswordChangedEvent>(_onPasswordChangedEvent);
    on<RegisterPressRegisterButtonEvent>(_onPressRegisterButtonEvent);
    on<RegisterErrorPopupClosedEvent>(_onErrorPopupClosedEvent);
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
      return _Constants.passwordRequiredMessage;
    }
    if (value.length != 6) {
      return _Constants.passwordCharLimitMessage;
    }
    return ''; // Return empty if the validation is successful
  }

  RegisterDisplayState _displayState() {
    return RegisterDisplayState(
        isUsernameFieldFocused: _isUsernameFieldFocused,
        usernameValidationMessage: _usernameValidationMessage,
        isPasswordFieldFocused: _isPasswordFieldFocused,
        passwordValidationMessage: _passwordValidationMessage);
  }

  void _onUsernameChangedEvent(
      RegisterUsernameChangedEvent event, Emitter<RegisterState> emit) {
    _isUsernameFieldFocused = event.username.isNotEmpty;
    _usernameValidationMessage = validateUsername(event.username);
    emit(_displayState());
  }

  void _onPasswordChangedEvent(
      RegisterPasswordChangedEvent event, Emitter<RegisterState> emit) {
    _isPasswordFieldFocused = event.password.isNotEmpty;
    _passwordValidationMessage = validatePassword(event.password);
    emit(_displayState());
  }

  Future<void> _onLoadDisplayEvent(
      RegisterLoadDisplayEvent event, Emitter<RegisterState> emit) async {
    emit(_displayState());
  }

  Future<void> _saveRefreshToken(String refreshToken) async {
    await SPHelper.setString(SPKeys.refreshTokenKey, refreshToken);
  }

  Future<void> _saveRegisterInfo() async {
    await SPHelper.setBool(SPKeys.isLoggedIn, true);
  }

  FutureOr<void> _onPressRegisterButtonEvent(
      RegisterPressRegisterButtonEvent event,
      Emitter<RegisterState> emit) async {
    RegisterResponseModel? response;

    RegisterRequestModel request = RegisterRequestModel(
      username: event.username,
      password: event.password,
    );

    try {
      response = await _repository.register(request);
    } on SocketException {
      emit(const RegisterOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(RegisterFailure(error: error.toString()));
    }

    if (response != null) {
      if (response.success == true && response.refresh != null) {
        /// INFO: save refresh token locally
        await _saveRefreshToken(response.refresh!);
        await _saveRegisterInfo();
        emit(const RegisterSuccess());
      } else {
        emit(RegisterFailure(error: response.msg.toString()));
      }
    }
  }

  void _onErrorPopupClosedEvent(
      RegisterErrorPopupClosedEvent event, Emitter<RegisterState> emit) {
    emit(_displayState());
  }
}
