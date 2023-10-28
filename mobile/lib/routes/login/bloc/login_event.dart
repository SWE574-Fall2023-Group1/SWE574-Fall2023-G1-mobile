part of 'login_bloc.dart';

sealed class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => <Object>[];
}

class LoginLoadDisplayEvent extends LoginEvent {
  @override
  String toString() => 'Load login route';
}

class LoginUsernameChangedEvent extends LoginEvent {
  final String username;

  const LoginUsernameChangedEvent(this.username);

  @override
  List<Object> get props => <Object>[username];
}

class LoginPasswordChangedEvent extends LoginEvent {
  final String password;

  const LoginPasswordChangedEvent(this.password);

  @override
  List<Object> get props => <Object>[password];
}

class LoginPressLoginButtonEvent extends LoginEvent {
  final String username;
  final String password;

  const LoginPressLoginButtonEvent(
      {required this.username, required this.password});

  @override
  String toString() => 'Login button is pressed';

  @override
  List<Object> get props => <Object>[username, password];
}

class LoginErrorPopupClosedEvent extends LoginEvent {}
