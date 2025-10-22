import 'package:flutter/material.dart';

class ServiceGridShimmer extends StatefulWidget {
  const ServiceGridShimmer({super.key});

  @override
  State<ServiceGridShimmer> createState() => _ServiceGridShimmerState();
}

class _ServiceGridShimmerState extends State<ServiceGridShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[800]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[700]! : Colors.grey[100]!;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return GridView.builder(
          padding: const EdgeInsets.all(16.0),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 4 : 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: 8,
          itemBuilder: (context, index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [baseColor, highlightColor, baseColor],
                  stops: [
                    _controller.value - 0.3,
                    _controller.value,
                    _controller.value + 0.3,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
