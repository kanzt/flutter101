
import 'package:flutter/material.dart';

class Line extends CustomPainter {

  final Color color;

  Line(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint();
    paint.color = color;
    paint.strokeWidth = 0.5;
    paint.strokeCap = StrokeCap.round;

    var startingOffset = Offset(0, size.height);
    var endingOffset = Offset(size.width, size.height);

    canvas.drawLine(startingOffset, endingOffset, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}