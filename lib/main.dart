import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'app/config/themes/themedata.dart';
import 'app/data/implementations/cmd_stream_impl.dart';
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

  // TODO: Obtener el nombre del puerto serial desde API/shared preferences
  const String portName =
      'COM3'; // <-- Cambiar por valor dinámico en producción
  final stream = CmdStreamImpl(portName: portName);

  runApp(MyApp(stream: stream));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.stream});

  final CmdStreamImpl stream;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<CmdStreamRepository>(create: (_) => stream)],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ControlBIn - Tanques',
        theme: lightTheme,
        home: const LoadingPage(),
      ),
    );
  }
}
