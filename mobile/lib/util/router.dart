import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/landing/bloc/landing_bloc.dart';
import 'package:memories_app/routes/landing/landing_page.dart';
import 'package:memories_app/routes/login/bloc/login_bloc.dart';
import 'package:memories_app/routes/login/login_route.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/register/register_route.dart';

// TODO: Edit this file as needed

enum AppRoute { login, register, landing }

extension AppRouteExtension on AppRoute {
  void navigate(BuildContext context, {Object? arguments}) async {
    switch (this) {
      case AppRoute.login:
        final LoginBloc loginBloc = LoginBloc(repository: LoginRepositoryImp());
        const LoginRoute loginRoute = LoginRoute();

        Navigator.pushAndRemoveUntil(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              // ignore: always_specify_types
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) =>
                    loginBloc..add(LoginLoadDisplayEvent()),
                child: loginRoute,
              ),
            ),
            // ignore: always_specify_types
            (Route route) => false);
      case AppRoute.register:
        Navigator.push(
          context,
          // ignore: always_specify_types
          MaterialPageRoute(
            builder: (BuildContext context) => const RegisterRoute(),
          ),
        );
      case AppRoute.landing:
        final LandingBloc landingBloc = LandingBloc();

        Navigator.pushAndRemoveUntil(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider<LandingBloc>(
                create: (BuildContext context) => landingBloc,
                child: const LandingPage(),
              ),
            ),
            // ignore: always_specify_types
            (Route route) => false);
    }
  }
}
