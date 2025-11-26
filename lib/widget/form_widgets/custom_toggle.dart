import 'package:flutter/material.dart';
import '../../core/app_color.dart';

class CustomToggle extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isRequired;

  const CustomToggle({super.key, required this.label, required this.value, required this.onChanged, this.isRequired = false});

  @override
  State<CustomToggle> createState() => _CustomToggleState();
}

class _CustomToggleState extends State<CustomToggle> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(widget.label, style: TextStyle(color: AppColors.appBodyTextColor))),
        Switch(
          value: widget.value,
          activeColor: AppColors.appButtonColor,
          onChanged: (newValue) {
            setState(() {
              widget.onChanged(newValue);
            });
          },
        ),
      ],
    );
  }
}


