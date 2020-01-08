import 'package:ae_scanner/model/saved_scan.dart';
import 'package:ae_scanner/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'config.dart' as config;
import 'core/saved_scan_provider.dart';

void main() => runApp(MyApp());

class AllScans with ChangeNotifier {
  List<SavedScan> _savedScans = [];

  List<SavedScan> get savedScans => [..._savedScans];

  Future updateFromDb() async {
    final savedScanProvider = SavedScanProvider();
    await savedScanProvider.open();
    final all = await savedScanProvider.all();
    await
    savedScanProvider.close();
    update(all);
  }

  void update(List<SavedScan> scans) {
    this._savedScans = scans;
    notifyListeners();
  }

  void insert(SavedScan scan) {
    this._savedScans = [..._savedScans, scan];
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

    return ChangeNotifierProvider(
      builder: (ctx) => AllScans(),
      child: MaterialApp(
        title: config.appTitle,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: config.primaryColor,
          accentColor: config.accentColor,
        ),
        home: HomeScreen(),
      ),
    );
  }
}
