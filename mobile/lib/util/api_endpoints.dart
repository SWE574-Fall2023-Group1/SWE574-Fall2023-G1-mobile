class ApiEndpoints {
  static const String login = "user/login";
  static const String register = "user/register";
  static const String getUserDetails = "user/userDetails";
  static const String updateBiography = "user/biography";
  static const String avatar = "user/profilePhoto";

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

  static const String createStory = "user/storyCreate";

  static String getStoriesByAuthorId(int id) {
    return "user/storyGetbyAuthor/$id";
  }
}
