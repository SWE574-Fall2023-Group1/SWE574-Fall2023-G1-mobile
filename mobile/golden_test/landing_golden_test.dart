import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/routes/landing/bloc/landing_bloc.dart';
import 'package:memories_app/routes/landing/landing_page.dart';
import 'package:memories_app/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late LandingBloc landingBloc;

  setUp(() {
    landingBloc = LandingBloc();
  });

  tearDown(() {
    landingBloc.close();
  });

  testGoldens('Landing page initial golden test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithLandingPage(landingBloc),
          name: 'landing/landing_page_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();

    await screenMatchesGolden(tester, 'landing/landing_page_initial');
  });
}

Widget initializeAppWithLandingPage(LandingBloc landingBloc) {
  return MaterialApp(
    home: BlocProvider<LandingBloc>(
      create: (BuildContext context) =>
          landingBloc..add(LandingLoadEvent(tabIndex: 0)),
      child: const LandingPage(),
    ),
  );
}
