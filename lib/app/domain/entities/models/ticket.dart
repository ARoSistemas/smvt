import 'dart:convert';

class Ticket {
  Ticket({
    required this.uuid,
    required this.date,
    required this.tipo,
    required this.nivel,
  });

  final String uuid;
  final String date;
  final String tipo;
  final String nivel;

  factory Ticket.fromRaw(String str) => Ticket.fromMap(json.decode(str));

  factory Ticket.fromMap(Map<String, dynamic> map) => Ticket(
    uuid: map['uuid'] ?? '',
    date: map['date'] ?? '',
    tipo: map['tipo'] ?? '',
    nivel: map['nivel'] ?? '',
  );

  factory Ticket.empty() {
    return Ticket(uuid: '', date: '', tipo: '', nivel: '');
  }

  String toRaw(Ticket ticket) => jsonEncode({
    'uuid': ticket.uuid,
    'date': ticket.date,
    'tipo': ticket.tipo,
    'nivel': ticket.nivel,
  });
}
