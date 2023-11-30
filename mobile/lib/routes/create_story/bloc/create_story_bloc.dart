import 'package:flutter_map/flutter_map.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/create_story/create_story_repository.dart';

part 'create_story_event.dart';
part 'create_story_state.dart';

class CreateStoryBloc extends Bloc<CreateStoryEvent, CreateStoryState> {
  final CreateStoryRepository _repository;

  CreateStoryBloc({required CreateStoryRepository repository})
      : _repository = repository,
        super(const CreateStoryState()) {
    on<CreateStoryCreateStoryEvent>(_createStoryEvent);
  }

  void _createStoryEvent(
      CreateStoryCreateStoryEvent event, Emitter<CreateStoryState> emit) {}
}
