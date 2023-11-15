import 'package:flutter/material.dart';

class DateText {
  static Text build({required String text}) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontFamily: 'Inter',
        fontWeight: FontWeight.w400,
        height: 1.5,
        letterSpacing: 1.75,
      ),
    );
  }
}
