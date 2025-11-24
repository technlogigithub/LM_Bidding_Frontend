import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemToString;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.itemToString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.appColor, // 🔵 Use your app color
          width: 1.2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          hint: Text(
            hintText,
            style: TextStyle(color: AppColors.appColor),
          ),
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            color: AppColors.appColor,
          ),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemToString(item),
                style: TextStyle(
                  color: AppColors.appColor, // 🔵 Text color
                ),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
