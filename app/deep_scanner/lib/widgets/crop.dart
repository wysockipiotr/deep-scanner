import 'dart:ui' as ui;

import 'package:deep_scanner/core/crop_painter.dart';
import 'package:deep_scanner/core/crop_polygon.dart';
import 'package:flutter/widgets.dart';

class Crop extends StatefulWidget {
  final ui.Image image;

  Crop({@required this.image});

  @override
  State<StatefulWidget> createState() {
    return _CropState();
  }
}

class _CropState extends State<Crop> {
  int _editedPointIndex;
  CropPolygon _polygon = CropPolygon();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: CropPainter(cropPolygon: _polygon, image: widget.image),
      ),
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onPanCancel: _onPanCancel,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_editedPointIndex != null) {
      setState(() {
        if (_editedPointIndex == 0) {
          _polygon = _polygon.update(topLeft: details.localPosition);
        } else if (_editedPointIndex == 1) {
          _polygon = _polygon.update(topRight: details.localPosition);
        } else if (_editedPointIndex == 2) {
          _polygon = _polygon.update(bottomRight: details.localPosition);
        } else {
          _polygon = _polygon.update(bottomLeft: details.localPosition);
        }
      });
    }
  }

  void _onPanStart(DragStartDetails details) {
    _editedPointIndex = _polygon.detectEditedPoint(details.localPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    _editedPointIndex = null;
  }

  void _onPanCancel() {
    _editedPointIndex = null;
  }
}
