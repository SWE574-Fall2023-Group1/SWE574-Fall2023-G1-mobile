import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_state.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/routes/story_detail/wigdets/comments_container.dart';
import 'package:memories_app/routes/story_detail/wigdets/likes_container.dart';
import 'package:memories_app/routes/story_detail/wigdets/location_names_container.dart';
import 'package:memories_app/routes/story_detail/wigdets/story_date_container.dart';
import 'package:memories_app/ui/date_text_view.dart';
import 'package:memories_app/ui/titled_app_bar.dart';

bool shouldRefreshStories = false;

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
  Future<bool> _onWillPop() async {
    Navigator.pop(context, shouldRefreshStories);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocConsumer<StoryDetailBloc, StoryDetailState>(
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
      ),
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
                LikesContainer(
                  storyId: story.id,
                  initialLikes: story.likes ?? <int>[],
                )
              ],
            ),
            const SizedBox(height: 6),
            const Divider(
              color: Colors.black,
              thickness: 1,
            ),
            LoadComments(storyId: story.id),
          ],
        ),
      ),
    );
  }
}
