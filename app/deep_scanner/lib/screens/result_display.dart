import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ResultDisplayScreen extends StatelessWidget {
  final Uint8List bytes;

  ResultDisplayScreen({this.bytes});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Image.memory(bytes),
      ),
    );
  }
}
