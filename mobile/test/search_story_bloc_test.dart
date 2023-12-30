import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/search/bloc/search_story_bloc.dart';
import 'package:memories_app/routes/search/model/search_story_repository.dart';
import 'package:memories_app/routes/search/model/search_story_request_model.dart';
import 'package:memories_app/routes/search/model/search_story_response_model.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:memories_app/routes/home/model/location_model.dart'
    // ignore: library_prefixes
    as locationModel;

class _Constants {
  static final SearchStoryResponseModel responseSuccess =
      SearchStoryResponseModel(
    stories: <StoryModel>[
      StoryModel(
        startYear: null,
        endYear: null,
        date: "01-01-2022",
        creationDate: DateTime.now(),
        startDate: null,
        endDate: null,
        decade: null,
        includeTime: false,
        id: 123456,
        author: 123456,
        authorUsername: 'test',
        seasonName: null,
        title: 'test',
        content: '<p>test</p>',
        storyTags: <TagModel>[
          TagModel(
              name: 'test',
              label: 'test',
              wikidataId: '123456',
              description: 'test')
        ],
        dateType: 'Normal Date',
        locations: <LocationModel>[
          LocationModel(
              name: 'test',
              point: locationModel.PointLocation(
                  type: "point", coordinates: <double>[1.0, 1.0]))
        ],
        likes: null,
        year: null,
      )
    ],
  );

  static final SearchStoryResponseModel responseFailure =
      SearchStoryResponseModel(
    stories: <StoryModel>[],
  );

  static const SearchStoryEventSearchPressed successEvent =
      SearchStoryEventSearchPressed(
    title: 'test',
    author: 'test',
    timeType: "Date",
    date: "01-01-2022",
    marker: CircleMarker(
        point: LatLng(1.0, 1.0),
        color: Colors.red,
        radius: 10,
        borderColor: Colors.black,
        borderStrokeWidth: 2),
  );

  static const SearchStoryEventSearchPressed failEvent =
      SearchStoryEventSearchPressed(
          title: null,
          author: null,
          timeType: 'Year',
          date: null,
          marker: null);
}

class MockSearchStoryRepository extends SearchStoryRepository {
  @override
  Future<SearchStoryResponseModel> searchStory(
      SearchStoryRequestModel request) async {
    if (request.location?.coordinates == null &&
        request.author == null &&
        request.title == null) {
      return _Constants.responseFailure;
    } else {
      return _Constants.responseSuccess;
    }
  }
}

