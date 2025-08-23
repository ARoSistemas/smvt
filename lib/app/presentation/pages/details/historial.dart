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
