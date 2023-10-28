import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double height;
  final VoidCallback? onPressed;
  final Widget child;
  final Color? buttonColor;

  const PrimaryButton({
    Key? key,
    this.onPressed,
    required this.child,
    this.borderRadius,
    this.width,
    this.height = 56.0,
    this.buttonColor,
  }) : super(key: key);

  getBorderRadius() {
    return borderRadius ?? BorderRadius.circular(0);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration:
          BoxDecoration(color: buttonColor, borderRadius: getBorderRadius()),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          shape: RoundedRectangleBorder(borderRadius: getBorderRadius()),
        ),
        child: child,
      ),
    );
  }
}
