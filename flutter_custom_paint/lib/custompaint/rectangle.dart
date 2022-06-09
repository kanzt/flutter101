
import 'package:flutter/material.dart';

class Rectangle extends CustomPainter {
  bool? isFilled;
  Rectangle({this.isFilled});
  /// the paint() method will get called whenever the objects needs to repaint
  /// @param canvas - เหมือน Android native
  /// @param size - ขนาดความกว้าง/ยาว ของ Canvas
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint();
    paint.color = Colors.blue;
    if(isFilled != null){
      paint.style = PaintingStyle.fill;
    }
    else {
      paint.style = PaintingStyle.stroke;
    }
    paint.strokeCap = StrokeCap.round;
    paint.strokeJoin = StrokeJoin.round;
    paint.strokeWidth = 5;
    Offset offset = Offset(size.width * 0.5, size.height * 0.5);

    Rect rect = Rect.fromCenter(center: offset, width: 50, height: 50);
    canvas.drawRect(rect, paint);
  }

  /// The shouldRepaint() method will be called whenever there is a new instance of the CustomPainter.
  /// If the new instance will always have the same property value then the method can just return false.
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    throw false;
  }

}