import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:memories_app/network/network_manager.dart';

class CachedAvatar extends StatelessWidget {
  final String? url;
  final double radius;

  const CachedAvatar({
    required this.url,
    required this.radius,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: NetworkConstant.baseURL + (url ?? ""),
      placeholder: (BuildContext context, String url) => CircleAvatar(
        radius: radius,
        child: const CircularProgressIndicator(),
      ),
      imageBuilder:
          (BuildContext context, ImageProvider<Object> imageProvider) =>
              CircleAvatar(
        backgroundImage: imageProvider,
        radius: radius,
      ),
      errorWidget: (BuildContext context, String url, dynamic error) =>
          CircleAvatar(
        radius: radius,
        child: Icon(
          Icons.person,
          size: radius,
        ),
      ),
    );
  }
}
