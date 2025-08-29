import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../home/home_page.dart';
import '../../providers/general_provider.dart';

import '../../../config/constans/cfg_my_enums.dart';

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
    int count = await authImpl.fetchTotalNiveles();

    /// Se carga la tabla de las equivalencias de los niveles a cm y metros
    if (count <= 0) {
      await authImpl.insertNiveles();
      authImpl.saveCustomer('Estacion demo', 'Dirección demo');
      count = await authImpl.fetchTotalNiveles();
    }

    /// Cargo en el estado
    if (!mounted) return;

    /// Datos de los niveles cargados
    final provider = Provider.of<GeneralProvider>(context, listen: false);
    provider.niveles = count.toString();

    /// Datos de la empresa
    final customer = authImpl.fetchCustomer();
    provider.empresa = customer.name;
    provider.direccion = customer.address;

    /// Se obtiene la capacidad del tanque en centimetros
    provider.capacityTankCms = authImpl.capacityTankCms();
    provider.capacityTankLiters = authImpl.capacityTankLiters();

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
