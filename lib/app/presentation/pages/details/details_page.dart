import 'dart:async';

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
  int _selectedIndex = 0;
  int _counter = 0;
  late Timer _timer;

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

  void _showHistorial() {
    _timer.cancel();
    _counter = 0;

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
    ).then((_) {
      _initTimer();
    });
  }

  void _initDescarga() {
    _timer.cancel();
    _counter = 0;

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
    ).then((_) {
      _initTimer();
    });
  }

  void _initPrinting() {
    _timer.cancel();
    _counter = 0;

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
    ).then((_) {
      _initTimer();
    });
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _counter++;
      if (_counter == 20) {
        if (mounted) {
          _timer.cancel();
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initTimer();
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
            children: [
              SizedBox(height: widget.hw.pHeight(5)),

              /// Tank Details
              Stack(
                children: [
                  /// Tank
                  Positioned(
                    top: -60,
                    left: widget.hw.pWidth(22),
                    child: SizedBox(
                      height: widget.hw.pHeight(58),
                      width: widget.hw.pWidth(60),
                      child: AnimatedFuelTank(
                        fuelLevel: widget.tank.percentage,
                        tankColor: widget.tank.scaleColor,
                        isActive: widget.tank.isActive,
                      ),
                    ),
                  ),

                  /// porcentaje
                  Positioned(
                    top: widget.hw.height * 0.09,
                    left: widget.hw.width * 0.44,
                    child: Text(
                      '80 %',
                      style: TextStyle(
                        fontSize: widget.hw.pText(7),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// Name Tank
                  Positioned(
                    top: -5,
                    left: widget.hw.width * 0.49,
                    child: Text(
                      widget.tank.nameTank,
                      style: TextStyle(
                        fontSize: widget.hw.pText(2),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

                  /// Product
                  Positioned(
                    top: widget.hw.height * 0.35,
                    left: widget.hw.width * 0.49,
                    child: Text(
                      widget.tank.product,
                      style: TextStyle(
                        fontSize: widget.hw.pText(2),
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),

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

                      SizedBox(
                        height: widget.hw.pHeight(40),
                        width: widget.hw.pWidth(50),
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
                ],
              ),

              SizedBox(height: widget.hw.pHeight(5)),

              /// Botones
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Print
                  GestureDetector(
                    onTap: () {
                      _selectedIndex = 0;
                      setState(() {});
                      _initPrinting();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 0
                            ? Colors.blue.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedIndex == 0
                              ? Colors.blue.withValues(alpha: 0.5)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
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
                  ),

                  /// Reports
                  GestureDetector(
                    onTap: () {
                      _selectedIndex = 1;
                      setState(() {});
                      _showHistorial();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 1
                            ? Colors.blue.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedIndex == 1
                              ? Colors.blue.withValues(alpha: 0.5)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
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
                            'ReImprimir\n ',
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
                  ),

                  /// Iniciar descarga
                  GestureDetector(
                    onTap: () {
                      _selectedIndex = 2;
                      setState(() {});
                      _initDescarga();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: _selectedIndex == 2
                            ? Colors.blue.withValues(alpha: 0.2)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: _selectedIndex == 2
                              ? Colors.blue.withValues(alpha: 0.5)
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
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
