import 'package:flutter/material.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class LocationNamesContainer extends StatelessWidget {
  final StoryModel story;

  const LocationNamesContainer({required this.story, super.key});

  @override
  Widget build(BuildContext context) {
    if (story.locations?.isEmpty ?? false) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (LocationModel location in story.locations!) ...<Widget>[
          Text(
            location.name ?? "",
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
        Container(
          height: 500,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: MapView(locations: story.locations),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}

class MapView extends StatelessWidget {
  final List<LocationModel>? locations;

  const MapView({super.key, this.locations});

  @override
  Widget build(BuildContext context) {
    List<Marker> markers = <Marker>[];
    List<CircleMarker> circles = <CircleMarker>[];
    List<Polygon> polygons = <Polygon>[];
    List<Polyline> lines = <Polyline>[];

    // Process each location
    locations?.forEach((LocationModel location) {
      // Handle point locations
      if (location.point != null) {
        markers.add(Marker(
          width: 80,
          height: 80,
          point: LatLng(
            location.point!.coordinates.last,
            location.point!.coordinates.first,
          ),
          child: const Icon(Icons.location_on),
        ));
      }

      // Handle circle locations
      if (location.circle != null && location.radius != null) {
        circles.add(CircleMarker(
          point: LatLng(
            location.circle!.coordinates.last,
            location.circle!.coordinates.first,
          ),
          color: Colors.blue.withOpacity(0.7),
          borderStrokeWidth: 2,
          borderColor: Colors.blue,
          radius: location.radius!,
        ));
      }

      // Handle polygon locations
      location.polygon?.coordinates.map(
        (List<List<double>> e) => polygons.add(
          Polygon(
            points: e
                .map((List<double> coordinate) => LatLng(
                      coordinate.last,
                      coordinate.first,
                    ))
                .toList(),
            color: Colors.green.withOpacity(0.7),
            borderColor: Colors.green,
            borderStrokeWidth: 2,
          ),
        ),
      );

      // Handle line locations
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
      mapController: MapController(),
      options: const MapOptions(
        initialCenter: LatLng(35.0, 35.0), // Default center, update as needed
        initialZoom: 2.0,
      ),
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.fleaflet.flutter_map.example',
        ),
        MarkerLayer(markers: markers),
        CircleLayer(circles: circles),
        PolygonLayer(polygons: polygons),
        PolylineLayer(polylines: lines),
      ],
    );
  }
}
