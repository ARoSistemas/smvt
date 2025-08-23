import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/utils/aro_assets.dart';
import '../../../config/themes/themedata.dart';
import '../../../../core/widgets/wdgt_aro_image.dart';

class DescargaPage extends StatelessWidget {
  const DescargaPage({super.key, required this.height, required this.width});

  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width / 1.2,
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
              height: height * 0.5,
              width: width,
              child: Lottie.asset(
                ARoAssets.animations('descarga'),
                fit: BoxFit.contain,
              ),
            ),

            GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
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
                      height: height * 0.2,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Terminar Descarga',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: height * 0.05,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
