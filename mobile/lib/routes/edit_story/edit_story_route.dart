import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/edit_story/bloc/edit_story_bloc.dart';
import 'package:memories_app/routes/home/model/story_model.dart';
import 'package:memories_app/ui/shows_dialog.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/utils.dart';

class EditStoryRoute extends StatefulWidget {
  final StoryModel storyModel;
  const EditStoryRoute({required this.storyModel, super.key});

  @override
  State<EditStoryRoute> createState() => _EditStoryRouteState();
}

class _EditStoryRouteState extends State<EditStoryRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditStoryBloc, EditStoryState>(
      buildWhen: (EditStoryState previousState, EditStoryState state) {
        return !(state is EditStoryFailure || state is EditStoryOffline);
      },
      builder: (BuildContext context, EditStoryState state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Edit Story"),
          ),
          body: const SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: SpaceSizes.x8),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, children: []),
            ),
          ),
        );
      },
      listener: (BuildContext context, EditStoryState state) {
        if (state is EditStorySuccess) {
          AppRoute.landing.navigate(context);
        } else if (state is EditStoryFailure) {
          ShowsDialog.showAlertDialog(context, 'Oops!', state.error.toString(),
              isEditStoryFail: true);
        } else if (state is EditStoryOffline) {
          ShowsDialog.showAlertDialog(
              context, 'Oops!', state.offlineMessage.toString(),
              isEditStoryFail: true);
        }
      },
    );
  }
}
