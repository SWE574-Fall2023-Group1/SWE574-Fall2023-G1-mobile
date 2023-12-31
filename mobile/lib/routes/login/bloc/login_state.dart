part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object?> get props => <Object?>[];
}

class LoginInitial extends LoginState {
  const LoginInitial();
}

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
  List<Object?> get props => <Object?>[
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
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Login is successful';
}

class LoginFailure extends LoginState {
  final String? error;

  const LoginFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Login is failed with $error';
}

class LoginOffline extends LoginState {
  final String? offlineMessage;

  const LoginOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() => 'Login service is offline with message: $offlineMessage';
}
