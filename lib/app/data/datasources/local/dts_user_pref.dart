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
  String get empresa => _userPref.getString('empresa') ?? '';
  set empresa(String value) => _userPref.setString('empresa', value);

  /// Dirección de la empresa
  String get direccion => _userPref.getString('direccion') ?? '';
  set direccion(String value) => _userPref.setString('direccion', value);
}
