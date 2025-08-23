import 'dart:async';

import 'package:flutter/material.dart';

import '../../../config/themes/themedata.dart';
import '../../../domain/entities/models/reports.dart';

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
  int _counter = 0;
  late Timer _timer;

  void updateItem(int i) {
    for (var e in historial) {
      e.isSelected = false;
    }

    historial[i].isSelected = !historial[i].isSelected;
    _counter = 0;
    setState(() {});
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
    historial = widget.historial;
    _initTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width / 1.2,
      color: secondaryColor,
      child: Column(
        children: [
          Text(
            'Historial de Reportes',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
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
                        ? primaryColor
                        : Colors.grey.shade300,
                  ),
                  child: ListTile(
                    title: Text(
                      '${historial[i].date} - ${historial[i].tipo}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: historial[i].isSelected
                            ? secondaryColor
                            : Colors.black,
                      ),
                    ),
                    trailing: Icon(
                      historial[i].isSelected
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: historial[i].isSelected
                          ? secondaryColor
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
