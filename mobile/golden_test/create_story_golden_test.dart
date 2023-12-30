// Import the necessary packages
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/routes/create_story/bloc/create_story_bloc.dart';
import 'package:memories_app/routes/create_story/create_story_route.dart';
import 'package:memories_app/routes/create_story/create_story_repository.dart';
import 'package:memories_app/routes/create_story/model/story_request_model.dart';
import 'package:memories_app/routes/create_story/model/create_story_response_model.dart';
import 'package:memories_app/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final CreateStoryResponseModel responseSuccess =
      CreateStoryResponseModel(
    success: true,
    msg: 'Story ok',
  );
  static final CreateStoryResponseModel responseFailure =
      CreateStoryResponseModel(
          success: false, msg: 'One of the required fields is empty');
}

class MockCreateStoryRepository extends CreateStoryRepository {
  @override
  Future<CreateStoryResponseModel> createStory(StoryRequestModel model) async {
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
  late CreateStoryBloc createStoryBloc;
  late CreateStoryRepository createStoryInterface;

  setUp(() {
    createStoryInterface = MockCreateStoryRepository();
    createStoryBloc = CreateStoryBloc(repository: createStoryInterface);
  });

  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('CreateStory initial golden test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithCreateStoryRoute(createStoryBloc),
          name: 'create_story/create_story_route_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(
        tester, 'create_story/create_story_route_initial');
  });
}

Widget initializeAppWithCreateStoryRoute(CreateStoryBloc createStoryBloc) {
  return MaterialApp(
    home: BlocProvider<CreateStoryBloc>(
      create: (BuildContext context) => createStoryBloc,
      child: const CreateStoryRoute(),
    ),
  );
}
