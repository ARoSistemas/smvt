import 'package:flutter/material.dart';
import 'package:smvt/core/utils/aro_assets.dart';

class ARoImage extends StatelessWidget {
  const ARoImage({
    super.key,
    this.height,
    this.width,
    this.type = 'png',
    this.isAsset = true,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    required this.img,
  });

  final double? height;
  final double? width;
  final String img;
  final String type;
  final bool isAsset;
  final BoxFit fit;
  final Alignment alignment;

  static final Map<String, String Function(String)> _assetResolvers = {
    'png': ARoAssets.png,
    // 'webp': Assets.webp,
    // 'gif': Assets.gif,
    // 'jpg': Assets.jpg,
    // 'jpeg': Assets.jpg,
  };

  @override
  Widget build(BuildContext context) {
    String imagePath;

    if (isAsset) {
      final assetPathResolver = _assetResolvers[type];

      if (assetPathResolver == null) {
        debugPrint(
          'Tipo de imagen "$type" no soportado por ARoImage o Assets.',
        );
        return const SizedBox(
          height: 50,
          width: 50,
          child: Icon(Icons.error, color: Colors.red),
        );
      }
      imagePath = assetPathResolver(img);
    } else {
      imagePath = img;
    }

    Widget imageWidget;
    if (isAsset) {
      imageWidget = Image.asset(
        imagePath,
        fit: fit,
        alignment: alignment,
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error cargando asset: $imagePath. Error: $error');
          return const Icon(Icons.broken_image, color: Colors.grey);
        },
      );
    } else {
      imageWidget = Image.network(
        imagePath,
        fit: fit,
        alignment: alignment,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value: loadingProgress.expectedTotalBytes != null
                  ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                  : null,
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          debugPrint('Error cargando imagen de red: $imagePath. Error: $error');
          return const Icon(Icons.error_outline, color: Colors.red);
        },
      );
    }

    return SizedBox(height: height, width: width, child: imageWidget);
  }
}
