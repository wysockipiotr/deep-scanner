import 'package:ae_scanner/model/saved_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Gallery extends StatelessWidget {

  final List<SavedScan> scans;

  Gallery({this.scans});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        mainAxisSpacing: .5,
        crossAxisSpacing: .5,
        children: this.scans
            .map(
              (SavedScan scan) => Card(
                elevation: 2.0,
                child: InkWell(
                  onTap: () {},
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    child: Image.file(scan.scanFile, fit: BoxFit.cover,),
                  ),
                ),
              ),
            )
            .toList());
  }
}
