import 'package:flutter/material.dart' show Color;

class ProductColor {
  static Color getColor(String product) {
    Map<String, Color> products = {
      'magna': Color(0xFF37B24C),
      'premium': Color(0xFFE81B23),
      'diesel': Color(0xFFFFD700),
      'urea': Color(0xFF5F9EA0),
      'etanol': Color(0xFFF5F5F5),
    };
    return products[product] ?? Color(0x4AFFFFFF);
  }
}
