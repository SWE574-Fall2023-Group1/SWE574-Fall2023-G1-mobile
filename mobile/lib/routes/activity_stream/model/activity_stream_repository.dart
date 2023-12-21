import 'package:memories_app/network/model/response_model.dart';
import 'package:memories_app/network/network_manager.dart';
import 'package:memories_app/routes/activity_stream/model/activity_stream_response_model.dart';
import 'package:memories_app/util/api_endpoints.dart';

abstract class ActivityStreamRepository {
  Future<ActivityStreamResponseModel> getActivities();
  Future<ResponseModel> viewActivity(int activityId);
}

class ActivityStreamRepositoryImp extends ActivityStreamRepository {
  final NetworkManager _networkManager;

  ActivityStreamRepositoryImp({NetworkManager? networkManager})
      : _networkManager = networkManager ?? NetworkManager();

  @override
  Future<ActivityStreamResponseModel> getActivities() async {
    final Result result = await _networkManager.get(ApiEndpoints.getActivities);
    return ActivityStreamResponseModel.fromJson(result.json);
  }

  @override
  Future<ResponseModel> viewActivity(int activityId) async {
    final Result result =
        await _networkManager.patch(ApiEndpoints.getActivitiesById(activityId));
    return ResponseModel.fromJson(result.json);
  }
}
