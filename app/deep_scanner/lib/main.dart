import 'package:deep_scanner/config.dart' as config;
import 'package:deep_scanner/screens/home.dart';
import 'package:flutter/material.dart';

void main() => runApp(DeepScannerApp());

class DeepScannerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: config.appTitle,
      theme: ThemeData(
        primaryColor: config.primaryColor,
        accentColor: config.accentColor,
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
    );
  }
}
