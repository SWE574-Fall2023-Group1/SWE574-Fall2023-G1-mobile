import 'package:flutter/material.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/widget/cached_avatar.dart';

Row collapsedHeader(UserDetailsResponseModel user) => Row(
      children: <Widget>[
        CachedAvatar(url: user.profilePhoto, radius: 20),
        const SizedBox(width: 10),
        Text(
          user.username,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );
