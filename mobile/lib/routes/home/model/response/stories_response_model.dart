import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/routes/home/model/story_model.dart';

part 'stories_response_model.g.dart';

@JsonSerializable()
class StoriesResponseModel {
  List<StoryModel>? stories;
  bool? hasNext;
  bool? hasPrev;
  dynamic nextPage;
  dynamic prevPage;
  int? totalPages;

  StoriesResponseModel({
    required this.stories,
    required this.hasNext,
    required this.hasPrev,
    required this.nextPage,
    required this.prevPage,
    required this.totalPages,
  });

  factory StoriesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StoriesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$StoriesResponseModelToJson(this);
}
