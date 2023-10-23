part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginLoadDisplayEvent extends LoginEvent {
  @override
  String toString() => 'Load login route';
}

class LoginUsernameChangedEvent extends LoginEvent {
  final String username;

  LoginUsernameChangedEvent(this.username);

  @override
  List<Object> get props => [username];
}

class LoginPasswordChangedEvent extends LoginEvent {
  final String password;

  LoginPasswordChangedEvent(this.password);

  @override
  List<Object> get props => [password];
}

class LoginPressLoginButtonEvent extends LoginEvent {
  final String username;
  final String password;

  LoginPressLoginButtonEvent({required this.username, required this.password});

  @override
  String toString() => 'Login button is pressed';

  @override
  List<Object> get props => [username, password];
}

class LoginErrorPopupClosedEvent extends LoginEvent {}