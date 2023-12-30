import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/profile/util/date_util.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';

void main() {
  group('getFormattedDate', () {
    test('should return year format when dateType is year', () {
      final StoryModel story = StoryModel(
        id: 102,
        author: 42,
        authorUsername: "abc",
        title: "<p></p>",
        content: "<p></p>",
        storyTags: <TagModel>[],
        locations: <LocationModel>[],
        dateType: "year",
        seasonName: "Summer",
        year: 2015,
        startYear: null,
        endYear: null,
        date: "2023-12-23T19:46:55.656341Z",
        creationDate: DateTime.parse("2023-12-23T19:46:55.656341Z").toLocal(),
        startDate: null,
        endDate: null,
        decade: null,
        includeTime: false,
        likes: <int>[],
        dateText: null,
      );
      expect(getFormattedDate(story), 'Year: 2015');
      story.dateType = "decade";
      story.decade = 2015;
      expect(getFormattedDate(story), 'Decade: 2015');
      story.dateType = "year_interval";
      story.startYear = 2015;
      story.endYear = 2020;
      expect(getFormattedDate(story), 'Start: 2015 \nEnd: 2020');
      story.dateType = "normal_date";
      expect(getFormattedDate(story), formatDate(story.date));
      story.dateType = "interval_date";
      story.startDate = "2023-12-23T19:46:55.656341Z";
      story.endDate = "2023-12-30T19:46:55.656341Z";
      expect(getFormattedDate(story),
          'Start: ${formatDate(story.startDate)} \nEnd: ${formatDate(story.endDate)}');
    });
  });

  group('formatDate', () {
    test('should format valid date string correctly', () {
      expect(formatDate('2023-12-25'), '2023-12-25');
    });

    test('should format valid date string correctly', () {
      expect(formatDate('2023-12-23T00:00:00.000000Z'), '2023-12-23');
    });

    test('should return null for invalid date string', () {
      expect(formatDate('invalid-date'), null);
    });

    test('should return null for null date string', () {
      expect(formatDate(null), null);
    });
  });
}
