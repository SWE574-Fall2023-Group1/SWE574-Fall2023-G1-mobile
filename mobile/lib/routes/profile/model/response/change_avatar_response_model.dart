import 'package:memories_app/routes/app/model/response/base_response_model.dart';

class AddProfilePhotoResponseModel extends BaseResponseModel {
  final String profilePhoto;
  final String photoUrl;

  AddProfilePhotoResponseModel({
    required this.profilePhoto,
    required this.photoUrl,
    required super.success,
    required super.msg,
  });

  factory AddProfilePhotoResponseModel.fromJson(Map<String, dynamic> json) {
    return AddProfilePhotoResponseModel(
      profilePhoto: json['profile_photo'] as String,
      photoUrl: json['photo_url'] as String,
      success: json['success'] as bool,
      msg: json['msg'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'profile_photo': profilePhoto,
      'photo_url': photoUrl,
      'success': success,
      'msg': msg,
    };
  }
}
