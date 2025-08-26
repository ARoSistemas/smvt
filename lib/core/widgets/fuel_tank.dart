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
  State<AnimatedFuelTank> createState() => _DemoFuelTtateAnimation();
}

class _DemoFuelTtateAnimation extends State<AnimatedFuelTank>
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

  void _drawBase(
    Canvas canvas,
    Path pathLeft,
    Offset offset,
    double scaleFactor,
    Size size,
    Path pathRight,
  ) {
    pathLeft.moveTo(
      offset.dx - size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.2 * scaleFactor,
    );

    pathLeft.arcToPoint(
      // Más abajo que el punto de inicio
      Offset(
        offset.dx + size.width * 0.01 * scaleFactor,
        offset.dy - size.height * 0.7 * scaleFactor,
      ),
      radius: Radius.circular(size.width * 0.1),
      clockwise: false,
    );

    pathLeft.lineTo(
      offset.dx + size.width * 0.02 * scaleFactor,
      offset.dy - size.height * 0.7 * scaleFactor,
    );

    pathLeft.lineTo(
      offset.dx + size.width * 0.02 * scaleFactor,
      offset.dy + size.height * 0.1 * scaleFactor,
    );

    pathLeft.lineTo(
      offset.dx - size.width * 0.3 * scaleFactor,
      offset.dy + size.height * 0.05 * scaleFactor,
    );

    pathLeft.close();

    ///
    pathRight.moveTo(
      offset.dx + size.width * 0.02 * scaleFactor,
      offset.dy - size.height * 0.7 * scaleFactor,
    );

    pathRight.lineTo(
      offset.dx + size.width * 0.3 * scaleFactor,
      offset.dy - size.height * 0.7 * scaleFactor,
    );

    pathRight.lineTo(
      offset.dx + size.width * 0.3 * scaleFactor,
      offset.dy + size.height * 0.01 * scaleFactor,
    );

    pathRight.lineTo(
      offset.dx + size.width * 0.02 * scaleFactor,
      offset.dy + size.height * 0.1 * scaleFactor,
    );

    pathRight.close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    /// El cuerpo del canvas
    final paint = Paint()
      ..color = Colors.grey[400]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, size.height * 0.1);

    path.arcToPoint(
      Offset(size.width, size.height / 1.25),
      radius: Radius.circular(size.height),
      clockwise: true,
    );

    path.lineTo(size.width, size.height * 0.8);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);

    ///
    /// La animacion de combustible
    ///
    final fuelPaint = Paint()
      ..color = tankColor
      ..style = PaintingStyle.fill;

    final tankPath = Path();
    tankPath.close();

    if (fuelLevel > 0.09) {
      final fuelPath = Path();
      // final double fuelHeight = size.height * fuelLevel;

      // final double yOffset = (size.height * 1.05) - (size.height * fuelLevel);
      final double minUp = size.height * (fuelLevel < 0.2 ? 0.08 : 1.05);
      final double minDown = fuelLevel - (fuelLevel < 0.2 ? 0.8 : -0.01);

      final double yOffset = (minUp) - (size.height * minDown);

      final double waveAmplitude = 5;
      final double waveFrequency = 2;

      fuelPath.moveTo(0, 0);

      for (double x = 0; x <= size.width; x++) {
        final y =
            yOffset +
            math.sin(
                  (x / size.width) * waveFrequency * 2 * math.pi +
                      waveValue * 2 * math.pi,
                ) *
                waveAmplitude;
        fuelPath.lineTo(x, y);
      }

      // Complete the path to fill the liquid shape.

      // fuelPath.lineTo(size.width, size.height * fuelLevel);
      // fuelPath.lineTo(size.width, size.height * (fuelLevel < 0.2 ? 0.8 : 0.8));

      fuelPath.arcToPoint(
        Offset(size.width, size.height / 1.25),
        radius: Radius.circular(size.height),
        clockwise: true,
      );

      fuelPath.lineTo(size.width, size.height * 0.8);

      fuelPath.lineTo(0, size.height);

      fuelPath.close();

      // Draw the liquid.
      canvas.save();

      // canvas.clipPath(tankPath);
      canvas.drawPath(fuelPath, fuelPaint);
      canvas.restore();
    }

    /// Tapa inicial del cilindro
    final gradientFte = LinearGradient(
      colors: [Colors.grey.shade200, Colors.grey.shade800],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final colorTapaInicial = Paint()
      ..shader = gradientFte.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    final tapaInicial = Path();
    tapaInicial.moveTo(0, 0);
    tapaInicial.lineTo(size.width * 0.2, size.height * 0.03);
    tapaInicial.arcToPoint(
      Offset(size.width * 0.2, size.height * 0.96),
      radius: Radius.circular(size.height),
      clockwise: true,
    );
    tapaInicial.lineTo(size.width * 0.0, size.height);
    tapaInicial.close();
    canvas.drawPath(tapaInicial, colorTapaInicial);

    /// El frente del cilindro
    final List<Color> gradientColorsOval = [
      Colors.grey[400]!,
      Colors.grey[800]!,
    ];

    final gradientOval = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: gradientColorsOval,
      stops: const [0.8, 1.0],
    );

    final paintOval = Paint()
      ..shader = gradientOval.createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      -(size.width * 0.11),
      0,
      size.width * 0.23,
      size.height,
    );

    canvas.drawOval(rect, paintOval);

    ///
    /// Tapa final del cilindro
    ///
    final gradientFinal = LinearGradient(
      colors: [Colors.grey.shade200, Colors.grey.shade800],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    final colorTapaFinal = Paint()
      ..shader = gradientFinal.createShader(
        Rect.fromLTWH(
          0,
          0,
          size.width,
          size.height,
        ), // Define el área del degradado.
      )
      ..style = PaintingStyle.fill
      ..strokeWidth = 4.0;

    final tapaFinal = Path();
    tapaFinal.moveTo(size.width * 0.90, size.height * 0.1);
    tapaFinal.lineTo(size.width, size.height * 0.1);

    tapaFinal.arcToPoint(
      Offset(size.width, size.height / 1.25),
      radius: Radius.circular(size.height),
      clockwise: true,
    );

    tapaFinal.lineTo(size.width * 0.90, size.height * 0.82);
    tapaFinal.arcToPoint(
      Offset(size.width * 0.9, size.height * 0.1),
      radius: Radius.circular(size.height),
      clockwise: false,
    );

    tapaFinal.close();
    canvas.drawPath(tapaFinal, colorTapaFinal);

    ///
    /// Las tapas de descarga
    ///
    // Definir los colores para el relleno y el contorno.
    final topCapPaint = Paint()
      ..color = isActive ? Colors.grey[400]! : Colors.grey
      ..style = PaintingStyle.fill;

    final topCapOutline = Paint()
      ..color = isActive ? Colors.grey[400]! : Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;

    // Primer elemento: en la parte izquierda del lienzo.
    final path1 = Path();
    final centerOffset1 = Offset(size.width * 0.2, (size.height * 0.03) - 5);
    const double scaleFactor1 = 0.2;

    _drawShape(canvas, path1, centerOffset1, scaleFactor1, size);
    canvas.drawPath(path1, topCapPaint);
    canvas.drawPath(path1, topCapOutline);

    /// Segunda tapa
    final path2 = Path();
    final centerOffset2 = Offset(size.width * 0.85, (size.height * 0.1) - 5);
    const double scaleFactor2 = 0.13;
    _drawShape(canvas, path2, centerOffset2, scaleFactor2, size);
    canvas.drawPath(path2, topCapPaint);
    canvas.drawPath(path2, topCapOutline);

    /// Primera base
    final shapeBase1Left = Path();
    final Color shapeColorLeft1 = Colors.grey[700]!;

    final shapeBase1Right = Path();
    final Color shapeColor1Right = Colors.grey[400]!;

    final centerOffsetBase1 = Offset(size.width * 0.33, size.height * 0.99);
    const double scaleFactorBase1 = 0.2;

    // Dibuja la forma con el color de relleno
    final shapePaintLeft1 = Paint()
      ..color = shapeColorLeft1
      ..style = PaintingStyle.fill;

    final shapePaintRight1 = Paint()
      ..color = shapeColor1Right
      ..style = PaintingStyle.fill;

    _drawBase(
      canvas,
      shapeBase1Left,
      centerOffsetBase1,
      scaleFactorBase1,
      size,
      shapeBase1Right,
    );

    canvas.drawPath(shapeBase1Left, shapePaintLeft1);
    canvas.drawPath(shapeBase1Right, shapePaintRight1);

    /// Segunda base
    final shapeBase2Left = Path();
    final Color shapeColorLeft2 = Colors.grey[700]!;

    final shapeBase2Right = Path();
    final Color shapeColorRight2 = Colors.grey[400]!;

    final centerOffsetBase2 = Offset(size.width * 0.86, size.height * 0.87);
    const double scaleFactorBase2 = 0.15;

    // Dibuja la forma con el color de relleno
    final shapePaintLeft2 = Paint()
      ..color = shapeColorLeft2
      ..style = PaintingStyle.fill;

    final shapePaintRight2 = Paint()
      ..color = shapeColorRight2
      ..style = PaintingStyle.fill;

    _drawBase(
      canvas,
      shapeBase2Left,
      centerOffsetBase2,
      scaleFactorBase2,
      size,
      shapeBase2Right,
    );

    canvas.drawPath(shapeBase2Left, shapePaintLeft2);
    canvas.drawPath(shapeBase2Right, shapePaintRight2);
  }

  @override
  bool shouldRepaint(FuelTankPainter oldDelegate) {
    return oldDelegate.fuelLevel != fuelLevel ||
        oldDelegate.waveValue != waveValue ||
        oldDelegate.tankColor != tankColor;
  }
}
