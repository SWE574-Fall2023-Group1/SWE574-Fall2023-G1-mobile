import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/model/response_model.dart';
import 'package:memories_app/routes/activity_stream/bloc/activity_stream_bloc.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_repository.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final ActivityStreamResponseModel responseSuccess =
      ActivityStreamResponseModel(
          success: true,
          msg: "activites ok",
          activity: <Activity>[
        Activity(
            id: 1,
            user: 1,
            userUsername: "test",
            activityType: "new_story",
            date: DateTime.now(),
            viewed: false,
            targetUser: 2,
            targetUserUsername: "test2",
            targetStory: 1,
            targetStoryTitle: "test"),
        Activity(
            id: 2,
            user: 2,
            userUsername: "test",
            activityType: "story_liked",
            date: DateTime.now(),
            viewed: false,
            targetUser: 3,
            targetUserUsername: "test3",
            targetStory: 3,
            targetStoryTitle: "story_liked")
      ]);

  static final ResponseModel viewActivityResponseSuccess =
      ResponseModel(true, "view activity ok");
}

class MockActivityStreamRepository extends ActivityStreamRepository {
  @override
  Future<ActivityStreamResponseModel> getActivities() async {
    return _Constants.responseSuccess;
  }

  @override
  Future<ResponseModel> viewActivity(int activityId) async {
    return _Constants.viewActivityResponseSuccess;
  }
}

void main() {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late ActivityStreamBloc activityStreamBloc;
  late ActivityStreamRepository activityStreamInterface;

  setUp(() {
    activityStreamInterface = MockActivityStreamRepository();
    activityStreamBloc =
        ActivityStreamBloc(repository: activityStreamInterface);
  });

  blocTest<ActivityStreamBloc, ActivityStreamState>(
    'emits [] when nothing is added',
    build: () => activityStreamBloc,
    expect: () => <ActivityStreamState>[],
  );

  blocTest<ActivityStreamBloc, ActivityStreamState>(
    'emits [ActivityStreamDisplayState] when ActivityStreamLoadDisplayEvent is added.',
    build: () => activityStreamBloc,
    act: (ActivityStreamBloc bloc) =>
        bloc.add(ActivityStreamLoadDisplayEvent()),
    expect: () => <TypeMatcher<ActivityStreamDisplayState>>[
      isA<ActivityStreamDisplayState>()
    ],
  );
  blocTest<ActivityStreamBloc, ActivityStreamState>(
    'emits [ActivityStreamDisplayState] when ActivityStreamOnPressActivityEvent is added.',
    build: () => activityStreamBloc,
    act: (ActivityStreamBloc bloc) =>
        bloc.add(const ActivityStreamOnPressActivityEvent(activityId: 1)),
    expect: () => <TypeMatcher<ActivityStreamDisplayState>>[],
  );

  test('groupActivities should group activities correctly', () {
    // Arrange
    final List<Activity> activities = <Activity>[
      Activity(
          id: 1,
          user: 1,
          userUsername: "test",
          activityType: "new_story",
          date: DateTime.now(),
          viewed: false,
          targetUser: 2,
          targetUserUsername: "test2",
          targetStory: 1,
          targetStoryTitle: "test"),
      Activity(
          id: 2,
          user: 2,
          userUsername: "test",
          activityType: "story_liked",
          date: DateTime.now(),
          viewed: false,
          targetUser: 3,
          targetUserUsername: "test3",
          targetStory: 3,
          targetStoryTitle: "story_liked"),
      Activity(
          id: 3,
          user: 3,
          userUsername: "test",
          activityType: "story_unliked",
          date: DateTime.now(),
          viewed: false,
          targetUser: 4,
          targetUserUsername: "test4",
          targetStory: 4,
          targetStoryTitle: "story_unliked"),
      Activity(
          id: 4,
          user: 4,
          userUsername: "test",
          activityType: "followed_user",
          date: DateTime.now(),
          viewed: false,
          targetUser: 5,
          targetUserUsername: "test5",
          targetStory: 5,
          targetStoryTitle: "followed_user"),
      Activity(
          id: 5,
          user: 5,
          userUsername: "test",
          activityType: "unfollowed_user",
          date: DateTime.now(),
          viewed: false,
          targetUser: 6,
          targetUserUsername: "test6",
          targetStory: 6,
          targetStoryTitle: "unfollowed_user"),
      Activity(
          id: 6,
          user: 6,
          userUsername: "test",
          activityType: "new_commented_on_story",
          date: DateTime.now(),
          viewed: false,
          targetUser: 7,
          targetUserUsername: "test7",
          targetStory: 7,
          targetStoryTitle: "new_commented_on_story"),
      Activity(
          id: 7,
          user: 7,
          userUsername: "test",
          activityType: "new_comment_on_comment",
          date: DateTime.now(),
          viewed: false,
          targetUser: 8,
          targetUserUsername: "test8",
          targetStory: 8,
          targetStoryTitle: "new_comment_on_comment"),
    ];

    // Act
    activityStreamBloc.groupActivities(activities);

    // Assert
    expect(activityStreamBloc.newStories.length, 1);
    expect(activityStreamBloc.likedStories.length, 1);
    expect(activityStreamBloc.unlikedStories.length, 1);
    expect(activityStreamBloc.followedUser.length, 1);
    expect(activityStreamBloc.unfollowedUser.length, 1);
    expect(activityStreamBloc.commentOnStory.length, 1);
    expect(activityStreamBloc.commentStoryYouCommentedBefore.length, 1);
  });
}
