import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/foundation.dart';

enum CropPoint {
  TopLeft,
  TopRight,
  BottomRight,
  BottomLeft,
}

@immutable
class CropPolygon {
  final List<Offset> _points;

  CropPolygon.fromList({@required List<Offset> points})
      : assert(points.length == 4),
        _points = points;

  CropPolygon.fromPoints(
      {@required Offset topLeft,
      @required Offset topRight,
      @required Offset bottomRight,
      @required Offset bottomLeft})
      : _points = [topLeft, topRight, bottomRight, bottomLeft];

  Map<CropPoint, Offset> get points => {
        CropPoint.TopLeft: _points[0],
        CropPoint.TopRight: _points[1],
        CropPoint.BottomRight: _points[2],
        CropPoint.BottomLeft: _points[3]
      };

  List<Offset> get list => this._points;

  Offset get topLeft => this.points[CropPoint.TopLeft];

  Offset get topRight => this.points[CropPoint.TopRight];

  Offset get bottomRight => this.points[CropPoint.BottomRight];

  Offset get bottomLeft => this.points[CropPoint.BottomLeft];

  CropPolygon update(
          {Offset topLeft,
          Offset topRight,
          Offset bottomRight,
          Offset bottomLeft}) =>
      CropPolygon.fromPoints(
          topLeft: topLeft ?? this.topLeft,
          topRight: topRight ?? this.topRight,
          bottomRight: bottomRight ?? this.bottomRight,
          bottomLeft: bottomLeft ?? this.bottomLeft);

  int detectEditedPoint(Offset panStartOffset, {double epsilon = 25.0}) {
    final distances =
        _points.map((point) => (panStartOffset - point).distance).toList();

    final minDistanceIndex = distances.indexWhere(
        (double distance) => (distance == distances.reduce(math.min)));

    if (distances[minDistanceIndex] <= epsilon) {
      return minDistanceIndex;
    }

    return null;
  }
}
