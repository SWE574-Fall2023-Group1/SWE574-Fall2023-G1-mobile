import 'package:flutter/material.dart';
import 'package:memories_app/util/styles.dart';

class TitledAppBar {
  static AppBar createAppBar({required String title}) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      title: Text(
        title,
        style: Styles.appBarTitleStyle,
      ),
    );
  }
}
