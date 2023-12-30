// Import the necessary packages
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/routes/create_story/bloc/create_story_bloc.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/routes/create_story/create_story_repository.dart';
import 'package:memories_app/routes/create_story/model/story_request_model.dart';
import 'package:memories_app/routes/create_story/model/create_story_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _Constants {
  static final CreateStoryResponseModel responseSuccess =
      CreateStoryResponseModel(
    success: true,
    msg: 'Story ok',
  );
  static final CreateStoryResponseModel responseFailure =
      CreateStoryResponseModel(
          success: false, msg: 'One of the required fields is empty');

  static final CreateStoryCreateStoryEvent createStorySuccessEvent =
      CreateStoryCreateStoryEvent(
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

  static final CreateStoryCreateStoryEvent createStoryFailureEvent =
      CreateStoryCreateStoryEvent(
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

// Create a mock repository
class MockCreateStoryRepository extends CreateStoryRepository {
  @override
  Future<CreateStoryResponseModel> createStory(StoryRequestModel model) async {
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
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late CreateStoryBloc createStoryBloc;
  late CreateStoryRepository createStoryInterface;

  setUp(() {
    createStoryInterface = MockCreateStoryRepository();
    createStoryBloc = CreateStoryBloc(repository: createStoryInterface);
  });

  blocTest<CreateStoryBloc, CreateStoryState>(
    'emits [CreateStorySuccess] when CreateStoryCreateStoryEvent is added.',
    build: () => createStoryBloc,
    act: (CreateStoryBloc bloc) {
      return bloc.add(_Constants.createStorySuccessEvent);
    },
    expect: () => <TypeMatcher<CreateStorySuccess>>[isA<CreateStorySuccess>()],
  );

  blocTest<CreateStoryBloc, CreateStoryState>(
    'emits [CreateStoryFailure] when CreateStoryCreateStoryEvent is added.',
    build: () => createStoryBloc,
    act: (CreateStoryBloc bloc) => bloc.add(_Constants.createStoryFailureEvent),
    expect: () => <TypeMatcher<CreateStoryFailure>>[isA<CreateStoryFailure>()],
  );

  blocTest<CreateStoryBloc, CreateStoryState>(
    'emits [CreateStoryState] when CreateStoryErrorPopupClosedEvent is added.',
    build: () => createStoryBloc,
    act: (CreateStoryBloc bloc) {
      return bloc.add(CreateStoryErrorPopupClosedEvent());
    },
    expect: () => <TypeMatcher<CreateStoryState>>[isA<CreateStoryState>()],
  );

  test('mapDateTypeToValue returns correct value', () {
    expect(createStoryBloc.mapDateTypeToValue("year"), equals("year"));
    expect(createStoryBloc.mapDateTypeToValue("interval year"),
        equals("year_interval"));
    expect(createStoryBloc.mapDateTypeToValue("normal date"),
        equals("normal_date"));
    expect(createStoryBloc.mapDateTypeToValue("interval date"),
        equals("interval_date"));
    expect(createStoryBloc.mapDateTypeToValue("decade"), equals("decade"));
    expect(createStoryBloc.mapDateTypeToValue("random"),
        equals("year")); // default case
  });

  test('_createPolylineLocations adds correct LocationId to locationIds', () {
    List<String>? polylineAddresses = <String>["Address 1"];
    List<LocationId> locationIds = <LocationId>[];

    createStoryBloc.createPolylineLocations(
        _Constants.polyLines, polylineAddresses, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Address 1"));
    expect(locationIds[0].line?.coordinates.length, equals(2));
  });

  test('createPolygonLocations adds correct LocationId to locationIds', () {
    List<LocationId> locationIds = <LocationId>[];

    createStoryBloc.createPolygonLocations(_Constants.polygons, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Polygon 1"));
    expect(locationIds[0].polygon?.coordinates.length, equals(1));
    expect(locationIds[0].polygon?.coordinates[0].length,
        equals(4)); // 3 points + 1 to close the polygon
  });

  test('createCircleLocations adds correct LocationId to locationIds', () {
    List<String>? circleAddresses = <String>["Address 1"];
    List<LocationId> locationIds = <LocationId>[];

    createStoryBloc.createCircleLocations(
        _Constants.circleMarkers, circleAddresses, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Address 1"));
    expect(locationIds[0].circle?.coordinates[0], equals(1.0));
    expect(locationIds[0].circle?.coordinates[1], equals(1.0));
    expect(locationIds[0].radius, equals(10.0));
  });

  test('createPointLocations adds correct LocationId to locationIds', () {
    List<LocationId> locationIds = <LocationId>[];

    createStoryBloc.createPointLocations(
        _Constants.markersForPoint, _Constants.pointAdresses, locationIds);

    expect(locationIds.length, equals(1));
    expect(locationIds[0].name, equals("Point 1"));
    expect(locationIds[0].point?.coordinates.first, equals(5.0));
    expect(locationIds[0].point?.coordinates.last, equals(1.0));
  });

  test('createLocationId returns correct LocationId list', () {
    List<LocationId> locationIds = createStoryBloc.createLocationId(
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
      int? result = createStoryBloc.extractDecade(decade);
      expect(result, isNull);
    });

    test('extractDecade returns null when decade is empty', () {
      String? decade = '';
      int? result = createStoryBloc.extractDecade(decade);
      expect(result, isNull);
    });

    test('extractDecade returns null when decade ends with "s"', () {
      String? decade = '1980s';
      int? result = createStoryBloc.extractDecade(decade);
      expect(result, 1980);
    });
  });
}
