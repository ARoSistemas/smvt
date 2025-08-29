import 'dart:async';
import 'dart:math';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../../../config/themes/themedata.dart';

import '../../../../core/utils/aro_assets.dart';
import '../../../../core/widgets/wdgt_aro_image.dart';

import '../../../domain/repositories/cmd_stream_repository.dart';

class DescargaPage extends StatefulWidget {
  const DescargaPage({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  State<DescargaPage> createState() => _DescargaPageState();
}

class _DescargaPageState extends State<DescargaPage> {
  StreamSubscription<String>? _cmdSubscription;

  ///
  ///
  ///   Borrar este snipper
  ///
  ///

  /// Devuelve un número entero aleatorio entre 1 y 298, ambos inclusive.
  int getRandomNumber(bool isInit) {
    final random = Random();
    final randomNumber = isInit
        ? random.nextInt(198)
        : random.nextInt(100) + 198;

    return randomNumber + 1;
  }

  ///
  ///
  ///
  ///
  ///

  void _initStream() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cmdStream = Provider.of<CmdStreamRepository>(
        context,
        listen: false,
      );
      _cmdSubscription = cmdStream.cmdStreamListen.listen((cmd) {
        if (!mounted) return;
        if (ModalRoute.of(context)?.isCurrent == true) {
          /// Se continua con el proceso de descarga
          if (cmd.contains('accept')) {
            print('🌭 Se simula la lectura del tanque');
            cmdStream.cmdStreamSend.add(
              jsonEncode({'level': getRandomNumber(true)}),
            );

            cmdStream.cmdStreamSend.add('findescarga');
            Navigator.of(context).pop();
          }
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initStream();
    });
  }

  @override
  void dispose() {
    _cmdSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cmdStream = Provider.of<CmdStreamRepository>(context, listen: false);

    return Container(
      height: widget.height,
      width: widget.width,
      color: secondaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              '¿Terminar descarga?',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: widget.height * 0.5,
                  width: widget.width * 0.7,
                  child: Lottie.asset(
                    ARoAssets.animations('descarga'),
                    fit: BoxFit.fitHeight,
                  ),
                ),

                ///
                ///  Button software Enter
                ///
                ElevatedButton(
                  onPressed: () => cmdStream.cmdStreamSend.add('accept'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Icon(Icons.subdirectory_arrow_left),
                ),
              ],
            ),

            Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.blue.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ARoImage(
                    img: 'termino',
                    type: 'png',
                    height: widget.height * 0.2,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Terminar Descarga',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: widget.height * 0.05,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
