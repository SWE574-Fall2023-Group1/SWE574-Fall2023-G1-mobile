import 'package:flutter/material.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/widget/profile_avatar.dart';

Stack expandedHeader(UserDetailsResponseModel user) => Stack(
      alignment: Alignment.center,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: OutlinedButton(
                      onPressed: () {
                        // Define the action when the button is pressed
                      },
                      child: Text(
                        "${user.followers.length} follower(s)",
                      ),
                    ),
                  ),
                ),
                Center(
                  child: ProfileAvatar(
                    url: user.profilePhoto,
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