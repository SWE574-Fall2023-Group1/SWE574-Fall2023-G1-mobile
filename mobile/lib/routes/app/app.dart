import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/app/bloc/app_bloc.dart';
import 'package:memories_app/routes/landing/landing_page.dart';
import 'package:memories_app/routes/login/login_route.dart';
import 'package:memories_app/util/router.dart';

// TODO: Add splash screen

void runApplication() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: BlocProvider<AppBloc>(
          create: (BuildContext context) => AppBloc()..add(AppStarted()),
          child: BlocBuilder<AppBloc, AppState>(
              builder: (BuildContext context, AppState state) {
            if (state is AppInitial) {
              return Container();
            } else if (state is AppAuthenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AppRoute.landing.navigate(context);
              });
            } else if (state is AppUnauthenticated) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AppRoute.login.navigate(context);
              });
            } else if (state is AppLoading) {
              return Container();
            }
            return Container();
          }),
        ),
        routes: <String, WidgetBuilder>{
          LoginRoute.routeName: (BuildContext context) => const LoginRoute(),
          LandingPage.routeName: (BuildContext context) => const LandingPage(),
        });
  }
}
