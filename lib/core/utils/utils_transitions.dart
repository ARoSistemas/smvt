import 'package:flutter/material.dart';

import '../../app/config/constans/cfg_my_enums.dart';

class ARoTransitions<T> extends PageRouteBuilder<T> {
  /// The `ARoTransitions` class extends `PageRouteBuilder` to provide customizable
  /// transitions between pages. It supports a variety of transition types including
  /// size, scale, fade, rotate, and slide animations.
  ///   Parameters
  ///     { Widget widget } The widget destination
  ///     [ Curve? curve ]  The start effect's transtition
  ///     [ Duration? duration ]  The durations' transtition
  ///     [ Curve? reverseCurve ] The end effect's transtition
  ///     [ Alignment? alignment ] The alignment's transtition
  ///     [ TransitionType? transitionType ] The type's transtition
  ///
  ///   Return
  ///     [ widget with effect ]
  ///
  /// Example usage:
  /// ```dart
  /// Navigator.of(context).push(ARoTransitions(
  ///   widget: SecondPage(),
  ///   transitionType: TransitionType.slideUp,
  /// ));
  ///```
  final Widget widget;
  final Curve? curve;
  final Duration? duration;
  final Curve? reverseCurve;
  final Alignment? alignment;
  final TransitionType? transitionType;

  /// Creates an instance of `ARoTransitions`.
  ///
  /// [widget] The widget to display during the transition.
  /// [curve] The curve to apply to the animation (default is `Curves.bounceIn`).
  /// [alignment] The alignment for the scale transition (default is `Alignment.topRight`).
  /// [reverseCurve] The curve to apply to the reverse animation (default is `Curves.bounceOut`).
  /// [transitionType] The type of transition to use (default is `TransitionType.fade`).
  /// [duration] The duration of the transition (default is `Duration(milliseconds: 350)`).
  ARoTransitions({
    required this.widget,
    this.curve = Curves.bounceIn,
    this.alignment = Alignment.topRight,
    this.reverseCurve = Curves.bounceOut,
    this.transitionType = TransitionType.fade,
    this.duration = const Duration(milliseconds: 350),
  }) : super(
         transitionDuration: duration!,
         reverseTransitionDuration: duration,
         pageBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
             ) {
               return widget;
             },
         transitionsBuilder:
             (
               BuildContext context,
               Animation<double> animation,
               Animation<double> secondaryAnimation,
               Widget child,
             ) {
               switch (transitionType) {
                 case TransitionType.none:
                   return child;

                 case TransitionType.size:
                   return Align(
                     child: SizeTransition(sizeFactor: animation, child: child),
                   );

                 case TransitionType.scale:
                   return ScaleTransition(
                     scale: animation,
                     alignment: alignment!,
                     child: child,
                   );

                 case TransitionType.fade:
                   return FadeTransition(opacity: animation, child: child);

                 case TransitionType.rotate:
                   return RotationTransition(
                     alignment: Alignment.center,
                     turns: animation,
                     child: ScaleTransition(
                       alignment: Alignment.center,
                       scale: animation,
                       child: FadeTransition(opacity: animation, child: child),
                     ),
                   );

                 case TransitionType.slideDown:
                   return SlideTransition(
                     position: Tween<Offset>(
                       begin: const Offset(0.0, -1.0),
                       end: const Offset(0.0, 0.0),
                     ).animate(animation),
                     child: child,
                   );

                 case TransitionType.slideUp:
                   return SlideTransition(
                     position: Tween<Offset>(
                       begin: const Offset(0.0, 1.0),
                       end: const Offset(0.0, 0.0),
                     ).animate(animation),
                     child: child,
                   );

                 case TransitionType.slideLeft:
                   return SlideTransition(
                     position: Tween<Offset>(
                       begin: const Offset(1.0, 0.0),
                       end: const Offset(0.0, 0.0),
                     ).animate(animation),
                     child: child,
                   );

                 case TransitionType.slideRight:
                   return SlideTransition(
                     position: Tween<Offset>(
                       begin: const Offset(-1.0, 0.0),
                       end: const Offset(0.0, 0.0),
                     ).animate(animation),
                     child: child,
                   );

                 default:
                   return FadeTransition(opacity: animation, child: child);
               }
             },
       );
}
