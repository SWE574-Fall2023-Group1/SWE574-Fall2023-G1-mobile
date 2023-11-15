import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_state.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/ui/date_text_view.dart';
import 'package:memories_app/ui/titled_app_bar.dart';

class StoryDetailRoute extends StatefulWidget {
  final StoryModel story;

  const StoryDetailRoute({required this.story, super.key});

  @override
  _StoryDetailRouteState createState() => _StoryDetailRouteState();
}

Future<StoryModel> loadStoryById(BuildContext context, int storyId) async {
  StoryModel? responseModel;

  responseModel = await StoryDetailRepositoryImp().getStoryById(id: storyId);

  return responseModel;
}

class _StoryDetailRouteState extends State<StoryDetailRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StoryDetailBloc, StoryDetailState>(
      builder: (BuildContext context, StoryDetailState state) {
        Widget container;
        container = MaterialApp(
          home: Scaffold(
            appBar: TitledAppBar.createAppBar(title: "Story Detail"),
            body: ShowPostDetail(story: widget.story),
          ),
        );
        return container;
      },
      listener: (BuildContext context, StoryDetailState state) {},
    );
  }
}

class ShowPostDetail extends StatelessWidget {
  final StoryModel story;

  const ShowPostDetail({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            Text(
              story.title ?? "",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 0,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'By: ${story.authorUsername}',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w700,
                height: 0,
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 8),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Html(data: story.content, style: <String, Style>{
                  "p": Style(
                    color: Colors.black,
                    fontSize: FontSize(12),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                  ),
                }),
              ),
            ),
            const SizedBox(height: 28),
            LocationNamesContainer(story: story),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: StoryDateContainer(story: story),
                )
              ],
            ),
            const SizedBox(height: 6),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DateText.build(text: "Tags:"),
                      DateText.build(text: story.storyTags ?? "N/A")
                    ],
                  ),
                ),
                // Text(story.likes?.length.toString() ?? "0")
                LikesContainer(likesCount: story.likes?.length)
              ],
            ),
            const SizedBox(height: 6),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class LocationNamesContainer extends StatelessWidget {
  final StoryModel story;

  const LocationNamesContainer({required this.story, super.key});

  Widget _buildLocationsList() {
    if (story.locationIds?.isEmpty ?? false) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (LocationModel location in story.locationIds!) ...<Widget>[
          Text(
            location.name,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        const Text(
          "*** Map Here ***",
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLocationsList();
  }
}

class StoryDateContainer extends StatelessWidget {
  final StoryModel story;

  const StoryDateContainer({required this.story, super.key});

  String? getHumanizedDate(dynamic date) {
    if (date is DateTime) {
      return DateFormat('MMMM d, y').format(date);
    } else if (date is String) {
      DateTime? parsedDate = DateTime.tryParse(date);
      if (parsedDate != null) {
        return DateFormat('MMMM d, y').format(parsedDate);
      }
    }
    return null;
  }

  String getFormattedDate(StoryModel story) {
    switch (story.dateType) {
      case 'year':
        return 'Year: ${story.year?.toString() ?? ''}';
      case 'decade':
        return 'Decade: ${story.decade?.toString() ?? ''}';
      case 'year_interval':
        return 'Start: ${getHumanizedDate(story.startYear.toString())} \nEnd: ${getHumanizedDate(story.endYear.toString())}';
      case 'normal_date':
        return getHumanizedDate(story.date) ?? '';
      case 'interval_date':
        return 'Start: ${getHumanizedDate(story.startDate)} \nEnd: ${getHumanizedDate(story.endDate)}';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DateText.build(text: "Story Time"),
        DateText.build(text: getFormattedDate(story))
      ],
    );
  }
}

class LikesContainer extends StatelessWidget {
  final int? likesCount;

  const LikesContainer({required this.likesCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.favorite_border,
          color: Colors.black,
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD9D9D9),
          ),
          child: Text(
            likesCount?.toString() ?? "0",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              height: 0,
              letterSpacing: 1.75,
            ),
          ),
        ),
      ],
    );
  }
}
