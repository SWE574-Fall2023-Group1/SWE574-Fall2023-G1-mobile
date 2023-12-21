import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/activity_stream/bloc/activity_stream_bloc.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_response_model.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/styles.dart';

class ActivityStreamRoute extends StatefulWidget {
  const ActivityStreamRoute({super.key});

  @override
  State<ActivityStreamRoute> createState() => _ActivityStreamRouteState();
}

class _ActivityStreamRouteState extends State<ActivityStreamRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityStreamBloc, ActivityStreamState>(
      builder: (BuildContext context, ActivityStreamState state) {
        Widget column;
        if (state is ActivityStreamInitial) {
          column = const Center(child: CircularProgressIndicator());
        } else if (state is ActivityStreamDisplayState) {
          column = state.allActivities.isNotEmpty
              ? SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      if (state.followedUser.isNotEmpty)
                        _buildFollowedUserActivities(state.followedUser),
                      if (state.unfollowedUser.isNotEmpty)
                        _buildUnfollowedUserActivities(state.unfollowedUser),
                      if (state.commentOnStory.isNotEmpty)
                        _buildCommentOnStoryActivities(state.commentOnStory),
                      if (state.commentStoryYouCommentedBefore.isNotEmpty)
                        _buidCommentStoryYouCommentedBeforeActivities(
                            state.commentStoryYouCommentedBefore),
                      if (state.likedStories.isNotEmpty)
                        _buildLikedStoryActivities(state.likedStories),
                      if (state.newStories.isNotEmpty)
                        _buildNewStoryActivities(state.newStories),
                    ],
                  ),
                )
              : const Center(
                  child: Text("There is no recent activity for you"),
                );
        } else if (state is ActivityStreamFailure) {
          column = Center(
            child: Text("Error: ${state.error.toString()}"),
          );
        } else if (state is ActivityStreamOffline) {
          column = Center(
            child: Text(state.offlineMessage.toString()),
          );
        } else {
          column = const Center(child: CircularProgressIndicator());
        }

        return Material(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "Activity Stream",
                style: Styles.appBarTitleStyle,
              ),
            ),
            body: column,
          ),
        );
      },
    );
  }

  Widget _buildFollowedUserActivities(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Users Followed You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Section Activities
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int subIndex) {
            Activity activity = activities[subIndex];
            return GestureDetector(
              onTap: () {
                AppRoute.profile
                    .navigate(context, arguments: activity.targetUser);
                BlocProvider.of<ActivityStreamBloc>(context).add(
                    ActivityStreamOnPressActivityEvent(
                        activityId: activity.id));
              },
              child: ListTile(
                title: Text("${activity.targetUserUsername} followed you!"),
                // Add more ListTile customization as needed
              ),
            );
          },
        ),
        // Divider between sections
        const Divider(),
      ],
    );
  }

  Widget _buildUnfollowedUserActivities(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Users Unfollowed You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Section Activities
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int subIndex) {
            Activity activity = activities[subIndex];
            return GestureDetector(
              onTap: () {
                AppRoute.profile
                    .navigate(context, arguments: activity.targetUser);
                BlocProvider.of<ActivityStreamBloc>(context).add(
                    ActivityStreamOnPressActivityEvent(
                        activityId: activity.id));
              },
              child: ListTile(
                title: Text("${activity.targetUserUsername} unfollowed you!"),
                // Add more ListTile customization as needed
              ),
            );
          },
        ),
        // Divider between sections
        const Divider(),
      ],
    );
  }

  Widget _buildCommentOnStoryActivities(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Users Commented on Your Story",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Section Activities
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int subIndex) {
            Activity activity = activities[subIndex];
            return GestureDetector(
              onTap: () {
                AppRoute.profile
                    .navigate(context, arguments: activity.targetUser);
                BlocProvider.of<ActivityStreamBloc>(context).add(
                    ActivityStreamOnPressActivityEvent(
                        activityId: activity.id));
              },
              child: ListTile(
                title: Text(
                    "${activity.targetUserUsername} commented on your story!"),
                // Add more ListTile customization as needed
              ),
            );
          },
        ),
        // Divider between sections
        const Divider(),
      ],
    );
  }

  Widget _buidCommentStoryYouCommentedBeforeActivities(
      List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Users Commented a Story You Commented Before",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Section Activities
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int subIndex) {
            Activity activity = activities[subIndex];
            return GestureDetector(
              onTap: () {
                AppRoute.profile
                    .navigate(context, arguments: activity.targetUser);
                BlocProvider.of<ActivityStreamBloc>(context).add(
                    ActivityStreamOnPressActivityEvent(
                        activityId: activity.id));
              },
              child: ListTile(
                title: Text(
                    "${activity.targetUserUsername} commented a story you commented before!"),
                // Add more ListTile customization as needed
              ),
            );
          },
        ),
        // Divider between sections
        const Divider(),
      ],
    );
  }

  Widget _buildLikedStoryActivities(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Users Liked Your Story",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Section Activities
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int subIndex) {
            Activity activity = activities[subIndex];
            return GestureDetector(
              onTap: () {
                AppRoute.profile
                    .navigate(context, arguments: activity.targetUser);
                BlocProvider.of<ActivityStreamBloc>(context).add(
                    ActivityStreamOnPressActivityEvent(
                        activityId: activity.id));
              },
              child: ListTile(
                title: Text("${activity.targetUserUsername} liked your story!"),
                // Add more ListTile customization as needed
              ),
            );
          },
        ),
        // Divider between sections
        const Divider(),
      ],
    );
  }

  Widget _buildNewStoryActivities(List<Activity> activities) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Users Created New Stories",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        // Section Activities
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length,
          itemBuilder: (BuildContext context, int subIndex) {
            Activity activity = activities[subIndex];
            return GestureDetector(
              onTap: () {
                AppRoute.profile
                    .navigate(context, arguments: activity.targetUser);
                BlocProvider.of<ActivityStreamBloc>(context).add(
                    ActivityStreamOnPressActivityEvent(
                        activityId: activity.id));
              },
              child: ListTile(
                title:
                    Text("${activity.targetUserUsername} created a new story!"),
                // Add more ListTile customization as needed
              ),
            );
          },
        ),
        // Divider between sections
        const Divider(),
      ],
    );
  }
}
