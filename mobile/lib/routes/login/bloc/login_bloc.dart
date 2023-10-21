import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginLoadDisplayEvent>(_onLoadDisplayEvent);
    on<LoginUsernameChangedEvent>(_onUsernameChangedEvent);
    on<LoginPasswordChangedEvent>(_onPasswordChangedEvent);
    on<LoginPressLoginButtonEvent>(_onPressLoginButtonEvent);
  }

  // TODO: Add business logic

  LoginDisplayState _displayState() {
    return const LoginDisplayState();
  }

  Future<void> _onLoadDisplayEvent(
      LoginLoadDisplayEvent event, Emitter<LoginState> emit) async {
    emit(_displayState());
  }

  void _onUsernameChangedEvent(
      LoginUsernameChangedEvent event, Emitter<LoginState> emit) {
    emit(_displayState());
  }

  void _onPasswordChangedEvent(
      LoginPasswordChangedEvent event, Emitter<LoginState> emit) {
    emit(_displayState());
  }

  FutureOr<void> _onPressLoginButtonEvent(
      LoginPressLoginButtonEvent event, Emitter<LoginState> emit) async {
    // TODO: Add login call
  }
}
