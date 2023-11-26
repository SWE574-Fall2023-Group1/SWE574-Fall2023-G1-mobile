// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/map/location_list_tile.dart';
import 'package:memories_app/routes/map/model/place_autocomplete_response.dart';
import 'package:memories_app/routes/map/model/place_details_response.dart';
import 'package:memories_app/routes/map/zoom_buttons.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/utils.dart';

class CreateStoryRoute extends StatefulWidget {
  const CreateStoryRoute({super.key});

  @override
  State<CreateStoryRoute> createState() => _CreateStoryRouteState();
}

class _CreateStoryRouteState extends State<CreateStoryRoute> {
  // polygon variables
  late List<Marker> _markersForPolygon;
  late List<Marker> _markersForPolyline;
  late List<Marker> _markersForPoint;
  late List<Polygon> _polygons;
  late List<Polyline> _completedPolylines;
  List<CircleMarker> _circleMarkers = [];
  late ValueNotifier<double> _radiusNotifier;

  double _currentRadius = 50;

  List<Polyline> _polylinesForPolygon = <Polyline>[];
  List<Polyline> _currentPolylinesForPolylineSelection = <Polyline>[];
  List<LatLng> _currentPolygonPoints = <LatLng>[];
  List<LatLng> _currentPolylinePoints = <LatLng>[];
  String _selectedMode = 'Point';

