import 'package:flutter/material.dart';
import 'measurement_animations.dart';

class ShimmerLoading extends StatefulWidget {
  final Widget child;
  final bool isLoading;

  const ShimmerLoading({
    super.key,
    required this.child,
    this.isLoading = false,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(
        min: -0.5,
        max: 1.5,
        period: MeasurementAnimations.slow,
      );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return const LinearGradient(
          colors: [
            MeasurementAnimations.shimmerBaseColor,
            MeasurementAnimations.shimmerHighlightColor,
            MeasurementAnimations.shimmerBaseColor,
          ],
          stops: [0.0, 0.5, 1.0],
          begin: Alignment(-1.0, -0.3),
          end: Alignment(1.0, 0.3),
          tileMode: TileMode.clamp,
        ).createShader(bounds);
      },
      child: widget.child,
    );
  }
}