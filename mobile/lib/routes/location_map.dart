import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/routes/zoom_buttons.dart';
import 'package:memories_app/util/utils.dart';

class LocationMap extends StatefulWidget {
  const LocationMap({super.key});

  @override
  State<LocationMap> createState() => _LocationMapState();
}

class _LocationMapState extends State<LocationMap> {
  // polygon variables
  late List<Marker> _markersForPolygon;
  late List<Marker> _markersForPolyline;
  late List<Marker> _markersForPoint;
  late List<Polygon> _polygons;
  late List<Polyline> _completedPolylines;

  List<Polyline> _polylinesForPolygon = <Polyline>[];
  List<Polyline> _currentPolylinesForPolylineSelection = <Polyline>[];
  List<LatLng> _currentPolygonPoints = <LatLng>[];
  List<LatLng> _currentPolylinePoints = <LatLng>[];
  String _selectedMode = 'Point';

  @override
  void initState() {
    super.initState();
    _markersForPolygon = <Marker>[];
    _markersForPolyline = <Marker>[];
    _markersForPoint = <Marker>[];
    _polygons = <Polygon>[];
    _completedPolylines = <Polyline>[]; // Initialize the new list
  }

  void _addMarkerForPolygons(LatLng point) {
    _markersForPolygon.add(
      Marker(
        width: 40,
        height: 40,
        point: point,
        child: GestureDetector(
          child: const Icon(Icons.location_pin, size: 60, color: Colors.black),
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
          child: const Icon(Icons.location_pin, size: 60, color: Colors.black),
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
          child: const Icon(Icons.location_pin, size: 60, color: Colors.black),
          onTap: () {
            setState(() {
              // remove marker
              _markersForPoint
                  .removeWhere((Marker element) => element.point == point);
            });
          },
        ),
      ),
    );
  }

  void _startNewPolygon(LatLng point) {
    setState(() {
      _currentPolygonPoints = <LatLng>[point];
      _polylinesForPolygon =
          <Polyline>[]; // Clear existing polylines when starting a new polygon
      _addMarkerForPolygons(point);
    });
  }

  void _startNewPolyline(LatLng point) {
    setState(() {
      _currentPolylinePoints = <LatLng>[point];
      _currentPolylinesForPolylineSelection =
          <Polyline>[]; // Clear existing polylines when starting a new polygon
      _addMarkerForPolyline(point);
    });
  }

