import 'dart:async';

import '../../domain/repositories/cmd_stream_repository.dart';

import '../../../core/utils/serial_manager.dart';

class CmdStreamImpl implements CmdStreamRepository {
  /// Permite enviar datos al stream para pruebas sin puerto serial
  final StreamController<String> _stream = StreamController<String>.broadcast();
  late final StreamSubscription<String> serialSubscription;
  late final SerialManager _serialManager;

  /// Constructor de la clase
  CmdStreamImpl({required String portName}) {
    // TODO: Descomentar este snippet cuando se tenga la conexión al puerto serial
    // Inicializa y escucha el SerialManager
    // _serialManager = SerialManager();

    // _serialManager.initializeAndListen(portName: portName);

    // serialSubscription = _serialManager.commandsStream.listen(
    //   (event) {
    //     _stream.add(event);
    //   },
    //   onError: (error) {
    //     _stream.add('ERROR: $error');
    //   },
    //   onDone: () {
    //     _stream.add('Serial stream closed');
    //   },
    // );
  }

  @override
  Stream<String> get cmdStreamListen => _stream.stream;

  @override
  StreamSink<String> get cmdStreamSend => _stream.sink;

  @override
  void send(String data) {
    _serialManager.writeToPort(data);
  }
}
