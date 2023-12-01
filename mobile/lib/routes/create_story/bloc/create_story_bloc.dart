// ignore_for_file: avoid_bool_literals_in_conditional_expressions, always_specify_types

import 'dart:async';
import 'dart:io';

import 'package:flutter_map/flutter_map.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/routes/create_story/create_story_repository.dart';
import 'package:memories_app/routes/create_story/model/create_story_model.dart';
import 'package:memories_app/routes/create_story/model/create_story_response_model.dart';

part 'create_story_event.dart';
part 'create_story_state.dart';

class _Constants {
  static const String offlineMessage =
      'You are currently offline.\n Please check your internet connection!';
}

class CreateStoryBloc extends Bloc<CreateStoryEvent, CreateStoryState> {
  final CreateStoryRepository _repository;

  CreateStoryBloc({required CreateStoryRepository repository})
      : _repository = repository,
        super(const CreateStoryState()) {
    on<CreateStoryCreateStoryEvent>(_createStoryEvent);
    on<CreateStoryErrorPopupClosedEvent>(_onErrorPopupClosed);
  }

  late CreateStoryModel storyModel;
  Future<void> _createStoryEvent(
      CreateStoryCreateStoryEvent event, Emitter<CreateStoryState> emit) async {
    storyModel = _createStoryModel(event);
    CreateStoryResponseModel? response;
    try {
      response = await _repository.createStory(storyModel);
    } on SocketException {
      emit(const CreateStoryOffline(offlineMessage: _Constants.offlineMessage));
    } catch (error) {
      emit(CreateStoryFailure(error: error.toString()));
    }
    if (response != null) {
      if (response.success == true) {
        emit(const CreateStorySuccess());
      } else {
        emit(CreateStoryFailure(error: response.msg.toString()));
      }
    }
  }

  CreateStoryModel _createStoryModel(CreateStoryCreateStoryEvent event) {
    final String dateType = mapDateTypeToValue(event.dateType.toLowerCase());
    CreateStoryModel createStoryModel = CreateStoryModel(
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
      includeTime: _includeTime(dateType, event) ? true : false,
      seasonName: dateType == "year" || dateType == "year_interval"
          ? event.seasonName
          : null,
      startDate: dateType == "interval_date" ? event.startDate : null,
      startYear: dateType == "year_interval" ? event.startYear : null,
      year: dateType == "year" ? event.year : null,
    );
    return createStoryModel;
  }

  bool _includeTime(String dateType, CreateStoryCreateStoryEvent event) {
    return dateType.contains("normal_date") &&
            (event.startDate != null &&
                event.startDate!.isNotEmpty &&
                event.startDate!.contains(" ")) ||
        (event.date != null &&
            event.date!.isNotEmpty &&
            event.date!.contains(" ")) ||
        (event.endDate != null &&
            event.endDate!.isNotEmpty &&
            event.endDate!.contains(" "));
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
      _createPointLocations(markersForPoint, pointAdresses, locationIds);
    }

    if (circleMarkers != null && circleMarkers.isNotEmpty) {
      _createCircleLocations(circleMarkers, circleAdresses, locationIds);
    }
    if (polygons != null && polygons.isNotEmpty) {
      _createPolygonLocations(polygons, locationIds);
    }

    if (polyLines != null && polyLines.isNotEmpty) {
      _createPolylineLocations(polyLines, polylineAdresses, locationIds);
    }

    return locationIds;
  }

  void _createPolylineLocations(List<Polyline> polyLines,
      List<String>? polylineAdresses, List<LocationId> locationIds) {
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

  void _createPolygonLocations(
      List<Polygon> polygons, List<LocationId> locationIds) {
    for (int i = 0; i < polygons.length; i++) {
      List<List<List<double>>> coordinates = [];

      if (polygons[i].points.isNotEmpty) {
        List<List<double>> singlePolygon = [];

        LatLng firstPoint = polygons[i].points.first;
        List<double> firstCoordinates = [
          firstPoint.longitude,
          firstPoint.latitude
        ];
        singlePolygon.add(firstCoordinates);

        for (LatLng point in polygons[i].points) {
          List<double> coordinatesList = [point.longitude, point.latitude];
          singlePolygon.add(coordinatesList);
        }

        // Add the first coordinate again to close the polygon
        singlePolygon.add(firstCoordinates);

        coordinates.add(singlePolygon);
      }

      LocationId polygon = LocationId(
        name: polygons[i].label ?? "Address not found",
        polygon: PolygonLocation(coordinates: coordinates),
      );

      locationIds.add(polygon);
    }
  }

  void _createCircleLocations(List<CircleMarker> circleMarkers,
      List<String>? circleAdresses, List<LocationId> locationIds) {
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
        radius:
            double.parse((circleMarkers[i].radius * 1000).toStringAsFixed(10)),
      );
      locationIds.add(circleLocation);
    }
  }

  void _createPointLocations(List<Marker> markersForPoint,
      List<String>? pointAdresses, List<LocationId> locationIds) {
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

  void _onErrorPopupClosed(
      CreateStoryErrorPopupClosedEvent event, Emitter<CreateStoryState> emit) {
    emit(const CreateStoryState());
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