  void _addPointToPolygon(LatLng point) {
    setState(() {
      _currentPolygonPoints.add(point);
      _polylinesForPolygon = <Polyline>[
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
      _currentPolylinesForPolylineSelection = <Polyline>[
        Polyline(
          points: _currentPolylinePoints,
          color: Colors.red,
          strokeWidth: 3.0,
        ),
      ];
      _addMarkerForPolyline(point);
    });
  }

  void _completePolygon() async {
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

      // Reverse geocode to get the address from the centroid coordinates
      String address = await _reverseGeocode(centroidX, centroidY);

      // Create the Polygon with the address as the label
      setState(() {
        _polygons.add(
          Polygon(
            points: _currentPolygonPoints,
            isFilled: true,
            color: Colors.red.withOpacity(0.5),
            borderColor: Colors.red,
            borderStrokeWidth: 4,
            label: address != "not found"
                ? 'Area around $address'
                : "Cannot do reverse geocoding",
            // Add any additional label styling if needed
            labelPlacement: PolygonLabelPlacement.polylabel,
            labelStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
        _currentPolygonPoints = <LatLng>[];
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
        _currentPolylinePoints =
            <LatLng>[]; // Clear only when starting a new polyline
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMapAndAdressList(context);
  }

  Widget _buildMapAndAdressList(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: <Widget>[
              _buildMap(),
              if (_currentPolylinePoints.length > 1)
                Positioned(
                  right: 16,
                  child: ElevatedButton(
                    child: const Text("Done"),
                    onPressed: () {
                      _completePolyline();
                    },
                  ),
                )
            ],
          ),
        ),
        // Add selection buttons
        _buildPointSelectionModeButtons(),
        const SizedBox(
          height: SpaceSizes.x16,
        ),
        if (_markersForPoint.isNotEmpty) ..._buildMarkerAdresses,
        if (_polygons.isNotEmpty) ..._buildPolygonAdresses,
        if (_completedPolylines.isNotEmpty) ..._buildPolylineAdresses,
        const SizedBox(height: SpaceSizes.x16),
      ],
    );
  }

  List<Widget> get _buildPolylineAdresses {
    return <Widget>[
      const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Polylines:",
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
      const SizedBox(
        height: SpaceSizes.x8,
      ),
      for (int index = 0; index < _completedPolylines.length; index++)
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder<List<String>>(
                      future: _reverseGeocodePolylinePoints(
                          _completedPolylines[index].points),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<String>> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                              "..."); // Show loading indicator while fetching the addresses.
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Text(snapshot.data?.join('-') ??
                              "Addresses not found");
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        List<LatLng> polylinePoints =
                            _completedPolylines[index].points;

                        if (_completedPolylines.isNotEmpty) {
                          _completedPolylines.removeAt(index);
                        }

                        if (_currentPolylinesForPolylineSelection.isNotEmpty) {
                          _currentPolylinesForPolylineSelection = <Polyline>[];
                        }
                        _markersForPolyline.removeWhere((Marker marker) =>
                            polylinePoints.contains(marker.point));
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Divider(),
            ],
          ),
        ),
    ];
  }

  List<Widget> get _buildMarkerAdresses {
    return <Widget>[
      const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Points:",
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
      const SizedBox(
        height: SpaceSizes.x8,
      ),
      for (Marker marker in _markersForPoint)
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _reverseGeocode(
                          marker.point.latitude, marker.point.longitude),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                              "..."); // Show loading indicator while fetching the address.
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Text(snapshot.data ?? "Address not found");
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _markersForPoint.remove(marker);
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Divider(),
            ],
          ),
        ),
    ];
  }

  List<Widget> get _buildPolygonAdresses {
    return <Widget>[
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "Polygons:",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      const SizedBox(
        height: SpaceSizes.x8,
      ),
      for (int index = 0; index < _polygons.length; index++)
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(child: Text(_polygons[index].label.toString())),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        List<LatLng> polygonPoints = _polygons[index].points;
                        // Remove the polygon at the current index
                        _polygons.removeAt(index);
                        // Remove matching points from _polylinesForPolygon
                        _polylinesForPolygon.removeWhere((Polyline polyline) =>
                            polyline.points.any((LatLng point) =>
                                polygonPoints.contains(point)));
                        // Remove matching points from _markersForPolygon
                        _markersForPolygon.removeWhere((Marker marker) =>
                            polygonPoints.contains(marker.point));
                      });
                    },
                    child: const Icon(
                      Icons.close,
                      color: Colors.red,
                      size: 15,
                    ),
                  )
                ],
              ),
              const Divider(),
            ],
          ),
        ),
    ];
  }

  Row _buildPointSelectionModeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedMode = 'Point';
            });
          },
          style: _selectedMode == 'Point'
              ? ElevatedButton.styleFrom(backgroundColor: Colors.blue)
              : null,
          child: Text('Point',
              style: TextStyle(
                  color:
                      _selectedMode == "Point" ? Colors.white : Colors.blue)),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedMode = 'Polygon';
            });
          },
          style: _selectedMode == 'Polygon'
              ? ElevatedButton.styleFrom(backgroundColor: Colors.blue)
              : null,
          child: Text('Polygon',
              style: TextStyle(
                  color:
                      _selectedMode == "Polygon" ? Colors.white : Colors.blue)),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedMode = 'Polyline';
            });
          },
          style: _selectedMode == 'Polyline'
              ? ElevatedButton.styleFrom(backgroundColor: Colors.blue)
              : null,
          child: Text(
            'Polyline',
            style: TextStyle(
                color:
                    _selectedMode == "Polyline" ? Colors.white : Colors.blue),
          ),
        ),
      ],
    );
  }

  FlutterMap _buildMap() {
    return FlutterMap(
      options: MapOptions(
        onTap: (TapPosition tapPosition, LatLng point) {
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
      children: <Widget>[
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
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
        PolylineLayer(polylines: _currentPolylinesForPolylineSelection),
        PolylineLayer(polylines: _completedPolylines),
      ],
    );
  }

  Future<String> _reverseGeocode(double latitude, double longitude) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latitude, longitude);

    if (placemarks.isNotEmpty) {
      Placemark placemark = placemarks[0];
      return "${placemark.name ?? ''}, ${placemark.administrativeArea ?? ''}, ${placemark.country ?? ''} ";
    } else {
      return "not found";
    }
  }

  Future<List<String>> _reverseGeocodePolylinePoints(
      List<LatLng> points) async {
    List<String> addresses = <String>[];

    for (LatLng point in points) {
      String address = await _reverseGeocode(point.latitude, point.longitude);
      addresses.add(address);
    }

    return addresses;
  }
}
