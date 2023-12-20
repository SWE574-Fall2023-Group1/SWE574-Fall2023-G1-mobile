import 'dart:io';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_repository.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_response_model.dart';

part 'activity_stream_event.dart';
part 'activity_stream_state.dart';

class _Constants {
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class ActivityStreamBloc
    extends Bloc<ActivityStreamEvent, ActivityStreamState> {
  final ActivityStreamRepository _repository;

  ActivityStreamBloc({required ActivityStreamRepository repository})
      : _repository = repository,
        super(const ActivityStreamInitial()) {
    on<ActivityStreamLoadDisplayEvent>(_loadDisplayEvent);
  }

  Future<void> _loadDisplayEvent(ActivityStreamLoadDisplayEvent event,
      Emitter<ActivityStreamState> emit) async {
    ActivityStreamResponseModel? response;
    await _getActivities(response, emit);
  }

  Future<void> _getActivities(ActivityStreamResponseModel? response,
      Emitter<ActivityStreamState> emit) async {
    try {
      response = await _repository.getActivities();
    } on SocketException {
      emit(const ActivityStreamOffline(
          offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(ActivityStreamFailure(error: error.toString()));
    }

    if (response != null) {
      if (response.success == true && response.activity.isNotEmpty) {
        emit(ActivityStreamDisplayState(
            activities: response.activity, showLoadingAnimation: false));
      } else {
        emit(ActivityStreamFailure(error: response.msg.toString()));
      }
    }
  }
}
