import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/request/update_biography_request_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class ProfileRepository {
  Future<UserDetailsResponseModel> getUserDetails();

  Future<StoriesResponseModel> getOwnStories(int id);

  Future<UpdateBiographyRequestModel> updateBiography(String biography);
}

class ProfileRepositoryImp extends ProfileRepository {
  final NetworkManager _networkManager;

  ProfileRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<UserDetailsResponseModel> getUserDetails() async {
    final Result result =
        await _networkManager.get(ApiEndpoints.getUserDetails);
    return UserDetailsResponseModel.fromJson(result.json);
  }

  @override
  Future<StoriesResponseModel> getOwnStories(int id) async {
    final Result result =
        await _networkManager.get(ApiEndpoints.getStoriesByAuthorId(id));
    return StoriesResponseModel.fromJson(result.json);
  }

  @override
  Future<UpdateBiographyRequestModel> updateBiography(String biography) async {
    final Result result = await _networkManager.put(
        ApiEndpoints.updateBiography,
        body: UpdateBiographyRequestModel(biography: biography));
    return UpdateBiographyRequestModel.fromJson(result.json);
  }
}
