import 'package:flutter/material.dart' show ChangeNotifier;
import 'package:intl/intl.dart';

class GeneralProvider extends ChangeNotifier {
  GeneralProvider(this._formatterInit);

  final NumberFormat _formatterInit;

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String _errorMessage = '';
  String get errorMessage => _errorMessage;
  set errorMessage(String value) {
    _errorMessage = value;
    notifyListeners();
  }

  bool _isSuccess = false;
  bool get isSuccess => _isSuccess;
  set isSuccess(bool value) {
    _isSuccess = value;
    notifyListeners();
  }

  String _niveles = '';
  String get niveles => _niveles;
  set niveles(String value) {
    _niveles = value;
    notifyListeners();
  }

  String _empresa = '';
  String get empresa => _empresa;
  set empresa(String value) {
    _empresa = value;
    notifyListeners();
  }

  String _direccion = '';
  String get direccion => _direccion;
  set direccion(String value) {
    _direccion = value;
    notifyListeners();
  }

  int _capacityTankCms = 0;
  int get capacityTankCms => _capacityTankCms;
  set capacityTankCms(int value) {
    _capacityTankCms = value;
    notifyListeners();
  }

  int _capacityTankLiters = 0;
  int get capacityTankLiters => _capacityTankLiters;
  set capacityTankLiters(int value) {
    _capacityTankLiters = value;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';

    notifyListeners();
  }

  String formatNumber(int number) {
    return (number == 0) ? '0' : _formatterInit.format(number);
  }
}
