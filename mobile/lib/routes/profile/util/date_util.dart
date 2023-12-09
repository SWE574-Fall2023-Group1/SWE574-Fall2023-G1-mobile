import 'package:memories_app/routes/home/model/story_model.dart';

String getFormattedDate(StoryModel story) {
  switch (story.dateType) {
    case 'year':
      return 'Year: ${story.year?.toString() ?? ''}';
    case 'decade':
      return 'Decade: ${story.decade?.toString() ?? ''}';
    case 'year_interval':
      return 'Start: ${story.startYear.toString()} \nEnd: ${story.endYear.toString()}';
    case 'normal_date':
      return formatDate(story.date) ?? '';
    case 'interval_date':
      return 'Start: ${formatDate(story.startDate)} \nEnd: ${formatDate(story.endDate)}';
    default:
      return '';
  }
}

String? formatDate(String? dateString) {
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
    // ignore: avoid_print
    print('Error parsing date: $e');
    return null;
  }
}
