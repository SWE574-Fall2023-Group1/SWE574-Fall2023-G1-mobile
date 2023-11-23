class ApiEndpoints {
  static const String login = "user/login";
  static const String register = "user/register";
  static const String getUserDetails = "user/userDetails";

  static String buildAllStoriesUrl(int page, int size) {
    return "user/allStories?page=$page&size=$size";
  }

  static String buildUserStoriesUrl(int page, int size) {
    return "user/userStories?page=$page&size=$size";
  }

  static String buildStoryGetUrl(int id) {
    return "user/storyGet/$id";
  }

  static String getCommentsByStoryId(int id) {
    return "user/commentsByStory/$id";
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
}
