import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeInitial()) {
    on<HomeLoadDisplayEvent>(_onLoadDisplayEvent);
  }

  HomeDisplayState _displayState() {
    return const HomeDisplayState();
  }

  Future<void> _onLoadDisplayEvent(
      HomeLoadDisplayEvent event, Emitter<HomeState> emit) async {
    emit(_displayState());
  }
}
