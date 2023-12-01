// ignore_for_file: avoid_bool_literals_in_conditional_expressions, always_specify_types

import 'package:flutter_map/flutter_map.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/routes/create_story/create_story_repository.dart';
import 'package:memories_app/routes/create_story/model/create_story_model.dart';
import 'package:memories_app/routes/create_story/model/create_story_response_model.dart';

part 'create_story_event.dart';
part 'create_story_state.dart';

class CreateStoryBloc extends Bloc<CreateStoryEvent, CreateStoryState> {
  final CreateStoryRepository _repository;

  CreateStoryBloc({required CreateStoryRepository repository})
      : _repository = repository,
        super(const CreateStoryState()) {
    on<CreateStoryCreateStoryEvent>(_createStoryEvent);
  }

  late CreateStoryModel storyModel;
  Future<void> _createStoryEvent(
      CreateStoryCreateStoryEvent event, Emitter<CreateStoryState> emit) async {
    storyModel = _createStoryModel(event);
    CreateStoryResponseModel? response;
    try {
      response = await _repository.createStory(storyModel);
    } catch (error) {
      print(error);
    }
    if (response != null) {
      if (response.success == true) {
        print(response);
      }
    }
  }

  CreateStoryModel _createStoryModel(CreateStoryCreateStoryEvent event) {
    final String dateType = mapDateTypeToValue(event.dateType.toLowerCase());
    return CreateStoryModel(
      title: event.title,
      content: event.content,
      storyTags: event.storyTags,
      locationIds: _createLocationId(
          event.markersForPoint,
          event.circleMarkers,
          event.polygons,
          event.polyLines,
          event.pointAdresses,
          event.circleAdresses,
          event.polylineAdresses),
      dateType: dateType,
      date: dateType == "normal_date" ? event.date : null,
      decade: dateType == "decade" ? event.decade : null,
      endDate: dateType == "interval_date" ? event.endDate : null,
      endYear: dateType == "year_interval" ? event.endYear : null,
      includeTime: dateType.contains("normal_date") &&
                  (event.startDate != null &&
                      event.startDate!.isNotEmpty &&
                      event.startDate!.contains(" ")) ||
              (event.date != null &&
                  event.date!.isNotEmpty &&
                  event.date!.contains(" ")) ||
              (event.endDate != null &&
                  event.endDate!.isNotEmpty &&
                  event.endDate!.contains(" "))
          ? true
          : false,
      seasonName: dateType == "year" || dateType == "year_interval"
          ? event.seasonName
          : null,
      startDate: dateType == "interval_date" ? event.startDate : null,
      startYear: dateType == "year_interval" ? event.startYear : null,
      year: dateType == "year" ? event.year : null,
    );
  }

  List<LocationId> _createLocationId(
      List<Marker>? markersForPoint,
      List<CircleMarker>? circleMarkers,
      List<Polygon>? polygons,
      List<Polyline>? polyLines,
      List<String>? pointAdresses,
      List<String>? circleAdresses,
      List<String>? polylineAdresses) {
    List<LocationId> locationIds = [];
    if (markersForPoint != null && markersForPoint.isNotEmpty) {
      for (int i = 0; i < markersForPoint.length; i++) {
        LocationId pointLocation = LocationId(
          name: pointAdresses != null && pointAdresses.isNotEmpty
              ? pointAdresses[i]
              : "Adress not found",
          point: PointLocation(
            coordinates: [
              markersForPoint[i].point.longitude,
              markersForPoint[i].point.latitude
            ],
          ),
        );
        locationIds.add(pointLocation);
      }
    }

    if (circleMarkers != null && circleMarkers.isNotEmpty) {
      for (int i = 0; i < circleMarkers.length; i++) {
        LocationId circleLocation = LocationId(
          name: circleAdresses != null && circleAdresses.isNotEmpty
              ? circleAdresses[i]
              : "Adress not found",
          circle: PointLocation(
            coordinates: [
              circleMarkers[i].point.longitude,
              circleMarkers[i].point.latitude
            ],
          ),
          radius: double.parse(
              (circleMarkers[i].radius * 1000).toStringAsFixed(10)),
        );
        locationIds.add(circleLocation);
      }
    }
    if (polygons != null && polygons.isNotEmpty) {
      for (int i = 0; i < polygons.length; i++) {
        List<List<List<double>>> coordinates = [];

        if (polygons[i].points.isNotEmpty) {
          List<List<double>> singlePolygon = [];

          for (LatLng point in polygons[i].points) {
            List<double> coordinatesList = [point.longitude, point.latitude];
            singlePolygon.add(coordinatesList);
          }

          coordinates.add(singlePolygon);
        }

        LocationId polygon = LocationId(
          name: polygons[i].label ?? "Address not found",
          polygon: PolygonLocation(coordinates: coordinates),
        );

        locationIds.add(polygon);
      }
    }
    if (polyLines != null && polyLines.isNotEmpty) {
      for (int i = 0; i < polyLines.length; i++) {
        List<List<double>> coordinates = [];

        if (polyLines[i].points.isNotEmpty) {
          for (LatLng point in polyLines[i].points) {
            List<double> coordinatesList = [point.longitude, point.latitude];
            coordinates.add(coordinatesList);
          }
        }

        LocationId locationId = LocationId(
          name: polylineAdresses != null && polylineAdresses.isNotEmpty
              ? polylineAdresses[i]
              : "Address not found",
          line: LineStringLocation(coordinates: coordinates),
        );

        locationIds.add(locationId);
      }
    }

    return locationIds;
  }
}

enum StoryDateType {
  year,
  yearInterval,
  normalDate,
  intervalDate,
  decade,
}

String mapDateTypeToValue(String selectedDateType) {
  switch (selectedDateType.toLowerCase()) {
    case "year":
      return "year";
    case "interval year":
      return "year_interval";
    case "normal date":
      return "normal_date";
    case "interval date":
      return "interval_date";
    case "decade":
      return "decade";
    default:
      return "year";
  }
}
