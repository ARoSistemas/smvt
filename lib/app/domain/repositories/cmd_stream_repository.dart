import 'dart:async';

abstract class CmdStreamRepository {
  /// Stream de escucha para recibir datos del puerto serial
  Stream<String> get cmdStreamListen;

  /// StreamSink para enviar datos por el stream
  StreamSink<String> get cmdStreamSend;

  /// Envía datos al puerto serial
  void send(String data);
}
