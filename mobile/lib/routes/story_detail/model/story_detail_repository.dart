import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/response/avatar_response_model.dart';
import 'package:memories_app/routes/home/model/response/comments_response_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class StoryDetailRepository {
  Future<StoryModel> getStoryById({required int id});

  Future<CommentResponseModel> getComments({required int id});

  Future<AvatarResponseModel> getAvatarUrlById({required int id});
}

class StoryDetailRepositoryImp extends StoryDetailRepository {
  final NetworkManager _networkManager;

  StoryDetailRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<StoryModel> getStoryById({required int id}) async {
    final Result result =
        await _networkManager.get(ApiEndpoints.buildStoryGetUrl(id));
    return StoryModel.fromJson(result.json);
  }

  @override
  Future<CommentResponseModel> getComments({required int id}) async {
    final Result result =
        await _networkManager.get(ApiEndpoints.getCommentsByStoryId(id));
    return CommentResponseModel.fromJson(result.json);
  }

  @override
  Future<AvatarResponseModel> getAvatarUrlById({required int id}) async {
    final Result result =
        await _networkManager.get(ApiEndpoints.getAvatarById(id));
    return AvatarResponseModel.fromJson(result.json);
  }
}
