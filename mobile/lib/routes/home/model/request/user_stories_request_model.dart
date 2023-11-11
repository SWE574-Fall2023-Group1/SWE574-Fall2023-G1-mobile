import 'package:json_annotation/json_annotation.dart';

part 'user_stories_request_model.g.dart';

@JsonSerializable()
class UserStoriesRequestModel {
  final int page;
  final int size;

  UserStoriesRequestModel({
    required this.page,
    required this.size,
  });

  factory UserStoriesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$UserStoriesRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserStoriesRequestModelToJson(this);
}
