import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/recommendations/bloc/recommendations_bloc.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_repository.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_response.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/routes/home/model/location_model.dart'
    // ignore: library_prefixes
    as locationModel;
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final StoryModel story = StoryModel(
    startYear: null,
    endYear: null,
    date: "2022-01-01",
    creationDate: DateTime.now(),
    startDate: null,
    endDate: null,
    decade: null,
    includeTime: false,
    id: 123456,
    author: 123456,
    authorUsername: 'test',
    seasonName: null,
    title: 'test',
    content: '<p>test</p>',
    storyTags: <TagModel>[
      TagModel(
          name: 'test',
          label: 'test',
          wikidataId: '123456',
          description: 'test')
    ],
    dateType: 'normal_date',
    locations: <LocationModel>[
      LocationModel(
          name: 'test',
          point: locationModel.PointLocation(
              type: "point", coordinates: <double>[1.0, 1.0]))
    ],
    likes: null,
    year: null,
  );

  static final StoryModel storyWithDateTypeYear = StoryModel(
    startYear: null,
    endYear: null,
    date: null,
    creationDate: DateTime.now(),
    startDate: null,
    endDate: null,
    decade: null,
    includeTime: false,
    id: 123456,
    author: 123456,
    authorUsername: 'test',
    seasonName: null,
    title: 'test',
    content: '<p>test</p>',
    storyTags: <TagModel>[
      TagModel(
          name: 'test',
          label: 'test',
          wikidataId: '123456',
          description: 'test')
    ],
    dateType: 'year',
    locations: <LocationModel>[
      LocationModel(
          name: 'test',
          point: locationModel.PointLocation(
              type: "point", coordinates: <double>[1.0, 1.0]))
    ],
    likes: null,
    year: 2023,
  );

  static final StoryModel storyWithDateTypeYearInterval = StoryModel(
    startYear: 2023,
    endYear: 2024,
    date: null,
    creationDate: DateTime.now(),
    startDate: null,
    endDate: null,
    decade: null,
    includeTime: false,
    id: 123456,
    author: 123456,
    authorUsername: 'test',
    seasonName: null,
    title: 'test',
    content: '<p>test</p>',
    storyTags: <TagModel>[
      TagModel(
          name: 'test',
          label: 'test',
          wikidataId: '123456',
          description: 'test')
    ],
    dateType: 'year_interval',
    locations: <LocationModel>[
      LocationModel(
          name: 'test',
          point: locationModel.PointLocation(
              type: "point", coordinates: <double>[1.0, 1.0]))
    ],
    likes: null,
    year: null,
  );

  static final StoryModel storyWithDateTypeDecade = StoryModel(
    startYear: null,
    endYear: null,
    date: null,
    creationDate: DateTime.now(),
    startDate: null,
    endDate: null,
    decade: 2020,
    includeTime: false,
    id: 123456,
    author: 123456,
    authorUsername: 'test',
    seasonName: null,
    title: 'test',
    content: '<p>test</p>',
    storyTags: <TagModel>[
      TagModel(
          name: 'test',
          label: 'test',
          wikidataId: '123456',
          description: 'test')
    ],
    dateType: 'decade',
    locations: <LocationModel>[
      LocationModel(
          name: 'test',
          point: locationModel.PointLocation(
              type: "point", coordinates: <double>[1.0, 1.0]))
    ],
    likes: null,
    year: null,
  );

  static final StoryModel storyWithDateTypeIntervalDate = StoryModel(
    startYear: null,
    endYear: null,
    date: null,
    creationDate: DateTime.now(),
    startDate: "2023-11-13",
    endDate: "2023-12-31",
    decade: null,
    includeTime: false,
    id: 123456,
    author: 123456,
    authorUsername: 'test',
    seasonName: null,
    title: 'test',
    content: '<p>test</p>',
    storyTags: <TagModel>[
      TagModel(
          name: 'test',
          label: 'test',
          wikidataId: '123456',
          description: 'test')
    ],
    dateType: 'interval_date',
    locations: <LocationModel>[
      LocationModel(
          name: 'test',
          point: locationModel.PointLocation(
              type: "point", coordinates: <double>[1.0, 1.0]))
    ],
    likes: null,
    year: null,
  );

  static final RecommendationsResponseModel responseSuccess =
      RecommendationsResponseModel(
          success: true,
          msg: "recommendations ok",
          recommendations: <Recommendation>[
        Recommendation(story: story),
        Recommendation(
            story: StoryModel(
          startYear: null,
          endYear: null,
          date: "01-01-2012",
          creationDate: DateTime.now(),
          startDate: null,
          endDate: null,
          decade: null,
          includeTime: false,
          id: 123456,
          author: 123456,
          authorUsername: 'test2',
          seasonName: null,
          title: 'test2',
          content: '<p>test2</p>',
          storyTags: <TagModel>[
            TagModel(
                name: 'test2',
                label: 'test2',
                wikidataId: '123456',
                description: 'test2')
          ],
          dateType: 'Normal Date',
          locations: <LocationModel>[
            LocationModel(
                name: 'test2',
                point: locationModel.PointLocation(
                    type: "point", coordinates: <double>[26.0, 45.0]))
          ],
          likes: null,
          year: null,
        ))
      ]);
}

