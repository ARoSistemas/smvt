import 'package:flutter/material.dart';

import 'item_tank.dart';
import '../details/details_page.dart';

import '../../../domain/entities/models/tank.dart';

import '../../../../core/utils/aro_size_scaler.dart';
import '../../../../core/utils/product_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Tank> tanks = [
    Tank(
      nameTank: 'Tank1',
      product: 'Diesel',
      capacityCms: 100.00,
      currentLevelCms: 64.00,
      percentage: 0.64,
      liters: '6,450 Lts',
      isActive: true,
      isSelected: true,
      scaleColor: ProductColor.getColor('diesel'),
    ),
    Tank(
      nameTank: 'Tank2',
      product: 'Magna',
      capacityCms: 100.00,
      currentLevelCms: 45.00,
      percentage: 0.45,
      liters: '4,500 Lts',
      isActive: true,
      isSelected: false,
      scaleColor: ProductColor.getColor('magna'),
    ),
  ];

  void goDetails({required ARoSizeScaler hw, required Tank tank}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailsPage(hw: hw, tank: tank),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final ARoSizeScaler hw = ARoSizeScaler(
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );

        final alto = hw.pHeight(79);

        return Scaffold(
          appBar: AppBar(title: const Text('ControlBIn - Tanques')),
          backgroundColor: Colors.grey.shade100,
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      tanks[0].isSelected = true;
                      tanks[1].isSelected = false;
                      setState(() {});
                      goDetails(hw: hw, tank: tanks[0]);
                    },
                    child: SizedBox(
                      height: alto / 2,
                      child: TankDetails(
                        tank: tanks[0],
                        hw: ARoSizeScaler(
                          size: Size(constraints.maxWidth, alto / 2),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      tanks[0].isSelected = false;
                      tanks[1].isSelected = true;
                      setState(() {});
                      goDetails(hw: hw, tank: tanks[1]);
                    },
                    child: SizedBox(
                      height: alto / 2,
                      child: TankDetails(
                        tank: tanks[1],
                        hw: ARoSizeScaler(
                          size: Size(constraints.maxWidth, alto / 2),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
