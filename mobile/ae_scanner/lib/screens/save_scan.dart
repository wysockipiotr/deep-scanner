import 'dart:io';
import 'dart:typed_data';

import 'package:ae_scanner/core/crop_polygon.dart';
import 'package:ae_scanner/core/saved_scan_provider.dart';
import 'package:ae_scanner/core/scan.dart';
import 'package:ae_scanner/main.dart';
import 'package:ae_scanner/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SaveScanScreen extends StatefulWidget {
  final File imageFile;
  final CropPolygon cropPolygon;

  SaveScanScreen({this.imageFile, this.cropPolygon});

  @override
  _SaveScanScreenState createState() => _SaveScanScreenState();
}

class _SaveScanScreenState extends State<SaveScanScreen> {
  Uint8List bytes;

  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(context),
        body: Center(
          child: (bytes != null)
              ? Image.memory(bytes)
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 16.0,
                    ),
                    Text("Denoising"),
                  ],
                ),
        ));
  }

  Future _scan() async {
    try {
      Uint8List bytes = await scan(
          imageFile: widget.imageFile, cropPolygon: widget.cropPolygon);
      setState(() {
        this.bytes = bytes;
      });
    } on ScanException {
      Navigator.of(context).pop();
      HomeScreen.scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 5),
        content: Text("Scanning service unavailable. Try again later."),
      ));
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text("Result"),
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.clear),
        tooltip: "Cancel",
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: <Widget>[
        if (bytes != null)
          IconButton(
            icon: Icon(Icons.save_alt),
            onPressed: () async {
              final provider = SavedScanProvider();
              await provider.open();
              final scan = await provider.insert(bytes);
              await provider.close();
              Provider.of<AllScans>(context).insert(scan);
              Navigator.of(context).pop();
            },
            tooltip: "Save scan",
          )
      ],
    );
  }
}
