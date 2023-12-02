import 'package:flutter/material.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
import 'package:memories_app/ui/titled_app_bar.dart';

class StoryDetailAppBar {
  static AppBar build(BuildContext context) {
    return TitledAppBar.build(
      "Story Detail",
      gestureDetector: GestureDetector(
        onTap: () {
          Navigator.pop(context, shouldRefreshStories);
        },
        child: const Icon(
          Icons.chevron_left,
          color: Colors.black,
        ),
      ),
    );
  }
}
