import 'package:flutter/material.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/util/utils.dart';

class EditStoryRoute extends StatefulWidget {
  final StoryModel storyModel;
  const EditStoryRoute({required this.storyModel, super.key});

  @override
  State<EditStoryRoute> createState() => _EditStoryRouteState();
}

class _EditStoryRouteState extends State<EditStoryRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Story"),
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: SpaceSizes.x8),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, children: []),
        ),
      ),
    );
  }
}
