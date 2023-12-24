class UserDetailsResponseModel {
  final int id;
  final String username;
  final String email;
  final String? biography;
  final List<dynamic> followers;
  String? profilePhoto;

  UserDetailsResponseModel({
    required this.id,
    required this.username,
    required this.email,
    required this.followers,
    this.biography,
    this.profilePhoto,
  });

  factory UserDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return UserDetailsResponseModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      biography: json['biography'] as String?,
      followers: json['followers'] as List<dynamic>,
      profilePhoto: json['profile_photo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'username': username,
      'email': email,
      'biography': biography,
      'followers': followers,
      'profile_photo': profilePhoto,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is UserDetailsResponseModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
