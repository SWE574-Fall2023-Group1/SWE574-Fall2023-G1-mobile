import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/routes/home/model/story_model.dart';

part 'search_story_response_model.g.dart';

@JsonSerializable()
class SearchStoryResponseModel {
  List<StoryModel>? stories;
  SearchStoryResponseModel({
    required this.stories,
  });

  factory SearchStoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SearchStoryResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$SearchStoryResponseModelToJson(this);
}
