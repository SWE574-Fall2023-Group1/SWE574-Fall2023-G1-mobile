import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/create_story/bloc/create_story_bloc.dart';
import 'package:memories_app/routes/login/bloc/login_bloc.dart';
import 'package:memories_app/routes/register/bloc/register_bloc.dart';
import 'package:memories_app/util/utils.dart';

class ShowsDialog {
  static void showAlertDialog(
    BuildContext context,
    String title,
    String message, {
    bool isLoginFail = false,
    bool isRegisterFail = false,
    bool isRegisterSuccess = false,
    bool isCreateStoryFail = false,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SpaceSizes.x12),
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: FontSizes.regularSize,
            ),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: const TextStyle(
              color: Colors.black,
              fontSize: FontSizes.regularSize,
            ),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.all(SpaceSizes.x16),
          elevation: 0,
          insetPadding: const EdgeInsets.symmetric(horizontal: SpaceSizes.x16),
          scrollable: true,
          actions: <Widget>[
            TextButton(
                style: TextButton.styleFrom(
                    side: const BorderSide(width: 1, color: Colors.black),
                    padding: const EdgeInsets.all(SpaceSizes.x8),
                    foregroundColor: Colors.black,
                    textStyle:
                        const TextStyle(fontSize: FontSizes.regularSize)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OK"))
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
      // ignore: always_specify_types
    ).then((value) {
      if (isLoginFail) {
        BlocProvider.of<LoginBloc>(context).add(LoginErrorPopupClosedEvent());
      }
      if (isRegisterFail) {
        //TODO: Add RegisterErrorPopupClosedEvent here
        BlocProvider.of<RegisterBloc>(context)
            .add(RegisterErrorPopupClosedEvent());
      }
      if (isRegisterSuccess) {
        BlocProvider.of<RegisterBloc>(context)
            .add(RegisterSuccessPopupClosedEvent());
      }
      if (isCreateStoryFail) {
        BlocProvider.of<CreateStoryBloc>(context)
            .add(CreateStoryErrorPopupClosedEvent());
      }
    });
  }
}
