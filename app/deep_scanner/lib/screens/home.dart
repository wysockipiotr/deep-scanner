import 'package:deep_scanner/config.dart' as config;
import 'package:deep_scanner/screens/about.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          config.appTitle,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text("HomeScreen"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
//          Scaffold.of(context).showBottomSheet((context) => FlatButton(onPressed: null, child: Text("XD")));
          showModalBottomSheet(
              context: context,
              builder: (context) => Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                            title: Text("Take a photo"),
                            leading: Icon(Icons.photo_camera),
                            onTap: () async => _pickImage(ImageSource.camera)),
                        ListTile(
                            title: Text("Pick from the gallery"),
                            leading: Icon(Icons.image),
                            onTap: () async => _pickImage(ImageSource.gallery))
                      ],
                    ),
                  ));
        },
        child: Icon(Icons.add_a_photo),
        tooltip: "Pick an image",
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  BottomAppBar _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      child: Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.only(left: 4.0),
              child: PopupMenuButton(
                onSelected: (selection) => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AboutScreen())),
                icon: Icon(Icons.more_vert),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      value: "about",
                      child: Text("About"),
                    )
                  ];
                },
              ))
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      color: Theme.of(context).primaryColor,
    );
  }

  void _pickImage(ImageSource source) async {
    final file = await ImagePicker.pickImage(source: source);
    print(file.path);
  }
}
