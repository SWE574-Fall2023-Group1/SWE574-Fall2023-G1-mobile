import 'package:flutter/material.dart';
import 'package:memories_app/routes/profile/model/profile_repository.dart';
import 'package:memories_app/routes/profile/model/response/change_avatar_response_model.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class EditAvatarButton extends StatelessWidget {
  final Function(String?) onAvatarChange;

  const EditAvatarButton({required this.onAvatarChange, super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 0,
      top: 0,
      child: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Edit Photo'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          AddProfilePhotoResponseModel result =
                              await ProfileRepositoryImp().addAvatar(
                            await pickImage(ImageSource.camera),
                          );
                          onAvatarChange(result.profilePhoto);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Take Photo'),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          Navigator.of(context).pop();
                          AddProfilePhotoResponseModel result =
                              await ProfileRepositoryImp().addAvatar(
                                  await pickImage(ImageSource.gallery));
                          onAvatarChange(result.profilePhoto);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Choose From Gallery'),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          ProfileRepositoryImp().deleteAvatar();
                          onAvatarChange(null);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8),
                          child: Text('Remove Photo'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
        child: const CircleAvatar(
          backgroundColor: Colors.white70,
          radius: 15,
          child: Icon(
            Icons.edit,
            color: Colors.black87,
            size: 20,
          ),
        ),
      ),
    );
  }
}

Future<File> pickImage(ImageSource source) async {
  final XFile? pickedFile = await ImagePicker().pickImage(source: source);
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    throw Exception('No image selected.');
  }
}
