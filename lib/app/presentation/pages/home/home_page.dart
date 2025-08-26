import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'item_tank.dart';
import '../details/details_page.dart';

import '../../../domain/entities/models/tank.dart';
import '../../../domain/repositories/cmd_stream_repository.dart';

import '../../../../core/utils/aro_size_scaler.dart';
import '../../../../core/utils/product_color.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamSubscription<String>? _cmdSubscription;
  ARoSizeScaler hw = ARoSizeScaler(size: Size.zero);

  void _initStream() {
    /// Escucha el stream de comandos
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cmdStream = Provider.of<CmdStreamRepository>(
        context,
        listen: false,
      );
      _cmdSubscription = cmdStream.cmdStreamListen.listen((cmd) {
        if (!mounted) return;
        if (ModalRoute.of(context)?.isCurrent == true) {
          switch (cmd) {
            case 'up':
              if (tanks[1].isSelected) {
                tanks[0].isSelected = true;
                tanks[1].isSelected = false;
                _selectedIndex = 0;
                setState(() {});
              }
              break;
            case 'down':
              if (tanks[0].isSelected) {
                tanks[0].isSelected = false;
                tanks[1].isSelected = true;
                _selectedIndex = 1;
                setState(() {});
              }
              break;
            case 'accept':
              goDetails(hw: hw);
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
    _initStream();
  }

  @override
  void dispose() {
    _cmdSubscription?.cancel();
    super.dispose();
  }

  int _selectedIndex = 0;

  List<Tank> tanks = [
    Tank(
      nameTank: 'Tank1',
      product: 'Diesel',
      capacityCms: 100.00,
      currentLevelCms: 64.00,
      percentage: 0.64,
      liters: '6,450 Lts',
      isActive: true,
      isSelected: false,
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

  void goDetails({required ARoSizeScaler hw}) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetailsPage(tank: tanks[_selectedIndex]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        hw = ARoSizeScaler(
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );

        final alto = hw.pHeight(79) / 2.2;

        return Scaffold(
          appBar: AppBar(
            title: const Text('ControlBIn - Tanques'),
            // actions: [
            //   IconButton(
            //     icon: const Icon(Icons.settings),
            //     onPressed: () {
            //       Navigator.of(context).push(
            //         MaterialPageRoute(
            //           builder: (context) => const SettingPage(),
            //         ),
            //       );
            //     },
            //   ),
            // ],
          ),
          backgroundColor: Colors.grey.shade100,
          body: Padding(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _selectedIndex = 0;
                      goDetails(hw: hw);
                    },
                    child: SizedBox(
                      height: alto,
                      child: TankDetails(
                        tank: tanks[0],
                        hw: ARoSizeScaler(
                          size: Size(constraints.maxWidth, alto),
                        ),
                      ),
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      _selectedIndex = 1;
                      goDetails(hw: hw);
                    },
                    child: SizedBox(
                      height: alto,
                      child: TankDetails(
                        tank: tanks[1],
                        hw: ARoSizeScaler(
                          size: Size(constraints.maxWidth, alto),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // TODO: Eliminar este snippet de los botones de la UI,
          // TODO: Estas acciones seran recibidas por puerto serial.
          // floatingActionButtonLocation:
          //     FloatingActionButtonLocation.miniEndFloat,
          // floatingActionButton: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   children: [
          /// Aceptar
          // FloatingActionButton(
          //   heroTag: 'accept',
          //   onPressed: () => cmdStream.cmdStreamSend.add('accept'),
          //   child: const Icon(Icons.subdirectory_arrow_left),
          // ),
          // const SizedBox(height: 50),

          // /// Arriba
          // FloatingActionButton(
          //   heroTag: 'up',
          //   onPressed: () => cmdStream.cmdStreamSend.add('up'),
          //   child: const Icon(Icons.arrow_upward),
          // ),
          // const SizedBox(height: 16),

          // /// Abajo
          // FloatingActionButton(
          //   heroTag: 'down',
          //   onPressed: () => cmdStream.cmdStreamSend.add('down'),
          //   child: const Icon(Icons.arrow_downward),
          // ),

          // TODO: Eliminar hasta aqui.
          //   ],
          // ),
        );
      },
    );
  }
}
