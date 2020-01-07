import 'dart:io';
import 'dart:typed_data';

import 'package:ae_scanner/core/crop_polygon.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

enum ScanningPolicy { Local, Remote }

const int CONNECTION_TIMEOUT_MS = 30000;
const BASE_URL = "http://192.168.0.197:5000";
const SCAN_ENDPOINT = "/scan";

class ScanException implements Exception {}

Future<Uint8List> scan(
    {@required File imageFile,
    ScanningPolicy scanningPolicy = ScanningPolicy.Remote,
    CropPolygon cropPolygon}) async {
  if (scanningPolicy == ScanningPolicy.Local) {
    throw UnimplementedError("Local scanning is not implemented.");
  }

  final baseOptions =
      BaseOptions(connectTimeout: CONNECTION_TIMEOUT_MS, baseUrl: BASE_URL);

  FormData formData = FormData.fromMap({
    "topLeftX": cropPolygon.topLeft.dx,
    "topLeftY": cropPolygon.topLeft.dy,
    "topRightX": cropPolygon.topRight.dx,
    "topRightY": cropPolygon.topRight.dy,
    "bottomRightX": cropPolygon.bottomRight.dx,
    "bottomRightY": cropPolygon.bottomRight.dy,
    "bottomLeftX": cropPolygon.bottomLeft.dx,
    "bottomLeftY": cropPolygon.bottomLeft.dy,
    "files": [await MultipartFile.fromFile(imageFile.path)]
  });

  try {
    Response<List<int>> response = await Dio(baseOptions).post(SCAN_ENDPOINT,
        data: formData, options: Options(responseType: ResponseType.bytes));
    return Uint8List.fromList(response.data);
  } on DioError catch (e) {
    print(e.message);
    throw ScanException();
  }
}
