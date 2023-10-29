import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';

part 'register_response_model.g.dart';

@JsonSerializable()
class RegisterResponseModel extends ResponseModel {
  final String? access;
  final String? refresh;

  RegisterResponseModel({
    required bool? success,
    required String? msg,
    this.access,
    this.refresh,
  }) : super(success, msg);

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RegisterResponseModelToJson(this);
}
