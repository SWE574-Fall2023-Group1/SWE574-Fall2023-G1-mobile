import 'package:dio/dio.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/app/model/response/base_response_model.dart';
import 'package:memories_app/routes/home/model/response/stories_response_model.dart';
import 'package:memories_app/routes/login/model/user_details_response_model.dart';
import 'package:memories_app/routes/profile/model/request/update_biography_request_model.dart';
import 'package:memories_app/routes/profile/model/response/change_avatar_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';
import 'dart:io';

abstract class ProfileRepository {
  Future<UserDetailsResponseModel> getUserDetails();

  Future<StoriesResponseModel> getOwnStories(int id);

  Future<UpdateBiographyRequestModel> updateBiography(String biography);

  Future<AddProfilePhotoResponseModel> addAvatar(File content);

  Future<BaseResponseModel> deleteAvatar();
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
  Future<AddProfilePhotoResponseModel> addAvatar(File content) async {
    final Result result = await _networkManager.putFile(
      ApiEndpoints.avatar,
      formData: FormData.fromMap(
        <String, dynamic>{
          "profile_photo": await MultipartFile.fromFile(content.path)
        },
      ),
    );
    return AddProfilePhotoResponseModel.fromJson(result.json);
  }

  @override
  Future<BaseResponseModel> deleteAvatar() async {
    final Result result = await _networkManager.delete(ApiEndpoints.avatar);
    return BaseResponseModel.fromJson(result.json);
  }
}
