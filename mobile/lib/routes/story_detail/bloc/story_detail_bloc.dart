import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_event.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_state.dart';

class StoryDetailBloc extends Bloc<StoryDetailEvent, StoryDetailState> {
  StoryDetailBloc() : super(const StoryDetailInitial());
}
