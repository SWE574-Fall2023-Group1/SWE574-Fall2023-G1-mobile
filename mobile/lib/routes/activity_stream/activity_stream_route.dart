import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/activity_stream/bloc/activity_stream_bloc.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_response_model.dart';
import 'package:memories_app/util/styles.dart';
import 'package:intl/intl.dart';
import 'package:memories_app/util/router.dart';

class ActivityStreamRoute extends StatefulWidget {
  const ActivityStreamRoute({Key? key}) : super(key: key);

  @override
  State<ActivityStreamRoute> createState() => _ActivityStreamRouteState();
}

class _ActivityStreamRouteState extends State<ActivityStreamRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityStreamBloc, ActivityStreamState>(
      builder: (BuildContext context, ActivityStreamState state) {
        Widget content;
        List<Activity> activities = [];

        if (state is ActivityStreamInitial) {
          content = const Center(child: CircularProgressIndicator());
        } else if (state is ActivityStreamDisplayState) {
          activities
            ..addAll(state.likedStories)
            ..addAll(state.unlikedStories)
            ..addAll(state.followedUser)
            ..addAll(state.unfollowedUser)
            ..addAll(state.commentOnStory)
            ..addAll(state.commentStoryYouCommentedBefore)
            ..addAll(state.newStories);

          activities.sort((a, b) => b.date.compareTo(a.date));

          content = ListView.builder(
            itemCount: activities.length,
            itemBuilder: (context, index) => _buildActivityItem(context, activities[index]),
          );
        } else if (state is ActivityStreamFailure) {
          content = Center(child: Text("Error: ${state.error.toString()}"));
        } else if (state is ActivityStreamOffline) {
          content = Center(child: Text(state.offlineMessage ?? 'You are offline.'));
        } else {
          content = const Center(child: CircularProgressIndicator());
        }

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            title: const Text("Activity Stream", style: Styles.appBarTitleStyle),
          ),
          body: content,
        );
      },
    );
  }

  Widget _buildActivityItem(BuildContext context, Activity activity) {
    IconData icon = _getActivityIcon(activity.activityType);
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(activity.date);
    String titleText = "${activity.targetUserUsername} $formattedDate";
    return ListTile(
      title: Text(titleText),
      subtitle: Text(_getActivityDescription(activity)),
      trailing: Icon(icon),
      onTap: () {
        AppRoute.profile
            .navigate(context, arguments: activity.targetUser);
        BlocProvider.of<ActivityStreamBloc>(context).add(
            ActivityStreamOnPressActivityEvent(
                activityId: activity.id));
      },
    );
  }

  IconData _getActivityIcon(String activityType) {
    switch (activityType) {
      case 'story_liked':
        return Icons.favorite;
      case 'story_unliked':
        return Icons.favorite_border;
      case 'followed_user':
        return Icons.person_add;
      case 'unfollowed_user':
        return Icons.person_remove;
      case 'new_story':
        return Icons.create;
      default:
        return Icons.info;
    }
  }

  String _getActivityDescription(Activity activity) {
    switch (activity.activityType) {
      case 'story_liked':
        return 'Liked "${activity.targetStoryTitle}"';
      case 'story_unliked':
        return 'Unliked "${activity.targetStoryTitle}"';
      case 'followed_user':
        return 'Followed you';
      case 'unfollowed_user':
        return 'Unfollowed you';
      case 'new_story':
        return 'Created a new story: "${activity.targetStoryTitle}"';
      default:
        return 'Unknown activity';
    }
  }
}
