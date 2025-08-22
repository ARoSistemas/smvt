import 'package:flutter/material.dart' show Color, Colors;

class Tank {
  String nameTank;
  String product;
  double percentage;
  String liters;
  bool isSelected;
  double capacityCms;
  double currentLevelCms;
  Color scaleColor;
  bool isActive;

  Tank({
    required this.nameTank,
    required this.capacityCms,
    required this.currentLevelCms,
    required this.product,
    required this.percentage,
    required this.liters,
    required this.isSelected,
    required this.scaleColor,
    required this.isActive,
  });

  Tank copyWith({
    String? nameTank,
    String? title,
    String? subtitle,
    String? product,
    double? percentage,
    String? liters,
    bool? isSelected,
    double? capacityCms,
    double? currentLevelCms,
    Color? scaleColor,
    bool? isActive,
  }) {
    return Tank(
      nameTank: nameTank ?? this.nameTank,
      product: product ?? this.product,
      percentage: percentage ?? this.percentage,
      liters: liters ?? this.liters,
      isSelected: isSelected ?? this.isSelected,
      capacityCms: capacityCms ?? this.capacityCms,
      currentLevelCms: currentLevelCms ?? this.currentLevelCms,
      scaleColor: scaleColor ?? this.scaleColor,
      isActive: isActive ?? this.isActive,
    );
  }

  factory Tank.empty() => Tank(
    nameTank: '',
    product: '',
    percentage: 0.0,
    liters: '',
    isSelected: false,
    capacityCms: 0.0,
    currentLevelCms: 0.0,
    scaleColor: Colors.transparent,
    isActive: false,
  );
}
