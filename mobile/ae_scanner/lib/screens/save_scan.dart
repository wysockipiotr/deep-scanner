import 'dart:io';
import 'dart:typed_data';

import 'package:ae_scanner/core/crop_polygon.dart';
import 'package:ae_scanner/core/scan.dart';
import 'package:ae_scanner/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class SaveScanScreen extends StatefulWidget {
  final File imageFile;
  final CropPolygon cropPolygon;

  SaveScanScreen({this.imageFile, this.cropPolygon});

  @override
  _SaveScanScreenState createState() => _SaveScanScreenState();
}

class _SaveScanScreenState extends State<SaveScanScreen> {
//  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
              await PermissionHandler()
                  .requestPermissions([PermissionGroup.storage]);
              final result = await ImageGallerySaver.saveImage(bytes);
              print(result);
              Navigator.of(context).pop();
            },
            tooltip: "Save scan",
          )
      ],
    );
  }
}
