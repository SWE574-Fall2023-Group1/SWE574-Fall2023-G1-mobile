part of 'recommendations_bloc.dart';

sealed class RecommendationsState extends Equatable {
  const RecommendationsState();

  @override
  List<Object?> get props => <Object?>[];
}

class RecommendationsInitial extends RecommendationsState {
  const RecommendationsInitial();
}

class RecommendationsDisplayState extends RecommendationsState {
  final List<Recommendation> recommendations;
  final bool showLoadingAnimation;
  const RecommendationsDisplayState(
      {required this.recommendations, required this.showLoadingAnimation});

  @override
  List<Object?> get props => <Object?>[recommendations, showLoadingAnimation];

  @override
  String toString() => 'Displaying recommendations state';
}

class RecommendationsSuccess extends RecommendationsState {
  const RecommendationsSuccess();

  @override
  List<Object?> get props => <Object?>[];

  @override
  String toString() => 'Recommendations are successful';
}

class RecommendationsFailure extends RecommendationsState {
  final String? error;

  const RecommendationsFailure({required this.error});

  @override
  List<Object?> get props => <Object?>[error];

  @override
  String toString() => 'Fetch stories failed with $error';
}

class RecommendationsOffline extends RecommendationsState {
  final String? offlineMessage;

  const RecommendationsOffline({required this.offlineMessage});

  @override
  List<Object?> get props => <Object?>[offlineMessage];

  @override
  String toString() =>
      'Fetch stories service is offline with message: $offlineMessage';
}
