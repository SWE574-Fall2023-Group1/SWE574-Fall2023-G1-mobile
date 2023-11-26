import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:integration_test/integration_test.dart';
import 'package:memories_app/routes/login/bloc/login_bloc.dart';
import 'package:memories_app/routes/login/login_route.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/login/model/login_request_model.dart';
import 'package:memories_app/routes/login/model/login_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/util/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static const String username = 'ayhanc';
  static const String invalidUsername = 'ayhan';
  static const String failPassword = '123457';
  static const String invalidPassword = '12345';

  static final LoginResponseModel responseSuccess = LoginResponseModel(
      success: true,
      msg: 'Login success',
      refresh: "mockRefreshToken",
      access: "mockAccessToken");

  static final LoginResponseModel responseFailure =
      LoginResponseModel(success: false, msg: 'Invalid username or password');
}

class MockLoginRepository extends LoginRepository {
  @override
  Future<LoginResponseModel> login(LoginRequestModel model) async {
    if (model.password != _Constants.failPassword) {
      return _Constants.responseSuccess;
    } else {
      return _Constants.responseFailure;
    }
  }

  @override
  Future<UserDetailsResponseModel> getUserDetails() {
    return Future<UserDetailsResponseModel>.value(
      UserDetailsResponseModel(
        id: 1,
        username: "John Doe",
        email: "john.doe@example.com",
      ),
    );
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late LoginBloc loginBloc;
  late LoginRepository loginInterface;

  setUp(() {
    loginInterface = MockLoginRepository();
    loginBloc = LoginBloc(repository: loginInterface);
  });

  setUpAll(() async {
    await loadAppFonts();
  });

  testGoldens('LoginRoute initial golden test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices)
      ..addScenario(
          widget: initializeAppWithLoginRoute(loginBloc),
          name: 'login/login_route_initial');
    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'login/login_route_initial');
  });

  testGoldens('LoginRoute alert dialog test', (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices);

    builder.addScenario(
      widget: initializeAppWithLoginRoute(loginBloc),
      onCreate: (Key scenarioWidgetKey) async {
        loginBloc.add(LoginLoadDisplayEvent());
        await tester.pumpAndSettle();
        final Finder usernameFinder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byKey(WidgetKeys.usernameFieldKey));

        expect(usernameFinder, findsOneWidget);
        await tester.pumpAndSettle();

        final Finder passwordFinder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byKey(WidgetKeys.passwordFieldKey));
        expect(passwordFinder, findsOneWidget);
        await tester.pumpAndSettle();

        final Finder loginButtonFinder = find.descendant(
            of: find.byKey(scenarioWidgetKey),
            matching: find.byKey(WidgetKeys.loginButtonKey));

        expect(loginButtonFinder, findsOneWidget);
        await tester.pumpAndSettle();

        await tester.enterText(usernameFinder, _Constants.username);
        await tester.pumpAndSettle();

        await tester.enterText(passwordFinder, _Constants.failPassword);

        await tester.pumpAndSettle();
        await tester.ensureVisible(loginButtonFinder);

        await tester.tap(loginButtonFinder, warnIfMissed: false);

        await tester.pumpAndSettle();
      },
    );

    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'login/login_route_alert_dialog');
  });

  testGoldens('validation messages are displayed correctly',
      (WidgetTester tester) async {
    final DeviceBuilder builder = DeviceBuilder()
      ..overrideDevicesForAllScenarios(devices: TestDevices.devices);

    builder.addScenario(
        widget: initializeAppWithLoginRoute(loginBloc),
        onCreate: (Key scenarioWidgetKey) async {
          loginBloc.add(LoginLoadDisplayEvent());
          await tester.pumpAndSettle();
          final Finder usernameFinder = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.byKey(WidgetKeys.usernameFieldKey));

          expect(usernameFinder, findsOneWidget);

          final Finder passwordFinder = find.descendant(
              of: find.byKey(scenarioWidgetKey),
              matching: find.byKey(WidgetKeys.passwordFieldKey));
          expect(passwordFinder, findsOneWidget);

          await tester.enterText(usernameFinder, _Constants.invalidUsername);
          await tester.pumpAndSettle();

          await tester.enterText(passwordFinder, _Constants.invalidPassword);

          await tester.pumpAndSettle();
        });

    await tester.pumpDeviceBuilder(builder);
    await tester.pumpAndSettle();
    await screenMatchesGolden(tester, 'login/login_route_validation_messages');
  });
}

Widget initializeAppWithLoginRoute(LoginBloc loginBloc) {
  return MaterialApp(
    home: BlocProvider<LoginBloc>(
      create: (BuildContext context) => loginBloc..add(LoginLoadDisplayEvent()),
      child: const LoginRoute(),
    ),
  );
}
