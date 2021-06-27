import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';
import 'package:path/path.dart';

class SembastDatabase{
  static final String DB_NAME = 'sembast';

  Database _db;

  _initWebDatabase() async {
    var factory = databaseFactoryWeb;

    // Open the database
    this._db = await factory.openDatabase(DB_NAME);
  }

  _initNativeDatabase() async {
    var dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    String dbPath = join(dir.path, DB_NAME);

    this._db = await databaseFactoryIo.openDatabase(dbPath);
  }

  initDatabase() async {
    if (kIsWeb) {
      await _initWebDatabase();
    } else {
      await _initNativeDatabase();
    }
  }

  DatabaseClient getDatabase() {
    return this._db;
  }
}