import 'package:flutter/material.dart';
import 'package:memories_app/routes/home/model/location_model.dart';
import 'package:memories_app/routes/home/model/story_model.dart';

class LocationNamesContainer extends StatelessWidget {
  final StoryModel story;

  const LocationNamesContainer({required this.story, super.key});

  Widget _buildLocationsList() {
    if (story.locationIds?.isEmpty ?? false) {
      return Container();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        for (LocationModel location in story.locationIds!) ...<Widget>[
          Text(
            location.name ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              height: 0,
            ),
          ),
          const SizedBox(height: 8),
        ],
        const SizedBox(height: 10),
        const Text(
          "*** Map Here ***",
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildLocationsList();
  }
}
