import 'dart:ui' as ui;

import 'package:deep_scanner/core/crop_painter.dart';
import 'package:deep_scanner/core/crop_polygon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Crop extends StatefulWidget {
  final ui.Image image;
  final Size size;

  Crop({@required this.image, @required this.size});

  double get scaledImageHeight => (size.width / image.width) * image.height;

  double get minY => (size.height - scaledImageHeight) / 2;

  double get maxY => size.height - (size.height - scaledImageHeight) / 2;

  @override
  State<StatefulWidget> createState() {
    return _CropState();
  }
}

class _CropState extends State<Crop> {
  int _editedPointIndex;
  CropPolygon _polygon = CropPolygon();

  @override
  void initState() {
    final padding = 32.0;

    final scaledHeight =
        (widget.size.width / widget.image.width) * widget.image.height;
    _polygon = CropPolygon(
        topLeft:
            Offset(padding, (widget.size.height - scaledHeight) / 2 + padding),
        topRight: Offset(widget.size.width - padding,
            (widget.size.height - scaledHeight) / 2 + padding),
        bottomRight: Offset(
            widget.size.width - padding,
            widget.size.height -
                (widget.size.height - scaledHeight) / 2 -
                padding),
        bottomLeft: Offset(
            padding,
            widget.size.height -
                (widget.size.height - scaledHeight) / 2 -
                padding));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: CustomPaint(
        painter: CropPainter(cropPolygon: _polygon, image: widget.image),
        size: Size(double.infinity, double.infinity),
      ),
      onPanStart: _onPanStart,
      onPanUpdate: _onPanUpdate,
      onPanEnd: _onPanEnd,
      onPanCancel: _onPanCancel,
    );
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_editedPointIndex != null &&
        details.localPosition.dy >= widget.minY &&
        details.localPosition.dy <= widget.maxY) {
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
