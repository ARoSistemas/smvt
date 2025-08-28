import 'dart:convert';

class Ticket {
  Ticket({
    required this.uuid,
    required this.date,
    required this.empresa,
    required this.direccion,
    required this.titulo,
    required this.producto,
    required this.cmVacioInit,
    required this.cmNivelInit,
    required this.percentageVacioInit,
    required this.percentageNivelInit,
    required this.ltsPorLlenarInit,
    required this.ltsActualesInit,
    required this.cmVacioEnd,
    required this.cmNivelEnd,
    required this.percentageVacioEnd,
    required this.percentageNivelEnd,
    required this.ltsPorLlenarEnd,
    required this.ltsActualesEnd,
    required this.tipoTicket,
    required this.isSelected,
  });

  /// Encabezado del ticket
  String uuid; // UUID del ticket
  String date; // Fecha de creación
  String empresa; // Empresa asociada
  String direccion; // Dirección de la empresa
  String titulo; // Título del ticket
  String producto; // Producto asociado

  /// Valores del Status general
  String cmVacioInit; // cm vacío inicial
  String cmNivelInit; // cm nivel inicial

  String percentageVacioInit; // porcentaje vacío inicial
  String percentageNivelInit; // porcentaje nivel inicial
  String ltsPorLlenarInit; // litros por llenar inicial
  String ltsActualesInit; // litros actuales inicial

  /// Datos finales, si es recarga de combustible
  String cmVacioEnd; // cm vacío final
  String cmNivelEnd; // cm nivel final
  String percentageVacioEnd; // porcentaje vacío final
  String percentageNivelEnd; // porcentaje nivel final
  String ltsPorLlenarEnd; // litros por llenar final
  String ltsActualesEnd; // litros actuales final

  /// Tipo de ticket: Status | Carga
  String tipoTicket; // Tipo de ticket

  /// Solo para la lista del historial
  bool isSelected; // Indica si el ticket está seleccionado en la lista

  factory Ticket.fromRaw(String str) => Ticket.fromMap(json.decode(str));

  factory Ticket.fromMap(Map<String, dynamic> map) => Ticket(
    uuid: map['uuid'] ?? '',
    date: map['date'] ?? '',
    empresa: map['empresa'] ?? '',
    direccion: map['direccion'] ?? '',
    titulo: map['titulo'] ?? '',
    producto: map['producto'] ?? '',
    cmVacioInit: map['cmVacioInit'] ?? '',
    cmNivelInit: map['cmNivelInit'] ?? '',
    percentageVacioInit: map['percentageVacioInit'] ?? '',
    percentageNivelInit: map['percentageNivelInit'] ?? '',
    ltsPorLlenarInit: map['ltsPorLlenarInit'] ?? '',
    ltsActualesInit: map['ltsActualesInit'] ?? '',
    cmVacioEnd: map['cmVacioEnd'] ?? '',
    cmNivelEnd: map['cmNivelEnd'] ?? '',
    percentageVacioEnd: map['percentageVacioEnd'] ?? '',
    percentageNivelEnd: map['percentageNivelEnd'] ?? '',
    ltsPorLlenarEnd: map['ltsPorLlenarEnd'] ?? '',
    ltsActualesEnd: map['ltsActualesEnd'] ?? '',
    tipoTicket: map['tipoTicket'] ?? '',
    isSelected: map['isSelected'] ?? false,
  );

  factory Ticket.empty() {
    return Ticket(
      uuid: '',
      date: '',
      empresa: '',
      direccion: '',
      titulo: '',
      producto: '',
      cmVacioInit: '',
      cmNivelInit: '',
      percentageVacioInit: '',
      percentageNivelInit: '',
      ltsPorLlenarInit: '',
      ltsActualesInit: '',
      cmVacioEnd: '',
      cmNivelEnd: '',
      percentageVacioEnd: '',
      percentageNivelEnd: '',
      ltsPorLlenarEnd: '',
      ltsActualesEnd: '',
      tipoTicket: '',
      isSelected: false,
    );
  }

  Ticket copyWith({
    String? uuid,
    String? date,
    String? empresa,
    String? direccion,
    String? titulo,
    String? producto,
    String? cmVacioInit,
    String? cmNivelInit,
    String? percentageVacioInit,
    String? percentageNivelInit,
    String? ltsPorLlenarInit,
    String? ltsActualesInit,
    String? cmVacioEnd,
    String? cmNivelEnd,
    String? percentageVacioEnd,
    String? percentageNivelEnd,
    String? ltsPorLlenarEnd,
    String? ltsActualesEnd,
    String? tipoTicket,
    bool? isSelected,
  }) => Ticket(
    uuid: uuid ?? this.uuid,
    date: date ?? this.date,
    empresa: empresa ?? this.empresa,
    direccion: direccion ?? this.direccion,
    titulo: titulo ?? this.titulo,
    producto: producto ?? this.producto,
    cmVacioInit: cmVacioInit ?? this.cmVacioInit,
    cmNivelInit: cmNivelInit ?? this.cmNivelInit,
    percentageVacioInit: percentageVacioInit ?? this.percentageVacioInit,
    percentageNivelInit: percentageNivelInit ?? this.percentageNivelInit,
    ltsPorLlenarInit: ltsPorLlenarInit ?? this.ltsPorLlenarInit,
    ltsActualesInit: ltsActualesInit ?? this.ltsActualesInit,
    cmVacioEnd: cmVacioEnd ?? this.cmVacioEnd,
    cmNivelEnd: cmNivelEnd ?? this.cmNivelEnd,
    percentageVacioEnd: percentageVacioEnd ?? this.percentageVacioEnd,
    percentageNivelEnd: percentageNivelEnd ?? this.percentageNivelEnd,
    ltsPorLlenarEnd: ltsPorLlenarEnd ?? this.ltsPorLlenarEnd,
    ltsActualesEnd: ltsActualesEnd ?? this.ltsActualesEnd,
    tipoTicket: tipoTicket ?? this.tipoTicket,
    isSelected: isSelected ?? this.isSelected,
  );

  String toRaw(Ticket ticket) => jsonEncode({
    'uuid': ticket.uuid,
    'date': ticket.date,
    'empresa': ticket.empresa,
    'direccion': ticket.direccion,
    'titulo': ticket.titulo,
    'producto': ticket.producto,
    'cmVacioInit': ticket.cmVacioInit,
    'cmNivelInit': ticket.cmNivelInit,
    'percentageVacioInit': ticket.percentageVacioInit,
    'percentageNivelInit': ticket.percentageNivelInit,
    'ltsPorLlenarInit': ticket.ltsPorLlenarInit,
    'ltsActualesInit': ticket.ltsActualesInit,
    'cmVacioEnd': ticket.cmVacioEnd,
    'cmNivelEnd': ticket.cmNivelEnd,
    'percentageVacioEnd': ticket.percentageVacioEnd,
    'percentageNivelEnd': ticket.percentageNivelEnd,
    'ltsPorLlenarEnd': ticket.ltsPorLlenarEnd,
    'ltsActualesEnd': ticket.ltsActualesEnd,
    'tipoTicket': ticket.tipoTicket,
    'isSelected': ticket.isSelected,
  });
}
