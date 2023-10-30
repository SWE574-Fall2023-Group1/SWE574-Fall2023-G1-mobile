import 'package:json_annotation/json_annotation.dart';

part 'all_stories_request_model.g.dart';

@JsonSerializable()
class AllStoriesRequestModel {
  final int page;
  final int size;

  AllStoriesRequestModel({
    required this.page,
    required this.size,
  });

  factory AllStoriesRequestModel.fromJson(Map<String, dynamic> json) =>
      _$AllStoriesRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$AllStoriesRequestModelToJson(this);
}
