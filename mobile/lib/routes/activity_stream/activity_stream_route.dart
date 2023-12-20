import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:memories_app/routes/activity_stream/bloc/activity_stream_bloc.dart';
import 'package:memories_app/util/styles.dart';

class ActivityStreamRoute extends StatefulWidget {
  const ActivityStreamRoute({super.key});

  @override
  State<ActivityStreamRoute> createState() => _ActivityStreamRouteState();
}

class _ActivityStreamRouteState extends State<ActivityStreamRoute> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ActivityStreamBloc, ActivityStreamState>(
      builder: (BuildContext context, ActivityStreamState state) {
        Widget column;
        if (state is ActivityStreamInitial) {
          column = const Center(child: CircularProgressIndicator());
        } else if (state is ActivityStreamDisplayState) {
          column = state.activities.isNotEmpty
              ? Container(
                  color: Colors.green,
                )
              : const Center(
                  child: Text("There is no recent activity for you"),
                );
        } else if (state is ActivityStreamFailure) {
          column = Center(
            child: Text("Error: ${state.error.toString()}"),
          );
        } else if (state is ActivityStreamOffline) {
          column = Center(
            child: Text(state.offlineMessage.toString()),
          );
        } else {
          column = const Center(child: CircularProgressIndicator());
        }

        return Material(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              centerTitle: true,
              title: const Text(
                "Activity Stream",
                style: Styles.appBarTitleStyle,
              ),
            ),
            body: column,
          ),
        );
      },
    );
  }
}
