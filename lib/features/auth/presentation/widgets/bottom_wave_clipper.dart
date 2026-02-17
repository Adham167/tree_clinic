

import 'package:flutter/material.dart';

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, 70);

    path.quadraticBezierTo(size.width * 0.25, 0, size.width * 0.5, 70);

    path.quadraticBezierTo(size.width * 0.75, 140, size.width, 70);

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
