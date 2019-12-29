import 'dart:ui' as ui;

import 'package:ae_scanner/core/crop_painter.dart';
import 'package:ae_scanner/core/crop_polygon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef OnCropPolygonUpdate = void Function(CropPolygon cropPolygon);

CropPolygon toImageCoords(
    {double imageSpaceScaler, CropPolygon polygonWidgetCoords, double minY}) {
  final List<Offset> points = polygonWidgetCoords.list.map((Offset point) {
    double dy = (point.dy - minY) * imageSpaceScaler;
    double dx = point.dx * imageSpaceScaler;
    return Offset(dx, dy);
  }).toList();

  return CropPolygon.fromPoints(
      topLeft: points[0],
      topRight: points[1],
      bottomRight: points[2],
      bottomLeft: points[3]
  );
}

class Crop extends StatefulWidget {
  final ui.Image image;
  final Size size;
  final OnCropPolygonUpdate onCropPolygonUpdate;

  Crop(
      {@required this.image,
        @required this.size,
        @required this.onCropPolygonUpdate});

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
  CropPolygon _polygon; //= CropPolygon.fromPoints(topLeft: Offset(0,0), topRight: Offset(100,0), bottomRight: Offset(100,100), bottomLeft: null);

  @override
  void initState() {
    final padding = 16.0;
    final scaledHeight =
        (widget.size.width / widget.image.width) * widget.image.height;
    _polygon = CropPolygon.fromPoints(
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
    if (_editedPointIndex != null) {
      Offset offset = details.localPosition;
      if (details.localPosition.dy < widget.minY) {
        offset = Offset(offset.dx, widget.minY);
      } else if (details.localPosition.dy > widget.maxY) {
        offset = Offset(offset.dx, widget.maxY);
      }

      setState(() {
        if (_editedPointIndex == 0) {
          _polygon = _polygon.update(topLeft: offset);
        } else if (_editedPointIndex == 1) {
          _polygon = _polygon.update(topRight: offset);
        } else if (_editedPointIndex == 2) {
          _polygon = _polygon.update(bottomRight: offset);
        } else {
          _polygon = _polygon.update(bottomLeft: offset);
        }
      });
      widget.onCropPolygonUpdate(toImageCoords(
          imageSpaceScaler: widget.image.height / widget.scaledImageHeight,
          polygonWidgetCoords: _polygon,
          minY: widget.minY));
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