  List<Prediction> _placePredictions = <Prediction>[];
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _markersForPolygon = <Marker>[];
    _markersForPolyline = <Marker>[];
    _markersForPoint = <Marker>[];
    _polygons = <Polygon>[];
    _completedPolylines = <Polyline>[];
    _radiusNotifier = ValueNotifier<double>(_currentRadius);
  }

  // Method to get the current state of LocationMap

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        {"input": query, "key": AppConstants.apiKey});
    String? response = await NetworkManager.fetchMapUrl(uri);
    if (response != null) {
      PlaceResponse result = PlaceResponse.fromJson(json.decode(response));
      setState(() {
        _placePredictions = result.predictions;
      });
    }
  }

  void placeDetailsMarking(String placeId) async {
    Uri uri = Uri.https("maps.googleapis.com", "maps/api/place/details/json", {
      "place_id": placeId,
      "fields": ["geometry"],
      "key": AppConstants.apiKey
    });
    String? response = await NetworkManager.fetchMapUrl(uri);
    if (response != null) {
      PlaceDetailsResponse placeDetails =
          PlaceDetailsResponse.fromJson(json.decode(response));

      final LatLng point = LatLng(
        placeDetails.result.geometry.location.lat,
        placeDetails.result.geometry.location.lng,
      );

      _addMarkerForPointSelection(point);

      setState(() {
        _controller.clear();
        _placePredictions.clear();
      });
      FocusManager.instance.primaryFocus?.unfocus();
      _mapController.move(point, _mapController.camera.zoom + 5);
    }
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
      String address = "...";

      String reverseGeocodeResult = await _reverseGeocode(centroidX, centroidY);
      if (reverseGeocodeResult != "not found") {
        address = 'Area around $reverseGeocodeResult';
      } else {
        address = "Cannot do reverse geocoding";
      }
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

  void _addCircleMarker(LatLng point) {
    setState(() {
      _circleMarkers.add(
        CircleMarker(
          point: point,
          color: Colors.red.withOpacity(0.5),
          radius: _currentRadius,
        ),
      );
    });
  }

  void _updateCircleRadius() {
    CircleMarker lastCircle = _circleMarkers.last;
    _circleMarkers.removeLast(); // Remove the existing circle
    _circleMarkers.add(
      CircleMarker(
        point: lastCircle.point,
        color: Colors.red.withOpacity(0.5),
        radius: _radiusNotifier.value, // Use the updated radius
      ),
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      LatLng point = LatLng(position.latitude, position.longitude);
      setState(() {
        _addMarkerForPointSelection(point);
      });
      _mapController.move(point, _mapController.camera.zoom + 5);
      //_reverseGeocode(position.latitude, position.longitude);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  Widget _buildPage(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Story"),
        leading: GestureDetector(
            onTap: () {
              AppRoute.landing.navigate(context);
            },
            child: const Icon(Icons.close)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            children: [
              _buildMapAndAdresses(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMapAndAdresses(BuildContext context) {
    return Column(
      children: [
        Form(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: SpaceSizes.x4, vertical: SpaceSizes.x8),
            child: TextFormField(
              onChanged: (String value) {
                placeAutocomplete(value);
              },
              controller: _controller,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                filled: true,
                hintText: "Search your location",
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: SpaceSizes.x4),
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.black,
                  ),
                ),
                suffixIcon: (_controller.text.isNotEmpty)
                    ? GestureDetector(
                        onTap: () {
                          _controller.clear();
                          setState(() {
                            _placePredictions.clear();
                          });
                        },
                        child: const Icon(
                          Icons.cancel_rounded,
                          color: AppColors.disabledButtonTextColor,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
        const Divider(
          height: 4,
          thickness: 2,
        ),
        Padding(
          padding: const EdgeInsets.all(SpaceSizes.x8),
          child: ElevatedButton.icon(
            onPressed: _getCurrentPosition,
            icon: Image.asset(
              "assets/navigation.png",
              height: 16,
            ),
            label: const Text("Use my Current Location"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonColor,
              elevation: 0,
              minimumSize: const Size.fromHeight(50), // NEW
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
          ),
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _placePredictions.length,
          itemBuilder: (BuildContext context, int index) => LocationListTile(
              location: _placePredictions[index].description,
              press: () {
                placeDetailsMarking(_placePredictions[index].placeId);
              }),
        ),
        if (_placePredictions.isNotEmpty)
          const SizedBox(
            height: SpaceSizes.x16,
          ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: Stack(
            children: <Widget>[
              _buildMap(),
              if (_currentPolylinePoints.length > 1)
                Positioned(
                  right: SpaceSizes.x16,
                  child: ElevatedButton(
                    child: const Text("Done"),
                    onPressed: () {
                      _completePolyline();
                    },
                  ),
                ),
              if (_selectedMode == "Circle" && _circleMarkers.isNotEmpty)
                Positioned.fill(
                  top:
                      MediaQuery.of(context).size.height * 0.5 - SpaceSizes.x60,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: 100,
                      child: ValueListenableBuilder<double>(
                        valueListenable: _radiusNotifier,
                        builder: (context, value, child) {
                          return Slider(
                            value: value,
                            min: 1.0,
                            max: 100.0,
                            onChanged: (double newValue) {
                              _radiusNotifier.value = newValue;
                              _updateCircleRadius();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ),
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
        if (_circleMarkers.isNotEmpty) ..._buildCircleAdresses,
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

  List<Widget> get _buildCircleAdresses {
    return <Widget>[
      const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Circle:",
            style: TextStyle(fontWeight: FontWeight.w700),
          )),
      const SizedBox(
        height: SpaceSizes.x8,
      ),
      for (CircleMarker circleMarker in _circleMarkers)
        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: FutureBuilder<String>(
                      future: _reverseGeocode(circleMarker.point.latitude,
                          circleMarker.point.longitude),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text(
                              "..."); // Show loading indicator while fetching the address.
                        } else if (snapshot.hasError) {
                          return Text("Error: ${snapshot.error}");
                        } else {
                          return Text(snapshot.data != null
                              ? "Circle area around ${snapshot.data}"
                              : "Address not found");
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _circleMarkers.remove(circleMarker);
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
        )
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
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedMode = 'Circle';
            });
          },
          style: _selectedMode == 'Circle'
              ? ElevatedButton.styleFrom(backgroundColor: Colors.blue)
              : null,
          child: Text('Circle',
              style: TextStyle(
                  color:
                      _selectedMode == "Circle" ? Colors.white : Colors.blue)),
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
            } else if (_selectedMode == "Circle") {
              setState(() {
                _addCircleMarker(point);
              });
            }
          },
          initialCenter: _markersForPoint.isNotEmpty
              ? _markersForPoint.last.point
              : _markersForPolygon.isNotEmpty
                  ? _markersForPolygon.last.point
                  : _markersForPolyline.isNotEmpty
                      ? _markersForPolyline.last.point
                      : _circleMarkers.isNotEmpty
                          ? _circleMarkers.last.point
                          : const LatLng(41.05, 29.03),
          initialZoom: _markersForPolygon.isNotEmpty ||
                  _markersForPoint.isNotEmpty ||
                  _markersForPolyline.isNotEmpty ||
                  _circleMarkers.isNotEmpty
              ? 8
              : 5),
      mapController: _mapController,
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
        CircleLayer(circles: _circleMarkers),
      ],
    );
  }

  Future<String> _reverseGeocode(double latitude, double longitude) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, longitude,
        localeIdentifier: "en");

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
