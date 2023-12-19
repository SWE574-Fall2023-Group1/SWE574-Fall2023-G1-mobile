// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/create_story/location_list_tile.dart';
import 'package:memories_app/routes/create_story/model/place_autocomplete_response.dart';
import 'package:memories_app/routes/create_story/model/place_details_response.dart';
import 'package:memories_app/routes/create_story/model/tag.dart';
import 'package:memories_app/routes/create_story/zoom_buttons.dart';
import 'package:memories_app/routes/search/bloc/search_story_bloc.dart';
import 'package:memories_app/ui/shows_dialog.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/utils.dart';
import 'package:http/http.dart' as http;

class SearchStoryRoute extends StatefulWidget {
  const SearchStoryRoute({super.key});

  @override
  State<SearchStoryRoute> createState() => _SearchStoryRouteState();
}

class _SearchStoryRouteState extends State<SearchStoryRoute> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _searchTagsController = TextEditingController();
  final TextEditingController _tagsLabelController = TextEditingController();

  final List<Tag> _tagsSearchResults = <Tag>[];
  List<String> tags = <String>[];
  late Tag _semanticTagSelected;

  String selectedDateType = '';
  String selectedSeason = '';
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();

  final TextEditingController _datePickerController = TextEditingController();
  final TextEditingController _endDatePickerController =
      TextEditingController();

  String _selectedDecade = '';

  List<Prediction> _placePredictions = <Prediction>[];
  final TextEditingController _locationController = TextEditingController();
  final MapController _mapController = MapController();

  final List<CircleMarker> _circleMarkers = <CircleMarker>[];
  final double _currentRadiusInKm = 25;
  late ValueNotifier<double> _radiusNotifier;
  final TextEditingController _radiusInputController =
      TextEditingController(text: "25");

  @override
  void initState() {
    _radiusNotifier = ValueNotifier<double>(_currentRadiusInKm);
    super.initState();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _searchTagsController.dispose();
    _tagsLabelController.dispose();
    _yearController.dispose();
    _endYearController.dispose();
    _datePickerController.dispose();
    _endDatePickerController.dispose();
    _locationController.dispose();
    _mapController.dispose();
    _radiusInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SearchStoryBloc, SearchStoryState>(
        buildWhen: (SearchStoryState previousState, SearchStoryState state) {
      return !(state is SearchStoryFailure || state is SearchStoryOffline);
    }, builder: (BuildContext context, SearchStoryState state) {
      return WillPopScope(
        onWillPop: () async {
          AppRoute.landing.navigate(context);
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Search Story"),
            leading: GestureDetector(
              onTap: () {
                AppRoute.landing.navigate(context);
              },
              child: const Icon(Icons.close),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpaceSizes.x8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: SpaceSizes.x16,
                  ),
                  _buildTitleField(),
                  const SizedBox(
                    height: SpaceSizes.x8,
                  ),
                  _buildAuthorField(),
                  const SizedBox(
                    height: SpaceSizes.x8,
                  ),
                  _buildSearchTags(),
                  const SizedBox(
                    height: SpaceSizes.x8,
                  ),
                  if (_tagsSearchResults.isNotEmpty) _buildSearchTagsResult(),
                  _buildTagsLabelInput(),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildDateTypeDropdown(),
                  const SizedBox(height: SpaceSizes.x16),
                  if (selectedDateType == 'Year' ||
                      selectedDateType == 'Interval Year')
                    _buildYearSelection(),
                  if (selectedDateType == 'Normal Date' ||
                      selectedDateType == 'Interval Date')
                    _buildDateSelection(),
                  if (selectedDateType == 'Decade') _buildDecadeDropdown(),
                  _buildLocationInput(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: Stack(children: <Widget>[
                      _buildMap(),
                      if (_circleMarkers.isNotEmpty)
                        _buildSliderAndRadiusInput()
                    ]),
                  ),
                  const SizedBox(
                    height: SpaceSizes.x32,
                  ),
                  _buildSearchButtons(context),
                  const SizedBox(
                    height: SpaceSizes.x32,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }, listener: (BuildContext context, SearchStoryState state) {
      if (state is SearchStorySuccess) {
      } else if (state is SearchStoryFailure) {
        ShowsDialog.showAlertDialog(context, 'Oops!', state.error.toString(),
            isSearchStoryFail: true);
      } else if (state is SearchStoryOffline) {
        ShowsDialog.showAlertDialog(
            context, 'Oops!', state.offlineMessage.toString(),
            isSearchStoryFail: true);
      }
    });
  }

  Widget _buildSearchButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        FilledButton(
          child: const Text("Search Stories"),
          onPressed: () {
            BlocProvider.of<SearchStoryBloc>(context)
                .add(SearchStoryEventSearchPressed(
              author: _authorController.text,
              date: _datePickerController.text,
              endDate: _endDatePickerController.text,
              endYear: _endYearController.text,
              seasonName: selectedSeason,
              startDate: _datePickerController.text,
              startYear: _yearController.text,
              tag: _semanticTagSelected.id,
              tagLabel: _tagsLabelController.text,
              title: _titleController.text,
              year: _yearController.text,
              timeType: selectedDateType,
              decade: _selectedDecade,
              marker: _circleMarkers.first,
              radius: _radiusNotifier.value.toInt(),
              dateDiff: 2,
            ));
          },
        ),
      ],
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
          borderSide:
              const BorderSide(color: AppColors.disabledButtonTextColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
          borderSide:
              const BorderSide(color: AppColors.disabledButtonTextColor),
        ),
        labelText: "Search by Title",
      ),
    );
  }

  Widget _buildAuthorField() {
    return TextFormField(
      controller: _authorController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
          borderSide:
              const BorderSide(color: AppColors.disabledButtonTextColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
          borderSide:
              const BorderSide(color: AppColors.disabledButtonTextColor),
        ),
        labelText: "Search by Author",
      ),
    );
  }

  Widget _buildSearchTags() {
    return TextField(
      controller: _searchTagsController,
      onChanged: (String value) {
        if (value.isNotEmpty) {
          setState(() {
            _searchWikiData(value);
          });
        } else {
          setState(() {
            _tagsSearchResults.clear();
          });
        }
      },
      decoration: InputDecoration(
        labelText: 'Search Semantic Tags',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            String query = _searchTagsController.text;
            if (query.isNotEmpty) {
              setState(() {
                _searchWikiData(query);
              });
            } else {
              setState(() {
                _tagsSearchResults.clear();
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildSearchTagsResult() {
    return Container(
      height: 150,
      decoration: const BoxDecoration(
          border: BorderDirectional(
              top: BorderSide.none,
              end: BorderSide(),
              start: BorderSide(),
              bottom: BorderSide())),
      child: Scrollbar(
        child: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                for (int i = 0; i < _tagsSearchResults.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tags.add(_tagsSearchResults[i].label);
                              _semanticTagSelected = _tagsSearchResults[i];
                              _searchTagsController.text =
                                  _tagsSearchResults[i].label;
                              _tagsLabelController.text =
                                  _searchTagsController.text;
                              _tagsSearchResults.clear();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  _tagsSearchResults[i].label,
                                  textAlign: TextAlign.start,
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Text(
                                _tagsSearchResults[i].description,
                                textAlign: TextAlign.start,
                              ),
                              const Divider(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
              ]),
        ),
      ),
    );
  }

  Widget _buildTagsLabelInput() {
    return TextFormField(
      controller: _tagsLabelController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Enter the label you want to give the tag"),
    );
  }

  Widget _buildDateTypeDropdown() {
    return DropdownButtonFormField<String>(
      onChanged: (String? newValue) {
        setState(() {
          selectedDateType = newValue!;
        });
      },
      decoration: InputDecoration(
        hintText: "Date Type",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
        ),
      ),
      items: <String>[
        'Year',
        'Interval Year',
        'Normal Date',
        'Interval Date',
        'Decade'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildYearSelection() {
    return Row(
      children: <Widget>[
        // TextFormfield for year
        Expanded(
          child: TextFormField(
            controller: _yearController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: selectedDateType == 'Year' ? "Year" : "Start Year",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SpaceSizes.x8),
              ),
            ),
          ),
        ),
        const SizedBox(width: SpaceSizes.x8),
        if (selectedDateType == "Interval Year")
          Expanded(
            child: TextFormField(
              controller: _endYearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: "End Year",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SpaceSizes.x8),
                ),
              ),
            ),
          ),
        const SizedBox(width: SpaceSizes.x8),

        // Dropdown for season
        IntrinsicWidth(
          child: DropdownButtonFormField<String>(
            onChanged: (String? newValue) {
              setState(() {
                selectedSeason = newValue!;
              });
            },
            decoration: InputDecoration(
              hintText: "Season",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(SpaceSizes.x8),
              ),
            ),
            items: <String>['Summer', 'Fall', 'Spring', 'Winter']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    if (selectedDateType == "Normal Date") {
      return Row(
        children: <Widget>[
          Expanded(
            child: _buildDatePicker(),
          ),
          const SizedBox(width: SpaceSizes.x8),
        ],
      );
    } else {
      return Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: _buildDatePicker()),
              const SizedBox(
                height: SpaceSizes.x8,
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: _buildEndDatePicker()),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: _datePickerController,
      decoration: InputDecoration(
        hintText: selectedDateType == 'Normal Date' ? "Date" : "Start Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
        ),
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

          setState(() {
            _datePickerController.text = formattedDate;
          });
        }
      },
    );
  }

  Widget _buildEndDatePicker() {
    return TextFormField(
      controller: _endDatePickerController,
      decoration: InputDecoration(
        hintText: "End Date",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
        ),
        suffixIcon: const Icon(Icons.calendar_month),
      ),
      readOnly: true,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime.now(),
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);

          setState(() {
            _endDatePickerController.text = formattedDate;
          });
        }
      },
    );
  }

  Widget _buildDecadeDropdown() {
    return DropdownButtonFormField<String>(
      onChanged: (String? newValue) {
        setState(() {
          _selectedDecade = newValue!;
        });
      },
      decoration: InputDecoration(
        hintText: "Select a decade",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SpaceSizes.x8),
        ),
      ),
      items: <String>[
        '1900s',
        '1910s',
        '1920s',
        '1930s',
        '1940s',
        '1950s',
        '1960s',
        '1970s',
        '1980s',
        '1990s',
        '2000s',
        '2010s',
        '2020s',
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  Widget _buildLocationInput(BuildContext context) {
    return Column(
      children: <Widget>[
        Form(
          child: Padding(
            padding: const EdgeInsets.only(top: SpaceSizes.x16),
            child: TextFormField(
              onChanged: (String value) {
                placeAutocomplete(value);
              },
              controller: _locationController,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SpaceSizes.x8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(SpaceSizes.x8),
                ),
                filled: true,
                fillColor: Colors.white,
                hintText: "Search your location",
                prefixIcon: const Padding(
                  padding: EdgeInsets.symmetric(vertical: SpaceSizes.x4),
                  child: Icon(
                    Icons.location_pin,
                    color: Colors.black,
                  ),
                ),
                suffixIcon: (_locationController.text.isNotEmpty)
                    ? GestureDetector(
                        onTap: () {
                          _locationController.clear();
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: SpaceSizes.x8),
          child: ElevatedButton.icon(
            onPressed: _getCurrentPosition,
            icon: Image.asset(
              "assets/navigation.png",
              height: 16,
              color: Colors.white,
            ),
            label: const Text(
              "Use My Current Location",
              style: TextStyle(color: Colors.white),
            ),
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
      ],
    );
  }

  FlutterMap _buildMap() {
    return FlutterMap(
      options: MapOptions(
          onTap: (TapPosition tapPosition, LatLng point) {
            setState(() {
              _circleMarkers.clear();
              _addCircleMarker(point);
              _updateCircleRadius();
            });
          },
          initialCenter: _circleMarkers.isNotEmpty
              ? _circleMarkers.last.point
              : const LatLng(41.05, 29.03),
          initialZoom: _circleMarkers.isNotEmpty ? 8 : 5),
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
          zoomInColorIcon: Colors.white,
          zoomOutColorIcon: Colors.white,
        ),
        CircleLayer(circles: _circleMarkers),
      ],
    );
  }

  Widget _buildSliderAndRadiusInput() {
    return Positioned.fill(
      top: MediaQuery.of(context).size.height * 0.5 - 90,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              child: ValueListenableBuilder<double>(
                valueListenable: _radiusNotifier,
                builder: (BuildContext context, double value, Widget? child) {
                  return Slider(
                    value: value,
                    min: 1,
                    max: 250,
                    onChanged: (double newValue) {
                      _radiusNotifier.value = newValue;

                      _updateCircleRadius();
                      setState(() {
                        _radiusInputController.text = "${newValue.toInt()}";
                      });
                    },
                  );
                },
              ),
            ),
            SizedBox(
              width: 75,
              height: 32,
              child: TextFormField(
                controller: _radiusInputController,
                style: const TextStyle(fontSize: 13),
                keyboardType: TextInputType.number,
                onChanged: (String value) {
                  double temp = double.parse(value);
                  if (temp > 1 && temp < 2500) {
                    _radiusNotifier.value = temp;
                    _updateCircleRadius();
                  }
                },
                decoration: InputDecoration(
                    hintText: "Radius",
                    hintStyle: const TextStyle(fontSize: 13),
                    border: const OutlineInputBorder(),
                    fillColor: Colors.white.withOpacity(0.5),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    filled: true,
                    suffixText: "km",
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 8)),
              ),
            ),
            const SizedBox(
              height: SpaceSizes.x4,
            )
          ],
        ),
      ),
    );
  }

  void _updateCircleRadius() {
    CircleMarker lastCircle = _circleMarkers.last;
    _circleMarkers.clear();
    _circleMarkers.add(
      CircleMarker(
          point: lastCircle.point,
          radius: _radiusNotifier.value * 1000,
          color: Colors.red.withOpacity(0.5),
          useRadiusInMeter: true),
    );
  }

  void placeAutocomplete(String query) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        "maps/api/place/autocomplete/json",
        <String, dynamic>{"input": query, "key": AppConstants.apiKey});
    String? response = await NetworkManager.fetchMapUrl(uri);
    if (response != null) {
      PlaceResponse result = PlaceResponse.fromJson(json.decode(response));
      setState(() {
        _placePredictions = result.predictions;
      });
    }
  }

  Future<void> _getCurrentPosition() async {
    final bool hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      return;
    }
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      LatLng point = LatLng(position.latitude, position.longitude);
      setState(() {
        _addCircleMarker(point);
      });
      _mapController.move(point, _mapController.camera.zoom + 5);
    }).catchError((dynamic e) {
      debugPrint(e);
    });
  }

  void _addCircleMarker(LatLng point) {
    setState(() {
      _circleMarkers.add(
        CircleMarker(
            point: point,
            color: Colors.red.withOpacity(0.5),
            radius: _currentRadiusInKm,
            useRadiusInMeter: true),
      );
    });
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

  void placeDetailsMarking(String placeId) async {
    Uri uri = Uri.https(
        "maps.googleapis.com", "maps/api/place/details/json", <String, dynamic>{
      "place_id": placeId,
      "fields": <String>["geometry"],
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

      _addCircleMarker(point);

      setState(() {
        _locationController.clear();
        _placePredictions.clear();
      });
      FocusManager.instance.primaryFocus?.unfocus();
      _mapController.move(point, _mapController.camera.zoom + 5);
    }
  }

  Future<void> _searchWikiData(String query) async {
    final http.Response response = await http.get(
      Uri.parse('${NetworkConstant.baseURL}/user/wikidataSearch?query=$query'),
    );

    if (response.statusCode == 200) {
      // Parse the response as a list of tags
      List<dynamic> tagsJson =
          json.decode(utf8.decode(response.bodyBytes))['tags'];

      // Convert the list of tags to a List<Tag>
      List<Tag> results = tagsJson
          .map((dynamic tagJson) => Tag(
                id: tagJson['id'],
                label: tagJson['label'],
                description: tagJson['description'],
              ))
          .toList();

      setState(() {
        _tagsSearchResults.clear();
        _tagsSearchResults.addAll(results);
      });
    } else {}
  }
}
