import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

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

  void _initStream() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cmdStream = Provider.of<CmdStreamRepository>(
        context,
        listen: false,
      );
      _cmdSubscription = cmdStream.cmdStreamListen.listen((cmd) {
        if (!mounted) return;
        if (ModalRoute.of(context)?.isCurrent == true) {
          switch (cmd) {
            case 'accept':

              /// Se continua con el proceso de descarga
              cmdStream.cmdStreamSend.add('findescarga');
              Navigator.of(context).pop();
              break;

            default:
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
      width: widget.width / 1.4,
      color: secondaryColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              'Descarga de Combustible',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),
            SizedBox(
              height: widget.height * 0.4,
              width: widget.width * 0.6,
              child: Lottie.asset(
                ARoAssets.animations('descarga'),
                fit: BoxFit.contain,
              ),
            ),

            ElevatedButton(
              onPressed: () => cmdStream.cmdStreamSend.add('accept'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                padding: const EdgeInsets.all(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ARoImage(
                    img: 'termino',
                    type: 'png',
                    height: widget.height * 0.15,
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
