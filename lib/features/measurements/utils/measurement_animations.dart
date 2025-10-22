import 'package:flutter/material.dart';

class MeasurementAnimations {
  static const Duration duration = Duration(milliseconds: 300);
  static const Curve curve = Curves.easeInOut;

  static Widget slideTransition({
    required Animation<double> animation,
    required Widget child,
    bool horizontal = true,
  }) {
    return SlideTransition(
      position: Tween<Offset>(
        begin: Offset(horizontal ? -1.0 : 0.0, horizontal ? 0.0 : -1.0),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: animation,
        curve: curve,
      )),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static Widget scaleTransition({
    required Animation<double> animation,
    required Widget child,
  }) {
    return ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: curve,
      ),
      child: FadeTransition(
        opacity: animation,
        child: child,
      ),
    );
  }

  static Widget fadeSlideTransition({
    required Animation<double> animation,
    required Widget child,
    bool horizontal = true,
  }) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(horizontal ? 0.3 : 0.0, horizontal ? 0.0 : 0.3),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: curve,
        )),
        child: child,
      ),
    );
  }
}