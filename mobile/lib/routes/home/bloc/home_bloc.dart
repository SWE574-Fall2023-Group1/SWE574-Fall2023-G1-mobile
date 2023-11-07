import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:memories_app/util/sp_helper.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeLoadDisplayEvent>(_onLoadDisplayEvent);
    on<HomeEventPressLogout>(_onPressLogout);
  }

  HomeDisplayState _displayState() {
    return const HomeDisplayState();
  }

  Future<void> _onLoadDisplayEvent(
      HomeLoadDisplayEvent event, Emitter<HomeState> emit) async {
    emit(_displayState());
  }

  Future<void> _onPressLogout(
      HomeEventPressLogout event, Emitter<HomeState> emit) async {
    await SPHelper.clear();
    emit(HomeNavigateToLoginState());
  }
}
