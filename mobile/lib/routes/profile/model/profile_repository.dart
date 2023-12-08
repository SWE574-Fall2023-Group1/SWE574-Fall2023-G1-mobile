import 'dart:typed_data';

import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/request/update_biography_request_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class ProfileRepository {
  Future<UserDetailsResponseModel> getUserDetails();

  Future<StoriesResponseModel> getOwnStories(int id);

  Future<UpdateBiographyRequestModel> updateBiography(String biography);

  Future<Object> addAvatar(Uint8List content);

  Future<Object> deleteAvatar();
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

  @override
  Future<Object> addAvatar(Uint8List content) async {
    final Result result =
        await _networkManager.put(ApiEndpoints.avatar, body: content);
    return Future<Object>.value(Object);
  }

  @override
  Future<Object> deleteAvatar() async {
    final Result result = await _networkManager.delete(ApiEndpoints.avatar);
    return Future<Object>.value(Object);
  }
}
