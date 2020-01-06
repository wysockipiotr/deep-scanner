import 'package:ae_scanner/core/saved_scan_provider.dart';
import 'package:ae_scanner/main.dart';
import 'package:ae_scanner/model/saved_scan.dart';
import 'package:ae_scanner/screens/about.dart';
import 'package:ae_scanner/screens/crop.dart';
import 'package:ae_scanner/widgets/gallery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../config.dart' as config;

class HomeScreen extends StatefulWidget {
  static final GlobalKey<ScaffoldState> scaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _loadSavedScans();
  }

  void _loadSavedScans() async {
    final savedScanProvider = SavedScanProvider();
    await savedScanProvider.open();
    Provider.of<AllScans>(context).update(await savedScanProvider.all());
    await savedScanProvider.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: HomeScreen.scaffoldKey,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFab(),
    );
  }

  AppBar _buildAppBar() => AppBar(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              config.appTitle,
            ),
            Text(
              "Recent documents",
              style: Theme.of(context).textTheme.caption,
            )
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext ctx) => AboutScreen())),
            tooltip: "About DeepScanner",
          )
        ],
      );

  Widget _buildBody() {
    final scans = Provider.of<AllScans>(context).savedScans;
    return Center(child: Gallery(scans: scans));
  }

  FloatingActionButton _buildFab() => FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Colors.white,
      tooltip: "Pick an image",
      onPressed: _showPickImageBottomSheet);

  void _showPickImageBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                    title: Text("Take a photo"),
                    leading: Icon(Icons.add_a_photo),
                    onTap: () async => _pickImage(ImageSource.camera)),
                ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 20.0, horizontal: 24.0),
                    title: Text("Pick from the gallery"),
                    leading: Icon(Icons.photo),
                    onTap: () async => _pickImage(ImageSource.gallery))
              ],
            ));
  }

  void _pickImage(ImageSource imageSource) {
    Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext ctx) => CropScreen(
              imageSource: imageSource,
            )));
  }
}
