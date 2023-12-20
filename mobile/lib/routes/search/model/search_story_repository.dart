import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/search/model/search_story_request_model.dart';
import 'package:memories_app/routes/search/model/search_story_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class SearchStoryRepository {
  Future<SearchStoryResponseModel> searchStory(SearchStoryRequestModel model);
}

class SearchStoryRepositoryImp extends SearchStoryRepository {
  final NetworkManager _networkManager;
  SearchStoryRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<SearchStoryResponseModel> searchStory(
      SearchStoryRequestModel model) async {
    final Result result =
        await _networkManager.post(ApiEndpoints.searchStory, body: model);
    return SearchStoryResponseModel.fromJson(result.json);
  }
}
