import 'package:flutter/material.dart';
import 'package:smvt/app/presentation/pages/details/printing.dart';

import 'descarga.dart';
import 'historial.dart';

import '../../../config/themes/themedata.dart';
import '../../../domain/entities/models/tank.dart';
import '../../../domain/entities/models/reports.dart';

import '../../../../core/widgets/fuel_tank.dart';
import '../../../../core/utils/aro_size_scaler.dart';
import '../../../../core/widgets/wdgt_aro_image.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.tank, required this.hw});

  final Tank tank;
  final ARoSizeScaler hw;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  List<Reporte> historial = [
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: true),
    Reporte(date: '2025-08-01 00:15', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 01:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 03:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 12:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
  ];

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: HistorialDetails(
            height: widget.hw.pHeight(75),
            width: widget.hw.pWidth(50),
            historial: historial,
          ),
        );
      },
    );
  }

  void _initDescarga() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: DescargaPage(
            height: widget.hw.pHeight(75),
            width: widget.hw.pWidth(50),
          ),
        );
      },
    );
  }

  void _initPrinting() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: Printing(
            height: widget.hw.pHeight(75),
            width: widget.hw.pWidth(50),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ControlBIn - Tanques')),
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Tank
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Centimetros
                  Column(
                    children: [
                      ARoImage(
                        img: 'centimetros',
                        type: 'png',
                        height: widget.hw.pHeight(15),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Vacio: 30 cms',
                        style: TextStyle(
                          fontSize: widget.hw.pText(2),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Nivel: 70 cms',
                        style: TextStyle(
                          fontSize: widget.hw.pText(2),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),

                  /// Tank
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Lleno: 70 %',
                            style: TextStyle(
                              fontSize: widget.hw.pText(2),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: widget.hw.pHeight(35),
                        width: widget.hw.pWidth(35),
                        child: AnimatedFuelTank(
                          fuelLevel: widget.tank.percentage,
                          tankColor: widget.tank.scaleColor,
                          isActive: widget.tank.isActive,
                        ),
                      ),
                    ],
                  ),

                  /// Litros
                  Column(
                    children: [
                      ARoImage(
                        img: 'centimetros',
                        type: 'png',
                        height: widget.hw.pHeight(15),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 15),
                      Text(
                        '3,000 Lts',
                        style: TextStyle(
                          fontSize: widget.hw.pText(2),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '7,000 Lts',
                        style: TextStyle(
                          fontSize: widget.hw.pText(2),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              /// Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Print
                  GestureDetector(
                    onTap: () => _initPrinting(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ARoImage(
                          img: 'print',
                          type: 'png',
                          height: widget.hw.pHeight(15),
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'Imprimir\nEstatus',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widget.hw.pText(2),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Reports
                  GestureDetector(
                    onTap: () => _showAlertDialog(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ARoImage(
                          img: 'historial',
                          type: 'png',
                          height: widget.hw.pHeight(15),
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'ReImprimir',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widget.hw.pText(2),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Iniciar descarga
                  GestureDetector(
                    onTap: () => _initDescarga(),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ARoImage(
                          img: 'descarga',
                          type: 'png',
                          height: widget.hw.pHeight(15),
                          fit: BoxFit.contain,
                        ),
                        Text(
                          'Iniciar\nDescarga',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: widget.hw.pText(2),
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Terminar Descarga
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
