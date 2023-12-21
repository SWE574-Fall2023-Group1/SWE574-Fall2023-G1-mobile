import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/activity_stream/activity_stream_route.dart';
import 'package:memories_app/routes/activity_stream/bloc/activity_stream_bloc.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_repository.dart';
import 'package:memories_app/routes/edit_story/bloc/edit_story_bloc.dart';
import 'package:memories_app/routes/edit_story/edit_story_route.dart';
import 'package:memories_app/routes/edit_story/model/edit_story_repository.dart';
import 'package:memories_app/routes/landing/bloc/landing_bloc.dart';
import 'package:memories_app/routes/landing/landing_page.dart';
import 'package:memories_app/routes/login/bloc/login_bloc.dart';
import 'package:memories_app/routes/login/login_route.dart';
import 'package:memories_app/routes/login/model/login_repository.dart';
import 'package:memories_app/routes/profile/bloc/profile_bloc.dart';
import 'package:memories_app/routes/profile/profile_route.dart';
import 'package:memories_app/routes/register/bloc/register_bloc.dart';
import 'package:memories_app/routes/register/register_route.dart';
import 'package:memories_app/routes/register/model/register_repository.dart';
import 'package:memories_app/routes/search/search_results_route.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
import 'package:memories_app/routes/home/model/story_model.dart';

// TODO: Edit this file as needed

enum AppRoute {
  login,
  register,
  landing,
  storyDetail,
  editStory,
  searchResults,
  profile,
  activityStream,
}

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
              // ignore: always_specify_types
              builder: (BuildContext context) => BlocProvider(
                create: (BuildContext context) =>
                    RegisterBloc(repository: RegisterRepositoryImp())
                      ..add(RegisterLoadDisplayEvent()),
                child: const RegisterRoute(),
              ),
            ));
      case AppRoute.landing:
        final LandingBloc landingBloc = LandingBloc();

        Navigator.pushAndRemoveUntil(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider<LandingBloc>(
                create: (BuildContext context) =>
                    landingBloc..add(LandingLoadEvent(tabIndex: 0)),
                child: const LandingPage(),
              ),
            ),
            // ignore: always_specify_types
            (Route route) => false);
      case AppRoute.storyDetail:
        Navigator.push(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider<StoryDetailBloc>(
                create: (BuildContext context) => StoryDetailBloc(),
                child: StoryDetailRoute(
                  story: arguments as StoryModel,
                ),
              ),
            ));
      case AppRoute.editStory:
        Navigator.push(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider<EditStoryBloc>(
                create: (BuildContext context) =>
                    EditStoryBloc(repository: EditStoryRepositoryImp()),
                child: EditStoryRoute(
                  storyModel: arguments as StoryModel,
                ),
              ),
            ));

      case AppRoute.searchResults:
        Navigator.push(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => SearchResultsRoute(
                stories: arguments as List<StoryModel>,
              ),
            ));

      case AppRoute.profile:
        Navigator.pushReplacement(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) => BlocProvider<ProfileBloc>(
                create: (BuildContext context) => ProfileBloc(),
                child: ProfileRoute(userId: arguments as int?),
              ),
            ));

      case AppRoute.activityStream:
        Navigator.push(
            context,
            // ignore: always_specify_types
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  BlocProvider<ActivityStreamBloc>(
                create: (BuildContext context) => ActivityStreamBloc(
                    repository: ActivityStreamRepositoryImp())
                  ..add(ActivityStreamLoadDisplayEvent()),
                child: const ActivityStreamRoute(),
              ),
            ));
    }
  }
}
