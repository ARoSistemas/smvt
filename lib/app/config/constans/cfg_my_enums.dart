///
// title: isInventory ? TicketType.inventory.title : TicketType.reception.title,
enum TicketType {
  inventory('REPORTE DE INVENTARIO'),
  reception('RECEPCIÓN DE PRODUCTO');

  const TicketType(this.type);
  final String type;
}

/// The `HttpMethod` enum defines various methods http of response
enum HttpMethod { get, post, put, patch, delete, other }

/// The `PlatformOs` enum defines various kinds of system operating
enum PlatformOs {
  android('Android'),
  iOS('iOS'),
  web('Web'),
  unknow('unknow');

  const PlatformOs(this.name);

  final String name;
}

/// The `TransitionType` enum defines various transition effects that can be applied
/// to page transitions in a Flutter application.
enum TransitionType {
  defaultTransition, // Default transition, usually a fade.
  none, // No transition.
  size, // Transition that changes the size of the page.
  scale, // Transition that scales the page.
  fade, // Transition that fades the page in and out.
  rotate, // Transition that rotates the page.
  slideDown, // Transition that slides the page down from the top.
  slideUp, // Transition that slides the page up from the bottom.
  slideLeft, // Transition that slides the page left from the right.
  slideRight, // Transition that slides the page right from the left.
}

enum Legality { legal, restricted }

/// Facilita la referencia a rutas sin usar strings directamente.
enum AppRoute { loading, offline, login, home, games }

/// Demasiado pequeño, no considerado móvil
/// xs	= Extra Small :: < 320

/// Dispositivos móviles pequeños (teléfonos compactos, gama baja)
/// sm	= Small       :: < 431

/// Móviles medianos a grandes (iPhone Pro Max, Galaxy S+ etc.)
/// o tablets pequeñas en portrait
/// md	= Medium      :: < 767

/// Tablets chicas y phablets en portrait
/// lg	= Large       :: < 1024

/// Tablets grandes o en landscape y pantallas medianas
/// xl	= Extra Large :: < 1440

/// Escritorios, pantallas amplias o WideScreen
/// xxl	= Wide        :: >= 1440

enum ScreenSize {
  xs,
  sm,
  md,
  lg,
  xl,
  xxl;

  double get width {
    switch (this) {
      case ScreenSize.xs:
        return 320;
      case ScreenSize.sm:
        return 431;
      case ScreenSize.md:
        return 767;
      case ScreenSize.lg:
        return 1023;
      case ScreenSize.xl:
        return 1439;
      case ScreenSize.xxl:
        return 1440;
    }
  }

  static ScreenSize of(double screenWidth) {
    switch (screenWidth) {
      case < 320:
        return ScreenSize.xs;
      case < 431:
        return ScreenSize.sm;
      case < 767:
        return ScreenSize.md;
      case < 1024:
        return ScreenSize.lg;
      case < 1440:
        return ScreenSize.xl;
      default:
        return ScreenSize.xxl;
    }
  }
}
  
  
  
  
  // static int gridCrossAxisCount(double screenWidth) {
  //   switch (ScreenSize.of(screenWidth)) {
  //     case ScreenSize.xs:
  //     case ScreenSize.sm:
  //       return 1;
  //     case ScreenSize.md:
  //       return 2;
  //     case ScreenSize.lg:
  //       return 3;
  //     case ScreenSize.xl:
  //       return 4;
  //     case ScreenSize.xxl:
  //       return 5;
  //   }
  // }
