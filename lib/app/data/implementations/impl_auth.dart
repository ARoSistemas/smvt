import 'package:uuid/uuid.dart';
import 'package:sqflite/sqflite.dart';

import '../datasources/local/db_sqflite.dart';
import '../datasources/local/dts_user_pref.dart';

import '../../domain/entities/models/mdl_empresa.dart';
import '../../domain/entities/models/mdl_lectura.dart';

import '../../domain/repositories/repository_auth.dart';

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
    return _userPref.customer.isNotEmpty;
  }

  @override
  void saveCustomer(String name, String address) {
    _userPref.customer = name;
    _userPref.address = address;
  }

  @override
  Customer fetchCustomer() {
    return Customer(name: _userPref.customer, address: _userPref.address);
  }

  @override
  int capacityTankCms() {
    return _userPref.capacidadTanqueCms;
  }

  @override
  int capacityTankLiters() {
    return _userPref.capacidadTanqueLitros;
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
