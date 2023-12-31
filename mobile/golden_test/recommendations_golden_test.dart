import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/recommendations/bloc/recommendations_bloc.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_repository.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_response.dart';
import 'package:memories_app/routes/recommendations/recommendations_route.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/routes/home/model/location_model.dart'
    // ignore: library_prefixes
    as locationModel;
import 'package:memories_app/util/utils.dart';
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
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late RecommendationsBloc recommendationsBloc;
  late RecommendationsRepository recommendationsInterface;

  setUp(() {
    recommendationsInterface = MockRecommendationsRepository();
    recommendationsBloc =
        RecommendationsBloc(repository: recommendationsInterface);
  });

  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Recommendations initial golden test',
      (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithRecommendationsRoute(recommendationsBloc),
          name: 'recommendations/recommendations_route_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(
        tester, 'recommendations/recommendations_route_initial');
  });
}

Widget initializeAppWithRecommendationsRoute(
    RecommendationsBloc recommendationsBloc) {
  return MaterialApp(
    home: BlocProvider<RecommendationsBloc>(
      create: (BuildContext context) =>
          recommendationsBloc..add(RecommendationsLoadDisplayEvent()),
      child: const RecommendationsRoute(),
    ),
  );
}
