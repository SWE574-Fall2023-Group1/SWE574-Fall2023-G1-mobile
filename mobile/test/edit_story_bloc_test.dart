import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/routes/edit_story/bloc/edit_story_bloc.dart';
import 'package:memories_app/routes/edit_story/model/edit_story_repository.dart';
import 'package:memories_app/routes/edit_story/model/edit_story_response_model.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/routes/create_story/model/story_request_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final EditStoryResponseModel responseSuccess = EditStoryResponseModel(
    success: true,
    msg: 'Story ok',
  );

  static final EditStoryResponseModel responseFailure = EditStoryResponseModel(
      success: false, msg: 'One of the required fields is empty');

  static final EditStoryUpdateStoryEvent updateStorySuccessEvent =
      EditStoryUpdateStoryEvent(
          id: 123456,
          title: 'test',
          content: '<p>test</p>',
          storyTags: <TagModel>[
            TagModel(
                name: 'test',
                label: 'test',
                wikidataId: '123456',
                description: 'test')
          ],
          dateType: 'year',
          markersForPoint: const <Marker>[
            Marker(
              point: LatLng(26, 28),
              child: SizedBox.shrink(),
            )
          ]);

  static final EditStoryUpdateStoryEvent updateStoryFailureEvent =
      EditStoryUpdateStoryEvent(
    id: 123456,
    title: '',
    content: '',
    storyTags: <TagModel>[
      TagModel(
          name: 'test',
          label: 'test',
          wikidataId: '123456',
          description: 'test')
    ],
    dateType: '',
  );

  static final List<Polyline> polyLines = <Polyline>[
    Polyline(
      points: <LatLng>[const LatLng(1.0, 1.0), const LatLng(2.0, 2.0)],
    ),
  ];

  static final List<Polygon> polygons = <Polygon>[
    Polygon(
      points: <LatLng>[
        const LatLng(1.0, 1.0),
        const LatLng(2.0, 2.0),
        const LatLng(3.0, 3.0)
      ],
      label: "Polygon 1",
    ),
  ];

  static final List<CircleMarker> circleMarkers = <CircleMarker>[
    const CircleMarker(
      point: LatLng(1.0, 1.0),
      radius: 10.0,
    ),
  ];

  static final List<Marker> markersForPoint = <Marker>[
    const Marker(
      point: LatLng(1.0, 5.0),
      child: SizedBox.shrink(),
    ),
  ];

  static final List<String> pointAdresses = <String>["Point 1", "Point 2"];

  static final List<String> circleAdresses = <String>["Circle 1"];

  static final List<String> polylineAddreses = <String>[
    "Point 1 - Point 2 - Point 3"
  ];
}

class MockEditStoryRepository extends EditStoryRepository {
  @override
  Future<EditStoryResponseModel> editStory(
      StoryRequestModel model, int storyId) async {
    if (model.title.isNotEmpty &&
        model.content.isNotEmpty &&
        model.storyTags != null &&
        model.storyTags!.isNotEmpty &&
        model.dateType.isNotEmpty &&
        model.locationIds.isNotEmpty) {
      return _Constants.responseSuccess;
    } else {
      return _Constants.responseFailure;
    }
  }
}

