import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'printing.dart';
import 'descarga.dart';
import 'historial.dart';

import '../../../config/themes/themedata.dart';

import '../../../domain/entities/models/tank.dart';
import '../../../domain/entities/models/ticket.dart';
import '../../../domain/entities/models/lectura.dart';

import '../../../domain/repositories/cmd_stream_repository.dart';
import '../../../domain/repositories/repository_auth.dart';

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
  final tmpTicket = Ticket.empty();
  late Timer _timer;

  ///
  ///
  ///   Borrar este snipper
  ///
  ///

  /// Devuelve un número entero aleatorio entre 1 y 298, ambos inclusive.
  int getRandomNumber() {
    final random = Random();
    final randomNumber = random.nextInt(298);
    return randomNumber + 1;
  }

  ///
  ///
  ///
  ///
  ///

  void _selectMenu() {
    switch (_selectedIndex) {
      case 0:
        _fetchNivel(true);
        // _mnuPrinting(holdOn: false);
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
          ),
        );
      },
    ).then((isPrinting) {
      _initTimer();
      if (isPrinting == true) {
        _mnuPrinting(holdOn: false);
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

  Future<String> _prepareTicket(int nivel, bool tipo) async {
    /// Se recibe el nivel actual del vacio del tanque en centímetros
    /// Se obtiene la capacidad del tanque en centimetros
    final authImpl = Provider.of<AuthRepository>(context, listen: false);
    final capacidadTanqueCms = authImpl.capacidadTanqueCms();

    /// Se calcula el nivel real en centimetros
    final nivelRealCms = capacidadTanqueCms - nivel;

    /// busco en la tabla el nivel en litros
    final Lectura lectura = await authImpl.fetchDataNivel(nivelRealCms);

    final uuid = authImpl.getUuid();

    final ticket = lectura.copyWith(
      uuid: uuid,
      date: DateTime.now().toString().substring(0, 19),
      tipo: tipo ? 0 : 1,
    );

    // final Ticket ticket = Ticket(
    //   uuid: uuid,
    //   date: date,
    //   empresa: empresa,
    //   direccion: direccion,
    //   titulo: titulo,
    //   producto: producto,
    //   cmVacioInit: cmVacioInit,
    //   cmNivelInit: cmNivelInit,
    //   percentageVacioInit: percentageVacioInit,
    //   percentageNivelInit: percentageNivelInit,
    //   ltsPorLlenarInit: ltsPorLlenarInit,
    //   ltsActualesInit: ltsActualesInit,
    //   cmVacioEnd: cmVacioEnd,
    //   cmNivelEnd: cmNivelEnd,
    //   percentageVacioEnd: percentageVacioEnd,
    //   percentageNivelEnd: percentageNivelEnd,
    //   ltsPorLlenarEnd: ltsPorLlenarEnd,
    //   ltsActualesEnd: ltsActualesEnd,
    //   tipoTicket: tipoTicket,
    //   isSelected: isSelected,
    // );

    /// Se envia la lectura al api para que la guarde en la base de datos
    /// Se espera respuesta del API, para enviar a guardar localmente

    ///
    print(ticket.toRaw());
    return r'elTicket';
  }

  void _fetchNivel(bool tipo) async {
    /// Se muestra animación de impresión
    _mnuPrinting(holdOn: true);

    // /// Se píde el nivel actual al CBIn
    // final cmdStream = Provider.of<CmdStreamRepository>(context, listen: false);
    // cmdStream.send('getstatus');

    // /// Espera la respuesta por máximo 20 segundos
    // final completer = Completer<String>();
    // int elNivel = 0;

    // late StreamSubscription sub;
    // sub = cmdStream.cmdStreamListen.listen((response) {
    //   completer.complete(response);
    //   sub.cancel();

    //   if (response != '0') {
    //     elNivel = int.tryParse(response) ?? 0;
    //   }
    // });

    // completer.future
    //     .timeout(Duration(seconds: 20))
    //     .then((_) async {
    //       ///
    //       /// Teniendo el nivel actual se prepara la info y se manda
    //       /// por puerto serial para ser impresa.
    //       ///

    //       /// obtener el ticket en raw
    //       // final String ticket = _prepareTicket(elNivel);
    // final ticket = await _prepareTicket(getRandomNumber());
    await _prepareTicket(getRandomNumber(), tipo);

    //       cmdStream.send(ticket);

    //       /// Se cierra la animación de impresión
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

    if (!mounted) return;
    Navigator.pop(context);
  }

  void _mnuPrinting({required bool holdOn}) {
    _timer.cancel();
    _counter = 0;

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: secondaryColor,
          content: Printing(
            height: hw.pHeight(75),
            width: hw.pWidth(50),
            holdOn: holdOn,
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
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ControlBIn - ${widget.tank.nameTank} ${widget.tank.product}',
                  style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          backgroundColor: Colors.grey.shade100,
          body: Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: [
                SizedBox(height: 40),

                /// Tank Details
                Stack(
                  children: [
                    /// Tank
                    Positioned(
                      top: 0,
                      left: 0,
                      child: SizedBox(
                        height: hw.pHeight(37),
                        width: hw.width,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 40),
                            AnimatedFuelTank(
                              fuelLevel: widget.tank.percentage,
                              tankColor: widget.tank.scaleColor,
                              isActive: widget.tank.isActive,
                              height: hw.pHeight(33),
                              width: hw.pWidth(40),
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
