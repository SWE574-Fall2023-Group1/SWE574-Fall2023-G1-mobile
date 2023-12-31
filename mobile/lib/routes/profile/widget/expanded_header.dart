import 'package:flutter/material.dart';
import 'package:memories_app/routes/app/application_context.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/response/add_profile_photo_response_model.dart';
import 'package:memories_app/routes/profile/widget/follow_button.dart';
import 'package:memories_app/routes/profile/widget/profile_avatar.dart';

class ExpandedHeader extends StatelessWidget {
  final UserDetailsResponseModel user;
  final Function(AddProfilePhotoResponseModel) onAvatarChange;

  const ExpandedHeader({
    required this.user,
    required this.onAvatarChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                if (ApplicationContext.isCurrentUser(user.id))
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: OutlinedButton(
                        onPressed: () {},
                        child: Text("${user.followers.length} follower(s)"),
                      ),
                    ),
                  )
                else
                  FollowButton(user: user),
                Center(
                  child: ProfileAvatar(
                    userId: user.id,
                    url: user.profilePhoto,
                    onAvatarChange: onAvatarChange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              user.username,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
