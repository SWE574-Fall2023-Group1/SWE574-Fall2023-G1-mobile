import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/recommendations/bloc/recommendations_bloc.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_response.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/styles.dart';
import 'package:memories_app/util/utils.dart';

class RecommendationsRoute extends StatefulWidget {
  const RecommendationsRoute({super.key});

  @override
  State<RecommendationsRoute> createState() => _RecommendationsRouteState();
}

class _RecommendationsRouteState extends State<RecommendationsRoute> {
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RecommendationsBloc, RecommendationsState>(
      builder: (BuildContext context, RecommendationsState state) {
        Widget column;
        if (state is RecommendationsInitial) {
          column = const Center(child: CircularProgressIndicator());
        } else if (state is RecommendationsDisplayState) {
          column = state.recommendations.isNotEmpty
              ? Container(
                  color: Colors.white,
                  child: Column(children: <Widget>[
                    Expanded(child: _buildStoryList(state.recommendations)),
                    if (state.showLoadingAnimation) ...<Widget>[
                      const SizedBox(
                        height: SpaceSizes.x16,
                      ),
                      const CircularProgressIndicator(),
                    ]
                  ]),
                )
              : const Center(
                  child:
                      Text("There no stories from the users you are following"),
                );
        } else if (state is RecommendationsFailure) {
          column = Center(
            child: Text("Error: ${state.error.toString()}"),
          );
        } else if (state is RecommendationsOffline) {
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
              centerTitle: true,
              title: const Text(
                "Suggested Stories",
                style: Styles.appBarTitleStyle,
              ),
            ),
            body: column,
          ),
        );
      },
    );
  }

  Widget _buildStoryList(List<Recommendation> recommendations) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: recommendations.length,
      itemBuilder: (BuildContext context, int index) {
        final StoryModel? story = recommendations[index].story;
        return GestureDetector(
          onTap: () {
            _navigateToStoryDetail(context, story!);
          },
          child: _buildStoryCard(context, story),
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
      BlocProvider.of<RecommendationsBloc>(context)
          .add(RecommendationsEventRefreshStories());
    }
  }
}

Widget _buildStoryCard(BuildContext context, StoryModel? story) {
  return story != null
      ? Card(
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
                        fontFamily: 'JosefinSans',
                        fontWeight: FontWeight.bold,
                        height: 0,
                      ),
                    ),
                    if (story.isEditable)
                      GestureDetector(
                          onTap: () {
                            AppRoute.editStory
                                .navigate(context, arguments: story);
                          },
                          child: const Icon(Icons.edit)),
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
                          fontFamily: 'JosefinSans',
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
                          fontFamily: 'JosefinSans',
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
                          fontFamily: 'JosefinSans',
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
                            fontFamily: 'JosefinSans',
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
        )
      : const SizedBox.shrink();
}
