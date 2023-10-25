part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => [];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterDisplayState extends RegisterState {
  final bool isUsernameFieldFocused;
  final bool isEmailFieldFocused;
  final bool isPasswordFieldFocused;
  final bool isPasswordAgainFieldFocused;
  final String? usernameValidationMessage;
  final String? passwordValidationMessage;
  final String? passwordAgainValidationMessage;

  const RegisterDisplayState({
    this.isUsernameFieldFocused = false,
    this.isEmailFieldFocused = false,
    this.isPasswordFieldFocused = false,
    this.isPasswordAgainFieldFocused = false,
    this.usernameValidationMessage,
    this.passwordValidationMessage,
    this.passwordAgainValidationMessage,
  });

  @override
  List<Object?> get props => [
        isUsernameFieldFocused,
        usernameValidationMessage,
        isPasswordFieldFocused,
        passwordValidationMessage,
        passwordAgainValidationMessage,
      ];

  @override
  String toString() => 'Displaying Register state';
}

class RegisterSuccess extends RegisterState {
  const RegisterSuccess();

  @override
  List<Object?> get props => [];

  @override
  String toString() => 'Register is successful';
}

class RegisterFailure extends RegisterState {
  final String? error;

  const RegisterFailure({required this.error});

  @override
  List<Object?> get props => [error];

  @override
  String toString() => 'Register is failed with $error';
}

class RegisterOffline extends RegisterState {
  final String? offlineMessage;

  const RegisterOffline({required this.offlineMessage});

  @override
  List<Object?> get props => [offlineMessage];

  @override
  String toString() =>
      'Register service is offline with message: $offlineMessage';
}
