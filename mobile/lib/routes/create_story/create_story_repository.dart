import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/create_story/model/story_request_model.dart';
import 'package:memories_app/routes/create_story/model/create_story_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class CreateStoryRepository {
  Future<CreateStoryResponseModel> createStory(StoryRequestModel model);
}

class CreateStoryRepositoryImp extends CreateStoryRepository {
  final NetworkManager _networkManager;

  CreateStoryRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<CreateStoryResponseModel> createStory(StoryRequestModel model) async {
    final Result result =
        await _networkManager.post(ApiEndpoints.createStory, body: model);
    return CreateStoryResponseModel.fromJson(result.json);
  }
}
