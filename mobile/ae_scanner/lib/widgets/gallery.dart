import 'package:ae_scanner/core/saved_scan_provider.dart';
import 'package:ae_scanner/model/saved_scan.dart';
import 'package:ae_scanner/screens/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as p;

typedef OnDeleteScan = void Function(int id);

class Gallery extends StatelessWidget {
  final List<SavedScan> scans;
  final OnDeleteScan onDeleteScan;

  Gallery({this.scans, this.onDeleteScan});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children:
            scans.map((SavedScan scan) => _buildCard(context, scan)).toList());
  }

  Widget _buildCard(BuildContext ctx, SavedScan scan) => Card(
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        elevation: 2.0,
        child: GridTile(
          footer: GridTileBar(
            backgroundColor: Colors.white.withOpacity(0.8),
            trailing: IconButton(
              onPressed: () async {
                final provider = SavedScanProvider();
                await provider.open();
                await provider.delete(scan.id);
                await provider.close();
                onDeleteScan(scan.id);
              },
              color: Colors.black.withOpacity(0.6),
              icon: Icon(Icons.delete_outline),
            ),
            title: Text(
                p.basename(
                  scan.scanFile.path,
                ),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black.withOpacity(0.6),
                    fontSize: 12.0)),
          ),
          child: Ink.image(
            image: FileImage(scan.scanFile),
            fit: BoxFit.cover,
            child: InkWell(
              onTap: () {
                Navigator.of(ctx).push(MaterialPageRoute(
                    builder: (ctx) => DetailsScreen(
                          imageName: p.basename(scan.scanFile.path),
                          imageProvider: FileImage(scan.scanFile),
                        )));
              },
            ),
          ),
        ),
      );
}
