import 'package:json_annotation/json_annotation.dart';

part 'post_response_model.g.dart';

@JsonSerializable()
class PostModel {
  final String username;
  final String title;
  final String date;
  final String location;

  PostModel({
    required this.username,
    required this.title,
    required this.date,
    required this.location,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);

  PostModel toJson() => _$PostModelFromJson(this as Map<String, dynamic>);
}
