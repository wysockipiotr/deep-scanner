import 'dart:io';
import 'dart:typed_data';

import 'package:deep_scanner/core/crop_polygon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;

class Scanner {
  static const _platform =
      const MethodChannel("deep_scanner.wysockipiotr.me/scan");

  static const WARP_CROP_METHOD_NAME = "warpCrop";

  static Future<Uint8List> warpCrop(
      {@required File imageFile, @required CropPolygon cropPolygon}) async {
    final Map<String, dynamic> args = {
      "srcImagePath": p.basename(imageFile.path),
      "topLeft": [cropPolygon.topLeft.dx, cropPolygon.topLeft.dy],
      "topRight": [cropPolygon.topRight.dx, cropPolygon.topRight.dy],
      "bottomRight": [cropPolygon.bottomRight.dx, cropPolygon.bottomRight.dy],
      "bottomLeft": [cropPolygon.bottomLeft.dx, cropPolygon.bottomLeft.dy],
    };
    try {
      return await _platform.invokeMethod(WARP_CROP_METHOD_NAME, args);
    } on PlatformException {
      return null;
    }
  }
}
