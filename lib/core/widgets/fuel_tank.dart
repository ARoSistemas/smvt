import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedFuelTank extends StatefulWidget {
  const AnimatedFuelTank({
    super.key,
    required this.fuelLevel,
    required this.tankColor,
    required this.isActive,
  });

  final double fuelLevel;
  final Color tankColor;
  final bool isActive;

  @override
  State<AnimatedFuelTank> createState() => _AnimatedFuelTankState();
}

class _AnimatedFuelTankState extends State<AnimatedFuelTank>
    with TickerProviderStateMixin {
  late final AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _waveController,
      builder: (context, child) {
        return CustomPaint(
          painter: FuelTankPainter(
            fuelLevel: widget.fuelLevel,
            waveValue: _waveController.value,
            tankColor: widget.tankColor,
            isActive: widget.isActive,
          ),
        );
      },
    );
  }
}

class FuelTankPainter extends CustomPainter {
  FuelTankPainter({
    required this.tankColor,
    required this.fuelLevel,
    required this.waveValue,
    required this.isActive,
  });

  final double fuelLevel;
  final double waveValue;
  final Color tankColor;
  final bool isActive;

  void _drawShape(
    Canvas canvas,
    Path path,
    Offset offset,
    double scaleFactor,
    Paint fillPaint,
    Paint outlinePaint,
    Size size,
  ) {
    path.moveTo(
      offset.dx - size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.25 * scaleFactor,
    );
    path.quadraticBezierTo(
      offset.dx - size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.3 * scaleFactor,
      offset.dx - size.width * 0.25 * scaleFactor,
      offset.dy - size.height * 0.3 * scaleFactor,
    );
    path.lineTo(
      offset.dx + size.width * 0.25 * scaleFactor,
      offset.dy - size.height * 0.3 * scaleFactor,
    );
    path.quadraticBezierTo(
      offset.dx + size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.3 * scaleFactor,
      offset.dx + size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.25 * scaleFactor,
    );
    path.lineTo(
      offset.dx + size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.1 * scaleFactor,
    );
    path.lineTo(
      offset.dx + size.width * 0.2 * scaleFactor,
      offset.dy - size.height * 0.1 * scaleFactor,
    );
    path.lineTo(
      offset.dx + size.width * 0.2 * scaleFactor,
      offset.dy + size.height * 0.1 * scaleFactor,
    );
    path.lineTo(
      offset.dx - size.width * 0.2 * scaleFactor,
      offset.dy + size.height * 0.1 * scaleFactor,
    );
    path.lineTo(
      offset.dx - size.width * 0.2 * scaleFactor,
      offset.dy - size.height * 0.1 * scaleFactor,
    );
    path.lineTo(
      offset.dx - size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.1 * scaleFactor,
    );
    path.close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    final tankPaint = Paint()
      ..color = isActive ? Colors.blueGrey.shade200 : Colors.grey
      ..style = PaintingStyle.fill;
    final outlinePaint = Paint()
      ..color = isActive ? Colors.blueGrey.shade400 : Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    final supportPaint = Paint()
      ..color = isActive ? Colors.blueGrey.shade300 : Colors.grey
      ..style = PaintingStyle.fill;
    final supportOutlinePaint = Paint()
      ..color = isActive ? Colors.blueGrey.shade500 : Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final fuelPaint = Paint()
      ..color = tankColor
      ..style = PaintingStyle.fill;

    final double tankHeight = size.height * 0.5;
    final double tankWidth = size.width * 0.8;
    final double radius = tankHeight / 2;

    final double dx = (size.width - tankWidth) / 2;
    final double dy = (size.height - (tankHeight + size.height * 0.1)) / 2;
    canvas.translate(dx, dy);

    final tankPath = Path();
    tankPath.moveTo(radius, 0);
    tankPath.lineTo(tankWidth - radius, 0);
    tankPath.arcToPoint(
      Offset(tankWidth - radius, tankHeight),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    tankPath.lineTo(radius, tankHeight);
    tankPath.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    tankPath.close();

    canvas.drawPath(tankPath, tankPaint);

    if (fuelLevel > 0) {
      final fuelPath = Path();
      final double fuelHeight = tankHeight * fuelLevel;
      final double yOffset = tankHeight - fuelHeight;
      final double waveAmplitude = 5;
      final double waveFrequency = 2;

      fuelPath.moveTo(0, yOffset);
      for (double x = 0; x <= tankWidth; x++) {
        final y =
            yOffset +
            math.sin(
                  (x / tankWidth) * waveFrequency * 2 * math.pi +
                      waveValue * 2 * math.pi,
                ) *
                waveAmplitude;
        fuelPath.lineTo(x, y);
      }

      // Complete the path to fill the liquid shape.
      fuelPath.lineTo(tankWidth, tankHeight);
      fuelPath.lineTo(0, tankHeight);
      fuelPath.close();

      // Draw the liquid.
      canvas.save();
      canvas.clipPath(tankPath);
      canvas.drawPath(fuelPath, fuelPaint);
      canvas.restore();
    }

    // Draw the tank outline on top to ensure it's visible.
    canvas.drawPath(tankPath, outlinePaint);

    // Draw the supports.
    final double supportHeight = size.height * 0.1;
    final double supportWidth = tankWidth * 0.1;
    final double supportY = tankHeight;

    final leftSupportRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tankWidth * 0.15, supportY, supportWidth, supportHeight),
      const Radius.circular(5),
    );
    canvas.drawRRect(leftSupportRect, supportPaint);
    canvas.drawRRect(leftSupportRect, supportOutlinePaint);

