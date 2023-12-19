import 'package:json_annotation/json_annotation.dart';
import 'package:memories_app/network/model/response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';

part 'recommendations_response.g.dart';

@JsonSerializable()
class RecommendationsResponseModel extends ResponseModel {
  List<Recommendation>? recommendations;

  RecommendationsResponseModel({
    required bool? success,
    required String? msg,
    required this.recommendations,
  }) : super(success, msg);

  factory RecommendationsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$RecommendationsResponseModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$RecommendationsResponseModelToJson(this);
}

@JsonSerializable()
class Recommendation {
  StoryModel? story;

  Recommendation({
    required this.story,
  });

  factory Recommendation.fromJson(Map<String, dynamic> json) =>
      _$RecommendationFromJson(json);

}
