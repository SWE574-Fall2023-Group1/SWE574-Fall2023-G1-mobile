import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel extends ResponseModel {
  final String? access;
  final String? refresh;

  LoginResponseModel({
    required bool? success,
    required String? msg,
    this.access,
    this.refresh,
  }) : super(success, msg);

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
