import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class ProfileRepository {
  Future<UserDetailsResponseModel> getUserDetails();
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
}
