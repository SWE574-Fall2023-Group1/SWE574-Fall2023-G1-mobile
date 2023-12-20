class ApiEndpoints {
  static const String login = "user/login";
  static const String register = "user/register";
  static const String updateBiography = "user/biography";
  static const String avatar = "user/profilePhoto";
  static const String getRecommendations = "user/recommendations";
  static const String createStory = "user/storyCreate";
  static const String searchStory = "user/storySearch";
  static const String getActivities = "user/activities";

  static String buildAllStoriesUrl(int page, int size) {
    return "user/allStories?page=$page&size=$size";
  }

  static String buildUserStoriesUrl(int page, int size) {
    return "user/userStories?page=$page&size=$size";
  }

  static String buildAllStoriesWithOwnUrl(int page, int size) {
    return "user/allStorieswithOwn?page=$page&size=$size";
  }

  static String buildStoryGetUrl(int id) {
    return "user/storyGet/$id";
  }

  static String getCommentsByStoryId(int id) {
    return "user/commentsByStory/$id?size=100";
  }

  static String getAvatarById(int id) {
    return "user/profilePhoto/$id";
  }

  static String likeStory(int id) {
    return "user/like/$id";
  }

  static String postComment(int id) {
    return "user/comment/$id";
  }

  static String storyUpdate(int id) {
    return "user/storyUpdate/$id";
  }

  static String getStoriesByAuthorId(int id) {
    return "user/storyGetbyAuthor/$id";
  }

  static String getUserDetails({int? userId}) {
    if (userId == null) {
      return "user/userDetails";
    }
    return "user/userDetails/$userId";
  }

  static String getActivitiesById(int activityId) {
    return "user/activities/$activityId";
  }
}
