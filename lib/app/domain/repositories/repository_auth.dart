import 'package:sqflite/sqflite.dart';

import '../entities/models/mdl_empresa.dart';
import '../entities/models/mdl_lectura.dart';
import '../entities/models/mdl_ticket.dart';

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

  /// Adds a new ticket to the database.
  Future<int> saveTicket(Ticket data);

  /// Update row if was send ok
  Future<int> updateTicket(String uuid);

  /// Fetches a ticket from the database.
  Future<Ticket> fetchTicket(String uuid);

  /// Fetches last 30 tickets
  Future<List<Ticket>> fetchLastTickets();

  String getUuid();

  ///
  ///
  ///
}
