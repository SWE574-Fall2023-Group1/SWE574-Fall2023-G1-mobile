import 'package:memories_app/routes/app/model/response/base_response_model.dart';

class LikeResponseModel extends BaseResponseModel {
  LikeResponseModel({
    super.success = false,
    super.msg = '',
  });

  factory LikeResponseModel.fromJson(Map<String, dynamic> json) {
    return LikeResponseModel(
      success: json['success'] as bool,
      msg: json['msg'] as String,
    );
  }
}
