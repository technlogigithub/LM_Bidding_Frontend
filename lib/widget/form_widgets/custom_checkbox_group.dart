import 'package:flutter/material.dart';
import '../../core/app_color.dart';

class CustomCheckboxGroup extends StatelessWidget {
  final String label;
  final List<String> options;
  final Set<String> values;
  final ValueChanged<Set<String>> onChanged;
  final bool scrollable;

  const CustomCheckboxGroup({super.key, required this.label, required this.options, required this.values, required this.onChanged, this.scrollable = true});

  @override
  Widget build(BuildContext context) {
    Widget buildList() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label.isNotEmpty) Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(label, style: TextStyle(color: AppColors.appTextColor, fontWeight: FontWeight.w600)),
          ),
          ...options.map((opt) {
            final checked = values.contains(opt);
            return CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: checked,
              onChanged: (v) {
                final next = Set<String>.from(values);
                if (v == true) {
                  next.add(opt);
                } else {
                  next.remove(opt);
                }
                onChanged(next);
              },
              title: Text(opt, style: TextStyle(color: AppColors.appTextColor)),
              activeColor: AppColors.appColor,
            );
          }),
        ],
      );
    }

    final column = buildList();
    if (!scrollable) return column;
    return SizedBox(height: 160, child: SingleChildScrollView(child: column));
  }
}


