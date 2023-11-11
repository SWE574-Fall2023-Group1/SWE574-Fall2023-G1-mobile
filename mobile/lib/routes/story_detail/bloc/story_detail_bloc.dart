import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_event.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_state.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';

class StoryDetailBloc extends Bloc<StoryDetailEvent, StoryDetailState>  {
  StoryDetailBloc() : super(const StoryDetailInitial());

  Future<StoryModel> _loadStoryById(int id) async {
    StoryModel? responseModel;

    responseModel = await StoryDetailRepositoryImp().getStoryById(id: id);

    responseModel.dateText = _getFormattedDate(responseModel);
    return responseModel;
  }

  String _getFormattedDate(StoryModel story) {
    switch (story.dateType) {
      case 'year':
        return 'Year: ${story.year?.toString() ?? ''}';
      case 'decade':
        return 'Decade: ${story.decade?.toString() ?? ''}';
      case 'year_interval':
        return 'Start: ${_formatDate(story.startYear.toString())} \nEnd: ${_formatDate(story.endYear.toString())}';
      case 'normal_date':
        return _formatDate(story.date) ?? '';
      case 'interval_date':
        return 'Start: ${_formatDate(story.startDate)} \nEnd: ${_formatDate(story.endDate)}';
      default:
        return '';
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) {
      return null;
    }

    try {
      DateTime dateTime = DateTime.parse(dateString);

      bool isMidnight =
          dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0;

      String formattedDate = isMidnight
          ? dateTime.toLocal().toLocal().toString().split(' ')[0]
          : dateTime.toLocal().toLocal().toString();

      return formattedDate;
    } catch (e) {
      print('Error parsing date: $e');
      return null;
    }
  }
}