    final rightSupportRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tankWidth * 0.7, supportY, supportWidth, supportHeight),
      const Radius.circular(5),
    );
    canvas.drawRRect(rightSupportRect, supportPaint);
    canvas.drawRRect(rightSupportRect, supportOutlinePaint);

    // Definir los colores para el relleno y el contorno.
    final topCapPaint = Paint()
      ..color = isActive ? Colors.blueGrey.shade400 : Colors.grey
      ..style = PaintingStyle.fill;

    final topCapOutline = Paint()
      ..color = isActive ? Colors.blueGrey.shade600 : Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Primer elemento: en la parte izquierda del lienzo.
    final path1 = Path();
    final centerOffset1 = Offset(size.width * 0.2, (size.height * 0.01) - 5);
    const double scaleFactor1 = 0.15;
    _drawShape(
      canvas,
      path1,
      centerOffset1,
      scaleFactor1,
      topCapPaint,
      topCapOutline,
      size,
    );
    canvas.drawPath(path1, topCapPaint);
    canvas.drawPath(path1, topCapOutline);

    // Segundo elemento: en la parte derecha del lienzo.
    final path2 = Path();
    final centerOffset2 = Offset(size.width * 0.6, (size.height * 0.01) - 5);
    const double scaleFactor2 = 0.15;
    _drawShape(
      canvas,
      path2,
      centerOffset2,
      scaleFactor2,
      topCapPaint,
      topCapOutline,
      size,
    );
    canvas.drawPath(path2, topCapPaint);
    canvas.drawPath(path2, topCapOutline);
  }

  @override
  bool shouldRepaint(covariant FuelTankPainter oldDelegate) {
    return oldDelegate.fuelLevel != fuelLevel ||
        oldDelegate.waveValue != waveValue ||
        oldDelegate.tankColor != tankColor;
  }
}

class FuelTankOk extends StatelessWidget {
  const FuelTankOk({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 150,
      child: CustomPaint(painter: FuelTankPainterOk()),
    );
  }
}

