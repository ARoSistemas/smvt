import 'dart:async';
import 'dart:typed_data';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class SerialManager {
  static final SerialManager _instance = SerialManager._internal();
  factory SerialManager() => _instance;

  SerialManager._internal();

  final _commandsController = StreamController<String>.broadcast();
  Stream<String> get commandsStream => _commandsController.stream;

  SerialPort? _serialPort;
  Timer? _reconnectTimer;
  String? _portName;

  Future<void> initializeAndListen({required String portName}) async {
    _portName = portName;
    _serialPort = SerialPort(portName);

    await _connect();
  }

  Future<void> _connect() async {
    try {
      // Si ya está conectado, no hagas nada
      if (_serialPort?.isOpen ?? false) {
        return;
      }
      if (_serialPort?.openReadWrite() ?? false) {
        // print('Puerto serial $_portName conectado con éxito.');
        _startListening();
        // Cancela cualquier temporizador de reconexión si la conexión fue exitosa.
        _reconnectTimer?.cancel();
      } else {
        throw Exception('No se pudo abrir el puerto.');
      }
    } catch (e) {
      // print('Error al conectar con el puerto: $e');
      // Inicia el temporizador de reconexión si no hay conexión activa.
      _commandsController.addError('Connection lost');
      _scheduleReconnect();
    }
  }

  SerialPortReader? _portReader;
  StreamSubscription<Uint8List>? _portSubscription;

  void _startListening() {
    // Usa SerialPortReader para escuchar datos entrantes.
    if (_serialPort == null) return;

    _portReader?.close();
    _portSubscription?.cancel();

    _portReader = SerialPortReader(_serialPort!);
    _portSubscription = _portReader!.stream.listen(
      (data) {
        final command = String.fromCharCodes(data).trim();
        _commandsController.add(command);
      },
      onError: (error) {
        // print('Error en el stream del puerto: $error');
        _commandsController.addError('Stream error');
        _disconnectAndReconnect();
      },
      onDone: () {
        // print('Stream del puerto completado.');
        _disconnectAndReconnect();
      },
    );
  }

  void _disconnectAndReconnect() {
    _serialPort?.close();
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    // Programa una reconexión si aún no hay un temporizador activo.
    if (_reconnectTimer == null || !_reconnectTimer!.isActive) {
      _reconnectTimer = Timer(const Duration(seconds: 5), () {
        if (_portName != null) {
          _connect();
        }
      });
    }
  }

  void dispose() {
    _reconnectTimer?.cancel();
    _portSubscription?.cancel();
    _portReader?.close();
    _serialPort?.close();
    _commandsController.close();
  }

  void writeToPort(String data) {
    _serialPort?.write(Uint8List.fromList(data.codeUnits));
  }
}
