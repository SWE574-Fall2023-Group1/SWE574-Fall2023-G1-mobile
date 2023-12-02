import 'dart:math';

import 'package:flutter/material.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class StoryLocationContainer extends StatelessWidget {
  final StoryModel story;

  const StoryLocationContainer({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    if (story.locations?.isNotEmpty != true) {
      return Container();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (LocationModel location in story.locations!) ...<Widget>[
            Text(
              location.name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                height: 0,
              ),
            ),
            const SizedBox(height: 8),
          ],
          const SizedBox(height: 10),
          SizedBox(
            height: 500,
            child: Map(locations: story.locations),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class Map extends StatelessWidget {
  final List<LocationModel>? locations;

  const Map({super.key, this.locations});

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = <Marker>[];
    List<CircleMarker> circles = <CircleMarker>[];
    List<Polygon> polygons = <Polygon>[];
    List<Polyline> lines = <Polyline>[];

    locations?.forEach((LocationModel location) {
      if (location.point != null) {
        markers.add(
          Marker(
            width: 80,
            height: 80,
            point: LatLng(
              location.point!.coordinates.last,
              location.point!.coordinates.first,
            ),
            child: const Icon(Icons.location_on),
          ),
        );
      }

      if (location.circle != null && location.radius != null) {
        circles.add(
          CircleMarker(
            point: LatLng(
              location.circle!.coordinates.last,
              location.circle!.coordinates.first,
            ),
            color: Colors.blue.withOpacity(0.7),
            borderStrokeWidth: 2,
            useRadiusInMeter: true,
            borderColor: Colors.blue,
            radius: location.radius!,
          ),
        );
      }

      if (location.polygon != null) {
        polygons.add(
          Polygon(
            points: location.polygon!.coordinates
                .map((List<double> e) => LatLng(e.last, e.first))
                .toList(),
            color: Colors.green.withOpacity(0.7),
            borderColor: Colors.green,
            borderStrokeWidth: 2,
          ),
        );
      }

      if (location.line != null) {
        lines.add(Polyline(
          points: location.line!.coordinates
              .map((List<double> p) => LatLng(p.last, p.first))
              .toList(),
          color: Colors.red,
          strokeWidth: 4.0,
        ));
      }
    });

    return FlutterMap(
      options: MapOptions(
        initialCenter: calculateBounds(markers, circles, polygons, lines),
        initialZoom: 6,
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          subdomains: const <String>['a', 'b', 'c'],
        ),
        MarkerLayer(markers: markers),
        CircleLayer(circles: circles),
        PolygonLayer(polygons: polygons),
        PolylineLayer(polylines: lines),
      ],
    );
  }
}

LatLng calculateBounds(
  List<Marker> markers,
  List<CircleMarker> circles,
  List<Polygon> polygons,
  List<Polyline> lines,
) {
  double? north, east, south, west;

  void updateBounds(double lat, double lon) {
    north = (north == null) ? lat : max(north!, lat);
    south = (south == null) ? lat : min(south!, lat);
    east = (east == null) ? lon : max(east!, lon);
    west = (west == null) ? lon : min(west!, lon);
  }

  // For markers
  for (Marker marker in markers) {
    updateBounds(marker.point.latitude, marker.point.longitude);
  }

  // For circles
  for (CircleMarker circle in circles) {
    updateBounds(circle.point.latitude, circle.point.longitude);
  }

  // For polygons
  for (Polygon polygon in polygons) {
    for (LatLng point in polygon.points) {
      updateBounds(point.latitude, point.longitude);
    }
  }

  // For polylines
  for (Polyline polyline in lines) {
    for (LatLng point in polyline.points) {
      updateBounds(point.latitude, point.longitude);
    }
  }

  return LatLngBounds(LatLng(north!, west!), LatLng(south!, east!)).center;
}
