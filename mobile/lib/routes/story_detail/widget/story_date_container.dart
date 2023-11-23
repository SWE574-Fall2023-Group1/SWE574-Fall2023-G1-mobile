import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/ui/date_text_view.dart';

class StoryDateContainer extends StatelessWidget {
  final StoryModel story;

  const StoryDateContainer({required this.story, super.key});

  String? getHumanizedDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('MMMM d, y').format(date);
    } else if (date is String) {
      DateTime? parsedDate = DateTime.tryParse(date);
      if (parsedDate != null) {
        return DateFormat('MMMM d, y').format(parsedDate);
      }
    }
    return null;
  }

  String getFormattedDate(StoryModel story) {
    switch (story.dateType) {
      case 'year':
        return 'Year: ${story.year?.toString() ?? ''}';
      case 'decade':
        return 'Decade: ${story.decade?.toString() ?? ''}';
      case 'year_interval':
        return 'Start: ${getHumanizedDate(story.startYear.toString())} \nEnd: ${getHumanizedDate(story.endYear.toString())}';
      case 'normal_date':
        return getHumanizedDate(story.date) ?? '';
      case 'interval_date':
        return 'Start: ${getHumanizedDate(story.startDate)} \nEnd: ${getHumanizedDate(story.endDate)}';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DateText.build(text: "Story Time"),
        DateText.build(text: getFormattedDate(story))
      ],
    );
  }
}
