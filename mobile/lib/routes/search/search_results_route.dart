// ignore_for_file: always_specify_types

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/routes/home/bloc/home_bloc.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/utils.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:html/dom.dart' as dom;

class SearchResultsRoute extends StatefulWidget {
  final List<StoryModel> stories;
  const SearchResultsRoute({required this.stories, super.key});

  @override
  State<SearchResultsRoute> createState() => _SearchResultsRouteState();
}

class _SearchResultsRouteState extends State<SearchResultsRoute> {
  final ScrollController _scrollController = ScrollController();
  bool reverseOrder = false;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Search Results"),
        ),
        body: Column(
          children: [
            const TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              labelColor: AppColors.buttonColor,
              dividerColor: AppColors.buttonColor,
              tabs: <Widget>[
                Tab(text: 'Results as a Timeline'),
                Tab(text: 'Results as a List'),
              ],
            ),
            Expanded(
              child: TabBarView(children: [
                Padding(
                  padding: const EdgeInsets.only(left: SpaceSizes.x8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: reverseOrder,
                                onChanged: (value) {
                                  setState(() {
                                    reverseOrder = value;
                                  });
                                },
                              ),
                            ),
                            const Text("Descending Order")
                          ],
                        ),
                      ),
                      Expanded(
                          child: _buildTimeline(reverseOrder
                              ? widget.stories.reversed.toList()
                              : widget.stories)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: SpaceSizes.x8),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Transform.scale(
                              scale: 0.8,
                              child: Switch(
                                value: reverseOrder,
                                onChanged: (value) {
                                  setState(() {
                                    reverseOrder = value;
                                  });
                                },
                              ),
                            ),
                            const Text("Descending Order")
                          ],
                        ),
                      ),
                      Expanded(
                          child: _buildStoryList(reverseOrder
                              ? widget.stories.reversed.toList()
                              : widget.stories)),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
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
                      _getFormattedDate(story),
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

  String _getFormattedDate(StoryModel story) {
    switch (story.dateType) {
      case 'year':
        return story.year?.toString() ?? '';
      case 'decade':
        return '${story.decade?.toString() ?? ''}s';
      case 'year_interval':
        return '${story.startYear.toString()} - ${story.endYear.toString()}';
      case 'normal_date':
        return _formatDate(story.date) ?? '';
      case 'interval_date':
        return '${_formatDate(story.startDate)} - ${_formatDate(story.endDate)}';
      default:
        return '';
    }
  }

  String? _formatDate(String? dateString) {
    if (dateString == null) {
      return null;
    }

    try {
      DateTime dateTime = DateTime.parse(dateString);

      bool isMidnight =
          dateTime.hour == 0 && dateTime.minute == 0 && dateTime.second == 0;

      String pattern = isMidnight ? 'yyyy-MM-dd' : 'yyyy-MM-dd HH:mm';

      String formattedDate = DateFormat(pattern).format(dateTime.toLocal());

      return formattedDate;
    } catch (e) {
      // ignore: avoid_print
      print('Error parsing date: $e');
      return null;
    }
  }

  Widget _buildTimeline(List<StoryModel> stories) {
    return ListView.builder(
      itemCount: stories.length,
      itemBuilder: (context, index) {
        StoryModel story = stories[index];
        String? imageUrl = story.content!.contains("<img")
            ? _extractImageUrl(story.content!)
            : null;

        return GestureDetector(
          onTap: () {
            _navigateToStoryDetail(context, story);
          },
          child: TimelineTile(
            alignment: TimelineAlign.start,
            isFirst: index == 0,
            isLast: index == stories.length - 1,
            indicatorStyle: const IndicatorStyle(
              width: 20,
              padding: EdgeInsets.symmetric(horizontal: SpaceSizes.x8),
              color: AppColors.buttonColor,
            ),
            hasIndicator: true,
            endChild: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: SpaceSizes.x8,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(blurRadius: 6, color: Colors.grey),
                      ],

                      //borderRadius: BorderRadius.all(Radius.circular(24)),
                      borderRadius: BorderRadius.circular(SpaceSizes.x8),
                      color: Colors.white,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (imageUrl != null &&
                            imageUrl.isNotEmpty &&
                            !imageUrl.contains("34.72.72.115:8000"))
                          Image.network(imageUrl),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                story.title ?? "",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(child: Text("by ${story.authorUsername}")),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "Memory Time: ${_getFormattedDate(story)}",
                              ),
                            ),
                            Row(
                              children: [
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
                  const SizedBox(
                    height: SpaceSizes.x8,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _extractImageUrl(String htmlContent) {
    final document = dom.Document.html(htmlContent);
    final imgElement = document.querySelector('img');
    return imgElement?.attributes['src'] ?? '';
  }
}
