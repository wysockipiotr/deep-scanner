import 'dart:io';
import 'dart:typed_data';

import 'package:deep_scanner/core/crop_polygon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Scanner {
  static Future<Uint8List> warpCrop(
      {@required File imageFile, @required CropPolygon cropPolygon}) async {

    FormData formData = FormData.fromMap({
      "topLeftX": cropPolygon.topLeft.dx.toString(),
      "topLeftY": cropPolygon.topLeft.dy.toString(),
      "topRightX": cropPolygon.topRight.dx.toString(),
      "topRightY": cropPolygon.topRight.dy.toString(),
      "bottomRightX": cropPolygon.bottomRight.dx.toString(),
      "bottomRightY": cropPolygon.bottomRight.dy.toString(),
      "bottomLeftX": cropPolygon.bottomLeft.dx.toString(),
      "bottomLeftY": cropPolygon.bottomLeft.dy.toString(),
      "files": [await MultipartFile.fromFile(imageFile.path)]
    });

    Response<List<int>> resp = await Dio().post(
        "http://192.168.0.197:5000/scan",
        data: formData,
        options: Options(responseType: ResponseType.bytes));

    return Uint8List.fromList(resp.data);
  }
}
