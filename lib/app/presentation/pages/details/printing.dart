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

    if (!widget.holdOn) {
      _timer = Timer(Duration(seconds: 4), () {
        if (mounted) {
          Navigator.of(context).pop();
          _timer.cancel();
        }
      });
    }
  }

  @override
  void dispose() {
    if (!widget.holdOn && _timer.isActive) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height * 0.8,
      width: widget.width / 1.2,
      color: secondaryColor,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Text(
              'Imprimiendo',
              style: TextStyle(
                fontSize: widget.height * 0.1,
                fontWeight: FontWeight.bold,
                color: primaryColor,
              ),
            ),

            Container(
              height: widget.height * 3,
              width: widget.width * 0.8,
              constraints: BoxConstraints(maxHeight: widget.height * 0.8),
              child: Lottie.asset(
                ARoAssets.animations('printing'),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
