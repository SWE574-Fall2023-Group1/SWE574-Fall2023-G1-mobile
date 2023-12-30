import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';

part 'edit_story_response_model.g.dart';

@JsonSerializable()
class EditStoryResponseModel extends ResponseModel {
  EditStoryResponseModel({required bool? success, required String? msg})
      : super(success, msg);

  factory EditStoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$EditStoryResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$EditStoryResponseModelToJson(this);
}
