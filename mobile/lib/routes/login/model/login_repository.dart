import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/login/model/login_request_model.dart';
import 'package:memories_app/routes/login/model/login_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class LoginRepository {
  Future<LoginResponseModel> login(LoginRequestModel model);

  Future<UserDetailsResponseModel> getUserDetails();
}

class LoginRepositoryImp extends LoginRepository {
  final NetworkManager _networkManager;

  LoginRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<LoginResponseModel> login(LoginRequestModel model) async {
    final Result result =
        await _networkManager.post(ApiEndpoints.login, body: model);
    return LoginResponseModel.fromJson(result.json);
  }

  @override
  Future<UserDetailsResponseModel> getUserDetails() async {
    final Result result =
        await _networkManager.get(ApiEndpoints.getUserDetails());
    return UserDetailsResponseModel.fromJson(result.json);
  }
}
