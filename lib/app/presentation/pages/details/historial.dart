import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lottie/lottie.dart';

import '../../providers/general_provider.dart';

import '../../../config/constans/cfg_my_enums.dart';
import '../../../config/themes/themedata.dart';

import '../../../domain/repositories/repository_auth.dart';
import '../../../domain/repositories/cmd_stream_repository.dart';

import '../../../domain/entities/models/mdl_ticket.dart';

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

  void _closeDialog() {
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
        /// Mover arriba
        if (cmd.contains('up') && _selectedIndex > 0) {
          _selectedIndex--;
          _counter = 0;
          _updateItem();
        }

        /// Mover abajo
        if (cmd.contains('down') && _selectedIndex < historial.length - 1) {
          _selectedIndex++;
          _counter = 0;
          _updateItem();
        }

        /// Aceptar e imprimir
        if (cmd.contains('accept')) {
          if (historial.isEmpty) {
            if (mounted) {
              _timer.cancel();
              Navigator.pop(context, false);
            }
          } else {
            /// Se envia por puerto serial
            cmdStream.sendToPort(historial[_selectedIndex].toJson());

            _closeDialog();
          }
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

  Future<void> _loadData() async {
    // leer los datos del db y actualizar
    final stateProvider = context.read<GeneralProvider>();
    final customer = stateProvider.empresa;
    final address = stateProvider.direccion;

    /// Se recibe el nivel actual del vacio del tanque en centímetros
    final authImpl = Provider.of<AuthRepository>(context, listen: false);

    /// Se obtiene el historial de tickets
    final fetch = await authImpl.fetchLastTickets();
    historial = fetch.map((ticket) {
      return ticket.copyWith(
        customer: customer,
        address: address,
        title: ticket.typeTicket == 0
            ? TicketType.inventory.type
            : TicketType.reception.type,
      );
    }).toList();

    historial[0].isSelected = true;
    setState(() {});

    return;
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: widget.height * 0.4,
                      width: widget.width * 0.7,
                      child: Lottie.asset(
                        ARoAssets.animations('warning'),
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                    Text(
                      'No hay reportes para mostrar',
                      style: TextStyle(
                        fontSize: widget.height * 0.1,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(height: widget.height * 0.04),

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
                        child: Icon(
                          Icons.subdirectory_arrow_left,
                          size: widget.height * 0.06,
                        ),
                      ),
                    ),
                  ],
                ),
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
                        fontSize: widget.height * 0.06,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    SizedBox(
                      height: widget.height / 1.21,
                      width: widget.width,
                      child: Scrollbar(
                        thumbVisibility: true,
                        trackVisibility: true,
                        thickness: 8.0,
                        controller: _scrollController,
                        radius: const Radius.circular(10),
                        child: ListView.builder(
                          itemCount: historial.length,
                          controller: _scrollController,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, i) {
                            return Container(
                              margin: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: historial[i].isSelected
                                      ? primaryColor
                                      : Colors.grey.shade300,
                                  width: 2,
                                ),
                                color: historial[i].isSelected
                                    ? Colors.blue.withValues(alpha: 0.2)
                                    : Colors.grey.shade300,
                              ),
                              child: ListTile(
                                title: Text(
                                  '${historial[i].date} - ${historial[i].title}',
                                  style: TextStyle(
                                    fontSize: widget.height * 0.04,
                                    fontWeight: FontWeight.bold,
                                    color: historial[i].isSelected
                                        ? primaryColor
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  '${historial[i].product} | Litros Init: ${historial[i].ltsCurrentInit} | Litros End: ${historial[i].ltsCurrentEnd}',
                                  style: TextStyle(
                                    fontSize: widget.height * 0.045,
                                    fontWeight: FontWeight.bold,
                                    color: historial[i].isSelected
                                        ? Colors.black
                                        : Colors.black,
                                  ),
                                ),
                                trailing: Icon(
                                  historial[i].isSelected
                                      ? Icons.check_circle
                                      : Icons.circle_outlined,
                                  color: historial[i].isSelected
                                      ? primaryColor
                                      : Colors.grey.shade100,
                                ),
                              ),
                            );
                          },
                        ),
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
