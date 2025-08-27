import 'dart:io';
import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as ruta;

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DbSQfLite {
  static Database? _database;

  static final DbSQfLite db = DbSQfLite._();

  DbSQfLite._();

  /// Returns the database instance, initializing it if necessary.
  Future<Database> get database async => _database ??= await initDB();

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = ruta.join(documentsDirectory.path, 'tanques.db');

    return await openDatabase(
      path,
      version: 3,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE lecturas(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT NOT NULL,
            date TEXT NOT NULL,
            tipo TEXT NOT NULL,
            nivel TEXT NOT NULL,
            isSend INTEGER NOT NULL
          )''');

        await db.execute('''
          CREATE TABLE niveles(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            centimeters INTEGER,
            cubic TEXT NOT NULL,
            liters TEXT NOT NULL            
          )''');
      },
    );
  }

  /// Get the total count of lecturas in the database.
  Future<int> getTotalLecturas() async {
    Database db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM lecturas',
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  /// Adds a new lectura to the database.
  Future<int> addLectura(int id) async {
    Database db = await database;
    int res = await db.insert('lecturas', {
      'id': id,
      'date': DateTime.now().toString(),
      'code': 'QR_CODE_$id',
      'details': 'Details for QR_CODE_$id',
      'wasScan': 0,
    });
    return res;
  }

  /// Fetches a lectura from the database.
  Future<int> fetchLectura(int id) async {
    Database db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM lecturas WHERE id = ?',
      [id],
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  ///
  /// Table Cms
  ///

  Future<bool> fetchDataNivel() async {
    // Database db = await database;

    // List<Map<String, Object?>> comments = await db.query(
    //   'comments',
    //   where: 'idCode = ?',
    //   whereArgs: [code],
    // );

    // MdlRecordCode result = MdlRecordCode.empty().copyWith(
    //   code: code,
    //   listComments: comments.map((c) => c['comment'].toString()).toList(),
    // );

    return false;
  }

  Future<bool> delDataNivel() async {
    Database db = await database;

    try {
      await db.delete("niveles");
      await db.rawQuery("UPDATE SQLITE_SEQUENCE SET seq = 0 WHERE name=?", [
        'niveles',
      ]);
    } catch (e) {
      return false;
    }

    return true;
  }

  // Future<void> delDatabaseFirstRun() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = ruta.join(documentsDirectory.path, 'tanques.db');

  //   if (await databaseExists(path)) {
  //     await deleteDatabase(path);
  //   }
  // }
}
