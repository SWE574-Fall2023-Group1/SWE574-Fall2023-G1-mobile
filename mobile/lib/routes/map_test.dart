import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/routes/zoom_buttons.dart';

// Import necessary packages and classes
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'dart:math';

// Define the MapTest widget
class MapTest extends StatefulWidget {
  const MapTest({super.key});

  @override
  State<MapTest> createState() => _MapTestState();
}

// Define the _MapTestState class
class _MapTestState extends State<MapTest> {
  // polygon variables
  late List<Marker> _markersForPolygon;
  late List<Marker> _markersForPolyline;
  late List<Marker> _markersForPoint;
  late List<Polygon> _polygons;
  late List<Polyline>
      _completedPolylines; // New list to store completed polylines

  List<Polyline> _polylinesForPolygon = [];
  List<Polyline> _polylinesForPolyline = [];
  List<LatLng> _currentPolygonPoints = [];
  List<LatLng> _currentPolylinePoints = [];
  String _selectedMode = 'Polygon';

  @override
  void initState() {
    super.initState();
    _markersForPolygon = [];
    _markersForPolyline = [];
    _markersForPoint = [];
    _polygons = [];
    _completedPolylines = []; // Initialize the new list
  }

  void _addMarkerForPolygons(LatLng point) {
    _markersForPolygon.add(
      Marker(
        width: 40,
        height: 40,
        point: point,
        child: GestureDetector(
          child: Icon(Icons.location_pin, size: 60, color: Colors.black),
          onTap: () {
            setState(() {
              if (_currentPolygonPoints.indexOf(point) == 0) {
                _completePolygon();
              }
            });
          },
        ),
      ),
    );
  }

  void _addMarkerForPolyline(LatLng point) {
    _markersForPolyline.add(
      Marker(
        width: 40,
        height: 40,
        point: point,
        child: GestureDetector(
          child: Icon(Icons.location_pin, size: 60, color: Colors.black),
          onTap: () {
            setState(() {});
          },
        ),
      ),
    );
  }

  void _addMarkerForPointSelection(LatLng point) {
    _markersForPoint.add(
      Marker(
        width: 40,
        height: 40,
        point: point,
        child: GestureDetector(
          child: Icon(Icons.location_pin, size: 60, color: Colors.black),
          onTap: () {
            setState(() {
              // remove marker
              _markersForPoint.removeWhere((element) => element.point == point);
            });
          },
        ),
      ),
    );
  }

  void _startNewPolygon(LatLng point) {
    setState(() {
      _currentPolygonPoints = [point];
      _polylinesForPolygon =
          []; // Clear existing polylines when starting a new polygon
      _addMarkerForPolygons(point);
    });
  }

  void _startNewPolyline(LatLng point) {
    setState(() {
      _currentPolylinePoints = [point];
      _polylinesForPolyline =
          []; // Clear existing polylines when starting a new polygon
      _addMarkerForPolyline(point);
    });
  }

  void _addPointToPolygon(LatLng point) {
    setState(() {
      _currentPolygonPoints.add(point);
      _polylinesForPolygon = [
        Polyline(
          points: _currentPolygonPoints,
          color: Colors.red,
          strokeWidth: 3.0,
        ),
      ];
      _addMarkerForPolygons(point);
    });
  }

  void _addPointToPolyline(LatLng point) {
    setState(() {
      _currentPolylinePoints.add(point);
      _polylinesForPolyline = [
        Polyline(
          points: _currentPolylinePoints,
          color: Colors.red,
          strokeWidth: 3.0,
        ),
      ];
      _addMarkerForPolyline(point);
    });
  }

