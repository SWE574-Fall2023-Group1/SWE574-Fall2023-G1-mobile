import 'dart:io';
import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_repository.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_response.dart';

part 'recommendations_event.dart';
part 'recommendations_state.dart';

class _Constants {
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class RecommendationsBloc
    extends Bloc<RecommendationsEvent, RecommendationsState> {
  final RecommendationsRepository _repository;

  RecommendationsBloc({required RecommendationsRepository repository})
      : _repository = repository,
        super(const RecommendationsInitial()) {
    on<RecommendationsLoadDisplayEvent>(_recommendationsEvent);
  }

  Future<void> _recommendationsEvent(RecommendationsLoadDisplayEvent event,
      Emitter<RecommendationsState> emit) async {
    RecommendationsResponseModel? response;
    emit(const RecommendationsDisplayState(
        recommendations: [], showLoadingAnimation: true));
    try {
      response = await _repository.getRecommendations();
    } on SocketException {
      emit(const RecommendationsOffline(
          offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(RecommendationsFailure(error: error.toString()));
    }
    if (response != null) {
      if (response.success == true &&
          response.recommendations != null &&
          response.recommendations!.isNotEmpty) {
        emit(RecommendationsDisplayState(
            recommendations: response.recommendations!,
            showLoadingAnimation: false));
      } else {
        emit(RecommendationsFailure(error: response.msg.toString()));
      }
    }
  }
}
