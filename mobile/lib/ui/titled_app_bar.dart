import 'package:flutter/material.dart';
import 'package:memories_app/util/styles.dart';

class TitledAppBar {
  static AppBar build(String title, {GestureDetector? gestureDetector}) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: gestureDetector,
      title: Text(
        title,
        style: Styles.appBarTitleStyle,
      ),
    );
  }
}
