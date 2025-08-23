class ARoAssets {
  /// The `ARoAssets` class contains methods to retrieve paths for animations and PNG images based on asset names.
  ///
  /// **Methods**:
  /// - `animations({required String asset})`: Retrieves the path for an animation asset.
  ///
  /// **Example**:
  /// ```dart
  /// String offlineAnimation = ARoAssets.animations(asset: 'offline');
  /// print(offlineAnimation); // Output: assets/animations/offline.json
  ///
  /// String logoImage = ARoAssets.png(asset: 'logo');
  /// print(logoImage); // Output: assets/png/logo.png
  /// ```
  static String animations(String asset) {
    /// Retrieves the path for an animation asset based on the provided asset name.
    ///
    /// **Properties**:
    /// - `asset` (String): The name of the animation asset.
    ///
    /// **Values Read from Map**:
    /// - 'offline': 'assets/animations/offline.json'
    ///
    /// **Returns**:
    /// - `String`: The path to the animation asset, or 'assets/animations/noimage.json' if the asset name is not found.
    ///
    /// **Example**:
    /// ```dart
    /// String animationPath = ARoAssets.animations(asset: 'offline');
    /// print(animationPath); // Output: assets/animations/offline.json
    /// ```
    Map<String, String> map = {
      'nofound': 'assets/animations/nofound.json',
      'offline': 'assets/animations/offline.json',
      'logout': 'assets/animations/logout.json',
    };
    return map[asset] ?? 'assets/animations/nofound.json';
  }

  static String png(asset) {
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
    Map<String, String> map = {
      'logo': 'assets/png/logo.png',
      'print': 'assets/png/print.png',
      'historial': 'assets/png/historial.png',
      'descarga': 'assets/png/descarga.png',
      'termino': 'assets/png/termino.png',
      'centimetros': 'assets/png/cms.png',
    };
    return map[asset] ?? 'assets/png/noimage.png';
  }

  static String svg(String asset) {
    /// Gets the icon corresponding to the provided identifier.
    ///
    /// [icon] The identifier of the icon.
    /// Returns a string with the path of the corresponding icon or the path of a default icon if not found.
    Map<String, String> map = {
      'menu': 'assets/svg/menu.svg',
      'noimg': 'assets/svg/noimg.svg',
      'playnow': 'assets/svg/play_now.svg',
      'ranking': 'assets/svg/ranking.svg',
      'cronometro': 'assets/svg/cronometro.svg',
      'cim': 'assets/svg/logo_cim.svg',
      'monedas': 'assets/svg/monedas.svg',
      'redflag': 'assets/svg/red_flag.svg',
      'stack': 'assets/svg/stack.svg',
      'robox': 'assets/svg/Robox.svg',
      'copa': 'assets/svg/copa.svg',
    };

    return map[asset] ?? 'assets/svg/noimg.svg';
  }

  static String webp(String asset) {
    /// Gets the icon corresponding to the provided identifier.
    ///
    /// [icon] The identifier of the icon.
    /// Returns a string with the path of the corresponding icon or the path of a default icon if not found.
    Map<String, String> map = {
      'grafica1': 'assets/webp/graficasGameZone2.webp',
      'robox': 'assets/webp/RoboxLogin.webp',
      'roboxjugar': 'assets/webp/RoboxJugar.webp',
      'ranking': 'assets/webp/MiRanking.webp',
    };

    return map[asset] ?? 'assets/svg/noimg.svg';
  }

  static String gif(String asset) {
    /// Gets the icon corresponding to the provided identifier.
    ///
    /// [icon] The identifier of the icon.
    /// Returns a string with the path of the corresponding icon or the path of a default icon if not found.
    Map<String, String> map = {'bobuser': 'assets/gif/bob_user.gif'};

    return map[asset] ?? 'assets/png/noimage.png';
  }
}