class FuelTankPainterOk extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Define the main paint for the tank body.
    final tankPaint = Paint()
      ..color = Colors.blueGrey.shade200
      ..style = PaintingStyle.fill;

    // Define the paint for the tank outline.
    final outlinePaint = Paint()
      ..color = Colors.blueGrey.shade400
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Define the paint for the supports.
    final supportPaint = Paint()
      ..color = Colors.blueGrey.shade300
      ..style = PaintingStyle.fill;

    // Define the paint for the support outlines.
    final supportOutlinePaint = Paint()
      ..color = Colors.blueGrey.shade500
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double tankHeight = size.height * 0.5;
    final double tankWidth = size.width;
    final double radius = tankHeight / 2;

    // Create a path for the tank body to ensure a seamless shape.
    final tankPath = Path();
    tankPath.moveTo(radius, 0);
    tankPath.lineTo(tankWidth - radius, 0);
    tankPath.arcToPoint(
      Offset(tankWidth - radius, tankHeight),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    tankPath.lineTo(radius, tankHeight);
    tankPath.arcToPoint(
      Offset(radius, 0),
      radius: Radius.circular(radius),
      clockwise: true,
    );
    tankPath.close();

    // Draw the main tank shape (fill and outline).
    canvas.drawPath(tankPath, tankPaint);
    canvas.drawPath(tankPath, outlinePaint);

    // Draw the left support.
    final leftSupportRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tankWidth * 0.15, tankHeight, 30, size.height / 7),
      const Radius.circular(5),
    );

    canvas.drawRRect(leftSupportRect, supportPaint);
    canvas.drawRRect(leftSupportRect, supportOutlinePaint);

    // Draw the right support.
    final rightSupportRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(tankWidth * 0.7, tankHeight, 30, size.height / 7),
      const Radius.circular(5),
    );
    canvas.drawRRect(rightSupportRect, supportPaint);
    canvas.drawRRect(rightSupportRect, supportOutlinePaint);

    // Draw the top cap/vent.
    final topCapPaint = Paint()
      ..color = Colors.blueGrey.shade400
      ..style = PaintingStyle.fill;
    final topCapOutline = Paint()
      ..color = Colors.blueGrey.shade600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    final topCapRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: Offset(tankWidth / 2, 0), width: 40, height: 15),
      const Radius.circular(5),
    );
    canvas.drawRRect(topCapRect, topCapPaint);
    canvas.drawRRect(topCapRect, topCapOutline);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}




    // ///
    // ///  Tapa izquierda
    // ///
    // final topCapPaint = Paint()
    //   ..color = isActive ? Colors.blueGrey.shade400 : Colors.grey
    //   ..style = PaintingStyle.fill;
    // final topCapOutline = Paint()
    //   ..color = isActive ? Colors.blueGrey.shade600 : Colors.grey
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.0;

    // final topRect = RRect.fromRectAndCorners(
    //   Rect.fromCenter(
    //     center: Offset(tankWidth / 4, -9.0),
    //     height: tankHeight * 0.06,
    //     width: tankWidth * 0.16,
    //   ),
    //   topLeft: const Radius.circular(5),
    //   topRight: const Radius.circular(5),
    // );
    // canvas.drawRRect(topRect, topCapPaint);
    // canvas.drawRRect(topRect, topCapOutline);

    // final baseRect = Rect.fromCenter(
    //   center: Offset(tankWidth / 4, 0.0),
    //   height: tankHeight * 0.15,
    //   width: tankWidth * 0.1,
    // );

    // canvas.drawRect(baseRect, topCapPaint);
    // canvas.drawRect(baseRect, topCapOutline);

    ///
    ///  Tapa derecha
    ///

    // final topCapPaintRight = Paint()
    //   ..color = isActive ? Colors.blueGrey.shade400 : Colors.grey
    //   ..style = PaintingStyle.fill;

    // final topCapOutlineRight = Paint()
    //   ..color = isActive ? Colors.blueGrey.shade600 : Colors.grey
    //   ..style = PaintingStyle.stroke
    //   ..strokeWidth = 1.0;

    // final topRectRight = RRect.fromRectAndCorners(
    //   Rect.fromCenter(
    //     center: Offset(tankWidth / 1.33, -9.0),
    //     height: tankHeight * 0.06,
    //     width: tankWidth * 0.16,
    //   ),
    //   topLeft: const Radius.circular(5),
    //   topRight: const Radius.circular(5),
    // );

    // canvas.drawRRect(topRectRight, topCapPaintRight);
    // canvas.drawRRect(topRectRight, topCapOutlineRight);

    // final baseRectRight = Rect.fromCenter(
    //   center: Offset(tankWidth / 1.33, 0.1),
    //   height: tankHeight * 0.15,
    //   width: tankWidth * 0.1,
    // );

    // canvas.drawRect(baseRectRight, topCapPaintRight);
    // canvas.drawRect(baseRectRight, topCapOutlineRight);

    ///
    ///
    ///
    ///