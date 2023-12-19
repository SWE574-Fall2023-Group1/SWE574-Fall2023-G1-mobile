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

class SearchResultsRoute extends StatefulWidget {
  final List<StoryModel> stories;
  const SearchResultsRoute({required this.stories, super.key});

  @override
  State<SearchResultsRoute> createState() => _SearchResultsRouteState();
}

class _SearchResultsRouteState extends State<SearchResultsRoute> {
  final ScrollController _scrollController = ScrollController();

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
                ListView(),
                _buildStoryList(widget.stories),
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
        return 'Year: ${story.year?.toString() ?? ''}';
      case 'decade':
        return 'Decade: ${story.decade?.toString() ?? ''}';
      case 'year_interval':
        return 'Start: ${story.startYear.toString()} \nEnd: ${story.endYear.toString()}';
      case 'normal_date':
        return _formatDate(story.date) ?? '';
      case 'interval_date':
        return 'Start: ${_formatDate(story.startDate)} \nEnd: ${_formatDate(story.endDate)}';
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
}