void main() {
  SharedPreferences.setMockInitialValues(<String, Object>{});
  late SearchStoryBloc searchStoryBloc;
  late SearchStoryRepository searchStoryInterface;

  setUp(() {
    searchStoryInterface = MockSearchStoryRepository();
    searchStoryBloc = SearchStoryBloc(repository: searchStoryInterface);
  });

  blocTest<SearchStoryBloc, SearchStoryState>(
    'emits [SearchStorySuccess] when SearchStoryEventSearchPressed is added.',
    build: () => searchStoryBloc,
    act: (SearchStoryBloc bloc) {
      return bloc.add(_Constants.successEvent);
    },
    expect: () => <TypeMatcher<SearchStorySuccess>>[isA<SearchStorySuccess>()],
  );

  blocTest<SearchStoryBloc, SearchStoryState>(
    'emits [SearchStoryFailure] when SearchStoryEventSearchPressed is added.',
    build: () => searchStoryBloc,
    act: (SearchStoryBloc bloc) => bloc.add(_Constants.failEvent),
    expect: () => <TypeMatcher<SearchStoryFailure>>[isA<SearchStoryFailure>()],
  );

  blocTest<SearchStoryBloc, SearchStoryState>(
      'emits [SearchStoryState] when SearchStoryErrorPopupClosedEvent is added.',
      build: () => searchStoryBloc,
      act: (SearchStoryBloc bloc) =>
          bloc.add(SearchStoryErrorPopupClosedEvent()),
      expect: () => <TypeMatcher<SearchStoryState>>[isA<SearchStoryState>()],
      verify: (SearchStoryBloc bloc) {
        expect(bloc.state, isA<SearchStoryState>());
      });

  test('createSearchModel returns correct SearchStoryRequestModel', () {
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      title: 'test',
      author: 'test',
      tag: 'test',
      tagLabel: 'test',
      timeType: 'Year',
      radius: 10,
      dateDiff: 7,
      marker: CircleMarker(
          point: LatLng(1.0, 1.0),
          color: Colors.red,
          radius: 10,
          borderColor: Colors.black,
          borderStrokeWidth: 2),
    );

    // Act
    final SearchStoryRequestModel result =
        searchStoryBloc.createSearchModel(event);

    // Assert
    expect(result.title, event.title);
    expect(result.author, event.author);
    expect(result.tag, event.tag);
    expect(result.tagLabel, event.tagLabel);
    expect(result.timeType, 'year');
    expect(result.location?.coordinates, <double>[1.0, 1.0]);
    expect(result.radiusDiff, 10);
    expect(result.dateDiff, 7);
  });

  test('setTimeModel returns NormalYear when timeType is "Year"', () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      timeType: "Year",
      year: "2022",
      seasonName: "Spring",
    );

    // Act
    final TimeValue? result = searchStoryBloc.setTimeModel(event);

    // Assert
    expect(result, isA<NormalYear>());
  });

  test('setTimeModel returns IntervalYear when timeType is "Interval Year"',
      () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      timeType: "Interval Year",
      startYear: "2020",
      endYear: "2022",
      seasonName: "Summer",
    );

    // Act
    final TimeValue? result = searchStoryBloc.setTimeModel(event);

    // Assert
    expect(result, isA<IntervalYear>());
  });

  test('setTimeModel returns NormalDate when timeType is "Date"', () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      timeType: "Date",
      date: "01-01-2022",
    );

    // Act
    final TimeValue? result = searchStoryBloc.setTimeModel(event);

    // Assert
    expect(result, isA<NormalDate>());
  });

  test('setTimeModel returns IntervalDate when timeType is "Interval Date"',
      () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      timeType: "Interval Date",
      startDate: "01-01-2022",
      endDate: "31-12-2022",
    );

    // Act
    final TimeValue? result = searchStoryBloc.setTimeModel(event);

    // Assert
    expect(result, isA<IntervalDate>());
  });

  test('setTimeModel returns Decade when timeType is "Decade"', () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      timeType: "Decade",
      decade: "1990s",
    );

    // Act
    final TimeValue? result = searchStoryBloc.setTimeModel(event);

    // Assert
    expect(result, isA<Decade>());
  });

  test('setTimeModel returns null when timeType is unknown', () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      timeType: "Unknown",
    );

    // Act
    final TimeValue? result = searchStoryBloc.setTimeModel(event);

    // Assert
    expect(result, isNull);
  });

  test(
      'setLocationModel returns Location with coordinates when marker is not null',
      () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed(
      marker: CircleMarker(
        point: LatLng(1.0, 2.0),
        color: Colors.red,
        radius: 10,
        borderColor: Colors.black,
        borderStrokeWidth: 2,
      ),
    );

    // Act
    final Location? result = searchStoryBloc.setLocationModel(event);

    // Assert
    expect(result, isNotNull);
    expect(result!.coordinates, <double>[2.0, 1.0]);
    expect(result.type, 'Point');
  });

  test('setLocationModel returns null when marker is null', () {
    // Arrange
    const SearchStoryEventSearchPressed event = SearchStoryEventSearchPressed();

    // Act
    final Location? result = searchStoryBloc.setLocationModel(event);

    // Assert
    expect(result, isNull);
  });

  test('extractDecade returns null when decade is null', () {
    // Arrange
    const String? decade = null;

    // Act
    final int? result = searchStoryBloc.extractDecade(decade);

    // Assert
    expect(result, isNull);
  });

  test('extractDecade returns null when decade is empty', () {
    // Arrange
    const String decade = '';

    // Act
    final int? result = searchStoryBloc.extractDecade(decade);

    // Assert
    expect(result, isNull);
  });

  test('extractDecade returns parsed integer when decade is valid', () {
    // Arrange
    const String decade = '1990s';

    // Act
    final int? result = searchStoryBloc.extractDecade(decade);

    // Assert
    expect(result, equals(1990));
  });

  test('extractDecade returns null when decade is invalid', () {
    // Arrange
    const String decade = 'invalid';

    // Act
    final int? result = searchStoryBloc.extractDecade(decade);

    // Assert
    expect(result, isNull);
  });

  test('mapDateTypeToValue returns correct value for selectedDateType', () {
    // Arrange
    const String selectedDateType = 'Normal Date';

    // Act
    final String result = searchStoryBloc.mapDateTypeToValue(selectedDateType);

    // Assert
    expect(result, equals('normal_date'));
  });

  test('mapDateTypeToValue returns null for unknown selectedDateType', () {
    // Arrange
    const String selectedDateType = '';

    // Act
    final String result = searchStoryBloc.mapDateTypeToValue(selectedDateType);

    // Assert
    expect(result, "year");
  });
}
