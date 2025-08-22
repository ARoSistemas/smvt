import 'dart:math' as math;
import 'package:flutter/material.dart' show Size;

/// The `ARoSizeScaler` class calculates various screen dimensions and provides methods
/// to get percentage-based measurements for width, height, and text size.
///
/// **Constructor**:
/// - `ARoSizeScaler`: Initializes the screen dimensions based on the provided `Size`.
///
/// **Properties**:
/// - `_widthScreen` (double): The adjusted width of the screen.
/// - `_heightScreen` (double): The adjusted height of the screen.
/// - `_diagonalScreen` (double): The diagonal measurement of the screen.
///
/// **Getters**:
/// - `width`: Returns the adjusted width of the screen.
/// - `height`: Returns the adjusted height of the screen.
///
/// **Methods**:
/// - `pWidth`: Returns a percentage of the screen width.
/// - `pHeight`: Returns a percentage of the screen height.
/// - `pText`: Returns a percentage of the diagonal screen measurement.
///
/// **Example**:
/// ```dart
/// Size screenSize = Size(800, 600);
/// ARoSizeScaler ARoSizeScaler = ARoSizeScaler(size: screenSize);
///
/// double width10Percent = ARoSizeScaler.pWidth(10); // 10% of the screen width
/// double height20Percent = ARoSizeScaler.pHeight(20); // 20% of the screen height
/// double text15Percent = ARoSizeScaler.pText(15); // 15% of the diagonal screen size
/// ```
class ARoSizeScaler {
  /// Initializes the screen dimensions based on the provided `Size`.
  ///
  /// **Parameters**:
  /// - `size` (Size): The size of the screen.
  ///
  /// **Notes**:
  /// Adjusts the screen dimensions based on predefined thresholds for height and width.
  ARoSizeScaler({required Size size}) : _size = size;
  Size _size;

  /// Returns a percentage of the screen width.
  ///
  /// **Parameters**:
  /// - `percent` (double): The percentage of the width.
  ///
  /// **Returns**:
  /// - `double`: The calculated width.
  double pWidth(double percent) => _size.width * percent / 100;

  /// Returns a percentage of the screen height.
  ///
  /// **Parameters**:
  /// - `percent` (double): The percentage of the height.
  ///
  /// **Returns**:
  /// - `double`: The calculated height.
  double pHeight(double percent) => _size.height * percent / 100;

  /// Returns a percentage of the diagonal screen measurement.
  ///
  /// **Parameters**:
  /// - `percent` (double): The percentage of the diagonal measurement.
  ///
  /// **Returns**:
  /// - `double`: The calculated text size based on the diagonal screen measurement.

  double pText(double percent) {
    final diagonal = math.sqrt(
      math.pow(_size.width, 2) + math.pow(_size.height, 2),
    );
    return diagonal * percent / 100;
  }

  double get width => _size.width;

  double get height => _size.height;

  double get diagonal => math.sqrt(math.pow(width, 2) + math.pow(height, 2));

  ARoSizeScaler copyWith(Size newSize) => ARoSizeScaler(size: newSize);

  void updateSize(Size newSize) => _size = newSize;
}
