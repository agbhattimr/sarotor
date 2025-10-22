import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sartor_order_management/features/measurements/utils/measurement_animations.dart';

class MeasurementInputCard extends StatefulWidget {
  final String label;
  final String unit;
  final IconData icon;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final String? initialValue;
  final String? Function(String?)? validator;

  const MeasurementInputCard({
    super.key,
    required this.label,
    required this.unit,
    required this.icon,
    required this.controller,
    this.onChanged,
    this.initialValue,
    this.validator,
  });

  @override
  State<MeasurementInputCard> createState() => _MeasurementInputCardState();
}

class _MeasurementInputCardState extends State<MeasurementInputCard> 
    with SingleTickerProviderStateMixin {
  Timer? _debounce;
  bool _isValid = true;
  final _focusNode = FocusNode();
  
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    if (widget.initialValue != null) {
      widget.controller.text = widget.initialValue!;
    }
    _focusNode.addListener(_onFocusChange);

    _animationController = AnimationController(
      vsync: this,
      duration: MeasurementAnimations.duration,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: MeasurementAnimations.curve,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      _validate();
    }
  }

  void _validate() {
    if (widget.validator != null) {
      setState(() {
        _isValid = widget.validator!(widget.controller.text) == null;
      });
    }
  }

  void _onChangedDebounced(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.onChanged != null) {
        widget.onChanged!(value);
      }
      _validate();
    });
  }

  void _increment() {
    final currentValue = double.tryParse(widget.controller.text) ?? 0;
    widget.controller.text = (currentValue + 0.5).toStringAsFixed(1);
    _onChangedDebounced(widget.controller.text);
  }

  void _decrement() {
    final currentValue = double.tryParse(widget.controller.text) ?? 0;
    if (currentValue > 0) {
      widget.controller.text = (currentValue - 0.5).toStringAsFixed(1);
      _onChangedDebounced(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MeasurementAnimations.scaleTransition(
      animation: _scaleAnimation,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: _isValid 
              ? const Color.fromRGBO(76, 175, 80, 0.5)  // green
              : const Color.fromRGBO(244, 67, 54, 0.5), // red
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              ListTile(
                leading: Icon(widget.icon, size: 28, color: Theme.of(context).primaryColor),
                title: Text(widget.label, style: const TextStyle(fontWeight: FontWeight.bold)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: _decrement,
                    ),
                    SizedBox(
                      width: 60,
                      child: TextFormField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          isDense: true,
                          suffixText: widget.unit,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: _isValid 
                                ? const Color.fromRGBO(76, 175, 80, 0.5)  // green
                                : const Color.fromRGBO(244, 67, 54, 0.5), // red
                            ),
                          ),
                        ),
                        onChanged: _onChangedDebounced,
                        validator: widget.validator,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: _increment,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
