import 'package:flutter/material.dart';
import '../../core/app_color.dart';

class CustomRadioGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;
  final bool scrollable;

  const CustomRadioGroup({super.key, required this.label, required this.options, required this.value, required this.onChanged, this.scrollable = true});

  @override
  Widget build(BuildContext context) {
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(label, style: TextStyle(color: AppColors.appTextColor, fontWeight: FontWeight.w600)),
        ),
        ...options.map((opt) => RadioListTile<String>(
          dense: true,
          contentPadding: EdgeInsets.zero,
          value: opt,
          groupValue: value,
          onChanged: onChanged,
          title: Text(opt, style: TextStyle(color: AppColors.appTextColor)),
          activeColor: AppColors.appColor,
        )),
      ],
    );

    if (!scrollable) return column;
    return SizedBox(
      height: 160,
      child: SingleChildScrollView(child: column),
    );
  }
}


