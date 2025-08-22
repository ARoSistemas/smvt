import 'package:flutter/material.dart' show ChangeNotifier;

class LoginProvider extends ChangeNotifier {
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

  String _email = '';
  String get email => _email;
  set email(String value) {
    _email = value;
    notifyListeners();
  }

  String _password = '';
  String get password => _password;
  set password(String value) {
    _password = value;
    notifyListeners();
  }

  Future<void> login() async {
    _isLoading = true;
    _isSuccess = false;
    _errorMessage = '';

    notifyListeners();

    try {
      // Simulamos un delay para mostrar el loading
      await Future.delayed(const Duration(milliseconds: 500));

      if (_email == 'demo@arosistemas.com' && _password == '123456') {
        _isSuccess = true;
      } else {
        _errorMessage = 'Email o contraseña incorrectos';
      }
    } catch (e) {
      _errorMessage = 'Error inesperado: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
