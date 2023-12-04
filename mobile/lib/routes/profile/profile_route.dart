import 'package:flutter/material.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';
import 'package:memories_app/routes/story_detail/widget/avatar_container.dart';

class ProfileRoute extends StatelessWidget {
  const ProfileRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: FutureBuilder<UserDetailsResponseModel>(
        future: ProfileRepositoryImp().getUserDetails(),
        builder: (BuildContext context,
            AsyncSnapshot<UserDetailsResponseModel> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return const Text('Error loading profile');
          }
          return snapshot.hasData
              ? ProfileDetails(user: snapshot.data!)
              : const Text('No user data found');
        },
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  final UserDetailsResponseModel user;

  const ProfileDetails({required this.user, super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            LoadAvatar(id: user.id, radius: 80),
            Text(user.username),
            Text(user.email),
            if (user.biography != null) Text(user.biography!),
            // Add more fields or buttons as needed
          ],
        ),
      ),
    );
  }
}
