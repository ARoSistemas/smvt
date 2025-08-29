import 'dart:io';
import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as ruta;

import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import '../../../domain/entities/models/mdl_lectura.dart';
import '../../../domain/entities/models/mdl_ticket.dart';

class DbSQfLite {
  static Database? _database;

  static final DbSQfLite db = DbSQfLite._();

  DbSQfLite._();

  /// Returns the database instance, initializing it if necessary.
  Future<Database> get database async => _database ??= await initDB();

  /// Init Class
  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = ruta.join(documentsDirectory.path, 'tanques.db');

    return await openDatabase(
      path,
      version: 3,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute('''
          CREATE TABLE tickets(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            uuid TEXT NOT NULL,
            date TEXT NOT NULL,
            product TEXT NOT NULL,
            cmVacuumInit INTEGER NOT NULL,
            cmVolumeInit INTEGER NOT NULL,
            percentageVacuumInit TEXT NOT NULL,
            percentageVolumeInit TEXT NOT NULL,
            ltsToFillInit TEXT NOT NULL,
            ltsCurrentInit TEXT NOT NULL,
            cmVacuumEnd INTEGER NOT NULL,
            cmVolumeEnd INTEGER NOT NULL,
            percentageVacuumEnd TEXT NOT NULL,
            percentageVolumeEnd TEXT NOT NULL,
            ltsToFillEnd TEXT NOT NULL,
            ltsCurrentEnd TEXT NOT NULL,
            typeTicket TEXT NOT NULL,
            isSend INTEGER NOT NULL
          )''');

        await db.execute('''
          CREATE TABLE tablaniveles(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            cms INTEGER,
            cubic TEXT NOT NULL,
            liters TEXT NOT NULL            
          )''');
      },
    );
  }

  /// ******************************************
  /// Table Cms
  /// ******************************************
  Future<int> getTotalNiveles() async {
    Database db = await database;
    List<Map<String, Object?>> res = await db.rawQuery(
      'SELECT COUNT(*) AS count FROM tablaniveles',
    );
    return Sqflite.firstIntValue(res) ?? 0;
  }

  ///  Delete table: Niveles
  /// * Only for updates From API+
  Future<bool> clearDataNivel() async {
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

  /// gets data from nivel
  Future<Lectura> fetchDataNivel(int cms) async {
    Database db = await database;
    List<Map<String, Object?>> res = await db.query(
      'tablaniveles',
      where: 'cms = ?',
      whereArgs: [cms],
    );
    return res.isNotEmpty
        ? Lectura.fromJsonRaw(res.first).copyWith(cms: cms)
        : Lectura.empty();
  }

  /// ******************************************
  ///  Table Lecturas
  /// ******************************************

  /// Adds a new ticket to the database.
  Future<int> saveTicket(Ticket data) async {
    Database db = await database;
    int res = await db.insert('tickets', {
      'uuid': data.uuid,
      'date': data.date,
      'product': data.product,
      'cmVacuumInit': data.cmVacuumInit,
      'cmVolumeInit': data.cmVolumeInit,
      'percentageVacuumInit': data.percentageVacuumInit,
      'percentageVolumeInit': data.percentageVolumeInit,
      'ltsToFillInit': data.ltsToFillInit,
      'ltsCurrentInit': data.ltsCurrentInit,
      'cmVacuumEnd': data.cmVacuumEnd,
      'cmVolumeEnd': data.cmVolumeEnd,
      'percentageVacuumEnd': data.percentageVacuumEnd,
      'percentageVolumeEnd': data.percentageVolumeEnd,
      'ltsToFillEnd': data.ltsToFillEnd,
      'ltsCurrentEnd': data.ltsCurrentEnd,
      'typeTicket': data.typeTicket,
      'isSend': 0,
    });
    return res;
  }

  /// Update row if was send ok
  Future<int> updateTicket(String uuid) async {
    Database db = await database;

    int res = await db.update(
      'tickets',
      {'isSend': 1},
      where: 'uuid = ?',
      whereArgs: [uuid],
    );

    return res;
  }

  /// Fetches a ticket from the database.
  Future<Ticket> fetchTicket(String uuid) async {
    Database db = await database;
    List<Map<String, Object?>> res = await db.query(
      'tickets',
      where: 'uuid = ?',
      whereArgs: [uuid],
    );
    return res.isNotEmpty
        ? Ticket.fromMap(res.first).copyWith(uuid: uuid)
        : Ticket.empty();
  }

  /// Fetches last 30 tickets from the database.
  Future<List<Ticket>> fetchLastTickets() async {
    Database db = await database;
    List<Map<String, Object?>> res = await db.query(
      'tickets',
      orderBy: 'id DESC',
      limit: 20,
    );
    return res.isNotEmpty ? res.map((e) => Ticket.fromMap(e)).toList() : [];
  }

  // Future<void> delDatabaseFirstRun() async {
  //   Directory documentsDirectory = await getApplicationDocumentsDirectory();
  //   String path = ruta.join(documentsDirectory.path, 'tanques.db');

  //   if (await databaseExists(path)) {
  //     await deleteDatabase(path);
  //   }
  // }

  /// Adds a new row to the table Niveles.
  Future<bool> insertNiveles() async {
    Database db = await database;
    bool ret = false;

    final List<Map<String, dynamic>> nivelesData = [
      {'cms': 1, 'cubic': '0.01', 'liters': '15'},
      {'cms': 2, 'cubic': '0.04', 'liters': '42'},
      {'cms': 3, 'cubic': '0.08', 'liters': '78'},
      {'cms': 4, 'cubic': '0.12', 'liters': '119'},
      {'cms': 5, 'cubic': '0.17', 'liters': '167'},
      {'cms': 6, 'cubic': '0.22', 'liters': '219'},
      {'cms': 7, 'cubic': '0.28', 'liters': '275'},
      {'cms': 8, 'cubic': '0.34', 'liters': '336'},
      {'cms': 9, 'cubic': '0.40', 'liters': '401'},
      {'cms': 10, 'cubic': '0.47', 'liters': '469'},
      {'cms': 11, 'cubic': '0.54', 'liters': '540'},
      {'cms': 12, 'cubic': '0.62', 'liters': '615'},
      {'cms': 13, 'cubic': '0.69', 'liters': '693'},
      {'cms': 14, 'cubic': '0.77', 'liters': '774'},
      {'cms': 15, 'cubic': '0.86', 'liters': '857'},
      {'cms': 16, 'cubic': '0.94', 'liters': '943'},
      {'cms': 17, 'cubic': '1.03', 'liters': '1032'},
      {'cms': 18, 'cubic': '1.12', 'liters': '1123'},
      {'cms': 19, 'cubic': '1.22', 'liters': '1217'},
      {'cms': 20, 'cubic': '1.31', 'liters': '1313'},
      {'cms': 21, 'cubic': '1.41', 'liters': '1411'},
      {'cms': 22, 'cubic': '1.51', 'liters': '1511'},
      {'cms': 23, 'cubic': '1.61', 'liters': '1614'},
      {'cms': 24, 'cubic': '1.72', 'liters': '1718'},
      {'cms': 25, 'cubic': '1.82', 'liters': '1825'},
      {'cms': 26, 'cubic': '1.93', 'liters': '1933'},
      {'cms': 27, 'cubic': '2.04', 'liters': '2044'},
      {'cms': 28, 'cubic': '2.16', 'liters': '2156'},
      {'cms': 29, 'cubic': '2.27', 'liters': '2270'},
      {'cms': 30, 'cubic': '2.38', 'liters': '2386'},
      {'cms': 31, 'cubic': '2.50', 'liters': '2503'},
      {'cms': 32, 'cubic': '2.62', 'liters': '2623'},
      {'cms': 33, 'cubic': '2.74', 'liters': '2744'},
      {'cms': 34, 'cubic': '2.87', 'liters': '2866'},
      {'cms': 35, 'cubic': '2.99', 'liters': '2990'},
      {'cms': 36, 'cubic': '3.12', 'liters': '3116'},
      {'cms': 37, 'cubic': '3.24', 'liters': '3243'},
      {'cms': 38, 'cubic': '3.37', 'liters': '3372'},
      {'cms': 39, 'cubic': '3.50', 'liters': '3502'},
      {'cms': 40, 'cubic': '3.63', 'liters': '3633'},
      {'cms': 41, 'cubic': '3.77', 'liters': '3766'},
      {'cms': 42, 'cubic': '3.90', 'liters': '3901'},
      {'cms': 43, 'cubic': '4.04', 'liters': '4036'},
      {'cms': 44, 'cubic': '4.17', 'liters': '4173'},
      {'cms': 45, 'cubic': '4.31', 'liters': '4312'},
      {'cms': 46, 'cubic': '4.45', 'liters': '4451'},
      {'cms': 47, 'cubic': '4.59', 'liters': '4592'},
      {'cms': 48, 'cubic': '4.73', 'liters': '4734'},
      {'cms': 49, 'cubic': '4.88', 'liters': '4877'},
      {'cms': 50, 'cubic': '5.02', 'liters': '5022'},
      {'cms': 51, 'cubic': '5.17', 'liters': '5167'},
      {'cms': 52, 'cubic': '5.31', 'liters': '5314'},
      {'cms': 53, 'cubic': '5.46', 'liters': '5462'},
      {'cms': 54, 'cubic': '5.61', 'liters': '5610'},
      {'cms': 55, 'cubic': '5.76', 'liters': '5760'},
      {'cms': 56, 'cubic': '5.91', 'liters': '5912'},
      {'cms': 57, 'cubic': '6.06', 'liters': '6064'},
      {'cms': 58, 'cubic': '6.22', 'liters': '6217'},
      {'cms': 59, 'cubic': '6.37', 'liters': '6371'},
      {'cms': 60, 'cubic': '6.53', 'liters': '6526'},
      {'cms': 61, 'cubic': '6.68', 'liters': '6682'},
      {'cms': 62, 'cubic': '6.84', 'liters': '6839'},
      {'cms': 63, 'cubic': '7.00', 'liters': '6997'},
      {'cms': 64, 'cubic': '7.16', 'liters': '7156'},
      {'cms': 65, 'cubic': '7.32', 'liters': '7316'},
      {'cms': 66, 'cubic': '7.48', 'liters': '7476'},
      {'cms': 67, 'cubic': '7.64', 'liters': '7638'},
      {'cms': 68, 'cubic': '7.80', 'liters': '7800'},
      {'cms': 69, 'cubic': '7.96', 'liters': '7964'},
      {'cms': 70, 'cubic': '8.13', 'liters': '8128'},
      {'cms': 71, 'cubic': '8.29', 'liters': '8293'},
      {'cms': 72, 'cubic': '8.46', 'liters': '8458'},
      {'cms': 73, 'cubic': '8.62', 'liters': '8625'},
      {'cms': 74, 'cubic': '8.79', 'liters': '8792'},
      {'cms': 75, 'cubic': '8.96', 'liters': '8960'},
      {'cms': 76, 'cubic': '9.13', 'liters': '9129'},
      {'cms': 77, 'cubic': '9.30', 'liters': '9298'},
      {'cms': 78, 'cubic': '9.47', 'liters': '9468'},
      {'cms': 79, 'cubic': '9.64', 'liters': '9639'},
      {'cms': 80, 'cubic': '9.81', 'liters': '9811'},
      {'cms': 81, 'cubic': '9.98', 'liters': '9983'},
      {'cms': 82, 'cubic': '10.16', 'liters': '10156'},
      {'cms': 83, 'cubic': '10.33', 'liters': '10330'},
      {'cms': 84, 'cubic': '10.50', 'liters': '10504'},
      {'cms': 85, 'cubic': '10.68', 'liters': '10679'},
      {'cms': 86, 'cubic': '10.85', 'liters': '10855'},
      {'cms': 87, 'cubic': '11.03', 'liters': '11031'},
      {'cms': 88, 'cubic': '11.21', 'liters': '11208'},
      {'cms': 89, 'cubic': '11.38', 'liters': '11385'},
      {'cms': 90, 'cubic': '11.56', 'liters': '11563'},
      {'cms': 91, 'cubic': '11.74', 'liters': '11741'},
      {'cms': 92, 'cubic': '11.92', 'liters': '11920'},
      {'cms': 93, 'cubic': '12.10', 'liters': '12100'},
      {'cms': 94, 'cubic': '12.28', 'liters': '12280'},
      {'cms': 95, 'cubic': '12.46', 'liters': '12460'},
      {'cms': 96, 'cubic': '12.64', 'liters': '12642'},
      {'cms': 97, 'cubic': '12.82', 'liters': '12823'},
      {'cms': 98, 'cubic': '13.01', 'liters': '13005'},
      {'cms': 99, 'cubic': '13.19', 'liters': '13188'},
      {'cms': 100, 'cubic': '13.37', 'liters': '13371'},
      {'cms': 101, 'cubic': '13.55', 'liters': '13554'},
      {'cms': 102, 'cubic': '13.74', 'liters': '13738'},
      {'cms': 103, 'cubic': '13.92', 'liters': '13923'},
      {'cms': 104, 'cubic': '14.11', 'liters': '14107'},
      {'cms': 105, 'cubic': '14.29', 'liters': '14293'},
      {'cms': 106, 'cubic': '14.48', 'liters': '14478'},
      {'cms': 107, 'cubic': '14.66', 'liters': '14664'},
      {'cms': 108, 'cubic': '14.85', 'liters': '14851'},
      {'cms': 109, 'cubic': '15.04', 'liters': '15037'},
      {'cms': 110, 'cubic': '15.22', 'liters': '15225'},
      {'cms': 111, 'cubic': '15.41', 'liters': '15412'},
      {'cms': 112, 'cubic': '15.60', 'liters': '15600'},
      {'cms': 113, 'cubic': '15.79', 'liters': '15788'},
      {'cms': 114, 'cubic': '15.98', 'liters': '15977'},
      {'cms': 115, 'cubic': '16.17', 'liters': '16165'},
      {'cms': 116, 'cubic': '16.35', 'liters': '16354'},
      {'cms': 117, 'cubic': '16.54', 'liters': '16544'},
      {'cms': 118, 'cubic': '16.73', 'liters': '16734'},
      {'cms': 119, 'cubic': '16.92', 'liters': '16924'},
      {'cms': 120, 'cubic': '17.11', 'liters': '17114'},
      {'cms': 121, 'cubic': '17.30', 'liters': '17304'},
      {'cms': 122, 'cubic': '17.50', 'liters': '17495'},
      {'cms': 123, 'cubic': '17.69', 'liters': '17686'},
      {'cms': 124, 'cubic': '17.88', 'liters': '17877'},
      {'cms': 125, 'cubic': '18.07', 'liters': '18069'},
      {'cms': 126, 'cubic': '18.26', 'liters': '18260'},
      {'cms': 127, 'cubic': '18.45', 'liters': '18452'},
      {'cms': 128, 'cubic': '18.64', 'liters': '18644'},
      {'cms': 129, 'cubic': '18.84', 'liters': '18837'},
      {'cms': 130, 'cubic': '19.03', 'liters': '19029'},
      {'cms': 131, 'cubic': '19.22', 'liters': '19222'},
      {'cms': 132, 'cubic': '19.41', 'liters': '19415'},
      {'cms': 133, 'cubic': '19.61', 'liters': '19608'},
      {'cms': 134, 'cubic': '19.80', 'liters': '19801'},
      {'cms': 135, 'cubic': '19.99', 'liters': '19994'},
      {'cms': 136, 'cubic': '20.19', 'liters': '20187'},
      {'cms': 137, 'cubic': '20.38', 'liters': '20381'},
      {'cms': 138, 'cubic': '20.57', 'liters': '20574'},
      {'cms': 139, 'cubic': '20.77', 'liters': '20768'},
      {'cms': 140, 'cubic': '20.96', 'liters': '20962'},
      {'cms': 141, 'cubic': '21.15', 'liters': '21155'},
      {'cms': 142, 'cubic': '21.35', 'liters': '21349'},
      {'cms': 143, 'cubic': '21.54', 'liters': '21543'},
      {'cms': 144, 'cubic': '21.74', 'liters': '21737'},
      {'cms': 145, 'cubic': '21.93', 'liters': '21931'},
      {'cms': 146, 'cubic': '22.13', 'liters': '22125'},
      {'cms': 147, 'cubic': '22.32', 'liters': '22320'},
      {'cms': 148, 'cubic': '22.51', 'liters': '22514'},
      {'cms': 149, 'cubic': '22.71', 'liters': '22708'},
      {'cms': 150, 'cubic': '22.90', 'liters': '22902'},
      {'cms': 151, 'cubic': '23.10', 'liters': '23096'},
      {'cms': 152, 'cubic': '23.30', 'liters': '23300'},
      {'cms': 153, 'cubic': '23.48', 'liters': '23485'},
      {'cms': 154, 'cubic': '23.68', 'liters': '23679'},
      {'cms': 155, 'cubic': '23.87', 'liters': '23873'},
      {'cms': 156, 'cubic': '24.07', 'liters': '24067'},
      {'cms': 157, 'cubic': '24.26', 'liters': '24261'},
      {'cms': 158, 'cubic': '24.45', 'liters': '24455'},
      {'cms': 159, 'cubic': '24.65', 'liters': '24648'},
      {'cms': 160, 'cubic': '24.84', 'liters': '24842'},
      {'cms': 161, 'cubic': '25.04', 'liters': '25036'},
      {'cms': 162, 'cubic': '25.23', 'liters': '25229'},
      {'cms': 163, 'cubic': '25.42', 'liters': '25423'},
      {'cms': 164, 'cubic': '25.62', 'liters': '25616'},
      {'cms': 165, 'cubic': '25.81', 'liters': '25809'},
      {'cms': 166, 'cubic': '26.00', 'liters': '26002'},
      {'cms': 167, 'cubic': '26.20', 'liters': '26195'},
      {'cms': 168, 'cubic': '26.39', 'liters': '26388'},
      {'cms': 169, 'cubic': '26.58', 'liters': '26580'},
      {'cms': 170, 'cubic': '26.77', 'liters': '26773'},
      {'cms': 171, 'cubic': '26.97', 'liters': '26965'},
      {'cms': 172, 'cubic': '27.16', 'liters': '27157'},
      {'cms': 173, 'cubic': '27.35', 'liters': '27349'},
      {'cms': 174, 'cubic': '27.54', 'liters': '27541'},
      {'cms': 175, 'cubic': '27.73', 'liters': '27732'},
      {'cms': 176, 'cubic': '27.92', 'liters': '27923'},
      {'cms': 177, 'cubic': '28.11', 'liters': '28114'},
      {'cms': 178, 'cubic': '28.30', 'liters': '28305'},
      {'cms': 179, 'cubic': '28.50', 'liters': '28495'},
      {'cms': 180, 'cubic': '28.69', 'liters': '28685'},
      {'cms': 181, 'cubic': '28.88', 'liters': '28875'},
      {'cms': 182, 'cubic': '29.06', 'liters': '29065'},
      {'cms': 183, 'cubic': '29.25', 'liters': '29254'},
      {'cms': 184, 'cubic': '29.44', 'liters': '29443'},
      {'cms': 185, 'cubic': '29.63', 'liters': '29632'},
      {'cms': 186, 'cubic': '29.82', 'liters': '29820'},
      {'cms': 187, 'cubic': '30.01', 'liters': '30008'},
      {'cms': 188, 'cubic': '30.20', 'liters': '30196'},
      {'cms': 189, 'cubic': '30.38', 'liters': '30384'},
      {'cms': 190, 'cubic': '30.57', 'liters': '30571'},
      {'cms': 191, 'cubic': '30.76', 'liters': '30757'},
      {'cms': 192, 'cubic': '30.94', 'liters': '30944'},
      {'cms': 193, 'cubic': '31.13', 'liters': '31129'},
      {'cms': 194, 'cubic': '31.32', 'liters': '31315'},
      {'cms': 195, 'cubic': '31.50', 'liters': '31500'},
      {'cms': 196, 'cubic': '31.68', 'liters': '31685'},
      {'cms': 197, 'cubic': '31.87', 'liters': '31869'},
      {'cms': 198, 'cubic': '32.05', 'liters': '32053'},
      {'cms': 199, 'cubic': '32.24', 'liters': '32236'},
      {'cms': 200, 'cubic': '32.42', 'liters': '32419'},
      {'cms': 201, 'cubic': '32.60', 'liters': '32602'},
      {'cms': 202, 'cubic': '32.78', 'liters': '32784'},
      {'cms': 203, 'cubic': '32.96', 'liters': '32965'},
      {'cms': 204, 'cubic': '33.15', 'liters': '33146'},
      {'cms': 205, 'cubic': '33.33', 'liters': '33326'},
      {'cms': 206, 'cubic': '33.51', 'liters': '33506'},
      {'cms': 207, 'cubic': '33.69', 'liters': '33686'},
      {'cms': 208, 'cubic': '33.86', 'liters': '33865'},
      {'cms': 209, 'cubic': '34.04', 'liters': '34043'},
      {'cms': 210, 'cubic': '34.22', 'liters': '34221'},
      {'cms': 211, 'cubic': '34.40', 'liters': '34398'},
      {'cms': 212, 'cubic': '34.57', 'liters': '34574'},
      {'cms': 213, 'cubic': '34.75', 'liters': '34750'},
      {'cms': 214, 'cubic': '34.93', 'liters': '34926'},
      {'cms': 215, 'cubic': '35.10', 'liters': '35101'},
      {'cms': 216, 'cubic': '35.27', 'liters': '35275'},
      {'cms': 217, 'cubic': '35.45', 'liters': '35448'},
      {'cms': 218, 'cubic': '35.62', 'liters': '35621'},
      {'cms': 219, 'cubic': '35.79', 'liters': '35793'},
      {'cms': 220, 'cubic': '35.96', 'liters': '35964'},
      {'cms': 221, 'cubic': '36.14', 'liters': '36135'},
      {'cms': 222, 'cubic': '36.31', 'liters': '36305'},
      {'cms': 223, 'cubic': '36.47', 'liters': '36474'},
      {'cms': 224, 'cubic': '36.64', 'liters': '36643'},
      {'cms': 225, 'cubic': '36.81', 'liters': '36811'},
      {'cms': 226, 'cubic': '36.98', 'liters': '36978'},
      {'cms': 227, 'cubic': '37.14', 'liters': '37144'},
      {'cms': 228, 'cubic': '37.31', 'liters': '37310'},
      {'cms': 229, 'cubic': '37.47', 'liters': '37474'},
      {'cms': 230, 'cubic': '37.64', 'liters': '37638'},
      {'cms': 231, 'cubic': '37.80', 'liters': '37801'},
      {'cms': 232, 'cubic': '37.96', 'liters': '37963'},
      {'cms': 233, 'cubic': '38.12', 'liters': '38125'},
      {'cms': 234, 'cubic': '38.29', 'liters': '38285'},
      {'cms': 235, 'cubic': '38.44', 'liters': '38445'},
      {'cms': 236, 'cubic': '38.60', 'liters': '38603'},
      {'cms': 237, 'cubic': '38.76', 'liters': '38761'},
      {'cms': 238, 'cubic': '38.92', 'liters': '38918'},
      {'cms': 239, 'cubic': '39.07', 'liters': '39074'},
      {'cms': 240, 'cubic': '39.23', 'liters': '39229'},
      {'cms': 241, 'cubic': '39.38', 'liters': '39382'},
      {'cms': 242, 'cubic': '39.54', 'liters': '39535'},
      {'cms': 243, 'cubic': '39.69', 'liters': '39687'},
      {'cms': 244, 'cubic': '39.84', 'liters': '39838'},
      {'cms': 245, 'cubic': '39.99', 'liters': '39987'},
      {'cms': 246, 'cubic': '40.14', 'liters': '40136'},
      {'cms': 247, 'cubic': '40.28', 'liters': '40284'},
      {'cms': 248, 'cubic': '40.43', 'liters': '40430'},
      {'cms': 249, 'cubic': '40.58', 'liters': '40575'},
      {'cms': 250, 'cubic': '40.72', 'liters': '40719'},
      {'cms': 251, 'cubic': '40.86', 'liters': '40862'},
      {'cms': 252, 'cubic': '41.00', 'liters': '41004'},
      {'cms': 253, 'cubic': '41.14', 'liters': '41144'},
      {'cms': 254, 'cubic': '41.28', 'liters': '41283'},
      {'cms': 255, 'cubic': '41.42', 'liters': '41421'},
      {'cms': 256, 'cubic': '41.56', 'liters': '41558'},
      {'cms': 257, 'cubic': '41.69', 'liters': '41693'},
      {'cms': 258, 'cubic': '41.83', 'liters': '41827'},
      {'cms': 259, 'cubic': '41.96', 'liters': '41959'},
      {'cms': 260, 'cubic': '42.09', 'liters': '42091'},
      {'cms': 261, 'cubic': '42.22', 'liters': '42221'},
      {'cms': 262, 'cubic': '42.35', 'liters': '42349'},
      {'cms': 263, 'cubic': '42.48', 'liters': '42476'},
      {'cms': 264, 'cubic': '42.60', 'liters': '42601'},
      {'cms': 265, 'cubic': '42.72', 'liters': '42725'},
      {'cms': 266, 'cubic': '42.85', 'liters': '42847'},
      {'cms': 267, 'cubic': '42.97', 'liters': '42967'},
      {'cms': 268, 'cubic': '43.09', 'liters': '43086'},
      {'cms': 269, 'cubic': '43.20', 'liters': '43203'},
      {'cms': 270, 'cubic': '43.32', 'liters': '43319'},
      {'cms': 271, 'cubic': '43.43', 'liters': '43432'},
      {'cms': 272, 'cubic': '43.54', 'liters': '43544'},
      {'cms': 273, 'cubic': '43.65', 'liters': '43654'},
      {'cms': 274, 'cubic': '43.76', 'liters': '43762'},
      {'cms': 275, 'cubic': '43.87', 'liters': '43868'},
      {'cms': 276, 'cubic': '43.97', 'liters': '43972'},
      {'cms': 277, 'cubic': '44.07', 'liters': '44074'},
      {'cms': 278, 'cubic': '44.17', 'liters': '44174'},
      {'cms': 279, 'cubic': '44.27', 'liters': '44271'},
      {'cms': 280, 'cubic': '44.37', 'liters': '44366'},
      {'cms': 281, 'cubic': '44.46', 'liters': '44459'},
      {'cms': 282, 'cubic': '44.55', 'liters': '44550'},
      {'cms': 283, 'cubic': '44.64', 'liters': '44638'},
      {'cms': 284, 'cubic': '44.72', 'liters': '44723'},
      {'cms': 285, 'cubic': '44.81', 'liters': '44806'},
      {'cms': 286, 'cubic': '44.89', 'liters': '44886'},
      {'cms': 287, 'cubic': '44.96', 'liters': '44963'},
      {'cms': 288, 'cubic': '45.04', 'liters': '45037'},
      {'cms': 289, 'cubic': '45.11', 'liters': '45107'},
      {'cms': 290, 'cubic': '45.17', 'liters': '45175'},
      {'cms': 291, 'cubic': '45.24', 'liters': '45238'},
      {'cms': 292, 'cubic': '45.30', 'liters': '45298'},
      {'cms': 293, 'cubic': '45.35', 'liters': '45353'},
      {'cms': 294, 'cubic': '45.40', 'liters': '45404'},
      {'cms': 295, 'cubic': '45.45', 'liters': '45450'},
      {'cms': 296, 'cubic': '45.49', 'liters': '45490'},
      {'cms': 297, 'cubic': '45.52', 'liters': '45524'},
      {'cms': 298, 'cubic': '45.55', 'liters': '45548'},
      {'cms': 299, 'cubic': '45.56', 'liters': '45558'},
    ];

    try {
      for (final Map<String, dynamic> nivel in nivelesData) {
        await db.insert(
          'tablaniveles',
          nivel,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
      ret = true;
    } catch (e) {
      // print('Error al insertar datos en la tabla tablaniveles: $e');
    }
    return ret;
  }
}
