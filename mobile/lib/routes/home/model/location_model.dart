import 'package:json_annotation/json_annotation.dart';

part 'location_model.g.dart';

@JsonSerializable()
class LocationModel {
  int id;
  String name;
  bool? success;
  String msg;

  LocationModel({
    required this.id,
    required this.name,
    required this.msg,
    this.success = false,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) =>
      _$LocationModelFromJson(json);

  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
/*
"id": 26,
"name": "Bo%C4%9Fazi%C3%A7i%20%C3%9Cniversitesi%20Kuzey%20Kamp%C3%BCs%C3%BC",
"point": null,
"line": null,
"polygon": null,
"circle": null,
"radius": null,
"success": true,
"msg": "Location ok."
 */
