import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_state.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/ui/TitledAppBar.dart';

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

  const ShowPostDetail({required this.story, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
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
            'By ${story.authorUsername}',
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
              child: Html(data: story.content),
            ),
          ),
        ],
      ),
    );
  }
}
