import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';

part 'create_story_response_model.g.dart';

@JsonSerializable()
class CreateStoryResponseModel extends ResponseModel {
  CreateStoryResponseModel({required bool? success, required String? msg})
      : super(success, msg);

  factory CreateStoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateStoryResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateStoryResponseModelToJson(this);
}
