import 'package:flutter/material.dart';

class IconLogo extends StatelessWidget {
  final double width;
  final double height;
  final BoxFit? fit;
  final Color? color;

  const IconLogo({
    super.key,
    this.width = 380,
    this.height = 380,
    this.fit,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/IconLogo.png',
      width: width,
      height: height,
      fit: fit,
      color: color,
    );
  }
}
