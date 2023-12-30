import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';
import 'package:memories_app/util/api_endpoints.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

void main() {
  late ProfileRepositoryImp profileRepository;
  late MockNetworkManager mockNetworkManager;

  setUpAll(() {
    mockNetworkManager = MockNetworkManager();
    profileRepository =
        ProfileRepositoryImp(networkManager: mockNetworkManager);

    // Register fallback values for any types used in the mocked methods
    registerFallbackValue(Uri());
  });

  group('ProfileRepository Tests', () {
    test(
        'getUserDetails calls correct endpoint and returns UserDetailsResponseModel',
        () async {
      int testUserId = 21;
      UserDetailsResponseModel mockResponseModel = UserDetailsResponseModel(
        id: testUserId,
        username: "asya00",
        email: "asya@gmail.com",
        followers: <dynamic>[],
      );

      // Convert UserDetailsResponseModel to a Map<String, dynamic>
      Map<String, dynamic> mockJson = mockResponseModel.toJson();

      // Setup mock response for NetworkManager
      when(() => mockNetworkManager.get(any()))
          .thenAnswer((_) async => Result(mockJson, 200));

      // Call getUserDetails
      UserDetailsResponseModel responseModel =
          await profileRepository.getUserDetails(testUserId);

      // Verify that the NetworkManager's get method was called with the correct URL
      verify(() => mockNetworkManager
          .get(ApiEndpoints.getUserDetails(userId: testUserId))).called(1);

      // Check if the returned object is an instance of UserDetailsResponseModel
      expect(responseModel, equals(mockResponseModel));
    });

    test(
        'getOwnStories calls correct endpoint and returns StoriesResponseModel',
        () async {
      int testUserId = 21;
      StoriesResponseModel mockResponseModel = StoriesResponseModel(
        stories: <StoryModel>[],
        hasNext: null,
        hasPrev: null,
        nextPage: null,
        prevPage: null,
        totalPages: null,
      );

      // Convert StoriesResponseModel to a Map<String, dynamic>
      Map<String, dynamic> mockJson = mockResponseModel.toJson();

      // Setup mock response for NetworkManager
      when(() => mockNetworkManager.get(any()))
          .thenAnswer((_) async => Result(mockJson, 200));

      // Call getOwnStories
      StoriesResponseModel responseModel =
          await profileRepository.getOwnStories(testUserId);

      // Verify that the NetworkManager's get method was called with the correct URL
      verify(() => mockNetworkManager
          .get(ApiEndpoints.getStoriesByAuthorId(testUserId))).called(1);

      // Check if the returned object is an instance of UserDetailsResponseModel
      expect(mockResponseModel.runtimeType, equals(responseModel.runtimeType));
    });
  });
}
