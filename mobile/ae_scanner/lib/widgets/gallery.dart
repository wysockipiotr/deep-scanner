import 'package:ae_scanner/model/saved_scan.dart';
import 'package:ae_scanner/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

class Gallery extends StatelessWidget {
  final List<SavedScan> scans;

  Gallery({this.scans});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: .5,
        crossAxisSpacing: .5,
        children: this.scans.map(
          (SavedScan scan) {
            return Card(
              elevation: 2.0,
              child: Ink.image(
                image: FileImage(scan.scanFile),
                fit: BoxFit.cover,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => DetailsScreen(
                              imageName: p.basename(scan.scanFile.path),
                              imageProvider: FileImage(scan.scanFile),
                            )));
                  },
                ),
              ),
            );
          },
        ).toList());
  }
}
