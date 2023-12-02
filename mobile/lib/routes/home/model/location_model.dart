import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class LocationModel {
  final String name;
  final PointLocation? point;
  final PointLocation? circle;
  final double? radius;
  final PolygonLocation? polygon;
  final LineStringLocation? line;

  LocationModel({
    required this.name,
    this.point,
    this.circle,
    this.radius,
    this.polygon,
    this.line,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      name: json['name'] as String,
      point:
          json['point'] == null ? null : PointLocation.fromJson(json['point']),
      circle: json['circle'] == null
          ? null
          : PointLocation.fromJson(json['circle']),
      radius: json['radius'] == null ? null : double.tryParse(json['radius']),
      polygon: json['polygon'] == null
          ? null
          : PolygonLocation.fromJson(json['polygon']),
      line: json['line'] == null
          ? null
          : LineStringLocation.fromJson(json['line']),
    );
  }
}

@JsonSerializable()
class PointLocation {
  final String? type;
  final List<double> coordinates;

  PointLocation({
    required this.coordinates,
    this.type = "Point",
  });

  factory PointLocation.fromJson(String pointString) {
    return PointLocation(
      coordinates: pointString
          .split('(')
          .last
          .split(')')[0]
          .split(' ')
          .map((String str) => double.parse(str))
          .toList(),
    );
  }
}

@JsonSerializable()
class PolygonLocation {
  final String? type;
  final List<List<double>> coordinates;

  PolygonLocation({
    required this.coordinates,
    this.type = "Polygon",
  });

  factory PolygonLocation.fromJson(String polygonString) {
    return PolygonLocation(
      coordinates: polygonString
          .split('POLYGON ((')[1]
          .split('))')[0]
          .split(', ')
          .map((String pair) {
        return pair.split(' ').map((String p) => double.parse(p)).toList();
      }).toList(),
    );
  }
}

@JsonSerializable()
class LineStringLocation {
  final String? type;
  final List<List<double>> coordinates;

  LineStringLocation({
    required this.coordinates,
    this.type = "LineString",
  });

  factory LineStringLocation.fromJson(String lineString) {
    return LineStringLocation(
      coordinates: lineString
          .split('LINESTRING (')[1]
          .split(')')[0]
          .split(', ')
          .map((String pair) {
        return pair.split(' ').map((String p) => double.parse(p)).toList();
      }).toList(),
    );
  }
}
