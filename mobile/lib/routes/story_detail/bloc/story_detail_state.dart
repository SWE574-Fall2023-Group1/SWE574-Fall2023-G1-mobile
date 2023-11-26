import 'package:equatable/equatable.dart';

sealed class StoryDetailState extends Equatable {
  const StoryDetailState();

  @override
  List<Object?> get props => <Object?>[];
}

class StoryDetailInitial extends StoryDetailState {
  const StoryDetailInitial();
}
