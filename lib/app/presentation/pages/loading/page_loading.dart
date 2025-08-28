import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/utils_transitions.dart';
import '../../../config/constans/cfg_my_enums.dart';
import '../../../config/themes/themedata.dart';
import '../../../domain/repositories/repository_auth.dart';
import '../home/home_page.dart';

class LoadingPage extends StatefulWidget {
  /// A page that shows a loading screen and performs initialization tasks.
  ///
  /// This page handles setting the theme, getting notification permissions, and
  /// checking internet connectivity and user authentication status. It navigates
  /// to appropriate pages based on the outcomes of these checks.
  ///
  /// ***Properties***:
  ///
  /// - `route`: The route to navigate to.
  /// - `_isNewNotifications`: A boolean indicating if there are new notifications.
  ///
  /// ***Example***:
  ///
  /// ```dart
  /// LoadingPage();
  /// ```
  ///
  /// The `LoadingPage` is typically used as a starting point for the app to perform
  /// necessary setup and then navigate to the main content or a sign-in page based
  /// on the user's authentication status.

  const LoadingPage({super.key});

  @override
  State<LoadingPage> createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  ///
  ///  Revisar las configuraciones al cargar.
  ///

  Future<void> _init() async {
    final auth = Provider.of<AuthRepository>(context, listen: false);
    final count = await auth.fetchTotalNiveles();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: primaryColor,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$count Niveles ',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
          ],
        ),
        duration: const Duration(seconds: 3),
      ),
    );

    /// Simulación de llamada a la API para obtener el nombre del puerto
    // final configData = await _fetchConfigData();
    // final String newPortName = configData['portName'] ?? 'COM3';

    /// Actualizar el puerto en CmdStreamImpl
    // final cmdStream = Provider.of<CmdStreamImpl>(context, listen: false);
    // cmdStream.updatePort(newPortName);

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
