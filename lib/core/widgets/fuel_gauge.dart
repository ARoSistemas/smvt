import 'package:flutter/material.dart';
import 'dart:math';

class FuelGauge extends StatefulWidget {
  final double percentage;
  final Color scaleColor;

  const FuelGauge({
    super.key,
    required this.percentage,
    required this.scaleColor,
  });

  @override
  State<StatefulWidget> createState() => _FuelGaugeState();
}

class _FuelGaugeState extends State<FuelGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late double _currentPercentage;

  @override
  void initState() {
    super.initState();
    _currentPercentage = widget.percentage;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(
      begin: _currentPercentage,
      end: widget.percentage,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant FuelGauge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.percentage != widget.percentage) {
      _currentPercentage = oldWidget.percentage;
      _animation = Tween<double>(
        begin: _currentPercentage,
        end: widget.percentage,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: _FuelGaugePainter(
            percentage: _animation.value,
            scaleColor: widget.scaleColor,
          ),
        );
      },
    );
  }
}

class _FuelGaugePainter extends CustomPainter {
  final double percentage;
  final Color scaleColor;

  _FuelGaugePainter({required this.percentage, required this.scaleColor});

  @override
  void paint(Canvas canvas, Size size) {
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;
    final double baseRadius = halfWidth * 0.9;
    final Offset center = Offset(halfWidth, halfHeight * 1.6);
    final double needleLength = baseRadius * 0.63;

    final double arcBaseWidth = baseRadius * 0.1;
    final double startArcWidth = arcBaseWidth * 0.2;
    final double endArcWidth = arcBaseWidth * 2.3;

    final double outerRadius = baseRadius;
    final double innerRadiusStart = outerRadius - startArcWidth;
    final double innerRadiusEnd = outerRadius - endArcWidth;

    final double sweepAngle = pi * percentage;
    final Path coloredArcPath = Path();
    final Path shadowArcPath = Path();

    const int segments = 100;

    for (int i = 0; i <= segments; i++) {
      final double segmentPercentage = i / segments;
      final double currentAngle = pi + (pi * segmentPercentage);
      final double currentOuterX = center.dx + outerRadius * cos(currentAngle);
      final double currentOuterY = center.dy + outerRadius * sin(currentAngle);
      if (i == 0) {
        shadowArcPath.moveTo(currentOuterX, currentOuterY);
      } else {
        shadowArcPath.lineTo(currentOuterX, currentOuterY);
      }
    }

    for (int i = segments; i >= 0; i--) {
      final double segmentPercentage = i / segments;
      final double currentAngle = pi + (pi * segmentPercentage);
      final double currentInnerShadowRadius =
          innerRadiusStart +
          (innerRadiusEnd - innerRadiusStart) * segmentPercentage;
      final double currentInnerX =
          center.dx + currentInnerShadowRadius * cos(currentAngle);
      final double currentInnerY =
          center.dy + currentInnerShadowRadius * sin(currentAngle);
      shadowArcPath.lineTo(currentInnerX, currentInnerY);
    }
    shadowArcPath.close();

    final Paint coloredArcPaintShadow = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.fill;
    canvas.drawPath(shadowArcPath, coloredArcPaintShadow);

    // DIBUJANDO EL ARCO DE COLOR

    // Borde exterior del color
    for (int i = 0; i <= segments; i++) {
      final double segmentPercentage = i / segments;
      final double currentAngle = pi + (sweepAngle * segmentPercentage);
      final double currentOuterX = center.dx + outerRadius * cos(currentAngle);
      final double currentOuterY = center.dy + outerRadius * sin(currentAngle);
      if (i == 0) {
        coloredArcPath.moveTo(currentOuterX, currentOuterY);
      } else {
        coloredArcPath.lineTo(currentOuterX, currentOuterY);
      }
    }

    // Borde interior del color (en reversa)
    for (int i = segments; i >= 0; i--) {
      final double segmentPercentage = i / segments;
      final double currentAngle = pi + (sweepAngle * segmentPercentage);

      final double currentInnerRadius =
          innerRadiusStart +
          (innerRadiusEnd - innerRadiusStart) * segmentPercentage;

      final double currentInnerX =
          center.dx + currentInnerRadius * cos(currentAngle);
      final double currentInnerY =
          center.dy + currentInnerRadius * sin(currentAngle);
      coloredArcPath.lineTo(currentInnerX, currentInnerY);
    }
    coloredArcPath.close();

    final Paint coloredArcPaint = Paint()
      ..color = scaleColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(coloredArcPath, coloredArcPaint);

    // E Text
    final TextPainter textPainterE = TextPainter(
      text: TextSpan(
        text: 'E',
        style: TextStyle(
          fontSize: halfWidth * 0.2,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterE.layout();
    textPainterE.paint(
      canvas,
      Offset(center.dx * 0.32, center.dy - textPainterE.height / 1.0),
    );

    // F Text
    final TextPainter textPainterF = TextPainter(
      text: TextSpan(
        text: 'F',
        style: TextStyle(
          fontSize: halfWidth * 0.2,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainterF.layout();
    textPainterF.paint(
      canvas,
      Offset(center.dx * 1.55, center.dy - textPainterF.height / 1.0),
    );

    // Needle with custom shape
    final double angle = pi + (pi * percentage);
    final double tipX = center.dx + needleLength * cos(angle);
    final double tipY = center.dy + needleLength * sin(angle);
    final double needleBaseWidth = halfWidth * 0.05;
    final double baseAngleOffset = pi / 10;
    final double baseAngleLeft = angle - baseAngleOffset;
    final double baseAngleRight = angle + baseAngleOffset;
    final double baseXLeft = center.dx + needleBaseWidth * cos(baseAngleLeft);
    final double baseYLeft = center.dy + needleBaseWidth * sin(baseAngleLeft);
    final double baseXRight = center.dx + needleBaseWidth * cos(baseAngleRight);
    final double baseYRight = center.dy + needleBaseWidth * sin(baseAngleRight);

    final Path needlePath = Path();
    needlePath.moveTo(baseXLeft, baseYLeft);
    needlePath.lineTo(tipX, tipY);
    needlePath.lineTo(baseXRight, baseYRight);
    needlePath.close();

    final Paint needlePaint = Paint()..color = Colors.black;
    canvas.drawPath(needlePath, needlePaint);
  }

  @override
  bool shouldRepaint(covariant _FuelGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.scaleColor != scaleColor;
  }
}
