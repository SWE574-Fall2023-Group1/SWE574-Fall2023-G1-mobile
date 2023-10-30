import 'package:flutter/material.dart';

class _Constant {
  static const double imageSize = 240.0;
}

class LogoWidget extends StatelessWidget {
  const LogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/login/logo.png",
      width: _Constant.imageSize,
      height: _Constant.imageSize,
    );
  }
}
