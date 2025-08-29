import 'package:sqflite/sqflite.dart';

import '../entities/models/mdl_empresa.dart';
import '../entities/models/mdl_lectura.dart';

abstract class AuthRepository {
  Future<bool> get isSignedIn;

  /// Get the database instance
  Future<Database> getDatabase();

  /// Save Config customer from EP on cache
  void saveCustomer(String name, String address);

  /// get data Customer from local DB
  Customer fetchCustomer();

  /// Capacidad del tanque en centimetros
  int capacityTankCms();

  /// Capacidad del tanque en litros
  int capacityTankLiters();

  /// Clear Niveles data
  Future<bool> clearDataNivel();

  /// Clear Niveles data
  Future<int> fetchTotalNiveles();

  /// Save new data nivel on DBF
  Future<bool> insertNiveles();

  /// get data nivel from DBF
  Future<Lectura> fetchDataNivel(int cms);

  /// Adds a new lectura to the database.
  Future<int> addLectura(Lectura data);

  /// Update row if was send ok
  Future<int> updateLectura(String uuid);

  /// Fetches a lectura from the database.
  Future<Lectura> fetchLectura(String uuid);

  /// Fetches last 30 lecturas
  Future<List<Lectura>> fetchLastLecturas();

  String getUuid();

  ///
  ///
  ///
}
