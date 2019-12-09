import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;

import 'package:deep_scanner/widgets/crop.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class CropScreen extends StatefulWidget {
  final ImageSource imageSource;

  CropScreen({this.imageSource});

  @override
  State<StatefulWidget> createState() {
    return _CropScreenState();
  }
}

class _CropScreenState extends State<CropScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crop image"),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.done),
              tooltip: "Crop image",
            )
          ],
        ),
        body: FutureBuilder(
          future: _pickImage(),
          builder:
              (BuildContext context, AsyncSnapshot<ui.Image> asyncSnapshot) {
            if (asyncSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            return Container(
                width: double.infinity,
                height: double.infinity,
                child: Crop(image: asyncSnapshot.data));
          },
        ));
  }

  Future<ui.Image> _pickImage() async {
    final File tmpImageFile =
        await ImagePicker.pickImage(source: widget.imageSource);
    final String baseName = p.basename(tmpImageFile.path);
    final String path = (await getApplicationDocumentsDirectory()).path;
    final File imageFile = await tmpImageFile.copy(p.join(path, baseName));

    final Completer<ui.Image> completer = Completer();
    ui.decodeImageFromList(await imageFile.readAsBytes(), (ui.Image img) {
      return completer.complete(img);
    });
    return await completer.future;
  }
}
