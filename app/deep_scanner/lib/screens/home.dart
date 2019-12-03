import 'package:deep_scanner/config.dart' as config;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(config.appTitle),
        centerTitle: true,
      ),
      body: Center(child: Text("HomeScreen"),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add_a_photo),
        tooltip: "Pick image",
      ),
    );
  }
}
