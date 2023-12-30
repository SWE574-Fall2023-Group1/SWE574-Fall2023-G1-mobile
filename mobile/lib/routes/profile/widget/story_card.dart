import 'package:flutter/material.dart';
import 'package:memories_app/routes/app/application_context.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/utils.dart';

class StoryCard extends StatelessWidget {
  final StoryModel story;

  const StoryCard({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
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
              children: <Widget>[
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
                if (ApplicationContext.isCurrentUser(story.author))
                  GestureDetector(
                    onTap: () {
                      AppRoute.editStory.navigate(context, arguments: story);
                    },
                    child: const Icon(Icons.edit),
                  ),
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
                    story.dateText ?? '',
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
  }
}
