import 'package:ae_scanner/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'config.dart' as config;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return MaterialApp(
      title: config.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: config.primaryColor,
        accentColor: config.accentColor,
      ),
      home: HomeScreen(),
    );
  }
}
