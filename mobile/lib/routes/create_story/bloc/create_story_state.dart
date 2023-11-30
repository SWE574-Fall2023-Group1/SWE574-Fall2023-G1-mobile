part of 'create_story_bloc.dart';

class CreateStoryState extends Equatable {
  const CreateStoryState();

  @override
  List<Object?> get props => <Object?>[];
}

class CreateStorySuccess extends CreateStoryState {
  const CreateStorySuccess();

  @override
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Create story is successful';
}

class CreateStoryFailure extends CreateStoryState {
  final String? error;

  const CreateStoryFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Create story is failed with $error';
}
