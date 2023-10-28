import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

class SpaceSizes {
  static const double x4 = 4.0;
  static const double x8 = 8.0;
  static const double x12 = 12.0;
  static const double x16 = 16.0;
  static const double x24 = 24.0;
  static const double x32 = 32.0;
  static const double x40 = 40.0;
  static const double x48 = 48.0;
  static const double x60 = 60.0;
  static const double x120 = 120.0;
}

class WidgetKeys {
  static const Key usernameFieldKey = Key('login_username_field');
  static const Key passwordFieldKey = Key('login_password_field');
  static const Key loginButtonKey = Key('login_button');
}

class AppColors {
  static const Color textFieldBorderColor = Color(0xFFE2E2E2);
  static const Color textFieldHintColor = Color(0xFF757575);
  static const Color buttonColor = Color(0xFF7E49FF);
  static const Color disabledButtonTextColor = Color(0xFF757575);
}

class AppScreenSizeUtils {
  static double getScrollPadding(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }
}

class FontSizes {
  static const double smallSize = 12.0;
  static const double regularSize = 16.0;
}

class TestDevices {
  static const Device iphoneSE =
      Device(name: 'iPhone SE', size: Size(375, 667));
  static const Device iphone14 =
      Device(name: 'iPhone 14', size: Size(390, 844));
  static const Device iphone14ProMax =
      Device(name: 'iPhone 14 Pro Max', size: Size(430, 932));

  static const List<Device> devices = <Device>[
    iphoneSE,
    iphone14,
    iphone14ProMax
  ];
}
