import '../../../network/network_manager.dart';
import '../../../util/api_endpoints.dart';
import 'register_request_model.dart';
import 'register_response_model.dart';

abstract class RegisterRepository {
  Future<RegisterResponseModel> register(RegisterRequestModel model);
}

class RegisterRepositoryImp extends RegisterRepository {
  final NetworkManager _networkManager;

  RegisterRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<RegisterResponseModel> register(RegisterRequestModel model) async {
    final Result result =
        await _networkManager.post(ApiEndpoints.register, model);
    return RegisterResponseModel.fromJson(result.json);
  }
}
