import 'package:flutter/material.dart';
import 'package:memories_app/routes/map/location_map.dart';
import 'package:memories_app/util/router.dart';
import 'package:memories_app/util/utils.dart';

class CreateStoryRoute extends StatefulWidget {
  const CreateStoryRoute({super.key});

  @override
  State<CreateStoryRoute> createState() => _CreateStoryRouteState();
}

class _CreateStoryRouteState extends State<CreateStoryRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Story"),
        leading: GestureDetector(
            onTap: () {
              AppRoute.landing.navigate(context);
            },
            child: const Icon(Icons.close)),
      ),
      body: const SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(SpaceSizes.x8), child: LocationMap())
        ],
      )),
    );
  }
}
