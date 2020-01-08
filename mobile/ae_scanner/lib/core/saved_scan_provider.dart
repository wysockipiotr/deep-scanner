import 'dart:io';
import 'dart:typed_data';

import 'package:ae_scanner/model/saved_scan.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SavedScanProvider {
  final tableName = "saved_scans";
  final dbName = "saved_scans";
  Database db;

  Future open() async {
    this.db = await openDatabase(
      p.join(await getDatabasesPath(), '$dbName.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE $tableName(id INTEGER PRIMARY KEY AUTOINCREMENT, scan_path TEXT NOT NULL, thumbnail_path TEXT NOT NULL)",
        );
      },
      version: 1,
    );
  }

  Future<SavedScan> insert(Uint8List bytes) async {
    Directory applicationDocumentsDir =
        await getApplicationDocumentsDirectory();
    String scanPath = p.join(applicationDocumentsDir.path,
        DateTime.now().millisecondsSinceEpoch.toString() + ".jpg");

    File(scanPath).writeAsBytesSync(bytes.toList());

    final id = await this
        .db
        .insert(tableName, {"scan_path": scanPath, "thumbnail_path": scanPath});

    return SavedScan.fromMap(
        {"id": id, "scan_path": scanPath, "thumbnail_path": scanPath});
  }

  Future<SavedScan> get(int id) async {
    List<Map> maps = await db.query(tableName,
        columns: ["id", "scan_path", "thumbnail_path"],
        where: 'id = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      return SavedScan.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    SavedScan scan = await get(id);
    await scan.scanFile.delete();
    return await db.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<SavedScan>> all() async => (await db.query(tableName))
      .map((Map<String, dynamic> map) => SavedScan.fromMap(map))
      .toList();

  Future close() async => db.close();
}
