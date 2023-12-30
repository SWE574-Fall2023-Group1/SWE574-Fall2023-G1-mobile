import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/home/model/home_repository.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/util/api_endpoints.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

void main() {
  late HomeRepositoryImp homeRepository;
  late MockNetworkManager mockNetworkManager;

  setUpAll(() {
    mockNetworkManager = MockNetworkManager();
    homeRepository = HomeRepositoryImp(networkManager: mockNetworkManager);

    registerFallbackValue(Uri());
  });

  group('HomeRepository Tests', () {
    test(
        'getUserStories calls correct endpoint and returns StoriesResponseModel',
        () async {
      const int testPage = 1;
      const int testSize = 10;
      final StoriesResponseModel mockResponseModel = StoriesResponseModel(
        stories: <StoryModel>[],
        hasNext: null,
        hasPrev: null,
        nextPage: null,
        prevPage: null,
        totalPages: null,
      );

      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      when(() => mockNetworkManager
              .get(ApiEndpoints.buildUserStoriesUrl(testPage, testSize)))
          .thenAnswer((_) async => Result(mockJson, 200));

      final StoriesResponseModel responseModel =
          await homeRepository.getUserStories(page: testPage, size: testSize);

      verify(() => mockNetworkManager
          .get(ApiEndpoints.buildUserStoriesUrl(testPage, testSize))).called(1);

      expect(responseModel.toJson(), equals(mockJson));
    });

    test(
        'getAllStoriesWithOwnUrl calls correct endpoint and returns StoriesResponseModel',
        () async {
      const int testPage = 1;
      const int testSize = 10;
      final StoriesResponseModel mockResponseModel = StoriesResponseModel(
        stories: <StoryModel>[],
        hasNext: null,
        hasPrev: null,
        nextPage: null,
        prevPage: null,
        totalPages: null,
      );

      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      when(() => mockNetworkManager
              .get(ApiEndpoints.buildAllStoriesWithOwnUrl(testPage, testSize)))
          .thenAnswer((_) async => Result(mockJson, 200));

      final StoriesResponseModel responseModel = await homeRepository
          .getAllStoriesWithOwnUrl(page: testPage, size: testSize);

      verify(() => mockNetworkManager
              .get(ApiEndpoints.buildAllStoriesWithOwnUrl(testPage, testSize)))
          .called(1);

      expect(responseModel.toJson(), equals(mockJson));
    });
  });
}
