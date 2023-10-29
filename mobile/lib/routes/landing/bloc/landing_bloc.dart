// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(const LandingInitial()) {
    on<LandingLoadEvent>(_onLandingLoadEvent);
    on<LandingOnPageChangedEvent>(_onLandingOnPageChangedEvent);
  }
  void _onLandingOnPageChangedEvent(
      LandingOnPageChangedEvent event, Emitter<LandingState> emit) async {
    emit(LandingDisplayState(tabIndex: event.tabIndex));
    emit(LandingJumpToPageState(tabIndex: event.tabIndex));
  }

  void _onLandingLoadEvent(
      LandingLoadEvent event, Emitter<LandingState> emit) async {
    emit(LandingDisplayState(tabIndex: event.tabIndex));
  }
}
