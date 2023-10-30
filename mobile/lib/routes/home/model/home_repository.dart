import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/request/all_stories_request_model.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class HomeRepository {
  Future<StoriesResponseModel> getAllStories(AllStoriesRequestModel request);
}

class HomeRepositoryImp extends HomeRepository {
  final NetworkManager _networkManager;

  HomeRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<StoriesResponseModel> getAllStories(AllStoriesRequestModel request) async {
    final Result result =
        await _networkManager.get(ApiEndpoints.allStories);
    return StoriesResponseModel.fromJson(result.json);
  }
}
