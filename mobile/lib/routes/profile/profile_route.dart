import 'package:flutter/material.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';
import 'package:memories_app/routes/story_detail/widget/avatar_container.dart';
import 'package:memories_app/ui/titled_app_bar.dart';

class ProfileRoute extends StatelessWidget {
  const ProfileRoute({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitledAppBar.build("Profile"),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Color.fromRGBO(151, 71, 255, 1),
                  Color.fromRGBO(198, 198, 198, 0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 20),
                LoadAvatar(id: user.id, radius: 70),
                const SizedBox(height: 10),
                Text("${user.username}'s Profile"),
                const SizedBox(height: 10),
              ],
            ),
          ),
          Column(
            children: <Widget>[
              if (user.biography != null) Text(user.biography!),
            ],
          ),
        ],
      ),
    );
  }
}
