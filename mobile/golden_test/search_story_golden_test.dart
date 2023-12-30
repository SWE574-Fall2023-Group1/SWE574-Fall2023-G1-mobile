import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/search/bloc/search_story_bloc.dart';
import 'package:memories_app/routes/search/model/search_story_repository.dart';
import 'package:memories_app/routes/search/model/search_story_request_model.dart';
import 'package:memories_app/routes/search/model/search_story_response_model.dart';
import 'package:memories_app/routes/search/search_story_route.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/routes/home/model/location_model.dart'
    // ignore: library_prefixes
    as locationModel;
import 'package:memories_app/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final SearchStoryResponseModel responseSuccess =
      SearchStoryResponseModel(
    stories: <StoryModel>[
      StoryModel(
        startYear: null,
        endYear: null,
        date: "01-01-2022",
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
        dateType: 'Normal Date',
        locations: <LocationModel>[
          LocationModel(
              name: 'test',
              point: locationModel.PointLocation(
                  type: "point", coordinates: <double>[1.0, 1.0]))
        ],
        likes: null,
        year: null,
      )
    ],
  );

  static final SearchStoryResponseModel responseFailure =
      SearchStoryResponseModel(
    stories: <StoryModel>[],
  );
}

class MockSearchStoryRepository extends SearchStoryRepository {
  @override
  Future<SearchStoryResponseModel> searchStory(
      SearchStoryRequestModel request) async {
    if (request.location?.coordinates == null &&
        request.author == null &&
        request.title == null) {
      return _Constants.responseFailure;
    } else {
      return _Constants.responseSuccess;
    }
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late SearchStoryBloc searchStoryBloc;
  late SearchStoryRepository searchStoryInterface;

  setUp(() {
    searchStoryInterface = MockSearchStoryRepository();
    searchStoryBloc = SearchStoryBloc(repository: searchStoryInterface);
  });

  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('SearchStory initial golden test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithSearchStoryRoute(searchStoryBloc),
          name: 'search_story/search_story_route_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(
        tester, 'search_story/search_story_route_initial');
  });
}

Widget initializeAppWithSearchStoryRoute(SearchStoryBloc searchStoryBloc) {
  return MaterialApp(
    home: BlocProvider<SearchStoryBloc>(
      create: (BuildContext context) => searchStoryBloc,
      child: const SearchStoryRoute(),
    ),
  );
}
