part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

class RegisterLoadDisplayEvent extends RegisterEvent {
  @override
  String toString() => 'Load Register route';
}

class RegisterUsernameChangedEvent extends RegisterEvent {
  final String username;

  const RegisterUsernameChangedEvent(this.username);

  @override
  List<Object> get props => [username];
}

class RegisterEmailChangedEvent extends RegisterEvent {
  final String email;

  const RegisterEmailChangedEvent(this.email);

  @override
  List<Object> get props => [email];
}

class RegisterPasswordChangedEvent extends RegisterEvent {
  final String password;

  const RegisterPasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class RegisterPasswordAgainChangedEvent extends RegisterEvent {
  final String password;
  final String passwordAgain;

  const RegisterPasswordAgainChangedEvent(this.password, this.passwordAgain);

  @override
  List<Object> get props => [password, passwordAgain];
}

class RegisterPressRegisterButtonEvent extends RegisterEvent {
  final String username;
  final String email;
  final String password;

  const RegisterPressRegisterButtonEvent(
      {required this.username, required this.email, required this.password});

  @override
  String toString() => 'Register button is pressed';

  @override
  List<Object> get props => [username, email, password];
}

class RegisterErrorPopupClosedEvent extends RegisterEvent {}
