import 'package:sqflite/sqflite.dart';

import '../entities/models/empresa.dart';
import '../entities/models/lectura.dart';

abstract class AuthRepository {
  Future<bool> get isSignedIn;

  /// Get the database instance
  Future<Database> getDatabase();

  /// Save Config empresa from EP on cache
  void saveEmpresa(String empresa, String direccion);

  /// get data Empresa from local DB
  Future<Empresa> getEmpresa();

  int capacidadTanqueCms();

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
