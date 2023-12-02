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
      options: const MapOptions(
        initialCenter: LatLng(35.0, 35.0),
        initialZoom: 4.0,
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
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
