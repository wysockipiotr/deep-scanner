import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("About"),
          centerTitle: true,
        ),
        body: Center(
          child: Text("DeepScanner"),
        ));
  }
}
