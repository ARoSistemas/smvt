import 'package:flutter/material.dart';
import 'package:smvt/app/presentation/pages/home/home_page.dart';

import '../../../../core/utils/utils_transitions.dart';
import '../../../config/constans/cfg_my_enums.dart';

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
    await Future.delayed(const Duration(seconds: 3), () {
      _init();
    });

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
