import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:ae_scanner/core/crop_polygon.dart';
import 'package:ae_scanner/screens/home.dart';
import 'package:ae_scanner/screens/save_scan.dart';
import 'package:ae_scanner/widgets/crop.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CropScreen extends StatefulWidget {
  final ImageSource imageSource;

  CropScreen({this.imageSource});

  @override
  State<StatefulWidget> createState() {
    return _CropScreenState();
  }
}

class _CropScreenState extends State<CropScreen> {
  File imageFile;
  ui.Image image;
  CropPolygon polygon;

  @override
  void initState() {
    super.initState();
    _pickImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Future _pickImage() async {
    final File imageFile =
        await ImagePicker.pickImage(source: widget.imageSource);

    if (imageFile == null) {
      Navigator.of(context).pop();
      HomeScreen.scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text("Image picking cancelled"),
      ));
    }

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(await imageFile.readAsBytes(), (ui.Image img) {
      return completer.complete(img);
    });

    ui.Image image = await completer.future;

    setState(() {
      this.imageFile = imageFile;
      this.image = image;
    });
  }

  AppBar _buildAppBar() => AppBar(
        title: Text("Crop"),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.clear),
          tooltip: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: <Widget>[
          if (imageFile != null)
            IconButton(
              icon: Icon(Icons.check),
              tooltip: "Crop image",
              onPressed: () async {
                return Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext ctx) => SaveScanScreen(
                          imageFile: imageFile,
                          cropPolygon: this.polygon,
                        )));
              },
            )
        ],
      );

  Widget _buildBody() => Builder(
        builder: (BuildContext ctx) {
          if (imageFile != null) {
            RenderBox renderBox = ctx.findRenderObject();
            Size size = renderBox.size;
            return Container(
              width: double.infinity,
              height: double.infinity,
              child: Crop(
                image: image,
                size: size,
                onCropPolygonUpdate: (CropPolygon poly) {
                  this.polygon = poly;
                },
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
}
