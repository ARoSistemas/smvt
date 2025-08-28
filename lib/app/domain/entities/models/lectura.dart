class Lectura {
  Lectura({
    required this.uuid,
    required this.date,
    required this.tipo,
    required this.cms,
    required this.cubic,
    required this.liters,
    required this.isSend,
  });

  String uuid;
  String date;
  int tipo;
  int cms;
  double cubic;
  int liters;
  int isSend;

  factory Lectura.fromJsonRaw(Map<String, dynamic> jsonRaw) => Lectura(
    uuid: jsonRaw['uuid'] ?? '',
    date: jsonRaw['date'] ?? '',
    tipo: 0,
    cms: jsonRaw['cms'] ?? 0,
    cubic: double.parse(jsonRaw['cubic'] ?? '0.0'),
    liters: int.parse(jsonRaw['liters'] ?? '0'),
    isSend: jsonRaw['isSend'] ?? 0,
  );

  factory Lectura.empty() => Lectura(
    uuid: '',
    date: '',
    tipo: 0,
    cms: 0,
    cubic: 0,
    liters: 0,
    isSend: 0,
  );

  Lectura copyWith({
    String? uuid,
    String? date,
    int? tipo,
    int? cms,
    double? cubic,
    int? liters,
    int? isSend,
  }) => Lectura(
    uuid: uuid ?? this.uuid,
    date: date ?? this.date,
    tipo: tipo ?? this.tipo,
    cms: cms ?? this.cms,
    cubic: cubic ?? this.cubic,
    liters: liters ?? this.liters,
    isSend: isSend ?? this.isSend,
  );

  String toRaw() {
    return '{uuid:$uuid},{date:$date},{tipo:$tipo},{cms:$cms},{cubic:$cubic},{liters:$liters},{isSend:$isSend}';
  }
}
