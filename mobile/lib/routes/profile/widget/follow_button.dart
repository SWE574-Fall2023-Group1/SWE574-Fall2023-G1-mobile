import 'package:flutter/material.dart';
import 'package:memories_app/routes/app/application_context.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';

class FollowButton extends StatefulWidget {
  final UserDetailsResponseModel user;

  const FollowButton({required this.user, super.key});

  @override
  FollowButtonState createState() => FollowButtonState();
}

class FollowButtonState extends State<FollowButton> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    isFollowing =
        widget.user.followers.contains(ApplicationContext.currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: OutlinedButton(
          onPressed: _toggleFollow,
          child: Text(isFollowing ? "Unfollow" : "Follow"),
        ),
      ),
    );
  }

  void _toggleFollow() async {
    bool success =
        (await ProfileRepositoryImp().followUser(widget.user.id)).success;
    if (success) {
      setState(() {
        isFollowing = !isFollowing;
      });
    }
  }
}
