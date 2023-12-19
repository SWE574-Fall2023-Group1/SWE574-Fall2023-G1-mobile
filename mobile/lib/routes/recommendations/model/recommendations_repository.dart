import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/recommendations/model/recommendations_response.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class RecommendationsRepository {
  Future<RecommendationsResponseModel> getRecommendations();
}

class RecommendationsRepositoryImp extends RecommendationsRepository {
  final NetworkManager _networkManager;

  RecommendationsRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<RecommendationsResponseModel> getRecommendations() async {
    final Result result =
        await _networkManager.get(ApiEndpoints.getRecommendations);
    return RecommendationsResponseModel.fromJson(result.json);
  }
}
