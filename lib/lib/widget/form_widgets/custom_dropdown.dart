import 'package:flutter/material.dart';
import '../../core/app_color.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String hintText;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const CustomDropdown({super.key, required this.label, required this.hintText, required this.options, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) Padding(
          padding: const EdgeInsets.only(bottom: 6.0),
          child: Text(label, style: TextStyle(color: AppColors.appTextColor)),
        ),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: AppColors.appTextColor.withValues(alpha: 0.4)),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.appTextColor.withValues(alpha: 0.3)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.appTextColor),
            ),
          ),
          items: options.map((e) => DropdownMenuItem<String>(value: e, child: Text(e, style: TextStyle(color: AppColors.appTextColor)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }
}


