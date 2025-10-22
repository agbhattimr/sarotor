import 'package:flutter/material.dart';

/// Breakpoints for responsive design
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 900;
  static const double desktop = 1200;
}

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget? tabletBody;
  final Widget? desktopBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    this.tabletBody,
    this.desktopBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < ResponsiveBreakpoints.mobile) {
          return mobileBody;
        } else if (constraints.maxWidth < ResponsiveBreakpoints.tablet) {
          return tabletBody ?? mobileBody;
        } else {
          return desktopBody ?? tabletBody ?? mobileBody;
        }
      },
    );
  }
}
