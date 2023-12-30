import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/search/search_results_route.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memories_app/routes/home/model/location_model.dart'
    // ignore: library_prefixes
    as locationModel;

class _Constants {
  static final List<StoryModel> stories = [
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
    ),
    StoryModel(
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
    )
  ];
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});

  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('CreateStory initial golden test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithSearchResultsRoute(),
          name: 'search_results/search_results_route_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(
        tester, 'search_results/search_results_route_initial');
  });

  testGoldens('CreateStory list mode golden test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithSearchResultsRoute(),
          name: 'search_results/search_results_route_list',
          onCreate: (Key scenarioWidgetKey) async {
            final Finder listModeFinder = find.descendant(
                of: find.byKey(scenarioWidgetKey),
                matching: find.byKey(WidgetKeys.searchResultsListModeKey));
            expect(listModeFinder, findsOneWidget);

            await tester.pumpAndSettle();
            await tester.tap(listModeFinder, warnIfMissed: false);
            await tester.pumpAndSettle();
          });
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(
        tester, 'search_results/search_results_route_list');
  });
}

Widget initializeAppWithSearchResultsRoute() {
  return MaterialApp(
    home: SearchResultsRoute(
      stories: _Constants.stories,
    ),
  );
}
