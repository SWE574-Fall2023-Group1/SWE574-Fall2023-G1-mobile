import 'package:flutter/material.dart';
import 'package:memories_app/util/Styles.dart';

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