void main() {
  SharedPreferences.setMockInitialValues({});
  late EditStoryBloc editStoryBloc;
  late EditStoryRepository editStoryInterface;

  setUp(() {
    editStoryInterface = MockEditStoryRepository();
    editStoryBloc = EditStoryBloc(repository: editStoryInterface);
  });

  blocTest<EditStoryBloc, EditStoryState>(
      'emits [EditStorySuccess] when EditStoryUpdateStoryEvent is added.',
      build: () => editStoryBloc,
      act: (EditStoryBloc bloc) => bloc.add(_Constants.updateStorySuccessEvent),
      expect: () => <TypeMatcher<EditStorySuccess>>[isA<EditStorySuccess>()]);

  blocTest<EditStoryBloc, EditStoryState>(
      'emits [EditStoryFailure] when EditStoryUpdateStoryEvent is added.',
      build: () => editStoryBloc,
      act: (EditStoryBloc bloc) => bloc.add(_Constants.updateStoryFailureEvent),
      expect: () => <TypeMatcher<EditStoryFailure>>[isA<EditStoryFailure>()]);

  blocTest<EditStoryBloc, EditStoryState>(
      'emits [EditStoryState] when '
      'EditStoryErrorPopupClosedEvent is added.',
      build: () => editStoryBloc,
      act: (EditStoryBloc bloc) => bloc.add(EditStoryErrorPopupClosedEvent()),
      expect: () => <TypeMatcher<EditStoryState>>[isA<EditStoryState>()]);

  test('mapDateTypeToValue returns correct value', () {
    expect(editStoryBloc.mapDateTypeToValue("year"), equals("year"));
    expect(editStoryBloc.mapDateTypeToValue("interval year"),
        equals("year_interval"));
    expect(
        editStoryBloc.mapDateTypeToValue("normal date"), equals("normal_date"));
    expect(editStoryBloc.mapDateTypeToValue("interval date"),
        equals("interval_date"));
    expect(editStoryBloc.mapDateTypeToValue("decade"), equals("decade"));
    expect(editStoryBloc.mapDateTypeToValue("random"),
        equals("year")); // default case
  });

  test('_createPolylineLocations adds correct LocationId to locationIds', () {
    List<String>? polylineAddresses = <String>["Address 1"];
    List<LocationId> locationIds = <LocationId>[];

    editStoryBloc.createPolylineLocations(
        _Constants.polyLines, polylineAddresses, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Address 1"));
    expect(locationIds[0].line?.coordinates.length, equals(2));
  });

  test('createPolygonLocations adds correct LocationId to locationIds', () {
    List<LocationId> locationIds = <LocationId>[];

    editStoryBloc.createPolygonLocations(_Constants.polygons, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Polygon 1"));
    expect(locationIds[0].polygon?.coordinates.length, equals(1));
    expect(locationIds[0].polygon?.coordinates[0].length,
        equals(4)); // 3 points + 1 to close the polygon
  });

  test('createCircleLocations adds correct LocationId to locationIds', () {
    List<String>? circleAddresses = <String>["Address 1"];
    List<LocationId> locationIds = <LocationId>[];

    editStoryBloc.createCircleLocations(
        _Constants.circleMarkers, circleAddresses, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Address 1"));
    expect(locationIds[0].circle?.coordinates[0], equals(1.0));
    expect(locationIds[0].circle?.coordinates[1], equals(1.0));
    expect(locationIds[0].radius, equals(10.0));
  });

  test('createPointLocations adds correct LocationId to locationIds', () {
    List<LocationId> locationIds = <LocationId>[];

    editStoryBloc.createPointLocations(
        _Constants.markersForPoint, _Constants.pointAdresses, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Point 1"));
    expect(locationIds[0].point?.coordinates.first, equals(5.0));
    expect(locationIds[0].point?.coordinates.last, equals(1.0));
  });

  test('createLocationId returns correct LocationId list', () {
    List<LocationId> locationIds = editStoryBloc.createLocationId(
        _Constants.markersForPoint,
        _Constants.circleMarkers,
        _Constants.polygons,
        _Constants.polyLines,
        _Constants.pointAdresses,
        _Constants.circleAdresses,
        _Constants.polylineAddreses);
    expect(locationIds, isA<List<LocationId>>());
    expect(locationIds.length, equals(4));
  });

  group('Decade Extraction Tests', () {
    test('extractDecade returns null when decade is null', () {
      String? decade;
      int? result = editStoryBloc.extractDecade(decade);
      expect(result, isNull);
    });

    test('extractDecade returns null when decade is empty', () {
      String? decade = '';
      int? result = editStoryBloc.extractDecade(decade);
      expect(result, isNull);
    });

    test('extractDecade returns null when decade ends with "s"', () {
      String? decade = '1980s';
      int? result = editStoryBloc.extractDecade(decade);
      expect(result, 1980);
    });
  });
}
