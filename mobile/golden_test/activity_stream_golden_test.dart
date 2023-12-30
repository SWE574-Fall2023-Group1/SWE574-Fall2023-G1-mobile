import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/network/model/response_model.dart';
import 'package:memories_app/routes/activity_stream/activity_stream_route.dart';
import 'package:memories_app/routes/activity_stream/bloc/activity_stream_bloc.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_repository.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_response_model.dart';
import 'package:memories_app/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final ActivityStreamResponseModel responseSuccess =
      ActivityStreamResponseModel(
          success: true,
          msg: "activites ok",
          activity: <Activity>[
        Activity(
            id: 1,
            user: 1,
            userUsername: "test",
            activityType: "new_story",
            date: DateTime.now(),
            viewed: false,
            targetUser: 2,
            targetUserUsername: "test2",
            targetStory: 1,
            targetStoryTitle: "test"),
        Activity(
            id: 2,
            user: 2,
            userUsername: "test",
            activityType: "story_liked",
            date: DateTime.now(),
            viewed: false,
            targetUser: 3,
            targetUserUsername: "test3",
            targetStory: 3,
            targetStoryTitle: "story_liked")
      ]);

  static final ResponseModel viewActivityResponseSuccess =
      ResponseModel(true, "view activity ok");
}

class MockActivityStreamRepository extends ActivityStreamRepository {
  @override
  Future<ActivityStreamResponseModel> getActivities() async {
    return _Constants.responseSuccess;
  }

  @override
  Future<ResponseModel> viewActivity(int activityId) async {
    return _Constants.viewActivityResponseSuccess;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late ActivityStreamBloc activityStreamBloc;
  late ActivityStreamRepository activityStreamInterface;

  setUp(() {
    activityStreamInterface = MockActivityStreamRepository();
    activityStreamBloc =
        ActivityStreamBloc(repository: activityStreamInterface);
  });

  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('Activity Stream initial golden test',
      (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithActivityStreamRoute(activityStreamBloc),
          name: 'activity_stream/activity_stream_route_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(
        tester, 'activity_stream/activity_stream_route_initial');
  });
}

Widget initializeAppWithActivityStreamRoute(
    ActivityStreamBloc activityStreamBloc) {
  return MaterialApp(
    home: BlocProvider<ActivityStreamBloc>(
      create: (BuildContext context) =>
          activityStreamBloc..add(ActivityStreamLoadDisplayEvent()),
      child: const ActivityStreamRoute(),
    ),
  );
}
