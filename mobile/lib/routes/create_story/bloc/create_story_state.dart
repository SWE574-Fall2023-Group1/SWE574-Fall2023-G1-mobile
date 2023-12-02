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

class CreateStoryOffline extends CreateStoryState {
  final String? offlineMessage;

  const CreateStoryOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() =>
      'Create story service is offline with message: $offlineMessage';
}
