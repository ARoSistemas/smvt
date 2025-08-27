import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

import 'core/network/dts_api_call.dart';

import 'app/config/themes/themedata.dart';

import 'app/data/datasources/local/dts_user_pref.dart';

import 'app/data/implementations/impl_api_conn.dart';
import 'app/data/implementations/cmd_stream_impl.dart';

import 'app/domain/repositories/repository_api_conn.dart';
import 'app/domain/repositories/cmd_stream_repository.dart';

import 'app/presentation/pages/loading/page_loading.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    // DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  /// Inicializa el repositorio de comandos
  final stream = CmdStreamImpl();

  /// Inicializa las preferencias de usuario
  UserPref userPrefs = UserPref();
  await userPrefs.initPrefs();

  /// Create Cliente http instance
  Client client = Client();

  /// get enviroment app
  String environment = userPrefs.environment;

  /// Initialize repository's connectivity with API
  ApiCall apiCall = ApiCall(client, environment, userPrefs);

  /// Initialize repository's
  ApiConnRepository apiConnRepository = APIConnImpl(apiCall);

  runApp(MyApp(stream: stream, apiConnRepository: apiConnRepository));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.stream,
    required this.apiConnRepository,
  });

  final CmdStreamImpl stream;
  final ApiConnRepository apiConnRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<CmdStreamRepository>(create: (_) => stream),
        Provider<ApiConnRepository>(create: (_) => apiConnRepository),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ControlBIn - Tanques',
        theme: lightTheme,
        home: const LoadingPage(),
      ),
    );
  }
}
