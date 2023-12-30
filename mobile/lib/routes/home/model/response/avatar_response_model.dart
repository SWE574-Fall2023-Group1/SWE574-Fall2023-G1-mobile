class AvatarResponseModel {
  final String? url;

  AvatarResponseModel({this.url});

  factory AvatarResponseModel.fromJson(Map<String, dynamic> json) {
    return AvatarResponseModel(
      url: json['photo_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'photo_url': url,
    };
  }
}
