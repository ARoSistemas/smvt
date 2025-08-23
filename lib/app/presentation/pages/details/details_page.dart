import 'package:flutter/material.dart';

import '../../../domain/entities/models/reports.dart';
import '../../../domain/entities/models/tank.dart';

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

  void _showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          content: HistorialDetails(
            height: widget.hw.pHeight(75),
            width: widget.hw.pWidth(50),
            historial: historial,
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
                        'Vacio: 10 cms',
                        style: TextStyle(
                          fontSize: widget.hw.pText(2),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Nivel: 10 cms',
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
                            'Lleno: 10 %',
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
                        '1,000 Lts',
                        style: TextStyle(
                          fontSize: widget.hw.pText(2),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '1,000 Lts',
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
                  Column(
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

                  /// Reports
                  GestureDetector(
                    onTap: () => _showAlertDialog(context),
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
                  Column(
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

                  /// Terminar Descarga
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ARoImage(
                        img: 'termino',
                        type: 'png',
                        height: widget.hw.pHeight(15),
                        fit: BoxFit.contain,
                      ),
                      Text(
                        'Terminar\nDescarga',
                        textAlign: TextAlign.center,
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
        ),
      ),
    );
  }
}

class HistorialDetails extends StatefulWidget {
  const HistorialDetails({
    super.key,
    required this.height,
    required this.width,
    required this.historial,
  });

  final double height;
  final double width;
  final List<Reporte> historial;

  @override
  State<HistorialDetails> createState() => _HistorialDetailsState();
}

class _HistorialDetailsState extends State<HistorialDetails> {
  List<Reporte> historial = [];

  void updateItem(int i) {
    for (var e in historial) {
      e.isSelected = false;
    }

    setState(() {
      historial[i].isSelected = !historial[i].isSelected;
    });
  }

  @override
  void initState() {
    super.initState();
    historial = widget.historial;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width / 1.2,
      color: Colors.blue.shade50,
      child: Column(
        children: [
          Text(
            'Historial de Descargas',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: widget.height / 1.21,
            child: ListView.builder(
              itemCount: historial.length,
              itemBuilder: (context, i) {
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: widget.historial[i].isSelected
                        ? Colors.green.shade100
                        : Colors.grey.shade300,
                  ),
                  child: ListTile(
                    title: Text(
                      '${historial[i].date} - ${historial[i].tipo}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      historial[i].isSelected
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: historial[i].isSelected
                          ? Colors.green.shade300
                          : Colors.grey.shade100,
                    ),

                    onTap: () => updateItem(i),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
