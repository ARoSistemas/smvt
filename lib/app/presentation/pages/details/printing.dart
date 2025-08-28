import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../config/themes/themedata.dart';
import '../../../../core/utils/aro_assets.dart';

class Printing extends StatefulWidget {
  const Printing({
    super.key,
    required this.height,
    required this.width,
    required this.holdOn,
  });

  final double height;
  final double width;
  final bool holdOn;

  @override
  State<Printing> createState() => _PrintingState();
}

class _PrintingState extends State<Printing> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: widget.holdOn ? 25 : 4), () {
      if (mounted) {
        Navigator.of(context).pop();
      }
      _timer.cancel();
    });
  }

  @override
  void dispose() {
    if (_timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width / 1.2,
      color: secondaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Imprimiendo',
            style: TextStyle(
              fontSize: 70,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),

          SizedBox(
            height: widget.height * 0.7,
            width: widget.width,
            child: Lottie.asset(
              ARoAssets.animations('printing'),
              fit: BoxFit.cover,
            ),
          ),

          Text(
            'Por favor, espere...',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
