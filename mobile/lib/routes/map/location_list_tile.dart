import 'package:flutter/material.dart';

class LocationListTile extends StatelessWidget {
  final String location;
  final VoidCallback press;
  const LocationListTile({
    required this.location,
    required this.press,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: press,
          leading: Icon(Icons.location_pin),
          title: Text(
            location,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Divider(height: 2, thickness: 2)
      ],
    );
  }
}
