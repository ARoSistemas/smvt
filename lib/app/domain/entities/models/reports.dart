class Reporte {
  Reporte({required this.date, required this.tipo, required this.isSelected});

  String date;
  String tipo;
  bool isSelected;

  Reporte copyWith({
    String? date,
    String? time,
    String? tipo,
    bool? isSelected,
  }) {
    return Reporte(
      date: date ?? this.date,
      tipo: tipo ?? this.tipo,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  factory Reporte.empty() => Reporte(date: '', tipo: '', isSelected: false);
}
