import 'package:flutter/material.dart';
import 'package:memories_app/routes/home/model/response/avatar_response_model.dart';
import 'package:memories_app/routes/story_detail/model/story_detail_repository.dart';

class LoadAvatar extends StatelessWidget {
  final int id;

  const LoadAvatar({required this.id, super.key});

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
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
