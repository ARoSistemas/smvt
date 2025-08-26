import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'printing.dart';
import 'descarga.dart';
import 'historial.dart';

import '../../../config/themes/themedata.dart';

import '../../../domain/entities/models/tank.dart';
import '../../../domain/entities/models/reports.dart';
import '../../../domain/repositories/cmd_stream_repository.dart';

import '../../../../core/widgets/fuel_tank.dart';
import '../../../../core/utils/aro_size_scaler.dart';
import '../../../../core/widgets/wdgt_aro_image.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key, required this.tank});

  final Tank tank;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  StreamSubscription<String>? _cmdSubscription;
  ARoSizeScaler hw = ARoSizeScaler(size: Size.zero);

  int _selectedIndex = 0;
  int _counter = 0;
  late Timer _timer;

  List<Reporte> historial = [
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: false),
    Reporte(date: '2025-08-01 00:15', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 01:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 03:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 12:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: false),
    Reporte(date: '2025-08-01 00:15', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 01:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 03:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 12:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: false),
    Reporte(date: '2025-08-01 00:15', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 01:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 03:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 12:00', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Descarga', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
    Reporte(date: '2025-08-01 10:10', tipo: 'Estatus', isSelected: false),
  ];

  void _selectMenu() {
    switch (_selectedIndex) {
      case 0:
        _mnuPrinting();
        break;
      case 1:
        _mnuHistorial();
        break;
      case 2:
        _mnuDescarga();
        break;
    }
  }

  void _mnuHistorial() {
    _timer.cancel();
    _counter = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: HistorialDetails(
            height: hw.pHeight(75),
            width: hw.pWidth(50),
            historial: historial,
          ),
        );
      },
    ).then((isPrinting) {
      _initTimer();
      if (isPrinting == true) {
        _mnuPrinting();
      }
    });
  }

  void _mnuDescarga() {
    _timer.cancel();
    _counter = 0;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: DescargaPage(height: hw.pHeight(75), width: hw.pWidth(40)),
        );
      },
    ).then((_) {
      _initTimer();
    });
  }

  void _mnuPrinting() {
    _timer.cancel();
    _counter = 0;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: Printing(height: hw.pHeight(75), width: hw.pWidth(50)),
        );
      },
    ).then((_) {
      _initTimer();
    });

    // final cmdStream = Provider.of<CmdStreamRepository>(context, listen: false);
    // cmdStream.send('getstatus');

    // /// Espera la respuesta por máximo 10 segundos
    // final completer = Completer<String>();
    // late StreamSubscription sub;
    // sub = cmdStream.cmdStreamListen.listen((response) {
    //   /// falta la respuesta
    //   if (response == 'status_ok') {
    //     completer.complete(response);
    //     sub.cancel();
    //   }
    // });

    // completer.future
    //     .timeout(Duration(seconds: 10))
    //     .then((_) {
    //       ///
    //       /// Teniendo el nivel actual se prepara la info y se manda
    //       /// por puerto serial para ser impresa.
    //       ///
    //       cmdStream.send('se manda el json del ticket');

    //       if (!mounted) return;
    //       showDialog(
    //         context: context,
    //         builder: (BuildContext context) {
    //           return AlertDialog(
    //             backgroundColor: secondaryColor,
    //             content: Printing(
    //               height: hw.pHeight(75),
    //               width: hw.pWidth(50),
    //             ),
    //           );
    //         },
    //       ).then((_) {
    //         _initTimer();
    //       });
    //     })
    //     .catchError((_) {
    //       sub.cancel();
    //       if (!mounted) return;
    //       ScaffoldMessenger.of(context).showSnackBar(
    //         SnackBar(
    //           content: Text('No se recibió respuesta del ControlBIn Tanques'),
    //         ),
    //       );
    //     });
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

  void _initStream() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final cmdStream = Provider.of<CmdStreamRepository>(
        context,
        listen: false,
      );
      _cmdSubscription = cmdStream.cmdStreamListen.listen((cmd) {
        if (!mounted) return;
        if (ModalRoute.of(context)?.isCurrent == true) {
          switch (cmd) {
            case 'left':
              if (_selectedIndex > 0) {
                _selectedIndex--;
                setState(() {});
              }
              break;
            case 'right':
              if (_selectedIndex < 2) {
                _selectedIndex++;
                setState(() {});
              }
              break;
            case 'accept':
              _selectMenu();
              break;
            case 'initload':
              // TODO: Aqui se inicia el proceso de carga.
              /// Se solicita primero el nivel actual
              ///
              /// Se guarda y se mantiene a la espera el siguiente estatus
              ///
              /// Cuando se toca en finalizar entonces, se recibe el nuevo estatus
              /// Y se procede con las demás operaciones.
              break;
            default:
          }
        }

        if (cmd == 'findescarga') {
          // TODO: Aquí se maneja la respuesta de la búsqueda de descarga.
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _initTimer();

    _initStream();
  }

  @override
  void dispose() {
    _cmdSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cmdStream = Provider.of<CmdStreamRepository>(context, listen: false);

    return LayoutBuilder(
      builder: (context, constraints) {
        hw = ARoSizeScaler(
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );

        return Scaffold(
          appBar: AppBar(
            title: Text(
              'ControlBIn - ${widget.tank.nameTank} ${widget.tank.product}  ',
            ),
          ),
          backgroundColor: Colors.grey.shade100,
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(height: 50),

                /// Tank Details
                Stack(
                  children: [
                    /// Tank
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        width: hw.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 40),
                            Container(
                              padding: EdgeInsets.all(20.0),
                              height: hw.pHeight(38),
                              width: hw.pWidth(43),
                              child: AnimatedFuelTank(
                                fuelLevel: widget.tank.percentage,
                                tankColor: widget.tank.scaleColor,
                                isActive: widget.tank.isActive,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    /// porcentaje
                    Positioned(
                      top: hw.height * 0.06,
                      left: hw.width * 0.47,
                      child: Text(
                        '70',
                        style: TextStyle(
                          fontSize: hw.pText(7),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Positioned(
                      top: hw.height * 0.11,
                      left: hw.width * 0.58,
                      child: Text(
                        '%',
                        style: TextStyle(
                          fontSize: hw.pText(4),
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),

                    ///
                    /// Medidas del nivel
                    ///
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        /// Centimetros
                        Column(
                          children: [
                            Text(
                              widget.tank.nameTank,
                              style: TextStyle(
                                fontSize: hw.pText(5),
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: hw.pHeight(5),
                              width: hw.pWidth(5),
                            ),
                            ARoImage(
                              img: 'nivel',
                              type: 'png',
                              height: hw.pHeight(9),
                              fit: BoxFit.contain,
                            ),
                            Text(
                              'Vacio: 30 cms',
                              style: TextStyle(
                                fontSize: hw.pText(2),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              'Nivel: 70 cms',
                              style: TextStyle(
                                fontSize: hw.pText(2),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: hw.pHeight(40), width: hw.pWidth(60)),

                        /// Litros
                        Column(
                          children: [
                            Text(
                              widget.tank.product,
                              style: TextStyle(
                                fontSize: hw.pText(5),
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                            ),
                            SizedBox(
                              height: hw.pHeight(5),
                              width: hw.pWidth(5),
                            ),
                            ARoImage(
                              img: 'litros',
                              type: 'png',
                              height: hw.pHeight(9),
                              fit: BoxFit.contain,
                            ),
                            Text(
                              '3,000 Lts',
                              style: TextStyle(
                                fontSize: hw.pText(2),
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Text(
                              '7,000 Lts',
                              style: TextStyle(
                                fontSize: hw.pText(2),
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

                SizedBox(height: 60),

                /// Botones
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Print
                    Container(
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
                            height: hw.pHeight(15),
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'Imprimir\nEstatus',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: hw.pText(2),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Reports
                    Container(
                      padding: const EdgeInsets.all(15),
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
                            height: hw.pHeight(15),
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'ReImprimir\n ',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: hw.pText(2),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    /// Iniciar descarga
                    Container(
                      padding: const EdgeInsets.all(15),
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
                            height: hw.pHeight(15),
                            fit: BoxFit.contain,
                          ),
                          Text(
                            'Iniciar\nDescarga',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: hw.pText(2),
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Aceptar
              FloatingActionButton(
                backgroundColor: secondaryColor,
                heroTag: 'accept',
                onPressed: () => cmdStream.cmdStreamSend.add('accept'),
                child: const Icon(
                  Icons.subdirectory_arrow_left,
                  color: Colors.black,
                ),
              ),
              const SizedBox(width: 50),

              /// Izquierda
              FloatingActionButton(
                backgroundColor: secondaryColor,
                heroTag: 'left',
                onPressed: () => cmdStream.cmdStreamSend.add('left'),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              const SizedBox(width: 16),

              /// Derecha
              FloatingActionButton(
                backgroundColor: secondaryColor,
                heroTag: 'down',
                onPressed: () => cmdStream.cmdStreamSend.add('right'),
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
