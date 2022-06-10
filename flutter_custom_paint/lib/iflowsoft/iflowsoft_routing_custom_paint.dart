import 'dart:ui' as ui show Image;
import 'package:flutter/material.dart';
import 'package:flutter_custom_paint/iflowsoft/routing_data.dart';

class IFlowSoftRoutingCustomPaint extends CustomPainter {
  late final ui.Image _image;
  late final Rect _imageRect;
  late final List<RoutingData> datas;

  static const _kirbyImageSize = 50.0;
  static const _verticalMargin = 32.0;
  static const _horizontalMargin = 48.0;

  // width + margin
  static const _imageWidth = (_horizontalMargin * 2) + _kirbyImageSize;
  static const _imageHeight = (_verticalMargin * 2) + _kirbyImageSize;

  IFlowSoftRoutingCustomPaint(this._image, );

  @override
  void paint(Canvas canvas, Size size) async {
    _drawImage(canvas, size);
    _drawTextAboveImage(canvas, size);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }

  void _drawImage(Canvas canvas, Size size) {

    _imageRect = Rect.fromLTRB((_horizontalMargin), (size.height * 0.5) - (_kirbyImageSize * 0.5),
        _horizontalMargin + _kirbyImageSize, (size.height * 0.5) + (_kirbyImageSize * 0.5));

    // เปิดเมื่อต้องการให้รูปอยู่ตรงกลาง Canvas
    // _imageRect = Rect.fromLTRB((size.width * 0.5) -  (_kirbyImageSize * 0.5), (size.height * 0.5) - (_kirbyImageSize * 0.5),
    //     (size.width * 0.5) +  (_kirbyImageSize * 0.5), (size.height * 0.5) + (_kirbyImageSize * 0.5));

    paintImage(
      canvas: canvas,
      rect: _imageRect,
      image: _image,
    );

    // canvas.drawImage(_image, Offset.zero, Paint());
  }

  void _drawTextAboveImage(Canvas canvas, Size size) {
    const textStyle = TextStyle(
      color: Colors.black,
      fontSize: 12
    );
    const textSpan = TextSpan(
      text: 'บริษัท ซีดีจี ซิสเต็มส์ จำกัด',
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
    if(centerOfText > centerOfImage){
      diff *= -1;
    }

    textPainter.paint(canvas, Offset(diff,_imageRect.top - _verticalMargin));
  }

  Offset _getHorizontalCenterOffset(Rect w1, Rect w2) {
    return const Offset(0, 0);
  }
}
