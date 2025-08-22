/// *************************************************************************
/// A utility class that provides paths to various asset files.
///
/// The `Assets` class contains methods to retrieve paths for animations and PNG images based on asset names.
///
/// **Methods**:
/// - `animations({required String asset})`: Retrieves the path for an animation asset.
/// - `png({required String asset})`: Retrieves the path for a PNG image asset.
///
/// **Example**:
/// ```dart
/// String offlineAnimation = Assets.animations(asset: 'offline');
/// print(offlineAnimation); // Output: assets/animations/offline.json
///
/// String logoImage = Assets.png(asset: 'logo');
/// print(logoImage); // Output: assets/png/logo.png
/// ```
/// *************************************************************************
class Assets {
  /// Retrieves the path for an animation asset based on the provided asset name.
  ///
  /// **Properties**:
  /// - `asset` (String): The name of the animation asset.
  ///
  /// **Values Read from Map**:
  /// - 'offline': 'assets/animations/offline.json'
  /// - 'blocked': 'assets/animations/blocked.json'
  /// - 'logout': 'assets/animations/logout.json'
  /// - 'nofound': 'assets/animations/nofound.json'
  /// - 'keys': 'assets/animations/keys.json'
  ///
  /// **Returns**:
  /// - `String`: The path to the animation asset, or 'assets/animations/noimage.json' if the asset name is not found.
  ///
  /// **Example**:
  /// ```dart
  /// String animationPath = Assets.animations(asset: 'offline');
  /// print(animationPath); // Output: assets/animations/offline.json
  /// ```
  static String animations({required String asset}) {
    Map<String, String> map = {
      'offline': 'assets/animations/offline.json',
      'blocked': 'assets/animations/blocked.json',
      'logout': 'assets/animations/logout.json',
      'nofound': 'assets/animations/nofound.json',
      'keys': 'assets/animations/keys.json',
    };
    return map[asset] ?? 'assets/animations/noimage.json';
  }

  /// Retrieves the path for a PNG image asset based on the provided asset name.
  ///
  /// **Properties**:
  /// - `asset` (String): The name of the PNG image asset.
  ///
  /// **Values Read from Map**:
  /// - 'logo': 'assets/png/logo.png'
  /// - 'logotipo': 'assets/png/logotipo.png'
  ///
  /// **Returns**:
  /// - `String`: The path to the PNG image asset, or 'assets/png/noimage.png' if the asset name is not found.
  ///
  /// **Example**:
  /// ```dart
  /// String imagePath = Assets.png(asset: 'logo');
  /// print(imagePath); // Output: assets/png/logo.png
  /// ```
  static String png({required String asset}) {
    Map<String, String> map = {
      'logo': 'assets/png/logo.png',
      'logotipo': 'assets/png/logotipo.png',
    };
    return map[asset] ?? 'assets/png/noimage.png';
  }
}
