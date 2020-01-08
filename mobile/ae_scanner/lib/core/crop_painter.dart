import 'dart:ui' as ui;

import 'package:ae_scanner/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'crop_polygon.dart';

class CropPainter extends CustomPainter {
  final CropPolygon cropPolygon;
  ui.Image image;

  CropPainter({@required this.cropPolygon, @required this.image});

  final _vertexPaint = Paint()
    ..color = config.primaryColor
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  final _edgePaint = Paint()
    ..blendMode = BlendMode.difference
    ..color = config.primaryColor
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.miter
    ..strokeMiterLimit = 0
    ..strokeWidth = 4;

  final _fillPaint = Paint()
//    ..blendMode = BlendMode.difference
    ..color = Colors.white.withOpacity(0.25)
    ..isAntiAlias = true
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) async {
    final double widgetWidth = size.width;
    final double scaleFactor = widgetWidth / image.width;
    final double scaledHeight = image.height * scaleFactor;

    canvas.drawImageRect(
        image,
        Rect.fromPoints(
            Offset.zero, Offset(image.width * 1.0, image.height * 1.0)),
        Rect.fromCenter(
            center: Offset(size.width / 2, size.height / 2),
            width: size.width,
            height: scaledHeight),
        Paint());

    final path = Path()..addPolygon(cropPolygon.list, true);
    canvas.drawPath(path, _fillPaint);

    canvas.drawPoints(ui.PointMode.polygon,
        [...cropPolygon.list, cropPolygon.list.first], _edgePaint);
    cropPolygon.list.forEach((offset) {
      canvas.drawCircle(offset, 8, _vertexPaint);
      canvas.drawArc(Rect.fromCircle(center: offset, radius: 8), 0.0, 3.1415*2, false, _edgePaint);
    });
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
