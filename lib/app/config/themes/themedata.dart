import 'package:flutter/material.dart';

// Definición de los colores de la paleta
const Color primaryColor = Color(0xFF1d4c7b);
const Color secondaryColor = Color(0xFFe4e5e9);
const Color darkGrey = Color(0xFF888e9d);
const Color lightGrey = Color(0xFFbdc1cb);
const Color veryDarkBlue = Color(0xFF3b4556);

/// Light theme colors
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme.light(
    // Color principal
    primary: primaryColor,
    onPrimary: Colors.white,

    // Color secundario (fondo y contraste)
    secondary: secondaryColor,
    onSecondary: veryDarkBlue, // Para texto sobre el color secundario
    // Superficies
    surface: secondaryColor,
    onSurface: darkGrey,

    // Color de errores
    error: Color(0xFFB00020),
    onError: Colors.white,

    // Color para acentos
    tertiary: veryDarkBlue, // Usado para sombras y profundidad
    // Puedes usar los colores grises para diferentes variantes de la superficie
    surfaceContainerHighest: lightGrey,
    onSurfaceVariant: darkGrey,
  ),

  // Estilos de texto
  textTheme: const TextTheme(
    headlineLarge: TextStyle(color: primaryColor), // Encabezados principales
    bodyMedium: TextStyle(color: darkGrey), // Texto de párrafo
    labelMedium: TextStyle(color: lightGrey), // Etiquetas y texto secundario
  ),

  // Estilos para botones
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
    ),
  ),

  // Estilos para la barra de la aplicación
  appBarTheme: const AppBarTheme(
    backgroundColor: primaryColor,
    titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData(color: Colors.white),
  ),

  // Puedes seguir personalizando otros widgets como...
  // cardTheme:
  // inputDecorationTheme:
  // floatingActionButtonTheme:
);

/// Dark theme colors (propuesta para el futuro)
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme.dark(
    primary: Color(0xFF7995DF), // Versión más clara del azul primario
    onPrimary: veryDarkBlue,

    secondary: veryDarkBlue,
    onSecondary: lightGrey,

    surface: veryDarkBlue,
    onSurface: lightGrey,

    error: Color(0xFFCF6679),
    onError: veryDarkBlue,
  ),
);
