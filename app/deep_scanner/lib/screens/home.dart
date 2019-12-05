import 'dart:io';

import 'package:deep_scanner/config.dart' as config;
import 'package:deep_scanner/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ),
      body: FutureBuilder(
          future: _loadGallery(),
          builder:
              (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                snapshot.hasData) {
              return _buildGalleryView(context, snapshot.data);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        children: <Widget>[
          PopupMenuButton(
              onSelected: (_) => _pushAboutScreen(context),
              icon: Icon(Icons.more_vert),
              itemBuilder: (_) => [
                    PopupMenuItem(
                      value: "about",
                      child: Text("About"),
                    )
                  ])
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      color: Theme.of(context).primaryColor,
    );
  }

  FloatingActionButton _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
            context: context,
            builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 24.0),
                        title: Text("Take a photo"),
                        leading: Icon(Icons.photo_camera),
                        onTap: () async => _pickImage(ImageSource.camera)),
                    ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 24.0),
                        title: Text("Pick from the gallery"),
                        leading: Icon(Icons.image),
                        onTap: () async => _pickImage(ImageSource.gallery))
                  ],
                ));
      },
      child: Icon(Icons.add_a_photo),
      tooltip: "Pick an image",
    );
  }

  GridView _buildGalleryView(BuildContext context, List<String> paths) {
    return GridView.count(
        crossAxisCount: 3,
        children: paths
            .map((String path) => Image.file(
                  File(path),
                  fit: BoxFit.cover,
                ))
            .toList());
  }

  void _pushAboutScreen(BuildContext context) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => AboutScreen()));

  Future<List<String>> _loadGallery() async {
    final Directory applicationDirectory =
        await getApplicationDocumentsDirectory();
    final list = applicationDirectory.listSync();
    return list
        .where((FileSystemEntity item) =>
            [".jpg", ".png", ".jpeg"].contains(p.extension(item.path)))
        .map((item) => item.path)
        .toList();
  }

  void _pickImage(ImageSource source) async {
    Navigator.pop(context);
    final file = await ImagePicker.pickImage(source: source);
    final String baseName = p.basename(file.path);
    final String path = (await getApplicationDocumentsDirectory()).path;
    await file.copy(p.join(path, baseName));
    setState(() {});
  }
}
