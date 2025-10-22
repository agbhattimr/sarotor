// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class CustomRadioGroup<T> extends StatefulWidget {
  final ValueChanged<T?>? onChanged;
  final List<CustomRadioListTile<T>> items;
  final T? initialValue;

  const CustomRadioGroup({
    super.key,
    this.onChanged,
    required this.items,
    this.initialValue,
  });

  @override
  State<CustomRadioGroup<T>> createState() => _CustomRadioGroupState<T>();
}

class _CustomRadioGroupState<T> extends State<CustomRadioGroup<T>> {
  T? _groupValue;

  @override
  void initState() {
    super.initState();
    _groupValue = widget.initialValue;
  }

  void _handleChanged(T? value) {
    setState(() {
      _groupValue = value;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.items.map((item) {
        return RadioListTile<T>(
          title: item.title,
          value: item.value,
          groupValue: _groupValue,
          onChanged: _handleChanged,
        );
      }).toList(),
    );
  }
}

class CustomRadioListTile<T> {
  final T value;
  final Widget title;

  const CustomRadioListTile({
    required this.value,
    required this.title,
  });
}
