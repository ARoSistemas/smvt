import 'dart:convert';

class Ticket {
  Ticket({
    required this.uuid,
    required this.date,
    required this.customer,
    required this.address,
    required this.title,
    required this.product,
    required this.cmVacuumInit,
    required this.cmVolumeInit,
    required this.percentageVacuumInit,
    required this.percentageVolumeInit,
    required this.ltsToFillInit,
    required this.ltsCurrentInit,
    required this.cmVacuumEnd,
    required this.cmVolumeEnd,
    required this.percentageVacuumEnd,
    required this.percentageVolumeEnd,
    required this.ltsToFillEnd,
    required this.ltsCurrentEnd,
    required this.typeTicket,
    required this.isSelected,
  });

  /// Encabezado del ticket
  String uuid; // UUID del ticket
  String date; // Fecha de creación
  String customer; // customer asociada
  String address; // Dirección de la customer
  String title; // Título del ticket
  String product; // Product asociado

  /// Valores del Status general
  String cmVacuumInit; // cm vacío inicial
  String cmVolumeInit; // cm volume inicial

  String percentageVacuumInit; // porcentaje vacío inicial
  String percentageVolumeInit; // porcentaje volume inicial
  String ltsToFillInit; // litros por llenar inicial
  String ltsCurrentInit; // litros Current inicial

  /// Datos finales, si es recarga de combustible
  String cmVacuumEnd; // cm vacío final
  String cmVolumeEnd; // cm volume final
  String percentageVacuumEnd; // porcentaje vacío final
  String percentageVolumeEnd; // porcentaje volume final
  String ltsToFillEnd; // litros por llenar final
  String ltsCurrentEnd; // litros Current final

  /// Tipo de ticket: Status | Carga
  String typeTicket; // Tipo de ticket

  /// Solo para la lista del historial
  bool isSelected; // Indica si el ticket está seleccionado en la lista

  factory Ticket.fromRaw(String str) => Ticket.fromMap(json.decode(str));

  factory Ticket.fromMap(Map<String, dynamic> map) => Ticket(
    uuid: map['uuid'] ?? '',
    date: map['date'] ?? '',
    customer: map['customer'] ?? '',
    address: map['address'] ?? '',
    title: map['title'] ?? '',
    product: map['product'] ?? '',
    cmVacuumInit: map['cmVacuumInit'] ?? '',
    cmVolumeInit: map['cmVolumeInit'] ?? '',
    percentageVacuumInit: map['percentageVacuumInit'] ?? '',
    percentageVolumeInit: map['percentageVolumeInit'] ?? '',
    ltsToFillInit: map['ltsToFillInit'] ?? '',
    ltsCurrentInit: map['ltsCurrentInit'] ?? '',
    cmVacuumEnd: map['cmVacuumEnd'] ?? '',
    cmVolumeEnd: map['cmVolumeEnd'] ?? '',
    percentageVacuumEnd: map['percentageVacuumEnd'] ?? '',
    percentageVolumeEnd: map['percentageVolumeEnd'] ?? '',
    ltsToFillEnd: map['ltsToFillEnd'] ?? '',
    ltsCurrentEnd: map['ltsCurrentEnd'] ?? '',
    typeTicket: map['typeTicket'] ?? '',
    isSelected: map['isSelected'] ?? false,
  );

  factory Ticket.empty() {
    return Ticket(
      uuid: '',
      date: '',
      customer: '',
      address: '',
      title: '',
      product: '',
      cmVacuumInit: '',
      cmVolumeInit: '',
      percentageVacuumInit: '',
      percentageVolumeInit: '',
      ltsToFillInit: '',
      ltsCurrentInit: '',
      cmVacuumEnd: '',
      cmVolumeEnd: '',
      percentageVacuumEnd: '',
      percentageVolumeEnd: '',
      ltsToFillEnd: '',
      ltsCurrentEnd: '',
      typeTicket: '',
      isSelected: false,
    );
  }

  Ticket copyWith({
    String? uuid,
    String? date,
    String? customer,
    String? address,
    String? title,
    String? product,
    String? cmVacuumInit,
    String? cmVolumeInit,
    String? percentageVacuumInit,
    String? percentageVolumeInit,
    String? ltsToFillInit,
    String? ltsCurrentInit,
    String? cmVacuumEnd,
    String? cmVolumeEnd,
    String? percentageVacuumEnd,
    String? percentageVolumeEnd,
    String? ltsToFillEnd,
    String? ltsCurrentEnd,
    String? typeTicket,
    bool? isSelected,
  }) => Ticket(
    uuid: uuid ?? this.uuid,
    date: date ?? this.date,
    customer: customer ?? this.customer,
    address: address ?? this.address,
    title: title ?? this.title,
    product: product ?? this.product,
    cmVacuumInit: cmVacuumInit ?? this.cmVacuumInit,
    cmVolumeInit: cmVolumeInit ?? this.cmVolumeInit,
    percentageVacuumInit: percentageVacuumInit ?? this.percentageVacuumInit,
    percentageVolumeInit: percentageVolumeInit ?? this.percentageVolumeInit,
    ltsToFillInit: ltsToFillInit ?? this.ltsToFillInit,
    ltsCurrentInit: ltsCurrentInit ?? this.ltsCurrentInit,
    cmVacuumEnd: cmVacuumEnd ?? this.cmVacuumEnd,
    cmVolumeEnd: cmVolumeEnd ?? this.cmVolumeEnd,
    percentageVacuumEnd: percentageVacuumEnd ?? this.percentageVacuumEnd,
    percentageVolumeEnd: percentageVolumeEnd ?? this.percentageVolumeEnd,
    ltsToFillEnd: ltsToFillEnd ?? this.ltsToFillEnd,
    ltsCurrentEnd: ltsCurrentEnd ?? this.ltsCurrentEnd,
    typeTicket: typeTicket ?? this.typeTicket,
    isSelected: isSelected ?? this.isSelected,
  );

  String toJson() => jsonEncode({
    'cmd': 'print',
    'uuid': uuid,
    'date': date,
    'customer': customer,
    'address': address,
    'title': title,
    'product': product,
    'cmVacuumInit': cmVacuumInit,
    'cmVolumeInit': cmVolumeInit,
    'percentageVacuumInit': percentageVacuumInit,
    'percentageVolumeInit': percentageVolumeInit,
    'ltsToFillInit': ltsToFillInit,
    'ltsCurrentInit': ltsCurrentInit,
    'cmVacuumEnd': cmVacuumEnd,
    'cmVolumeEnd': cmVolumeEnd,
    'percentageVacuumEnd': percentageVacuumEnd,
    'percentageVolumeEnd': percentageVolumeEnd,
    'ltsToFillEnd': ltsToFillEnd,
    'ltsCurrentEnd': ltsCurrentEnd,
    'typeTicket': typeTicket,
    'isSelected': isSelected,
  });
}
