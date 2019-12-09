import 'package:flutter/widgets.dart';
import 'dart:math' as math;

class CropPolygon {
  final Offset topLeft;
  final Offset topRight;
  final Offset bottomRight;
  final Offset bottomLeft;

  const CropPolygon(
      {this.topLeft = const Offset(0, 0),
      this.topRight = const Offset(100, 0),
      this.bottomRight = const Offset(100, 100),
      this.bottomLeft = const Offset(0, 100)});

  List<Offset> get points => [topLeft, topRight, bottomRight, bottomLeft];

  int detectEditedPoint(Offset panStartOffset) {
    final distances =
        points.map((point) => (panStartOffset - point).distance).toList();
    final epsilon = 25.0;

    final minDistanceIndex = distances.indexWhere(
        (double distance) => (distance == distances.reduce(math.min)));

    if (distances[minDistanceIndex] <= epsilon) {
      return minDistanceIndex;
    }

    return null;
  }

  CropPolygon update(
      {Offset topLeft,
      Offset topRight,
      Offset bottomRight,
      Offset bottomLeft}) {
    return CropPolygon(
        topLeft: topLeft ?? this.topLeft,
        topRight: topRight ?? this.topRight,
        bottomRight: bottomRight ?? this.bottomRight,
        bottomLeft: bottomLeft ?? this.bottomLeft);
  }
}