class MockRecommendationsRepository extends RecommendationsRepository {
  @override
  Future<RecommendationsResponseModel> getRecommendations() async {
    return _Constants.responseSuccess;
  }
}

void main() {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late RecommendationsBloc recommendationsBloc;
  late RecommendationsRepository recommendationsInterface;

  setUp(() {
    recommendationsInterface = MockRecommendationsRepository();
    recommendationsBloc =
        RecommendationsBloc(repository: recommendationsInterface);
  });

  blocTest<RecommendationsBloc, RecommendationsState>(
    'emits [RecommendationsDisplayState] when RecommendationsEvent is added.',
    build: () => recommendationsBloc,
    act: (RecommendationsBloc bloc) =>
        bloc.add(RecommendationsLoadDisplayEvent()),
    expect: () => <TypeMatcher<RecommendationsDisplayState>>[
      isA<RecommendationsDisplayState>()
    ],
  );

  blocTest<RecommendationsBloc, RecommendationsState>(
    'emits [RecommendationsDisplayState] when RecommendationsEventRefreshStories is added.',
    build: () => recommendationsBloc,
    act: (RecommendationsBloc bloc) =>
        bloc.add(RecommendationsEventRefreshStories()),
    expect: () => <TypeMatcher<RecommendationsDisplayState>>[
      isA<RecommendationsDisplayState>()
    ],
  );

  test('getFormattedDate returns formatted date for normal_date type', () {
    // Arrange
    final StoryModel story = _Constants.story;

    // Act
    final String result = recommendationsBloc.getFormattedDate(story);

    // Assert
    expect(result, '2022-01-01');
  });

  test('getFormattedDate returns formatted date for year type', () {
    // Arrange
    final StoryModel story = _Constants.storyWithDateTypeYear;

    // Act
    final String result = recommendationsBloc.getFormattedDate(story);

    // Assert
    expect(result, 'Year: 2023');
  });

  test('getFormattedDate returns formatted date for year_interval type', () {
    // Arrange
    final StoryModel story = _Constants.storyWithDateTypeYearInterval;

    // Act
    final String result = recommendationsBloc.getFormattedDate(story);

    // Assert
    expect(result, 'Start: 2023 \nEnd: 2024');
  });

  test('getFormattedDate returns formatted date for interval_date type', () {
    // Arrange
    final StoryModel story = _Constants.storyWithDateTypeIntervalDate;

    // Act
    final String result = recommendationsBloc.getFormattedDate(story);

    // Assert
    expect(result, 'Start: 2023-11-13 \nEnd: 2023-12-31');
  });

  test('getFormattedDate returns formatted date for decade type', () {
    // Arrange
    final StoryModel story = _Constants.storyWithDateTypeDecade;

    // Act
    final String result = recommendationsBloc.getFormattedDate(story);

    // Assert
    expect(result, 'Decade: 2020');
  });

  test('formatDate returns formatted date for valid input', () {
    // Arrange
    const String dateString = '2022-01-01';

    // Act
    final String? result = recommendationsBloc.formatDate(dateString);

    // Assert
    expect(result, '2022-01-01');
  });

  test('formatDate returns null for null input', () {
    // Arrange
    // ignore: always_specify_types
    const dateString = null;

    // Act
    final String? result = recommendationsBloc.formatDate(dateString);

    // Assert
    expect(result, isNull);
  });

  test('formatDate returns null for invalid input', () {
    // Arrange
    const String dateString = 'invalid-date';

    // Act
    final String? result = recommendationsBloc.formatDate(dateString);

    // Assert
    expect(result, isNull);
  });
}
