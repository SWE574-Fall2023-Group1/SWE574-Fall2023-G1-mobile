import 'package:flutter/material.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/util/sp_helper.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';

class LikesContainer extends StatefulWidget {
  final int storyId;
  final List<int> initialLikes;

  const LikesContainer({
    required this.storyId,
    required this.initialLikes,
    super.key,
  });

  @override
  State<LikesContainer> createState() => _LikesContainerState();
}

class _LikesContainerState extends State<LikesContainer> {
  late int likesCount;
  bool isHeartFilled = false;

  @override
  void initState() {
    super.initState();
    likesCount = widget.initialLikes.length;
    _isInitiallyLiked();
  }

  void _toggleHeartFill() {
    setState(() {
      isHeartFilled = !isHeartFilled;
    });
  }

  Future<void> _isInitiallyLiked() async {
    int? currentUserId = await SPHelper.getInt(SPKeys.currentUserId);
    setState(() {
      isHeartFilled = widget.initialLikes.contains(currentUserId);
    });
  }

  Future<void> _postLike() async {
    await StoryDetailRepositoryImp().likeStoryById(id: widget.storyId);
    shouldRefreshStories = true;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFD9D9D9),
          ),
          child: Text(
            likesCount.toString(),
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              letterSpacing: 1.75,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              if (isHeartFilled) {
                likesCount--;
              } else {
                likesCount++;
              }
              _toggleHeartFill();
              _postLike();
            });
          },
          onTapDown: (_) {
            _toggleHeartFill();
          },
          onTapUp: (_) {
            _toggleHeartFill();
          },
          onTapCancel: () {
            _toggleHeartFill();
          },
          child: Icon(
            isHeartFilled ? Icons.favorite : Icons.favorite_border,
            color: isHeartFilled ? Colors.red : Colors.black,
          ),
        ),
      ],
    );
  }
}
