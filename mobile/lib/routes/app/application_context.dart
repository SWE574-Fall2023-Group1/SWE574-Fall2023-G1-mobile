class ApplicationContext {
  static int currentUserId = 0;

  static bool isCurrentUser(int userId) {
    return currentUserId == userId;
  }
}
