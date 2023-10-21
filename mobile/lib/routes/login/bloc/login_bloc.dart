import 'package:bloc/bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/login/model/login_request_model.dart';
import 'package:memories_app/routes/login/model/login_response_model.dart';
import 'package:memories_app/util/sp_helper.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _repository;

  LoginBloc({required LoginRepository repository})
      : _repository = repository,
        super(LoginInitial()) {
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
    LoginResponseModel? response;

    LoginRequestModel request = LoginRequestModel(
      username: event.username,
      password: event.password,
    );

    try {
      response = await _repository.login(request);
    } catch (error) {
      emit(LoginFailure(error: error.toString()));
    }

    if (response != null && response.refresh != null) {
      /// INFO: save refresh token locally
      await SPHelper.setString(SPKeys.refreshTokenKey, response.refresh!);
      /*String? test = await SPHelper.getString(SPKeys.refreshTokenKey);
      print(test);*/
      emit(const LoginSuccess());
    } else {
      emit(LoginFailure(error: "Error"));
    }
  }
}
