import 'package:flutter_test/flutter_test.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';
import 'package:memories_app/routes/story_detail/model/comment_model.dart';
import 'package:memories_app/routes/home/model/response/avatar_response_model.dart';
import 'package:memories_app/routes/home/model/response/comments_response_model.dart';
import 'package:memories_app/routes/home/model/response/like_response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/routes/story_detail/model/request/comment_request_model.dart';
import 'package:memories_app/routes/story_detail/model/tag_model.dart';
import 'package:memories_app/util/api_endpoints.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkManager extends Mock implements NetworkManager {}

void main() {
  late StoryDetailRepositoryImp storyDetailRepository;
  late MockNetworkManager mockNetworkManager;
  const int testUserId = 21;
  const int testStoryId = 105;

  setUpAll(() {
    mockNetworkManager = MockNetworkManager();
    storyDetailRepository =
        StoryDetailRepositoryImp(networkManager: mockNetworkManager);

    registerFallbackValue(Uri());
    registerFallbackValue(
        CommentRequestModel(commentAuthorId: 44, storyId: 105, text: ''));
  });

  group('StoryDetailRepository Tests', () {
    test('getStoryById calls correct endpoint and returns StoryModel',
        () async {
      final StoryModel mockStoryModel = StoryModel(
        id: 102,
        author: 42,
        authorUsername: "abc",
        title: "<p></p>",
        content: "<p></p>",
        storyTags: <TagModel>[],
        locations: <LocationModel>[],
        dateType: "year",
        seasonName: "Summer",
        year: 2015,
        startYear: null,
        endYear: null,
        date: "2023-12-23T19:46:55.656341Z",
        creationDate: DateTime.parse("2023-12-23T19:46:55.656341Z").toLocal(),
        startDate: null,
        endDate: null,
        decade: null,
        includeTime: false,
        likes: <int>[],
        dateText: null,
      );

      final Map<String, dynamic> mockJson = mockStoryModel.toJson();

      when(() => mockNetworkManager
              .get(ApiEndpoints.buildStoryGetUrl(testStoryId)))
          .thenAnswer((_) async => Result(mockJson, 200));

      final StoryModel result =
          await storyDetailRepository.getStoryById(id: testStoryId);

      verify(() => mockNetworkManager
          .get(ApiEndpoints.buildStoryGetUrl(testStoryId))).called(1);
      expect(result.toJson(), equals(mockJson));
    });

    test('getComments calls correct endpoint and returns CommentResponseModel',
        () async {
      final CommentResponseModel mockResponseModel = CommentResponseModel(
        comments: <CommentModel>[],
        hasNext: false,
        hasPrev: false,
        totalPages: 1,
      );

      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      when(() => mockNetworkManager
              .get(ApiEndpoints.getCommentsByStoryId(testStoryId)))
          .thenAnswer((_) async => Result(mockJson, 200));

      final CommentResponseModel result =
          await storyDetailRepository.getComments(id: testStoryId);

      verify(() => mockNetworkManager
          .get(ApiEndpoints.getCommentsByStoryId(testStoryId))).called(1);
      expect(result.toJson(), equals(mockJson));
    });

    test(
        'getAvatarUrlById calls correct endpoint and returns AvatarResponseModel',
        () async {
      final AvatarResponseModel mockResponseModel = AvatarResponseModel();

      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      when(() => mockNetworkManager.get(ApiEndpoints.getAvatarById(testUserId)))
          .thenAnswer((_) async => Result(mockJson, 200));

      final AvatarResponseModel result =
          await storyDetailRepository.getAvatarUrlById(id: testUserId);

      verify(() =>
              mockNetworkManager.get(ApiEndpoints.getAvatarById(testUserId)))
          .called(1);
      expect(result.toJson(), equals(mockJson));
    });

    test('likeStoryById calls correct endpoint and returns LikeResponseModel',
        () async {
      final LikeResponseModel mockResponseModel = LikeResponseModel();

      final Map<String, dynamic> mockJson = mockResponseModel.toJson();

      when(() => mockNetworkManager.post(ApiEndpoints.likeStory(testStoryId)))
          .thenAnswer((_) async => Result(mockJson, 200));

      final LikeResponseModel result =
          await storyDetailRepository.likeStoryById(id: testStoryId);

      verify(() => mockNetworkManager.post(ApiEndpoints.likeStory(testStoryId)))
          .called(1);
      expect(result.toJson(), equals(mockJson));
    });

    test('postComment calls correct endpoint and returns CommentModel',
        () async {
      final CommentRequestModel requestModel = CommentRequestModel(
        commentAuthorId: testUserId,
        storyId: testStoryId,
        text: '',
      );

      final CommentModel mockCommentModel = CommentModel(
        id: 0,
        commentAuthor: '',
        commentAuthorId: testUserId,
        story: testStoryId,
        text: '',
        date: DateTime.now(),
        success: true,
        msg: '',
      );

      final Map<String, dynamic> mockJson = mockCommentModel.toJson();

      when(() => mockNetworkManager.post(ApiEndpoints.postComment(testStoryId),
              body: any(named: 'body')))
          .thenAnswer((_) async => Result(mockJson, 200));

      final CommentModel result = await storyDetailRepository.postComment(
          id: testStoryId, requestModel: requestModel);

      verify(() => mockNetworkManager.post(
          ApiEndpoints.postComment(testStoryId),
          body: requestModel)).called(1);
      expect(result.toJson(), equals(mockJson));
    });
  });
}
