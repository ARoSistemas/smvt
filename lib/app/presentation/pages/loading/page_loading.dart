import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';

import '../../../config/constans/cfg_my_enums.dart';
import '../../../config/themes/themedata.dart';

import '../../../domain/repositories/repository_auth.dart';

import '../../../../core/utils/utils_transitions.dart';

class LoadingPage extends StatefulWidget {
  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  Future<void> _init() async {
    /// Simulación de llamada a la API para obtener el nombre del puerto
    // final configData = await _fetchConfigData();

    /// Actualizar el puerto en CmdStreamImpl
    // final String newPortName = configData['portName'] ?? 'COM3';
    // final cmdStream = Provider.of<CmdStreamImpl>(context, listen: false);
    // cmdStream.updatePort(newPortName);

    final authImpl = Provider.of<AuthRepository>(context, listen: false);
    final count = await authImpl.fetchTotalNiveles();

    if (count <= 0) {
      // print('⭐ No hay datos en la tabla Niveles, insertando...');
      await authImpl.insertNiveles();
      authImpl.saveCustomer('Estacion demo', 'Dirección demo');
    } else {
      // print('⭐ Total de registros en la tabla Niveles: $fetchTotal');
    }

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Capacidad $count cms',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    if (!mounted) return;
    Navigator.of(context).pop();
    Navigator.of(context).push(
      ARoTransitions(
        transitionType: TransitionType.fade,
        duration: const Duration(milliseconds: 100),
        widget: const HomePage(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _init());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 70,
              width: 70,
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Cargando app...',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
