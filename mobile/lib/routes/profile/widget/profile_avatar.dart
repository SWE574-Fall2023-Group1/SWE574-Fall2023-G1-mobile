import 'package:flutter/material.dart';
import 'package:memories_app/routes/app/application_context.dart';
import 'package:memories_app/routes/profile/model/response/add_profile_photo_response_model.dart';
import 'package:memories_app/routes/profile/widget/cached_avatar.dart';
import 'package:memories_app/routes/profile/widget/edit_avatar_button.dart';

class ProfileAvatar extends StatelessWidget {
  final int userId;
  final String? url;
  final double radius;
  final Function(AddProfilePhotoResponseModel?) onAvatarChange;

  const ProfileAvatar({
    required this.userId,
    required this.url,
    required this.onAvatarChange,
    this.radius = 70,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CachedAvatar(url: url, radius: radius),
        if (ApplicationContext.isCurrentUser(userId))
          EditAvatarButton(onAvatarChange: onAvatarChange),
      ],
    );
  }
}
