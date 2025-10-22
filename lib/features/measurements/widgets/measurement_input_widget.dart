import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

enum MeasurementUnit {
  inches,
  centimeters;
  
  String get symbol => this == inches ? 'in' : 'cm';
  double convert(double value, MeasurementUnit to) {
    if (this == to) return value;
    return to == inches ? value / 2.54 : value * 2.54;
  }
}

class MeasurementValue {
  final double value;
  final DateTime timestamp;
  final MeasurementUnit unit;

  const MeasurementValue({
    required this.value,
    required this.timestamp,
    required this.unit,
  });
}

class MeasurementController extends ValueNotifier<double?> {
  final List<MeasurementValue> _history = [];
  final double? minValue;
  final double? maxValue;
  final int decimalPlaces;
  final void Function(double?)? onChanged;
  Timer? _debounceTimer;
  
  MeasurementController({
    double? initialValue,
    this.minValue,
    this.maxValue,
    this.decimalPlaces = 1,
    this.onChanged,
  }) : super(initialValue);

  List<MeasurementValue> get history => List.unmodifiable(_history);

  void increment([double step = 0.5]) {
    final newValue = (value ?? 0) + step;
    if (maxValue == null || newValue <= maxValue!) {
      _updateValue(newValue);
    }
  }

  void decrement([double step = 0.5]) {
    final newValue = (value ?? 0) - step;
    if (minValue == null || newValue >= minValue!) {
      _updateValue(newValue);
    }
  }

  void _updateValue(double? newValue) {
    if (newValue != value) {
      if (value != null) {
        _history.insert(0, MeasurementValue(
          value: value!,
          timestamp: DateTime.now(),
          unit: MeasurementUnit.inches, // Default unit
        ));
        if (_history.length > 5) _history.removeLast(); // Keep last 5
      }
      value = newValue;
      _debounceTimer?.cancel();
      _debounceTimer = Timer(const Duration(milliseconds: 500), () {
        onChanged?.call(newValue);
      });
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

class MeasurementInputWidget extends StatefulWidget {
  final String label;
  final MeasurementController controller;
  final String? helperText;
  final bool showHistory;
  final bool allowUnitToggle;
  
  const MeasurementInputWidget({
    super.key,
    required this.label,
    required this.controller,
    this.helperText,
    this.showHistory = true,
    this.allowUnitToggle = true,
  });

  @override
  State<MeasurementInputWidget> createState() => _MeasurementInputWidgetState();
}

class _MeasurementInputWidgetState extends State<MeasurementInputWidget> {
  final _focusNode = FocusNode();
  final _errorNotifier = ValueNotifier<String?>(null);
  MeasurementUnit _currentUnit = MeasurementUnit.inches;
  bool _showHistory = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_validateOnFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_validateOnFocusChange);
    _focusNode.dispose();
    _errorNotifier.dispose();
    super.dispose();
  }

  void _validateOnFocusChange() {
    if (!_focusNode.hasFocus) {
      _validate(widget.controller.value);
    }
  }

  void _validate(double? value) {
    if (value == null) {
      _errorNotifier.value = 'Required';
    } else if (widget.controller.minValue != null && value < widget.controller.minValue!) {
      _errorNotifier.value = 'Minimum value is ${widget.controller.minValue}';
    } else if (widget.controller.maxValue != null && value > widget.controller.maxValue!) {
      _errorNotifier.value = 'Maximum value is ${widget.controller.maxValue}';
    } else {
      _errorNotifier.value = null;
    }
  }

  Widget _buildHistoryPreview() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      height: _showHistory ? 100 : 0,
      child: SingleChildScrollView(
        child: Column(
          children: widget.controller.history.map((entry) {
            final timeAgo = DateTime.now().difference(entry.timestamp);
            String timeAgoStr;
            if (timeAgo.inMinutes < 1) {
              timeAgoStr = 'just now';
            } else if (timeAgo.inHours < 1) {
              timeAgoStr = '${timeAgo.inMinutes}m ago';
            } else {
              timeAgoStr = '${timeAgo.inHours}h ago';
            }

            return ListTile(
              dense: true,
              visualDensity: VisualDensity.compact,
              title: Text(
                '${entry.value.toStringAsFixed(1)} ${entry.unit.symbol}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              trailing: Text(
                timeAgoStr,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              onTap: () {
                final convertedValue = entry.unit.convert(
                  entry.value,
                  _currentUnit,
                );
                widget.controller.value = convertedValue;
                setState(() => _showHistory = false);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: ValueListenableBuilder<String?>(
                valueListenable: _errorNotifier,
                builder: (context, errorText, _) {
                  return ValueListenableBuilder<double?>(
                    valueListenable: widget.controller,
                    builder: (context, value, _) {
                      // Convert value based on current unit
                      final displayValue = value != null
                          ? MeasurementUnit.inches.convert(value, _currentUnit)
                          : null;

                      return TextField(
                        focusNode: _focusNode,
                        controller: TextEditingController(
                          text: displayValue?.toStringAsFixed(
                            widget.controller.decimalPlaces,
                          ),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                        decoration: InputDecoration(
                          labelText: widget.label,
                          helperText: widget.helperText,
                          errorText: errorText,
                          suffixText: _currentUnit.symbol,
                          suffixIcon: widget.allowUnitToggle 
                              ? IconButton(
                                  icon: Text(_currentUnit.symbol),
                                  onPressed: () {
                                    setState(() {
                                      _currentUnit = _currentUnit == MeasurementUnit.inches
                                          ? MeasurementUnit.centimeters
                                          : MeasurementUnit.inches;
                                    });
                                  },
                                )
                              : null,
                        ),
                        onChanged: (text) {
                          final newValue = double.tryParse(text);
                          if (newValue != null) {
                            // Convert back to inches for storage
                            final inchesValue = _currentUnit.convert(
                              newValue,
                              MeasurementUnit.inches,
                            );
                            widget.controller.value = inchesValue;
                          } else {
                            widget.controller.value = null;
                          }
                          _validate(newValue);
                        },
                      );
                    },
                  );
                },
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_drop_up),
                  onPressed: widget.controller.increment,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  onPressed: widget.controller.decrement,
                ),
              ],
            ),
          ],
        ),
        if (widget.showHistory && widget.controller.history.isNotEmpty)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              icon: Icon(
                _showHistory ? Icons.expand_less : Icons.expand_more,
              ),
              label: Text(_showHistory ? 'Hide History' : 'Show History'),
              onPressed: () {
                setState(() => _showHistory = !_showHistory);
              },
            ),
          ),
        if (_showHistory) _buildHistoryPreview(),
      ],
    );
  }
}