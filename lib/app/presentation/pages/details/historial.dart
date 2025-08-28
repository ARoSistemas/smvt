import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lottie/lottie.dart';

import '../../../config/themes/themedata.dart';
import '../../../domain/entities/models/ticket.dart';
import '../../../domain/repositories/cmd_stream_repository.dart';

import '../../../../core/utils/aro_assets.dart';

class HistorialDetails extends StatefulWidget {
  const HistorialDetails({
    super.key,
    required this.height,
    required this.width,
  });

  final double height;
  final double width;

  @override
  State<HistorialDetails> createState() => _HistorialDetailsState();
}

class _HistorialDetailsState extends State<HistorialDetails> {
  final ScrollController _scrollController = ScrollController();
  List<Ticket> historial = [];
  StreamSubscription<String>? _cmdSubscription;
  int _selectedIndex = 0;
  int _counter = 0;
  late Timer _timer;

  void _printTicket() {
    // TODO: Se valida que se manda a imprimir
    // print(
    //   'Printing ticket for: $_selectedIndex ::  ${historial[_selectedIndex].date} - ${historial[_selectedIndex].tipo} ',
    // );

    if (mounted) {
      _timer.cancel();
      Navigator.pop(context, true);
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

  void _scrollToSelectedElement() {
    if (_scrollController.hasClients) {
      final double itemHeight = 70.0;
      final double targetOffset = _selectedIndex * itemHeight;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
  }

  void _initStream() {
    final cmdStream = Provider.of<CmdStreamRepository>(context, listen: false);
    _cmdSubscription = cmdStream.cmdStreamListen.listen((cmd) {
      if (!mounted) return;

      if (ModalRoute.of(context)?.isCurrent == true) {
        switch (cmd) {
          case 'up':
            if (_selectedIndex > 0) {
              _selectedIndex--;
              _updateItem();
            }
            break;
          case 'down':
            if (_selectedIndex < historial.length - 1) {
              _selectedIndex++;
              _updateItem();
            }
            break;
          case 'accept':
            if (historial.isEmpty) {
              if (mounted) {
                _timer.cancel();
                Navigator.pop(context, false);
              }
            } else {
              _printTicket();
            }
            break;

          default:
        }
      }
    });
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

  void _loadData() {
    // leer los datos del db y actualizar
  }

  @override
  void initState() {
    super.initState();
    _initStream();
    _initTimer();
    _loadData();
  }

  @override
  void dispose() {
    _cmdSubscription?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cmdStream = Provider.of<CmdStreamRepository>(context, listen: false);

    return Container(
      height: widget.height,
      width: widget.width / 0.8,
      color: secondaryColor,
      child: historial.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: widget.height * 0.5,
                    width: widget.width * 0.7,
                    child: Lottie.asset(
                      ARoAssets.animations('warning'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                  Text(
                    'No hay reportes para mostrar',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  SizedBox(height: 30),

                  /// Enter
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.blue.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () => cmdStream.cmdStreamSend.add('accept'),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        padding: const EdgeInsets.all(20),
                      ),
                      child: const Icon(
                        Icons.subdirectory_arrow_left,
                        size: 60,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Text(
                      'Historial de Reportes',
                      style: TextStyle(
                        fontSize: 40,
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
                              color: historial[i].isSelected
                                  ? primaryColor
                                  : Colors.grey.shade300,
                            ),
                            child: ListTile(
                              title: Text(
                                '${historial[i].date} - ${historial[i].titulo}',
                                style: TextStyle(
                                  fontSize: 35,
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
                      onPressed: () => cmdStream.cmdStreamSend.add('accept'),
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
                      onPressed: () => cmdStream.cmdStreamSend.add('up'),
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
                      onPressed: () => cmdStream.cmdStreamSend.add('down'),
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
