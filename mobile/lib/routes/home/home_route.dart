// ignore_for_file: always_specify_types, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
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

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocConsumer<HomeBloc, HomeState>(
      builder: (BuildContext context, HomeState state) {
        Widget column;
        if (state is HomeInitial) {
          column = const Center(child: CircularProgressIndicator());
        } else if (state is HomeDisplayState) {
          column = state.stories.isNotEmpty
              ? RefreshIndicator(
                  onRefresh: _refreshStories,
                  child: Container(
                    color: Colors.white,
                    child: Column(children: <Widget>[
                      Expanded(child: _buildStoryList(state.stories)),
                      if (state.showLoadingAnimation) ...<Widget>[
                        const SizedBox(
                          height: SpaceSizes.x16,
                        ),
                        const CircularProgressIndicator(),
                      ]
                    ]),
                  ),
                )
              : const Center(
                  child:
                      Text("There no stories from the users you are following"),
                );
        } else if (state is HomeFailure) {
          column = Center(
            child: Text("Error: ${state.error.toString()}"),
          );
        } else if (state is HomeOffline) {
          column = Center(
            child: Text(state.offlineMessage.toString()),
          );
        } else {
          column = const Center(child: CircularProgressIndicator());
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
            body: column,
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
      controller: _scrollController,
      itemCount: stories.length,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            _navigateToStoryDetail(context, stories[index]);
          },
          child: _buildStoryCard(context, stories[index]),
        );
      },
      padding: const EdgeInsets.all(8),
    );
  }

  Future<void> _navigateToStoryDetail(
      BuildContext context, StoryModel story) async {
    final bool shouldRefreshStories = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => BlocProvider<StoryDetailBloc>(
          create: (BuildContext context) => StoryDetailBloc(),
          child: StoryDetailRoute(
            story: story,
          ),
        ),
      ),
    );

    if (shouldRefreshStories) {
      // ignore: use_build_context_synchronously
      BlocProvider.of<HomeBloc>(context).add(HomeEventRefreshStories());
    }
  }

  Future<void> _scrollListener() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      context.read<HomeBloc>().add(HomeEventLoadMoreStory());
    }
  }

  Future<void> _refreshStories() async {
    context.read<HomeBloc>().add(HomeEventRefreshStories());
  }
}

Widget _buildStoryCard(BuildContext context, StoryModel story) => Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                if (story.isEditable)
                  GestureDetector(
                      onTap: () {
                        AppRoute.editStory.navigate(context, arguments: story);
                      },
                      child: Icon(Icons.edit)),
              ],
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
                    story.dateText ?? '',
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
                    story.locations?.firstOrNull?.name ?? '',
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
