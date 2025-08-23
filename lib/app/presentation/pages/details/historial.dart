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
  final ScrollController _scrollController = ScrollController();
  int _selectedIndex = 0;

  List<Reporte> historial = [];
  int _counter = 0;
  late Timer _timer;

  void _printTicket() {
    // print(
    //   'Printing ticket for: $_selectedIndex ::  ${historial[_selectedIndex].date} - ${historial[_selectedIndex].tipo} ',
    // );

    if (mounted) {
      _timer.cancel();
      Navigator.pop(context);
    }
  }

  void _updateItem() {
    for (var e in historial) {
      e.isSelected = false;
    }

    historial[_selectedIndex].isSelected = true;
    _counter = 0;
    setState(() {});
    _scrollToSelectedElement();
  }

  void _initTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _counter++;
      if (_counter == 30) {
        if (mounted) {
          _timer.cancel();
          Navigator.pop(context);
        }
      }
    });
  }

  void _scrollToSelectedElement() {
    if (_scrollController.hasClients) {
      final double itemHeight = 60.0;
      final double targetOffset = _selectedIndex * itemHeight;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    historial = widget.historial;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (historial.isNotEmpty) {
          _updateItem();
        }
      }
    });

    _initTimer();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      width: widget.width / 0.8,
      color: secondaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
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
                width: widget.width,
                child: ListView.builder(
                  itemCount: historial.length,
                  controller: _scrollController,
                  physics: NeverScrollableScrollPhysics(),
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
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Column(
            children: [
              /// Enter
              ElevatedButton(
                onPressed: () => _printTicket(),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.subdirectory_arrow_left),
              ),
              const SizedBox(height: 50),

              /// Arriba
              ElevatedButton(
                onPressed: () {
                  if (_selectedIndex > 0) {
                    _selectedIndex--;
                    _updateItem();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.arrow_upward),
              ),
              const SizedBox(height: 20),

              /// Abajo
              ElevatedButton(
                onPressed: () {
                  if (_selectedIndex < historial.length - 1) {
                    _selectedIndex++;
                    _updateItem();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Icon(Icons.arrow_downward),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
