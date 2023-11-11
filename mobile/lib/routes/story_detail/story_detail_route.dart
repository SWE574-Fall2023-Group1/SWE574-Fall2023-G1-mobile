import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_state.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';

class StoryDetailRoute extends StatefulWidget {
  final int storyId;

  const StoryDetailRoute({required this.storyId, super.key});

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
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Image.asset(
              'assets/login/logo.png',
              height: 140,
            ),
            centerTitle: true,
          ),
          body: const LoadPost(),
        ));
        return container;
      },
      listener: (BuildContext context, StoryDetailState state) {},
    );
  }
}

class LoadPost extends StatelessWidget {
  Future<StoryModel> loadPosts(BuildContext context) async {
    StoryModel? responseModel;
    responseModel = await StoryDetailRepositoryImp().getStoryById(id: 1);
    return responseModel;
  }

  const LoadPost({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StoryModel>(
      future: loadPosts(context),
      builder: (BuildContext context, AsyncSnapshot<StoryModel> snapshot) {
        if (snapshot.hasData) {
          StoryModel story = snapshot.data!;
          return Text(story.authorUsername ?? "null");
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
