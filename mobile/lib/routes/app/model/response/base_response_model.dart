class BaseResponseModel {
  final bool success;
  final String msg;

  BaseResponseModel({
    required this.success,
    required this.msg,
  });

  factory BaseResponseModel.fromJson(Map<String, dynamic> json) {
    return BaseResponseModel(
      success: json['success'] as bool,
      msg: json['msg'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'success': success,
      'msg': msg,
    };
  }
}
