import 'package:ae_scanner/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class DetailsScreen extends StatelessWidget {
  final ImageProvider imageProvider;
  final String imageName;

  DetailsScreen({this.imageProvider, this.imageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(imageName),
      ),
      body: Center(
        child: PhotoView(
          loadingChild: CircularProgressIndicator(),
          backgroundDecoration: BoxDecoration(color: config.primaryColor),
          imageProvider: imageProvider,
        ),
      ),
    );
  }
}
