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
        date: null,
        creationDate: DateTime.parse("2023-12-23T19:46:55.656341Z").toLocal(),
        startDate: null,
        endDate: null,
        decade: null,
        includeTime: false,
        likes: <int>[],
        dateText: null,
      );
      expect(getFormattedDate(story), 'Year: 2015');
    });
  });

  group('formatDate', () {
    test('should format valid date string correctly', () {
      expect(formatDate('2023-12-25'), '2023-12-25');
    });

    test('should return null for invalid date string', () {
      expect(formatDate('invalid-date'), null);
    });

    test('should return null for null date string', () {
      expect(formatDate(null), null);
    });
  });
}
