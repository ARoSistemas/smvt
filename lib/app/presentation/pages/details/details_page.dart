import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../config/constans/cfg_my_enums.dart';
import 'printing.dart';
import 'descarga.dart';
import 'historial.dart';

import '../../providers/general_provider.dart';
import '../../../config/themes/themedata.dart';

import '../../../domain/entities/models/mdl_tank.dart';
import '../../../domain/entities/models/mdl_ticket.dart';
import '../../../domain/entities/models/mdl_lectura.dart';

import '../../../domain/repositories/repository_auth.dart';
import '../../../domain/repositories/cmd_stream_repository.dart';

import '../../../../core/utils/aro_assets.dart';
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

  int levelVacuumInit = 0;
  int levelVacuumEnd = 0;
  bool isInventory = true;
  bool isDownloadInit = false;
  bool showLoading = false;

  ///
  ///
  ///   Borrar este snipper
  ///
  ///

  /// Devuelve un número entero aleatorio entre 1 y 298, ambos inclusive.
  int getRandomNumber(bool isInit) {
    final random = Random();
    final randomNumber = isInit
        ? random.nextInt(198)
        : random.nextInt(100) + 198;
    return randomNumber + 1;
  }

  ///
  ///
  ///
  ///
  ///

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
        _mnuPrinting(false);
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

  Future<Ticket> _prepareTicket({
    required int cmsVacuumInit,
    required int cmsVacuumEnd,
  }) async {
    final stateProvider = context.read<GeneralProvider>();

    final customer = stateProvider.empresa;
    final address = stateProvider.direccion;

    /// Se obtiene la capacidad del tanque en centimetros
    final capacityTankCms = stateProvider.capacityTankCms;
    final capacityTankLiters = stateProvider.capacityTankLiters;

    /// Se recibe el nivel actual del vacio del tanque en centímetros
    final authImpl = Provider.of<AuthRepository>(context, listen: false);

    /// Datos iniciales
    final uuid = authImpl.getUuid();
    final int cmsVolumeInit = capacityTankCms - cmsVacuumInit;

    /// busco en la tabla el nivel en litros inicial
    final Lectura readingInit = await authImpl.fetchDataNivel(cmsVolumeInit);

    /// Litros en miles
    final tmpLtsToFillInit = capacityTankLiters - readingInit.liters;
    final ltsToFillInit = stateProvider.formatNumber(tmpLtsToFillInit);
    final ltsCurrentInit = stateProvider.formatNumber(readingInit.liters);

    /// Datos finales
    final int cmsVolumeEnd = !isInventory
        ? (capacityTankCms - cmsVacuumEnd)
        : 0;
    final Lectura readingEnd = !isInventory
        ? await authImpl.fetchDataNivel(cmsVolumeEnd)
        : Lectura.empty();

    final ltsToFillEnd = stateProvider.formatNumber(
      (capacityTankLiters - readingEnd.liters),
    );

    final ltsCurrentEnd = stateProvider.formatNumber(readingEnd.liters);

    final Ticket ticket = Ticket(
      uuid: uuid,
      date: DateTime.now().toString().substring(0, 19),
      customer: customer,
      address: address,
      title: isInventory
          ? TicketType.inventory.type
          : TicketType.reception.type,
      product: 'T1:${widget.tank.product}',
      cmVacuumInit: cmsVacuumInit.toString(),
      cmVolumeInit: cmsVolumeInit.toString(),
      ltsToFillInit: ltsToFillInit,
      ltsCurrentInit: ltsCurrentInit,
      percentageVacuumInit:
          '${((cmsVacuumInit * 100) / 299).toStringAsFixed(0)} %',
      percentageVolumeInit:
          '${((cmsVolumeInit * 100) / 299).toStringAsFixed(0)} %',
      cmVacuumEnd: cmsVacuumEnd.toString(),
      cmVolumeEnd: cmsVolumeEnd.toString(),
      percentageVacuumEnd:
          '${((cmsVacuumEnd * 100) / 299).toStringAsFixed(0)} %',
      percentageVolumeEnd:
          '${((cmsVolumeEnd * 100) / 299).toStringAsFixed(0)} %',
      ltsToFillEnd: !isInventory ? ltsToFillEnd : '0',
      ltsCurrentEnd: ltsCurrentEnd,
      typeTicket: isInventory ? 0 : 1,
      isSelected: false,
      isSend: 0,
    );

    /// Se guarda el ticket de lectura
    authImpl.saveTicket(ticket);

    return ticket;
  }

  void _mnuPrinting(bool holdOn) {
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

      _cmdSubscription = cmdStream.cmdStreamListen.listen((cmd) async {
        if (cmd.contains('left') || cmd.contains('right')) {
          print('Se recibe navegación: $cmd');
          _counter = 0;
        }

        if (!mounted) return;
        if (ModalRoute.of(context)?.isCurrent == true) {
          /// Mover a la izquierda
          if (cmd.contains('left') && _selectedIndex > 0) {
            _selectedIndex--;
            _counter = 0;
            setState(() {});
          }

          /// Mover a la derecha
          if (cmd.contains('right') && _selectedIndex < 2) {
            _selectedIndex++;
            _counter = 0;
            setState(() {});
          }

          /// Aceptar
          if (cmd.contains('accept')) {
            switch (_selectedIndex) {
              case 0:

                /// Se establece que es un inventario
                isInventory = true;
                levelVacuumInit = 0;
                levelVacuumEnd = 0;
                isDownloadInit = true;

                /// Se muestra animación de impresión
                _mnuPrinting(true);

                /// Y se pide la lectura del tanque
                final cmd = jsonEncode({'cmd': 'status'});

                ///
                /// Se simula Solicitar la lectura del tanque
                ///
                cmdStream.cmdStreamSend.add(cmd);

                ///
                ///  Borrar hasta aqui
                ///

                /// Se envia por puerto serial
                cmdStream.sendToPort(cmd);

                /// Eliminar esta linea
                ///  Se simula la lectura del tanque
                Future.delayed(Duration(seconds: 2), () {
                  cmdStream.cmdStreamSend.add(
                    jsonEncode({'level': getRandomNumber(false)}),
                  );

                  ///
                });

                break;
              case 1:
                _mnuHistorial();
                break;
              case 2:
                showLoading = true;
                setState(() {});

                /// Se establece que es una descarga
                isInventory = false;
                levelVacuumInit = 0;
                levelVacuumEnd = 0;
                isDownloadInit = true;

                /// Y se pide la lectura inicial del tanque
                final cmd = jsonEncode({'cmd': 'status'});

                ///
                ///  Se simula Solicitar la lectura del tanque
                ///  Se borra esta linea.
                cmdStream.cmdStreamSend.add(cmd);

                ///
                ///
                ///
                cmdStream.sendToPort(cmd);

                /// Eliminar este snippet
                ///
                /// Se simula la lectura del tanque en 2 seg.
                await Future.delayed(Duration(seconds: 2), () {
                  cmdStream.cmdStreamSend.add(
                    jsonEncode({'level': getRandomNumber(false)}),
                  );
                });

                ///
                ///
                ///
                break;
            }
          }
        }

        /// se recibe la lectura del tanque
        /// y se tiene un modal enfrente
        if (cmd.contains('level')) {
          /// Al recibir el status se prepara los datos
          print('Se recibe el nivel del tanque: $cmd');

          /// Y se valida si status o recepcion
          if (isInventory) {
            ///
            /// Si es un status se procede de inmediato
            /// a imprimir el ticket extrayendo el nivel
            final level = jsonDecode(cmd);

            levelVacuumInit = level['level'] ?? 0;

            /// Teniendo los datos se procede a imprimir el ticket
            /// Se obtiene el ticket completo
            final Ticket ticket = await _prepareTicket(
              cmsVacuumInit: levelVacuumInit,
              cmsVacuumEnd: levelVacuumEnd,
            );

            /// Se manda a imprimir el ticket
            cmdStream.sendToPort(ticket.toJson());

            /// Se cierra el dialogo de impresion
            if (!mounted) return;
            Navigator.pop(context);
          } else {
            /// Si es descarga se valida si es incial o final
            final level = jsonDecode(cmd);

            if (isDownloadInit) {
              levelVacuumInit = level['level'] ?? 0;
              isDownloadInit = false;
              _mnuDescarga();
            } else {
              /// Se obtiene la lectura al final de la descarga
              levelVacuumEnd = level['level'] ?? 0;

              /// Teniendo las lecturas inicial y final
              /// Se obtiene el ticket completo
              final Ticket ticket = await _prepareTicket(
                cmsVacuumInit: levelVacuumInit,
                cmsVacuumEnd: levelVacuumEnd,
              );

              /// Se manda a imprimir el ticket de la descarga
              cmdStream.sendToPort(ticket.toJson());
            }

            showLoading = false;
            setState(() {});
          }

          ///
        }

        ///
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
          body: showLoading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: hw.pHeight(50),
                        width: hw.pWidth(50),
                        child: Lottie.asset(
                          ARoAssets.animations('descarga'),
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                      Text(
                        'Iniciando la descarga de combustible',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                      Text(
                        'Espere por favor...',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SingleChildScrollView(
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
                                      'Vacuum: 30 cms',
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

                                SizedBox(
                                  height: hw.pHeight(40),
                                  width: hw.pWidth(60),
                                ),

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
                                    'Imprimir\nInventario',
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
                ),
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Aceptar
              FloatingActionButton(
                backgroundColor: secondaryColor,
                heroTag: 'accept',
                onPressed: () =>
                    cmdStream.cmdStreamSend.add(jsonEncode({'cmd': 'accept'})),
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
                onPressed: () =>
                    cmdStream.cmdStreamSend.add(jsonEncode({'cmd': 'left'})),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              const SizedBox(width: 16),

              /// Derecha
              FloatingActionButton(
                backgroundColor: secondaryColor,
                heroTag: 'right',
                onPressed: () =>
                    cmdStream.cmdStreamSend.add(jsonEncode({'cmd': 'right'})),
                child: const Icon(Icons.arrow_forward, color: Colors.black),
              ),
            ],
          ),
        );
      },
    );
  }
}
