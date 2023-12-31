import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';
import 'package:memories_app/routes/profile/model/response/add_profile_photo_response_model.dart';
import 'package:memories_app/routes/profile/util/date_util.dart';
import 'package:memories_app/routes/profile/widget/biography_container.dart';
import 'package:memories_app/routes/profile/widget/collapsed_header.dart';
import 'package:memories_app/routes/profile/widget/expanded_header.dart';
import 'package:memories_app/routes/profile/widget/story_card.dart';
import 'package:memories_app/routes/story_detail/bloc/story_detail_bloc.dart';
import 'package:memories_app/routes/story_detail/story_detail_route.dart';
import 'package:memories_app/ui/error_alert_dialog.dart';
import 'package:memories_app/ui/titled_app_bar.dart';

class ProfileRoute extends StatelessWidget {
  final int? userId;

  const ProfileRoute({super.key, this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitledAppBar.build("Profile"),
      body: FutureBuilder<UserDetailsResponseModel>(
        future: ProfileRepositoryImp().getUserDetails(userId),
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

class ProfileDetails extends StatefulWidget {
  final UserDetailsResponseModel user;

  const ProfileDetails({required this.user, super.key});

  @override
  ProfileDetailsState createState() => ProfileDetailsState();
}

class ProfileDetailsState extends State<ProfileDetails> {
  late UserDetailsResponseModel user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  void _changeAvatar(AddProfilePhotoResponseModel responseModel) {
    if (responseModel.success) {
      setState(() {
        user.profilePhoto = responseModel.profilePhoto;
      });
    } else {
      showErrorDialog(context, responseModel.msg);
    }
  }

  // ignore_for_file: always_specify_types
  Widget _buildStoryList(List<StoryModel> stories, BuildContext context) {
    return Column(
      children: stories.map((StoryModel story) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) =>
                      BlocProvider<StoryDetailBloc>(
                    create: (BuildContext context) => StoryDetailBloc(),
                    child: StoryDetailRoute(
                      story: story,
                    ),
                  ),
                ));
          },
          child: StoryCard(story: story),
        );
      }).toList(),
    );
  }

  Future<List<StoryModel>> _loadPosts(int page) async {
    StoriesResponseModel? responseModel =
        await ProfileRepositoryImp().getOwnStories(user.id);
    if (responseModel.stories != null) {
      responseModel.stories?.forEach((StoryModel story) {
        story.dateText = getFormattedDate(story);
      });
    }
    return responseModel.stories ?? <StoryModel>[];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              automaticallyImplyLeading: false,
              expandedHeight: 220,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              shadowColor: Colors.grey.withOpacity(0.5),
              elevation: 4,
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  double top = constraints.biggest.height;
                  bool isCollapsed = top < kToolbarHeight + 30;
                  return FlexibleSpaceBar(
                    titlePadding:
                        EdgeInsets.only(left: isCollapsed ? 48 : 0, bottom: 14),
                    title: isCollapsed ? CollapsedHeader(user: user) : null,
                    background: !isCollapsed
                        ? ExpandedHeader(
                            user: user,
                            onAvatarChange:
                                (AddProfilePhotoResponseModel responseModel) {
                              _changeAvatar(responseModel);
                            },
                          )
                        : null,
                  );
                },
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  EditableBiography(userId: user.id, biography: user.biography),
                  FutureBuilder<List<StoryModel>>(
                    future: _loadPosts(user.id),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<List<StoryModel>> snapshot,
                    ) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Container();
                      }
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No stories found.');
                      }
                      return _buildStoryList(snapshot.data!, context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
