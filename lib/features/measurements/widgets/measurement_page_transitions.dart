import 'package:flutter/material.dart';

class MeasurementPageTransitions {
  static const _defaultDuration = Duration(milliseconds: 300);
  
  /// Slide transition from right to left (forward) and left to right (reverse)
  static Route<T> slideTransition<T>({
    required Widget page,
    Duration duration = _defaultDuration,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: Curves.easeInOut),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// Fade and scale transition
  static Route<T> fadeScaleTransition<T>({
    required Widget page,
    Duration duration = _defaultDuration,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final scaleTween = Tween(begin: 0.95, end: 1.0).chain(
          CurveTween(curve: Curves.easeOutCubic),
        );
        
        final fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        );

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: ScaleTransition(
            scale: animation.drive(scaleTween),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      fullscreenDialog: fullscreenDialog,
    );
  }

  /// Bottom sheet transition with bounce
  static Route<T> bottomSheetTransition<T>({
    required Widget page,
    Duration duration = _defaultDuration,
    bool maintainState = true,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        
        final tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: Curves.easeOutBack),
        );

        final fadeTween = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        );

        return FadeTransition(
          opacity: animation.drive(fadeTween),
          child: SlideTransition(
            position: animation.drive(tween),
            child: child,
          ),
        );
      },
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      maintainState: maintainState,
      fullscreenDialog: true,
      opaque: false,
      barrierColor: Colors.black54,
    );
  }

  /// Modal transition with blur
  static Route<T> modalTransition<T>({
    required Widget page,
    Duration duration = _defaultDuration,
    bool maintainState = true,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) {
        return FadeTransition(
          opacity: animation,
          child: page,
        );
      },
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      opaque: false,
      barrierColor: Colors.black54,
      maintainState: maintainState,
      fullscreenDialog: true,
    );
  }
}