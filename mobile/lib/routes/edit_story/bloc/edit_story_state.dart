part of 'edit_story_bloc.dart';

class EditStoryState extends Equatable {
  const EditStoryState();

  @override
  List<Object?> get props => <Object?>[];
}

class EditStorySuccess extends EditStoryState {
  const EditStorySuccess();

  @override
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Edit story is successful';
}

class EditStoryFailure extends EditStoryState {
  final String? error;

  const EditStoryFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Edit story is failed with $error';
}

class EditStoryOffline extends EditStoryState {
  final String? offlineMessage;

  const EditStoryOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() =>
      'Edit story service is offline with message: $offlineMessage';
}
