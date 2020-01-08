import 'dart:io';

import 'package:path/path.dart' as p;

class SavedScan {
  int id;
  File scanFile;
  File thumbnailFile;

  get name => p.basenameWithoutExtension(scanFile.path);

  SavedScan({this.id, this.scanFile, this.thumbnailFile});

  Map<String, dynamic> toMap() => {
        "id": id,
        "scan_path": scanFile.path,
        "thumbnail_path": thumbnailFile.path,
      };

  SavedScan.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    scanFile = File(map["scan_path"]);
    thumbnailFile = File(map["thumbnail_path"]);
  }
}
