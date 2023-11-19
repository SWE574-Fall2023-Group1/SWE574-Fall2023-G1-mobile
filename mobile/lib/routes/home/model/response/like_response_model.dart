class LikeResponseModel {
  final String? msg;
  final bool? success;

  LikeResponseModel({this.msg, this.success});

  factory LikeResponseModel.fromJson(Map<String, dynamic> json) {
    return LikeResponseModel(
      msg: json['msg'] as String?,
      success: json['success'] as bool?,
    );
  }
}