  void _completePolygon() {
    if (_currentPolygonPoints.length >= 3) {
      // Calculate the centroid of the polygon
      double sumX = 0.0;
      double sumY = 0.0;
      for (LatLng point in _currentPolygonPoints) {
        sumX += point.latitude;
        sumY += point.longitude;
      }
      double centroidX = sumX / _currentPolygonPoints.length;
      double centroidY = sumY / _currentPolygonPoints.length;

      // Create the Polygon with the centroid as the label
      setState(() {
        _polygons.add(
          Polygon(
              points: _currentPolygonPoints,
              isFilled: true,
              color: Colors.red.withOpacity(0.5),
              borderColor: Colors.red,
              borderStrokeWidth: 4,
              label:
                  "Area around ${centroidX.toStringAsFixed(2)}, ${centroidY.toStringAsFixed(2)}",
              // Add any additional label styling if needed
              labelPlacement: PolygonLabelPlacement.polylabel,
              labelStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        );
        _currentPolygonPoints = [];
      });
    }
  }

  void _completePolyline() {
    if (_currentPolylinePoints.length > 1) {
      setState(() {
        _completedPolylines.add(
          Polyline(
            points: _currentPolylinePoints,
            color: Colors.red,
            strokeWidth: 3.0,
          ),
        );
        _currentPolylinePoints = []; // Clear only when starting a new polyline
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("map test"),
      ),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    onTap: (tapPosition, point) {
                      if (_selectedMode == "Polygon") {
                        if (_currentPolygonPoints.isEmpty) {
                          // Start a new polygon
                          setState(() {
                            _startNewPolygon(point);
                          });
                        } else {
                          // Continue adding points to the current polygon
                          setState(() {
                            _addPointToPolygon(point);
                          });
                        }
                      } else if (_selectedMode == "Point") {
                        setState(() {
                          _addMarkerForPointSelection(point);
                        });
                      } else if (_selectedMode == "Polyline") {
                        if (_currentPolylinePoints.isEmpty) {
                          setState(() {
                            _startNewPolyline(point);
                          });
                        } else {
                          setState(() {
                            _addPointToPolyline(point);
                          });
                        }
                      }
                    },
                    initialCenter: const LatLng(51.5, -0.09),
                    initialZoom: 5,
                  ),
                  mapController: MapController(),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
                    ),
                    const FlutterMapZoomButtons(
                      minZoom: 4,
                      maxZoom: 19,
                      mini: true,
                      padding: 10,
                      alignment: Alignment.bottomRight,
                    ),
                    PolygonLayer(polygons: _polygons),
                    PolylineLayer(polylines: _polylinesForPolygon),
                    MarkerLayer(markers: _markersForPolygon),
                    MarkerLayer(markers: _markersForPoint),
                    MarkerLayer(markers: _markersForPolyline),
                    PolylineLayer(polylines: _polylinesForPolyline),
                    PolylineLayer(polylines: _completedPolylines),
                  ],
                ),
                if (_currentPolylinePoints.length > 1)
                  Positioned(
                    right: 16,
                    child: ElevatedButton(
                      child: Text("Done"),
                      onPressed: () {
                        _completePolyline();
                      },
                    ),
                  )
              ],
            ),
          ),
          // Add selection buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedMode = 'Polygon';
                  });
                },
                style: _selectedMode == 'Polygon'
                    ? ElevatedButton.styleFrom(primary: Colors.blue)
                    : null,
                child: Text('Polygon',
                    style: TextStyle(
                        color: _selectedMode == "Polygon"
                            ? Colors.white
                            : Colors.blue)),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedMode = 'Point';
                  });
                },
                style: _selectedMode == 'Point'
                    ? ElevatedButton.styleFrom(primary: Colors.blue)
                    : null,
                child: Text('Point',
                    style: TextStyle(
                        color: _selectedMode == "Point"
                            ? Colors.white
                            : Colors.blue)),
              ),
              OutlinedButton(
                onPressed: () {
                  setState(() {
                    _selectedMode = 'Polyline';
                  });
                },
                style: _selectedMode == 'Polyline'
                    ? ElevatedButton.styleFrom(primary: Colors.blue)
                    : null,
                child: Text(
                  'Polyline',
                  style: TextStyle(
                      color: _selectedMode == "Polyline"
                          ? Colors.white
                          : Colors.blue),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
