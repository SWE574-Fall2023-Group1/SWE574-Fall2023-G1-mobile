import 'package:flutter/material.dart';
import 'package:memories_app/routes/profile/widget/cached_avatar.dart';

class ProfileAvatar extends StatelessWidget {
  final String? url;
  final double radius;

  const ProfileAvatar({
    required this.url,
    this.radius = 70,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        CachedAvatar(url: url, radius: radius),
        Positioned(
          right: 0,
          top: 0,
          child: GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Edit Photo'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              // Handle 'Change Photo' option
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Change Photo'),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              // Handle 'Remove Photo' option
                              Navigator.of(context).pop(); // Close the dialog
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Remove Photo'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: const CircleAvatar(
              backgroundColor: Colors.white70,
              radius: 15,
              child: Icon(
                Icons.edit,
                color: Colors.black87,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
