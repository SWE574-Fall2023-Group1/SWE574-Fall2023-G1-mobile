import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/routes/create_story/model/story_request_model.dart';
import 'package:memories_app/routes/edit_story/bloc/edit_story_bloc.dart';
import 'package:memories_app/routes/edit_story/edit_story_route.dart';
import 'package:memories_app/routes/edit_story/model/edit_story_repository.dart';
import 'package:memories_app/routes/edit_story/model/edit_story_response_model.dart';
import 'package:memories_app/routes/home/model/location_model.dart'
    as locationModel;
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final EditStoryResponseModel responseSuccess = EditStoryResponseModel(
    success: true,
    msg: 'Story ok',
  );

  static final EditStoryResponseModel responseFailure = EditStoryResponseModel(
      success: false, msg: 'One of the required fields is empty');

  static final StoryModel storyModel = StoryModel(
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
  );
}

class MockEditStoryRepository extends EditStoryRepository {
  @override
  Future<EditStoryResponseModel> editStory(
      StoryRequestModel model, int storyId) async {
    if (model.title.isNotEmpty &&
        model.content.isNotEmpty &&
        model.storyTags != null &&
        model.storyTags!.isNotEmpty &&
        model.dateType.isNotEmpty &&
        model.locationIds.isNotEmpty) {
      return _Constants.responseSuccess;
    } else {
      return _Constants.responseFailure;
    }
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late EditStoryBloc editStoryBloc;
  late EditStoryRepository editStoryInterface;

  setUp(() {
    editStoryInterface = MockEditStoryRepository();
    editStoryBloc = EditStoryBloc(repository: editStoryInterface);
  });

  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('EditStory initial golden test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithEditStoryRoute(editStoryBloc),
          name: 'edit_story/edit_story_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'edit_story/edit_story_initial');
  });
}

Widget initializeAppWithEditStoryRoute(EditStoryBloc editStoryBloc) {
  return MaterialApp(
    home: BlocProvider<EditStoryBloc>(
      create: (BuildContext context) => editStoryBloc,
      child: EditStoryRoute(
        storyModel: _Constants.storyModel,
      ),
    ),
  );
}
