class ApiEndpoints {
  static const String login = "user/login";
  static const String register = "user/register";

  static String buildAllStoriesUrl(int page, int size) {
    return "user/allStories?page=$page&size=$size";
  }

  static String buildUserStoriesUrl(int page, int size) {
    return "user/userStories?page=$page&size=$size";
  }
}
