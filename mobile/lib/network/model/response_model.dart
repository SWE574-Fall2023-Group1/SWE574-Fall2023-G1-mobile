import 'package:json_annotation/json_annotation.dart';

part 'response_model.g.dart';

@JsonSerializable()
class ResponseModel {
  @JsonKey(name: 'success')
  final bool? success;
  @JsonKey(name: 'msg')
  final String? msg;

  ResponseModel(this.success, this.msg);

  factory ResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ResponseModelToJson(this);
}
