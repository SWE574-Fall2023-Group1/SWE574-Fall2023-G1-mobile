part of 'search_story_bloc.dart';

class SearchStoryState extends Equatable {
  const SearchStoryState();

  @override
  List<Object?> get props => <Object?>[];
}

class SearchStorySuccess extends SearchStoryState {
  final List<StoryModel>? stories;
  const SearchStorySuccess(this.stories);

  @override
  List<Object?> get props => <Object?>[stories];

  @override
  String toString() => 'Search story is successful';
}

class SearchStoryFailure extends SearchStoryState {
  final String? error;

  const SearchStoryFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Search story is failed with $error';
}

class SearchStoryOffline extends SearchStoryState {
  final String? offlineMessage;

  const SearchStoryOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() =>
      'Search story service is offline with message: $offlineMessage';
}
