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

  test('getFormattedDate returns formatted date for year type', () {
    final StoryModel story = _Constants.story;

    final String result = recommendationsBloc.getFormattedDate(story);

    expect(result, '2022-01-01');
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
