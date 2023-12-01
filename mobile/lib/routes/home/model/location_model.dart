import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  int id;
  String? name;
  String? point;
  String? line;
  String? polygon;
  String? circle;
  String? radius;
  bool success;
  String? msg;

  LocationModel({
    required this.id,
    required this.name,
    required this.success,
    required this.msg,
    this.point,
    this.line,
    this.polygon,
    this.circle,
    this.radius,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
