import 'package:flutter/material.dart';
import 'package:memories_app/routes/home/model/response/avatar_response_model.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';

class LoadAvatar extends StatelessWidget {
  final int id;
  final double? radius;

  const LoadAvatar({required this.id, this.radius, super.key});

  Future<AvatarResponseModel> loadAvatar(BuildContext context) async {
    AvatarResponseModel? responseModel;
    responseModel = await StoryDetailRepositoryImp().getAvatarUrlById(id: id);
    return responseModel;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AvatarResponseModel>(
      future: loadAvatar(context),
      builder:
          (BuildContext context, AsyncSnapshot<AvatarResponseModel> snapshot) {
        if (snapshot.hasData) {
          AvatarResponseModel avatar = snapshot.data!;
          return CircleAvatar(
            backgroundImage: NetworkImage(avatar.url ?? ""),
            radius: radius ?? 20,
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
