import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:memories_app/util/sp_helper.dart';

part 'app_event.dart';
part 'app_state.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  AppBloc() : super(const AppInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(AppStarted event, Emitter<AppState> emit) async {
    bool? isLoggedIn = await SPHelper.getBool(SPKeys.isLoggedIn);
    if (isLoggedIn != null && isLoggedIn) {
      emit(const AppAuthenticated());
    } else {
      emit(const AppUnauthenticated());
    }
  }

  void _onLoggedIn(LoggedIn event, Emitter<AppState> emit) {
    emit(const AppAuthenticated());
  }

  void _onLoggedOut(LoggedOut event, Emitter<AppState> emit) {
    emit(const AppUnauthenticated());
  }
}
