import 'package:flutter/material.dart';

class MeasurementAnimations {
  // Durations
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);

  // Curves
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeOut = Curves.easeOut;
  static const Curve bounceOut = Curves.bounceOut;
  
  // Colors
  static const Color shimmerBaseColor = Color(0xFFEBEBF4);
  static const Color shimmerHighlightColor = Color(0xFFF4F4F4);

  static Route<T> createRoute<T>({
    required Widget page,
    bool fullscreenDialog = false,
  }) {
    return PageRouteBuilder<T>(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
      fullscreenDialog: fullscreenDialog,
    );
  }

  static void showSuccessSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      animation: _getSnackBarAnimation(context),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static void showErrorSnackBar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.white),
          const SizedBox(width: 8),
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.error,
      behavior: SnackBarBehavior.floating,
      duration: duration,
      action: actionLabel != null ? SnackBarAction(
        label: actionLabel,
        textColor: Colors.white,
        onPressed: onAction ?? () {},
      ) : null,
      animation: _getSnackBarAnimation(context),
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  static Animation<double> _getSnackBarAnimation(BuildContext context) {
    final state = ScaffoldMessenger.of(context);
    if (state is ScaffoldFeatureController<SnackBar, SnackBarClosedReason>) {
      return CurvedAnimation(
        parent: const AlwaysStoppedAnimation(1.0),
        curve: Curves.easeOut,
        reverseCurve: Curves.easeIn,
      );
    }
    return const AlwaysStoppedAnimation(1.0);
  }
}

class ShimmerLoading extends StatefulWidget {
  final bool isLoading;
  final Widget child;

  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
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
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
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

class SaveButton extends StatefulWidget {
  final bool isSaving;
  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  const SaveButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
    this.label = 'Save',
    this.icon = Icons.save,
  });

  @override
  State<SaveButton> createState() => _SaveButtonState();
}

class _SaveButtonState extends State<SaveButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: MeasurementAnimations.normal,
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: FilledButton.icon(
          onPressed: widget.isSaving ? null : widget.onPressed,
          icon: widget.isSaving
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Icon(widget.icon),
          label: Text(widget.isSaving ? 'Saving...' : widget.label),
        ),
      ),
    );
  }
}

class ValidatedTextField extends StatefulWidget {
  final String label;
  final String? errorText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool autovalidate;

  const ValidatedTextField({
    super.key,
    required this.label,
    required this.controller,
    this.errorText,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.autovalidate = false,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField>
    with SingleTickerProviderStateMixin {
  late AnimationController _errorController;
  late Animation<double> _errorAnimation;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _errorController = AnimationController(
      duration: MeasurementAnimations.normal,
      vsync: this,
    );

    _errorAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _errorController,
        curve: Curves.easeOut,
      ),
    );

    if (widget.errorText != null) {
      _errorController.forward();
      _hasError = true;
    }
  }

  @override
  void didUpdateWidget(ValidatedTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorText != null && !_hasError) {
      _errorController.forward();
      _hasError = true;
    } else if (widget.errorText == null && _hasError) {
      _errorController.reverse();
      _hasError = false;
    }
  }

  @override
  void dispose() {
    _errorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          onChanged: (value) {
            if (widget.autovalidate && widget.validator != null) {
              final error = widget.validator!(value);
              setState(() {
                if (error != null && !_hasError) {
                  _errorController.forward();
                  _hasError = true;
                } else if (error == null && _hasError) {
                  _errorController.reverse();
                  _hasError = false;
                }
              });
            }
            widget.onChanged?.call(value);
          },
          decoration: InputDecoration(
            labelText: widget.label,
            errorText: widget.errorText,
            border: const OutlineInputBorder(),
            contentPadding: const EdgeInsets.all(16),
          ),
        ),
        SizeTransition(
          sizeFactor: _errorAnimation,
          axisAlignment: -1,
          child: Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.errorText ?? '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.error,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}