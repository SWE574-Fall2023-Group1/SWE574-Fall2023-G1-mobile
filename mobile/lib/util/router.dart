import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/home_route.dart';
import 'package:memories_app/routes/login/bloc/login_bloc.dart';
import 'package:memories_app/routes/login/login_route.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/register/bloc/register_bloc.dart';
import 'package:memories_app/routes/register/register_route.dart';

import '../routes/register/model/register_repository.dart';

// TODO: Edit this file as needed

enum AppRoute { login, register, home }

extension AppRouteExtension on AppRoute {
  void navigate(BuildContext context, {Object? arguments}) async {
    switch (this) {
      case AppRoute.login:
        final loginBloc = LoginBloc(repository: LoginRepositoryImp());
        final loginRoute = LoginRoute();

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) => loginBloc..add(LoginLoadDisplayEvent()),
                child: loginRoute,
              ),
            ),
            (route) => false);
      case AppRoute.register:
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BlocProvider(
                create: (context) =>
                    RegisterBloc(repository: RegisterRepositoryImp())
                      ..add(RegisterLoadDisplayEvent()),
                child: RegisterRoute(),
              ),
            ));
      case AppRoute.home:
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeRoute(),
            ),
            (route) => false);
    }
  }
}
