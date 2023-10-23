part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {
  LoginInitial();
}

// TODO: Add necessary state variables
class LoginDisplayState extends LoginState {
  final bool isUsernameFieldFocused;
  final String? usernameValidationMessage;
  final bool isPasswordFieldFocused;
  final String? passwordValidationMessage;

  const LoginDisplayState({
    this.isUsernameFieldFocused = false,
    this.usernameValidationMessage,
    this.isPasswordFieldFocused = false,
    this.passwordValidationMessage,
  });

  @override
  List<Object?> get props => [
        isUsernameFieldFocused,
        usernameValidationMessage,
        isPasswordFieldFocused,
        passwordValidationMessage,
      ];

  @override
  String toString() => 'Displaying login state';
}

class LoginSuccess extends LoginState {
  const LoginSuccess();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'Login is successful';
}

class LoginFailure extends LoginState {
  final String? error;

  LoginFailure({required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'Login is failed with $error';
}

class LoginOffline extends LoginState {
  const LoginOffline();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'Login service is offline';
}
