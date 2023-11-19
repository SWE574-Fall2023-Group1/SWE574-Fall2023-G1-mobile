class UserDetailsResponseModel {
  final int id;
  final String username;
  final String email;
  final String? biography;

  // final List<int?> followers;
  final String? profilePhoto;

  UserDetailsResponseModel({
    required this.id,
    required this.username,
    required this.email,
    // required this.followers,
    this.biography,
    this.profilePhoto,
  });

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponseModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      biography: json['biography'] as String?,
      // followers: json['followers'] as List<int?>,
      profilePhoto: json['profile_photo'] as String?,
    );
  }
}
