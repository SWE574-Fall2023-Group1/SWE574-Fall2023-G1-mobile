part of 'register_bloc.dart';

sealed class RegisterState extends Equatable {
  const RegisterState();

  @override
  List<Object?> get props => <Object?>[];
}

class RegisterInitial extends RegisterState {
  const RegisterInitial();
}

class RegisterDisplayState extends RegisterState {
  final bool isUsernameFieldFocused;
  final String? usernameValidationMessage;
  final bool isEmailFieldFocused;
  final String? emailValidationMessage;
  final bool isPasswordFieldFocused;
  final String? passwordValidationMessage;
  final bool isPasswordAgainFieldFocused;
  final String? passwordAgainValidationMessage;

  const RegisterDisplayState({
    this.isUsernameFieldFocused = false,
    this.usernameValidationMessage,
    this.isEmailFieldFocused = false,
    this.emailValidationMessage,
    this.isPasswordFieldFocused = false,
    this.passwordValidationMessage,
    this.isPasswordAgainFieldFocused = false,
    this.passwordAgainValidationMessage,
  });

  @override
  List<Object?> get props => <Object?>[
        isUsernameFieldFocused,
        usernameValidationMessage,
        isEmailFieldFocused,
        emailValidationMessage,
        isPasswordFieldFocused,
        passwordValidationMessage,
        isPasswordAgainFieldFocused,
        passwordAgainValidationMessage,
      ];

  @override
  String toString() => 'Displaying Register state';
}

class RegisterSuccess extends RegisterState {
  final String? successMessage;

  const RegisterSuccess({required this.successMessage});

  @override
  List<Object?> get props => <Object?>[successMessage];

  @override
  String toString() => 'Register is successful';
}

class RegisterFailure extends RegisterState {
  final String? error;

  const RegisterFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Register is failed with $error';
}

class RegisterOffline extends RegisterState {
  final String? offlineMessage;

  const RegisterOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() =>
      'Register service is offline with message: $offlineMessage';
}

class RegisterNavigateToLoginState extends RegisterState {
  const RegisterNavigateToLoginState();

  @override
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Navigating to login';
}
