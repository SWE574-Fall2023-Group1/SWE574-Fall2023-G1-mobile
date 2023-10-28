// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';

part 'landing_event.dart';
part 'landing_state.dart';

class LandingBloc extends Bloc<LandingEvent, LandingState> {
  LandingBloc() : super(const LandingInitial(tabIndex: 0)) {
    on<LandingTabChangeEvent>(_onLandingTabChangeEvent);
  }

  void _onLandingTabChangeEvent(
      LandingTabChangeEvent event, Emitter<LandingState> emit) async {
    emit(LandingInitial(tabIndex: event.tabIndex));
  }
}
