// ignore_for_file: use_build_context_synchronously, always_specify_types

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/create_story/bloc/create_story_bloc.dart';
import 'package:memories_app/routes/create_story/location_list_tile.dart';
import 'package:memories_app/routes/create_story/model/place_autocomplete_response.dart';
import 'package:memories_app/routes/create_story/model/place_details_response.dart';
import 'package:memories_app/routes/create_story/model/tag.dart';
import 'package:memories_app/routes/create_story/zoom_buttons.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/ui/shows_dialog.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/utils.dart';
import 'package:intl/intl.dart';
import 'package:quill_html_editor/quill_html_editor.dart';
import 'package:http/http.dart' as http;

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
  final List<CircleMarker> _circleMarkers = <CircleMarker>[];
  late ValueNotifier<double> _radiusNotifier;

  final double _currentRadius = 50;

  List<Polyline> _polylinesForPolygon = <Polyline>[];
  List<Polyline> _currentPolylinesForPolylineSelection = <Polyline>[];
  List<LatLng> _currentPolygonPoints = <LatLng>[];
  List<LatLng> _currentPolylinePoints = <LatLng>[];
  String _selectedMode = 'Point';

  List<Prediction> _placePredictions = <Prediction>[];
  final TextEditingController _controller = TextEditingController();
  final MapController _mapController = MapController();

  final QuillEditorController _editorController = QuillEditorController();

  final TextEditingController _titleController = TextEditingController();

  List<String> tags = <String>[];

  String selectedDateType = 'Year';
  String selectedSeason = '';
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _endYearController = TextEditingController();

  final TextEditingController _datePickerController = TextEditingController();
  final TextEditingController _endDatePickerController =
      TextEditingController();
  bool _includeTime = false;

  String _selectedDecade = '';
  String content = "";

  final TextEditingController _searchTagsController = TextEditingController();
  final List<Tag> _tagsSearchResults = [];

  late Tag _semanticTagSelected;

  final List<TagModel> _storyTags = [];

  final TextEditingController _tagsLabelController = TextEditingController();
  final List<String> _pointAdresses = [];
  final List<String> _polylineAdresses = [];
  final List<String> _circleAdresses = [];

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

  @override
  void dispose() {
    _controller.dispose();
    _mapController.dispose();
    _editorController.dispose();
    _yearController.dispose();
    _endYearController.dispose();
    _datePickerController.dispose();
    _endDatePickerController.dispose();
    _titleController.dispose();
    _searchTagsController.dispose();
    _tagsLabelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _buildPage(context);
  }

  Widget _buildPage(BuildContext context) {
    return BlocConsumer<CreateStoryBloc, CreateStoryState>(
      buildWhen: (CreateStoryState previousState, CreateStoryState state) {
        return !(state is CreateStoryFailure || state is CreateStoryOffline);
      },
      builder: (BuildContext context, CreateStoryState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Create Story"),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(
                    height: SpaceSizes.x16,
                  ),

                  _buildTitleField(),
                  const SizedBox(
                    height: SpaceSizes.x8,
                  ),

                  const Divider(),
                  _buildRichText(context),
                  const SizedBox(
                    height: SpaceSizes.x8,
                  ),
                  const Divider(),

                  _searchTags(),
                  const SizedBox(
                    height: SpaceSizes.x4,
                  ),
                  if (_tagsSearchResults.isNotEmpty) _buildSearchTagsResult(),
                  const Divider(),
                  _buildTagsLabelInput(),
                  _buildAddTagButton(),
                  const SizedBox(
                    height: 8,
                  ),
                  _buildTagsBoxes(),
                  const Divider(),
                  _buildDateTypeDropdown(),
                  const SizedBox(height: SpaceSizes.x16),
                  // Additional input fields based on date type
                  if (selectedDateType == 'Year' ||
                      selectedDateType == 'Interval Year')
                    _buildYearSelection(),
                  if (selectedDateType == 'Normal Date' ||
                      selectedDateType == 'Interval Date')
                    _buildDateSelection(),
                  if (selectedDateType == 'Decade') _buildDecadeDropdown(),
                  const Divider(),
                  _buildMapAndAdresses(context),
                  const Divider(),
                  Center(
                    child: OutlinedButton(
                        onPressed: () async {
                          var contentTemp = await _editorController.getText();
                          setState(() {
                            content = contentTemp;
                            debugPrint(content);
                          });
                          _onPressCreate(context);
                        },
                        child: const Text("Create Story")),
                  ),
                  const SizedBox(
                    height: SpaceSizes.x16,
                  )
                ],
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, CreateStoryState state) {
        if (state is CreateStorySuccess) {
          AppRoute.landing.navigate(context);
        } else if (state is CreateStoryFailure) {
          ShowsDialog.showAlertDialog(context, 'Oops!', state.error.toString(),
              isCreateStoryFail: true);
        } else if (state is CreateStoryOffline) {
          ShowsDialog.showAlertDialog(
              context, 'Oops!', state.offlineMessage.toString(),
              isCreateStoryFail: true);
        }
      },
    );
  }

  Wrap _buildTagsBoxes() {
    return Wrap(
      children: [
        for (int i = 0; i < _storyTags.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 8.0, bottom: 8.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.circular(12),
                color: AppColors.buttonColor,
              ),
              child: Row(
                mainAxisSize:
                    MainAxisSize.min, // Ensure the Row takes minimum space
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _storyTags[i].label,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _storyTags.remove(_storyTags[i]);
                        });
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  TextButton _buildAddTagButton() {
    return TextButton(
      child: const Text("Add Tag"),
      onPressed: () {
        setState(() {
          _storyTags.add(
            TagModel(
                name: _semanticTagSelected.label,
                label: _tagsLabelController.text,
                wikidataId: _semanticTagSelected.id,
                description: _semanticTagSelected.description),
          );
          _tagsLabelController.text = "";
          _searchTagsController.text = "";
        });
      },
    );
  }

  TextFormField _buildTagsLabelInput() {
    return TextFormField(
      controller: _tagsLabelController,
      decoration: const InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Enter the label you want to give the tag"),
    );
  }

  Container _buildSearchTagsResult() {
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
              children: [
                for (int i = 0; i < _tagsSearchResults.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              tags.add(_tagsSearchResults[i].label);
                              _semanticTagSelected = _tagsSearchResults[i];
                              _searchTagsController.text =
                                  _tagsSearchResults[i].label;
                              _tagsSearchResults.clear();
                            });
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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

  TextField _searchTags() {
    return TextField(
      controller: _searchTagsController,
      onChanged: (value) {
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

  void _onPressCreate(BuildContext context) {
    setState(() {
      _pointAdresses.removeWhere((element) => element.isEmpty);
      _polylineAdresses.removeWhere((element) => element.isEmpty);
      _circleAdresses.removeWhere((element) => element.isEmpty);
    });

    BlocProvider.of<CreateStoryBloc>(context).add(CreateStoryCreateStoryEvent(
      title: _titleController.text,
      content: content,
      storyTags: _storyTags,
      dateType: selectedDateType,
      circleMarkers: _circleMarkers,
      markersForPoint: _markersForPoint,
      polyLines: _completedPolylines,
      polygons: _polygons,
      pointAdresses: _pointAdresses,
      circleAdresses: _circleAdresses,
      polylineAdresses: _polylineAdresses,
      //
      date: _datePickerController.text.isEmpty
          ? null
          : _datePickerController.text,
      decade: _selectedDecade.isEmpty ? null : _selectedDecade,
      endDate: _endDatePickerController.text.isEmpty
          ? null
          : _endDatePickerController.text,
      endYear: _endYearController.text.isEmpty ? null : _endYearController.text,
      includeTime: _includeTime,
      seasonName: selectedSeason.isEmpty ? null : selectedSeason,
      startDate: _datePickerController.text.isEmpty
          ? null
          : _datePickerController.text,
      startYear: _yearController.text.isEmpty ? null : _yearController.text,
      year: _yearController.text.isEmpty ? null : _yearController.text,
    ));
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

  Widget _buildDateSelection() {
    if (selectedDateType == "Normal Date") {
      return Row(
        children: [
          Expanded(
            child: _buildDatePicker(),
          ),
          const SizedBox(width: SpaceSizes.x8),
          Row(
            children: [
              Checkbox(
                value: _includeTime,
                onChanged: (bool? value) {
                  setState(() {
                    _includeTime = value ?? false;
                  });
                },
              ),
              const Text("Include Time")
            ],
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Column(
            children: [
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
          const SizedBox(
            width: SpaceSizes.x8,
          ),
          Row(
            children: [
              Checkbox(
                value: _includeTime,
                onChanged: (bool? value) {
                  setState(() {
                    _includeTime = value ?? false;
                  });
                },
              ),
              const Text("Include Time")
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
          if (_includeTime) {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (pickedTime != null) {
              pickedDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            }
          }

          String formattedDate =
              DateFormat(_includeTime ? 'yyyy-MM-dd HH:mm' : 'yyyy-MM-dd')
                  .format(pickedDate);

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
          if (_includeTime) {
            TimeOfDay? pickedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );

            if (pickedTime != null) {
              pickedDate = DateTime(
                pickedDate.year,
                pickedDate.month,
                pickedDate.day,
                pickedTime.hour,
                pickedTime.minute,
              );
            }
          }

          String formattedDate =
              DateFormat(_includeTime ? 'yyyy-MM-dd HH:mm' : 'yyyy-MM-dd')
                  .format(pickedDate);

          setState(() {
            _endDatePickerController.text = formattedDate;
          });
        }
      },
    );
  }

  Widget _buildYearSelection() {
    return Row(
      children: [
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

  Widget _buildRichText(BuildContext context) {
    return Column(
      children: [
        ToolBar(
          padding: const EdgeInsets.all(8),
          iconSize: 25,
          activeIconColor: Colors.greenAccent.shade400,
          controller: _editorController,
          crossAxisAlignment: WrapCrossAlignment.start,
          direction: Axis.horizontal,
          customButtons: [
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                  color: Colors.green, borderRadius: BorderRadius.circular(15)),
            ),
            InkWell(
                onTap: () async {
                  var selectedText = await _editorController.getSelectedText();
                  debugPrint('selectedText $selectedText');
                  var selectedHtmlText =
                      await _editorController.getSelectedHtmlText();
                  debugPrint('selectedHtmlText $selectedHtmlText');
                },
                child: const Icon(
                  Icons.add_circle,
                  color: Colors.black,
                )),
          ],
        ),
        QuillHtmlEditor(
          hintText: 'Enter your content',
          controller: _editorController,
          isEnabled: true,
          ensureVisible: false,
          minHeight: 500,
          autoFocus: false,
          textStyle: const TextStyle(),
          hintTextAlign: TextAlign.start,
          padding: const EdgeInsets.only(left: 10, top: 10),
          hintTextPadding: const EdgeInsets.only(left: 20),
          inputAction: InputAction.newline,
          loadingBuilder: (context) {
            return const Center(
                child: CircularProgressIndicator(
              strokeWidth: 1,
              color: Colors.red,
            ));
          },
          onTextChanged: (text) {},
          onEditorCreated: () {},
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
        labelText: "Title",
      ),
    );
  }

  Widget _buildMapAndAdresses(BuildContext context) {
    return Column(
      children: <Widget>[
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
              color: Colors.white,
            ),
            label: const Text(
              "Use my Current Location",
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
                        builder: (BuildContext context, double value,
                            Widget? child) {
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
    _polylineAdresses.add("");
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
                          _polylineAdresses[index] =
                              snapshot.data?.join('-') ?? "Addresses not found";

                          return Text(snapshot.data?.join('-') ??
                              "Addresses not found");
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _polylineAdresses.removeAt(index);
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
    _circleAdresses.add("");
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
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
                          _circleAdresses[
                                  _circleMarkers.indexOf(circleMarker)] =
                              snapshot.data != null
                                  ? "Circle area around ${snapshot.data}"
                                  : "Address not found ";

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
                        _circleAdresses
                            .removeAt(_circleMarkers.indexOf(circleMarker));
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
    _pointAdresses.add("");
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
                          _pointAdresses[_markersForPoint.indexOf(marker)] =
                              snapshot.data ?? "Address not found";

                          return Text(snapshot.data ?? "Address not found");
                        }
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _pointAdresses
                            .removeAt(_markersForPoint.indexOf(marker));
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

  Widget _buildPointSelectionModeButtons() {
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
              ? OutlinedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  side: const BorderSide(color: AppColors.buttonColor),
                )
              : null,
          child: Text('Point',
              style: TextStyle(
                  color: _selectedMode == "Point"
                      ? Colors.white
                      : AppColors.buttonColor)),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedMode = 'Polygon';
            });
          },
          style: _selectedMode == 'Polygon'
              ? OutlinedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  side: const BorderSide(color: AppColors.buttonColor),
                )
              : null,
          child: Text('Polygon',
              style: TextStyle(
                  color: _selectedMode == "Polygon"
                      ? Colors.white
                      : AppColors.buttonColor)),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedMode = 'Polyline';
            });
          },
          style: _selectedMode == 'Polyline'
              ? OutlinedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  side: const BorderSide(color: AppColors.buttonColor),
                )
              : null,
          child: Text(
            'Polyline',
            style: TextStyle(
                color: _selectedMode == "Polyline"
                    ? Colors.white
                    : AppColors.buttonColor),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            setState(() {
              _selectedMode = 'Circle';
            });
          },
          style: _selectedMode == 'Circle'
              ? OutlinedButton.styleFrom(
                  backgroundColor: AppColors.buttonColor,
                  side: const BorderSide(color: AppColors.buttonColor),
                )
              : null,
          child: Text('Circle',
              style: TextStyle(
                  color: _selectedMode == "Circle"
                      ? Colors.white
                      : AppColors.buttonColor)),
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
          zoomInColorIcon: Colors.white,
          zoomOutColorIcon: Colors.white,
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

  // Method to get the current state of LocationMap

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
    final bool hasPermission = await _handleLocationPermission();

    if (!hasPermission) {
      return;
    }
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

  Future<void> _searchWikiData(String query) async {
    final response = await http.get(
      Uri.parse('${NetworkConstant.baseURL}/user/wikidataSearch?query=$query'),
    );

    if (response.statusCode == 200) {
      // Parse the response as a list of tags
      List<dynamic> tagsJson = json.decode(response.body)['tags'];

      // Convert the list of tags to a List<Tag>
      List<Tag> results = tagsJson
          .map((tagJson) => Tag(
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
