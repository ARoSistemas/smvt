import 'package:shared_preferences/shared_preferences.dart';

class UserPref {
  UserPref._internal();

  /// Singleton instance of `UserPref`.
  static final _instancia = UserPref._internal();

  /// Factory constructor to return the singleton instance.
  factory UserPref() => _instancia;

  late SharedPreferences _userPref;

  /// Initializes the shared preferences instance.
  ///
  /// This method must be called before accessing any preferences.
  Future<void> initPrefs() async {
    _userPref = await SharedPreferences.getInstance();
  }

  /// List of HTTP responses stored as strings.
  List<String> get resHttp => _userPref.getStringList('resHttp') ?? [];
  set resHttp(List<String> value) => _userPref.setStringList('resHttp', value);

  /// The current environment setting, defaulting to `qa`.
  String get environment => _userPref.getString('environment') ?? 'qa';
  set environment(String value) => _userPref.setString('environment', value);

  /// Whether the dark theme is enabled. Defaults to `true`.
  bool get themeApp => _userPref.getBool('themeApp') ?? true;
  set themeApp(bool value) => _userPref.setBool('themeApp', value);

  /// The mobile token.
  String get tkMovil => _userPref.getString('tkMovil') ?? '';
  set tkMovil(String value) => _userPref.setString('tkMovil', value);

  /// Nombre de la empresa
  String get customer => _userPref.getString('customer') ?? '';
  set customer(String value) => _userPref.setString('customer', value);

  /// Dirección de la empresa
  String get address => _userPref.getString('address') ?? '';
  set address(String value) => _userPref.setString('address', value);

  /// Capacidad del tanque en centimetros
  int get capacidadTanqueCms => _userPref.getInt('capacidadTanqueCms') ?? 299;
  set capacidadTanqueCms(int value) =>
      _userPref.setInt('capacidadTanqueCms', value);

  /// Capacidad del tanque en litros
  int get capacidadTanqueLitros =>
      _userPref.getInt('capacidadTanqueLitros') ?? 45558;
  set capacidadTanqueLitros(int value) =>
      _userPref.setInt('capacidadTanqueLitros', value);
}
