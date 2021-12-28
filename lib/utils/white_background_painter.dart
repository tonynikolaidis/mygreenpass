import 'package:flutter/material.dart';

class WhiteBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;

    Path background = Path();
    background.addRect(Rect.fromLTRB(0, 0, width, height));
    Paint whitePaint = Paint();
    whitePaint.color = Colors.white;
    canvas.drawPath(background, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
