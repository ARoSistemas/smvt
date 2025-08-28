import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/models/empresa.dart';
import '../../domain/entities/models/lectura.dart';
import '../../domain/repositories/repository_auth.dart';
import '../datasources/local/db_sqflite.dart';
import '../datasources/local/dts_user_pref.dart';

class AuthImp implements AuthRepository {
  final UserPref _userPref;
  final DbSQfLite _dataDbf;
  final Uuid uuid;

  AuthImp(this._userPref, this._dataDbf, this.uuid);

  @override
  Future<Database> getDatabase() async {
    return _dataDbf.database;
  }

  @override
  Future<bool> get isSignedIn async {
    return _userPref.empresa.isNotEmpty;
  }

  @override
  void saveEmpresa(String empresa, String direccion) {
    _userPref.empresa = empresa;
    _userPref.direccion = direccion;
  }

  @override
  Future<Empresa> getEmpresa() async {
    return Empresa(nombre: _userPref.empresa, direccion: _userPref.direccion);
  }

  @override
  int capacidadTanqueCms() {
    return _userPref.capacidadTanqueCms;
  }

  @override
  Future<int> addLectura(Lectura data) async {
    return _dataDbf.addLectura(data);
  }

  @override
  Future<bool> clearDataNivel() async {
    return _dataDbf.clearDataNivel();
  }

  @override
  Future<int> fetchTotalNiveles() async {
    return _dataDbf.getTotalNiveles();
  }

  @override
  Future<bool> insertNiveles() async {
    return _dataDbf.insertNiveles();
  }

  @override
  Future<Lectura> fetchDataNivel(int cms) async {
    return _dataDbf.fetchDataNivel(cms);
  }

  @override
  Future<Lectura> fetchLectura(String uuid) async {
    return _dataDbf.fetchLectura(uuid);
  }

  @override
  Future<int> updateLectura(String uuid) async {
    return _dataDbf.updateLectura(uuid);
  }

  @override
  Future<List<Lectura>> fetchLastLecturas() async {
    return _dataDbf.fetchLastLecturas();
  }

  @override
  String getUuid() {
    return uuid.v4();
  }

  ///
  ///
  ///
  ///
}
