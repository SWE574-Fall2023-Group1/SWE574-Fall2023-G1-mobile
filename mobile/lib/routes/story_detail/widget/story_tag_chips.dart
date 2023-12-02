import 'package:flutter/material.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';

class StoryTagChips extends StatelessWidget {
  final List<TagModel>? tagModels;

  const StoryTagChips({required this.tagModels, super.key});

  @override
  Widget build(BuildContext context) {
    if (tagModels?.isNotEmpty != true) {
      return Container();
    }

    return Wrap(
      children: tagModels!
          .map((TagModel tag) => Tooltip(
              message: tag.description, child: Chip(label: Text(tag.label))))
          .toList(),
    );
  }
}
