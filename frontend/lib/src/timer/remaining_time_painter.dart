import 'dart:math';

import 'package:flutter/material.dart';

class RemainingTimePainter extends CustomPainter {
  final double value;

  RemainingTimePainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = const Color(0xFFBBCCBB)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0;
    Paint foregroundPaint = Paint()
      ..color = const Color.fromARGB(255, 56, 87, 35)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 20.0;

    double radius = min(
      size.width / 2 - backgroundPaint.strokeWidth,
      size.height / 2 - backgroundPaint.strokeWidth,
    );
    Offset centerOffset = Offset(
      size.width / 2,
      size.height / 2,
    );
    canvas.drawCircle(centerOffset, radius, backgroundPaint);
    canvas.drawArc(
        Rect.fromCircle(
          center: centerOffset,
          radius: radius,
        ),
        -pi / 2,
        pi * 2 * value,
        false,
        foregroundPaint);
  }

  @override
  bool shouldRepaint(covariant RemainingTimePainter oldDelegate) {
    return oldDelegate.value != value;
  }
}
