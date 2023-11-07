import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/util/utils.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({super.key});

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute>
    with AutomaticKeepAliveClientMixin<HomeRoute> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        Widget container;
        if (state is HomeInitial) {
          container = const Center(child: CircularProgressIndicator());
        } else if (state is HomeDisplayState) {
          container = state.stories.isNotEmpty
              ? _buildStoryList(state.stories)
              : const Center(
                  child:
                      Text("There no stories from the users you are following"),
                );
        } else if (state is HomeFailure) {
          container = Center(
            child: Text("Error: ${state.error.toString()}"),
          );
        } else if (state is HomeOffline) {
          container = Center(
            child: Text(state.offlineMessage.toString()),
          );
        } else {
          container = const Center(child: CircularProgressIndicator());
        }
        return Material(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: const Icon(
                  Icons.power_settings_new,
                  color: Colors.black87,
                ),
                onPressed: () {
                  onPressLogout(context);
                },
              ),
              title: Image.asset(
                'assets/login/logo.png',
                height: 140,
              ),
              centerTitle: true,
            ),
            body: container,
          ),
        );
      },
      listener: (BuildContext context, HomeState state) {
        if (state is HomeNavigateToLoginState) {
          AppRoute.login.navigate(context);
        }
      },
    );
  }

  Widget _buildStoryList(List<StoryModel> stories) {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildStoryCard(stories[index]);
      },
      padding: const EdgeInsets.all(8),
    );
  }
}

Widget _buildStoryCard(StoryModel story) => Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'By ${story.authorUsername}',
              style: const TextStyle(
                color: Color(0xFFAFB4B7),
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                height: 0,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    story.title ?? "",
                    style: const TextStyle(
                      color: Color(0xFF5F6565),
                      fontSize: 18,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/home/calendar_icon.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    story.date ?? '',
                    style: const TextStyle(
                      color: Color(0xFFAFB4B7),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Image.asset(
                  'assets/home/location_marker.png',
                  height: 20,
                  width: 20,
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    story.locationIds?[0].name ?? '',
                    style: const TextStyle(
                      color: Color(0xFFAFB4B7),
                      fontSize: 14,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
                const SizedBox(width: SpaceSizes.x16),
                Row(
                  children: <Widget>[
                    const Text(
                      'More',
                      style: TextStyle(
                        color: Color(0xFFAFB4B7),
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Image.asset(
                      'assets/home/chevrons-right.png',
                      height: 20,
                      width: 20,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );

void onPressLogout(BuildContext context) {
  BlocProvider.of<HomeBloc>(context).add(HomeEventPressLogout());
}
