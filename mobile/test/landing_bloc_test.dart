import 'package:bloc_test/bloc_test.dart';
import 'package:memories_app/routes/landing/bloc/landing_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late LandingBloc landingBloc;

  setUp(() {
    landingBloc = LandingBloc();
  });

  tearDown(() {
    landingBloc.close();
  });

  blocTest<LandingBloc, LandingState>(
    'emits [LandingDisplayState] when LandingLoadEvent is added',
    build: () => landingBloc,
    act: (LandingBloc bloc) => bloc..add(LandingLoadEvent(tabIndex: 0)),
    expect: () => <TypeMatcher<LandingDisplayState>>[
      isA<LandingDisplayState>(),
    ],
  );
  blocTest<LandingBloc, LandingState>(
    'emits [LandingDisplayState, LandingJumpToPageState] when LandingOnPageChangedEvent is added',
    build: () => landingBloc,
    act: (LandingBloc bloc) => bloc.add(LandingOnPageChangedEvent(tabIndex: 1)),
    expect: () => <TypeMatcher<LandingState>>[
      isA<LandingDisplayState>(),
      isA<LandingJumpToPageState>(),
    ],
  );
}
