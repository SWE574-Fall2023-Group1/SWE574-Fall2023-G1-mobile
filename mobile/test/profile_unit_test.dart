import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/app/model/response/base_response_model.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';
import 'package:memories_app/routes/profile/model/request/update_biography_request_model.dart';
import 'package:memories_app/routes/profile/model/response/add_profile_photo_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';
import 'package:mocktail/mocktail.dart';
import 'dart:io';
import 'package:dio/dio.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

class MockFile extends Mock implements File {}

void main() {
  late ProfileRepositoryImp profileRepository;
  late MockNetworkManager mockNetworkManager;
  late MockFile mockFile;
  const int testUserId = 21;

  setUpAll(() {
    mockNetworkManager = MockNetworkManager();
    profileRepository =
        ProfileRepositoryImp(networkManager: mockNetworkManager);
    mockFile = MockFile();

    // Register fallback values for any types used in the mocked methods
    registerFallbackValue(Uri());
    registerFallbackValue(UpdateBiographyRequestModel(biography: ''));
    registerFallbackValue(FormData.fromMap({}));
  });

  group('ProfileRepository Tests', () {
    test(
        'getUserDetails calls correct endpoint and returns UserDetailsResponseModel',
        () async {
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

    test(
        'updateBiography calls correct endpoint and returns UpdateBiographyRequestModel',
        () async {
      UpdateBiographyRequestModel mockResponseModel =
          UpdateBiographyRequestModel(
        biography: 'bio testing',
      );

      // Convert UpdateBiographyRequestModel to a Map<String, dynamic>
      Map<String, dynamic> mockJson = mockResponseModel.toJson();

      // Setup mock response for NetworkManager
      when(() => mockNetworkManager.put(ApiEndpoints.updateBiography,
              body: any(named: 'body')))
          .thenAnswer((_) async => Result(mockJson, 200));

      // Call updateBiography
      UpdateBiographyRequestModel responseModel =
          await profileRepository.updateBiography('bio testing');

      // Verify that the NetworkManager's put method was called with the correct URL and body
      verify(() => mockNetworkManager.put(ApiEndpoints.updateBiography,
          body: any(named: 'body'))).called(1);

      // Check if the returned object is the same as the mock response
      expect(mockResponseModel.biography, equals(responseModel.biography));
    });

    test(
        'addAvatar calls correct endpoint and returns AddProfilePhotoResponseModel',
        () async {
      final AddProfilePhotoResponseModel mockResponseModel =
          AddProfilePhotoResponseModel(
        profilePhoto: '',
        photoUrl: '',
        success: true,
        msg: 'ok',
      );

      // Convert AddProfilePhotoResponseModel to a Map<String, dynamic>
      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      // Setup mock response for NetworkManager
      when(() => mockNetworkManager.putFile(ApiEndpoints.avatar,
              formData: any(named: 'formData')))
          .thenAnswer((_) async => Result(mockJson, 200));

      // Mocking file path
      when(() => mockFile.path)
          .thenReturn('golden_test/goldens/login/login_route_initial.png');

      // Call addAvatar
      final AddProfilePhotoResponseModel responseModel =
          await profileRepository.addAvatar(mockFile);

      // Verify that the NetworkManager's putFile method was called with the correct endpoint and formData
      verify(() => mockNetworkManager.putFile(ApiEndpoints.avatar,
          formData: any(named: 'formData'))).called(1);

      // Check if the returned object is the same as the mock response
      expect(responseModel.toJson(), equals(mockJson));
    });

    test(
        'deleteAvatar calls correct endpoint and returns AddProfilePhotoResponseModel',
        () async {
      final AddProfilePhotoResponseModel mockResponseModel =
          AddProfilePhotoResponseModel(
        profilePhoto: '',
        photoUrl: '',
        success: true,
        msg: 'ok',
      );

      // Convert AddProfilePhotoResponseModel to a Map<String, dynamic>
      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      // Setup mock response for NetworkManager
      when(() => mockNetworkManager.delete(ApiEndpoints.avatar))
          .thenAnswer((_) async => Result(mockJson, 200));

      // Call deleteAvatar
      final AddProfilePhotoResponseModel responseModel =
          await profileRepository.deleteAvatar();

      // Verify that the NetworkManager's delete method was called with the correct URL
      verify(() => mockNetworkManager.delete(ApiEndpoints.avatar)).called(1);

      // Check if the returned object is the same as the mock response
      expect(responseModel.toJson(), equals(mockJson));
    });

    test('followUser calls correct endpoint and returns BaseResponseModel',
        () async {
      const int testUserId = 123; // Example user ID
      final BaseResponseModel mockResponseModel = BaseResponseModel(
        success: true,
        msg: 'ok',
      );

      // Convert BaseResponseModel to a Map<String, dynamic>
      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      // Setup mock response for NetworkManager
      when(() => mockNetworkManager.post(ApiEndpoints.followUser(testUserId)))
          .thenAnswer((_) async => Result(mockJson, 200));

      // Call followUser
      final BaseResponseModel responseModel =
          await profileRepository.followUser(testUserId);

      // Verify that the NetworkManager's post method was called with the correct URL
      verify(() => mockNetworkManager.post(ApiEndpoints.followUser(testUserId)))
          .called(1);

      // Check if the returned object is the same as the mock response
      expect(responseModel.toJson(), equals(mockJson));
    });
  });
}
