import 'package:flutter/material.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';

class StoryTagChips extends StatelessWidget {
  final List<TagModel>? tagModels;

  const StoryTagChips({required this.tagModels, super.key});

  @override
  Widget build(BuildContext context) {
    List<String> tags =
        tagModels?.map((TagModel model) => model.label).toList() ??
            List<String>.empty();

    return Wrap(
      spacing: 8.0,
      children: tags.map((String tag) => Chip(label: Text(tag))).toList(),
    );
  }
}
