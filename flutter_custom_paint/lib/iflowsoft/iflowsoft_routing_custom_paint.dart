import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/iflowsoft/routing_data.dart';

class IFlowSoftRoutingCustomPaint extends CustomPainter {
  late final RoutingData data;

  static const _imageSize = 50.0;
  static const _verticalMargin = 32.0;
  static const _horizontalMargin = 48.0;

  // ความยาวของเส้น
  static const _gap = 80;

  // width + margin
  static const _imageWidth = (_horizontalMargin * 2) + _imageSize;
  static const _imageHeight = (_verticalMargin * 2) + _imageSize;

  IFlowSoftRoutingCustomPaint(this.data);

  @override
  void paint(Canvas canvas, Size size) async {
    _onDraw(canvas, size, data);

    _drawAllChildNode(canvas, size, data);
  }

  void _onDraw(Canvas canvas, Size size, RoutingData data) {
    _drawImage(canvas, size, data);
    _drawTextAboveImage(canvas, size, data);

    if (data.parent != null) {
      _drawLine(canvas, size, data);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawImage(Canvas canvas, Size size, RoutingData data) {
    if (data.parent == null) {
      // Display root node @Center
      data.myRect = Rect.fromLTRB(
          (_horizontalMargin),
          (size.height * 0.5) - (_imageSize * 0.5),
          _horizontalMargin + _imageSize,
          (size.height * 0.5) + (_imageSize * 0.5));
    } else {
      final childCount = data.parent!.child!.length;
      final spaceY = (data.parent!.myRect!.center.dy * 2) / (childCount + 1.0);
      final childPosition = data.parent!.child!.indexOf(data) + 1;

      data.myRect = Rect.fromLTRB(
          data.parent!.myRect!.right + _gap + (_horizontalMargin * 2),
          (spaceY * childPosition) - (_imageSize * 0.5),
          data.parent!.myRect!.right +
              _gap +
              (_horizontalMargin * 2) +
              _imageSize,
          (spaceY * childPosition) + (_imageSize * 0.5));

      // data.myRect = Rect.fromLTRB(
      //     data.parent!.myRect!.right + _gap + (_horizontalMargin * 2),
      //     data.parent!.myRect!.top,
      //     data.parent!.myRect!.right + _gap + (_horizontalMargin * 2) + _imageSize,
      //     data.parent!.myRect!.bottom);
    }

    // เปิดเมื่อต้องการให้รูปอยู่ตรงกลาง Canvas
    // _imageRect = Rect.fromLTRB((size.width * 0.5) -  (_kirbyImageSize * 0.5), (size.height * 0.5) - (_kirbyImageSize * 0.5),
    //     (size.width * 0.5) +  (_kirbyImageSize * 0.5), (size.height * 0.5) + (_kirbyImageSize * 0.5));

    paintImage(
      canvas: canvas,
      rect: data.myRect!,
      image: data.image,
    );

    // canvas.drawImage(_image, Offset.zero, Paint());
  }

  void _drawTextAboveImage(Canvas canvas, Size size, RoutingData data) {
    const textStyle = TextStyle(color: Colors.black, fontSize: 12);
    final textSpan = TextSpan(
      text: data.title,
      style: textStyle,
    );
    final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center);

    textPainter.layout(
      minWidth: 0,
      maxWidth: _imageWidth,
    );

    // เปิด เมื่อต้องการแสดงข้อความตรงกลาง Canvas
    // textPainter.layout(
    //   minWidth: 0,
    //   maxWidth: size.width,
    // );
    // final xCenter = (size.width - textPainter.width) / 2;
    // final yCenter = (size.height - textPainter.height) / 2;
    // final offset = Offset(xCenter, yCenter);

    // final offset = Offset(
    //     0,
    //     (size.height * 0.5) -
    //         (_kirbyImageSize * 0.5) -
    //         _textBottomMarginFromImage);

    // final offset = _getHorizontalCenterOffset(_imageRect, _textRect);

    final centerOfText = textPainter.width * 0.5;
    const centerOfImage = _imageWidth * 0.5;
    var diff = centerOfImage - centerOfText;
    if (centerOfText > centerOfImage) {
      diff *= -1;
    }

    if (data.parent != null) {
      diff += data.parent!.myRect!.right + _gap + _horizontalMargin;
    }

    textPainter.paint(canvas, Offset(diff, data.myRect!.top - _verticalMargin));
  }

  Offset _getHorizontalCenterOffset(Rect w1, Rect w2) {
    return const Offset(0, 0);
  }

  void _drawLine(Canvas canvas, Size size, RoutingData data) {
    Paint paint = Paint();
    paint.color = Colors.green;
    paint.strokeWidth = 5;
    paint.strokeCap = StrokeCap.round;

    Offset startingOffset = data.parent!.myRect!.centerRight;
    Offset endingOffset = data.myRect!.centerLeft;

    canvas.drawLine(startingOffset, endingOffset, paint);
  }

  void _drawAllChildNode(Canvas canvas, Size size, RoutingData data) {
    data.child?.forEach((element) {
      _onDraw(
        canvas,
        size,
        element,
      );

      if(element.child?.isNotEmpty == true){
        _drawAllChildNode(canvas, size, element);
      }
    });
  }
}
