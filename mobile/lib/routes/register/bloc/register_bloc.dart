import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/register/model/register_repository.dart';
import 'package:memories_app/routes/register/model/register_request_model.dart';
import 'package:memories_app/routes/register/model/register_response_model.dart';

part 'register_event.dart';
part 'register_state.dart';

class _Constants {
  static const String usernameRequiredMessage = 'Username is required';
  static const String emailRequiredMessage = 'Email is required';
  static const String invalidEmailMessage = 'Email is invalid';
  static const String usernameCharLimitMessage =
      'Username should be between 6 and 10 characters';
  static const String passwordRequiredMessage = 'Password is required';
  static const String passwordsNotMatch = 'Passwords must be same';
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
    on<RegisterEmailChangedEvent>(_onEmailChangedEvent);
    on<RegisterPasswordChangedEvent>(_onPasswordChangedEvent);
    on<RegisterPasswordAgainChangedEvent>(_onPasswordAgainChangedEvent);
    on<RegisterPressRegisterButtonEvent>(_onPressRegisterButtonEvent);
    on<RegisterErrorPopupClosedEvent>(_onErrorPopupClosedEvent);
    on<RegisterSuccessPopupClosedEvent>(_onSuccessPopupClosedEvent);
  }

  bool _isUsernameFieldFocused = false;
  String? _usernameValidationMessage;
  bool _isEmailFieldFocused = false;
  String? _emailValidationMessage;
  bool _isPasswordFieldFocused = false;
  String? _passwordValidationMessage;
  bool _isPasswordAgainFieldFocused = false;
  String? _passwordAgainValidationMessage;

  String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return _Constants.usernameRequiredMessage;
    }
    if (value.length < 6 || value.length > 10) {
      return _Constants.usernameCharLimitMessage;
    }
    return null;
  }

  String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return _Constants.emailRequiredMessage;
    }

    final RegExp emailRegex =
        RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    if (!emailRegex.hasMatch(email)) {
      return _Constants.invalidEmailMessage;
    }

    return null;
  }

  String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return _Constants.passwordRequiredMessage;
    }
    // if (password.length != 6) {
    //   return _Constants.passwordCharLimitMessage;
    // }
    return null;
  }

  String? validatePasswordAgain(String? password, String? passwordAgain) {
    if (password != passwordAgain) {
      return _Constants.passwordsNotMatch;
    }
    return null;
  }

  RegisterDisplayState _displayState() {
    return RegisterDisplayState(
      isUsernameFieldFocused: _isUsernameFieldFocused,
      usernameValidationMessage: _usernameValidationMessage,
      isEmailFieldFocused: _isEmailFieldFocused,
      emailValidationMessage: _emailValidationMessage,
      isPasswordFieldFocused: _isPasswordFieldFocused,
      passwordValidationMessage: _passwordValidationMessage,
      isPasswordAgainFieldFocused: _isPasswordAgainFieldFocused,
      passwordAgainValidationMessage: _passwordAgainValidationMessage,
    );
  }

  void _onUsernameChangedEvent(
      RegisterUsernameChangedEvent event, Emitter<RegisterState> emit) {
    _isUsernameFieldFocused = event.username.isNotEmpty;
    _usernameValidationMessage = validateUsername(event.username);
    emit(_displayState());
  }

  void _onEmailChangedEvent(
      RegisterEmailChangedEvent event, Emitter<RegisterState> emit) {
    _isEmailFieldFocused = event.email.isNotEmpty;
    _emailValidationMessage = validateEmail(event.email);
    emit(_displayState());
  }

  void _onPasswordChangedEvent(
      RegisterPasswordChangedEvent event, Emitter<RegisterState> emit) {
    _isPasswordFieldFocused = event.password.isNotEmpty;
    _passwordValidationMessage = validatePassword(event.password);
    emit(_displayState());
  }

  void _onPasswordAgainChangedEvent(
      RegisterPasswordAgainChangedEvent event, Emitter<RegisterState> emit) {
    _isPasswordAgainFieldFocused = event.passwordAgain.isNotEmpty;
    _passwordAgainValidationMessage =
        validatePasswordAgain(event.password, event.passwordAgain);
    emit(_displayState());
  }

  Future<void> _onLoadDisplayEvent(
      RegisterLoadDisplayEvent event, Emitter<RegisterState> emit) async {
    emit(_displayState());
  }

  FutureOr<void> _onPressRegisterButtonEvent(
      RegisterPressRegisterButtonEvent event,
      Emitter<RegisterState> emit) async {
    RegisterResponseModel? response;

    RegisterRequestModel request = RegisterRequestModel(
        username: event.username,
        email: event.email,
        password: event.password,
        passwordAgain: event.password);

    try {
      response = await _repository.register(request);
    } on SocketException {
      emit(const RegisterOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(RegisterFailure(error: error.toString()));
    }

    if (response != null) {
      if (response.success == true && response.msg != null) {
        /// INFO: save refresh token locally
        emit(RegisterSuccess(successMessage: response.msg));
      } else {
        emit(RegisterFailure(error: response.msg.toString()));
      }
    }
  }

  void _onErrorPopupClosedEvent(
      RegisterErrorPopupClosedEvent event, Emitter<RegisterState> emit) {
    emit(_displayState());
  }

  void _onSuccessPopupClosedEvent(
      RegisterSuccessPopupClosedEvent event, Emitter<RegisterState> emit) {
    emit(const RegisterNavigateToLoginState());
  }
}
