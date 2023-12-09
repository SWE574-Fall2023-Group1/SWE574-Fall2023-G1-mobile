import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/request/update_biography_request_model.dart';
import 'package:memories_app/util/api_endpoints.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;

abstract class ProfileRepository {
  Future<UserDetailsResponseModel> getUserDetails();

  Future<StoriesResponseModel> getOwnStories(int id);

  Future<UpdateBiographyRequestModel> updateBiography(String biography);

  Future<Object> addAvatar(File content);

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
  Future<Result> addAvatar(File content) async {
    dio.MultipartFile file = await dio.MultipartFile.fromFile(content.path,
        filename: 'profile_photo');

    dio.FormData formData = dio.FormData.fromMap({
      "profile_photo": file,
    });

    final Result result =
        await _networkManager.putFile(ApiEndpoints.avatar, body: formData);
    return result;
  }

  @override
  Future<Object> deleteAvatar() async {
    final Result result = await _networkManager.delete(ApiEndpoints.avatar);
    return Future<Object>.value(Object);
  }
}
