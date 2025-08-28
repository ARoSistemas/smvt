import 'package:flutter/material.dart';

import '../../../domain/entities/models/tank.dart';

import '../../../../core/widgets/fuel_gauge.dart';
import '../../../../core/widgets/fuel_tank.dart';

import '../../../../core/utils/aro_size_scaler.dart';

class TankDetails extends StatelessWidget {
  const TankDetails({super.key, required this.tank, required this.hw});

  final Tank tank;
  final ARoSizeScaler hw;

  @override
  Widget build(BuildContext context) {
    final sizeNameTank = hw.pText(6);
    final sizeProduct = hw.pText(5);
    final sizeLitros = hw.pText(4);

    return Container(
      decoration: BoxDecoration(
        color: tank.isSelected
            ? Colors.blue.withValues(alpha: 0.2)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: tank.isSelected
              ? Colors.blue.withValues(alpha: 0.5)
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          /// Tank Animation
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: hw.height * 0.75,
              width: hw.pWidth(35),
              child: AnimatedFuelTank(
                fuelLevel: tank.percentage,
                tankColor: tank.scaleColor,
                isActive: tank.isActive,
                height: hw.height * 0.75,
                width: hw.pWidth(35),
              ),
            ),
          ),

          /// Tank Details
          SizedBox(
            width: hw.pWidth(25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// Tank Name
                Text(
                  tank.nameTank,
                  style: TextStyle(
                    fontSize: sizeNameTank,
                    fontWeight: FontWeight.bold,
                    color: tank.isActive ? tank.scaleColor : Colors.grey,
                  ),
                ),

                /// Tank Product
                Text(
                  tank.product,
                  style: TextStyle(
                    fontSize: sizeProduct,
                    fontWeight: FontWeight.bold,
                    color: tank.isActive ? tank.scaleColor : Colors.grey,
                  ),
                ),

                /// Tank Litros
                Text(
                  tank.liters,
                  style: TextStyle(
                    fontSize: sizeLitros,
                    fontWeight: FontWeight.bold,
                    color: tank.isActive ? tank.scaleColor : Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// Fuel Gauge
          SizedBox(
            height: hw.pHeight(80),
            width: hw.pWidth(30),
            child: FuelGauge(
              percentage: tank.percentage,
              scaleColor: tank.scaleColor,
            ),
          ),
        ],
      ),
    );
  }
}
