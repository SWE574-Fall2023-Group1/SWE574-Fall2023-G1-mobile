part of 'recommendations_bloc.dart';

sealed class RecommendationsEvent extends Equatable {
  const RecommendationsEvent();

  @override
  List<Object?> get props => <Object>[];
}

class RecommendationsLoadDisplayEvent extends RecommendationsEvent {
  @override
  String toString() => 'Load recommendations route';

  @override
  List<Object?> get props => <Object>[];
}

class RecommendationsEventRefreshStories extends RecommendationsEvent {
  @override
  String toString() => 'Refresh recommendations route';

  @override
  List<Object?> get props => <Object>[];
}
