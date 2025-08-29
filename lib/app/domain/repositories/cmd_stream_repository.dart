import 'dart:async';

abstract class CmdStreamRepository {
  /// Stream de escucha para recibir datos del puerto serial
  Stream<String> get cmdStreamListen;

  /// StreamSink para enviar datos por el stream
  StreamSink<String> get cmdStreamSend;

  /// Nombre del puerto serial
  String get portName;

  /// Envía datos al puerto serial
  void sendToPort(String data);

  /// Inicializa el repositorio
  void init();

  /// Actualiza el nombre del puerto serial
  void updatePort(String newPortName);
}
