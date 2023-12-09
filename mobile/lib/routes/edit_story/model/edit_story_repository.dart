import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/create_story/model/story_request_model.dart';
import 'package:memories_app/routes/edit_story/model/edit_story_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class EditStoryRepository {
  Future<EditStoryResponseModel> editStory(
      StoryRequestModel model, int storyId);
}

class EditStoryRepositoryImp extends EditStoryRepository {
  final NetworkManager _networkManager;

  EditStoryRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<EditStoryResponseModel> editStory(
      StoryRequestModel model, int storyId) async {
    final Result result = await _networkManager
        .post(ApiEndpoints.storyUpdate(storyId), body: model);
    return EditStoryResponseModel.fromJson(result.json);
  }
}
