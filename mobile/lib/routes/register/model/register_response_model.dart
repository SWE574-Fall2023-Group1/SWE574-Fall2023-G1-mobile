import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel extends ResponseModel {
  final String? email;
  final String? username;

  RegisterResponseModel({
    required bool? success,
    required String? msg,
    this.email,
    this.username,
  }) : super(success, msg);

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}
