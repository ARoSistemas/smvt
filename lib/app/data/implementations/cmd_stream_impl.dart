import 'dart:async';

import '../../domain/repositories/cmd_stream_repository.dart';

import '../../../core/utils/serial_manager.dart';

class CmdStreamImpl implements CmdStreamRepository {
  ///
  /// Permite enviar datos al stream para pruebas sin puerto serial
  ///
  final StreamController<String> _stream = StreamController<String>.broadcast();
  late final StreamSubscription<String> serialSubscription;
  late final SerialManager _serialManager;
  String _portName = 'COM100';

  @override
  String get portName => _portName;

  @override
  Stream<String> get cmdStreamListen => _stream.stream;

  @override
  StreamSink<String> get cmdStreamSend => _stream.sink;

  @override
  void sendToPort(String data) {
    print('Se envia al puerto serial : $data');
    // _serialManager.writeToPort(data);
  }

  @override
  void updatePort(String newPortName) {
    _portName = newPortName;
    // Aquí se puede reiniciar la conexión o realizar otras acciones necesarias
  }

  @override
  void init() {
    // Inicializa y escucha el SerialManager
    _serialManager = SerialManager();

    _serialManager.initializeAndListen(portName: portName);

    serialSubscription = _serialManager.commandsStream.listen(
      (event) {
        _stream.add(event);
      },
      onError: (error) {
        _stream.add('ERROR: $error');
      },
      onDone: () {
        _stream.add('Serial stream closed');
      },
    );
  }
}
