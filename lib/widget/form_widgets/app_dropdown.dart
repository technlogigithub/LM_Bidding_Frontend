import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hintText;
  final ValueChanged<T?> onChanged;
  final String Function(T) itemToString;

  final Color? textColor;
  final Color? hintColor;
  final Color? iconColor;
  final Color? borderColor;
  final Color? backgroundColor;
  final Color? menuBackgroundColor;

  const CustomDropdown({
    Key? key,
    required this.value,
    required this.items,
    required this.hintText,
    required this.onChanged,
    required this.itemToString,
    this.textColor,
    this.hintColor,
    this.iconColor,
    this.borderColor,
    this.backgroundColor,
    this.menuBackgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: borderColor ?? AppColors.appBodyTextColor,
          width: 1.2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
            borderRadius: BorderRadius.circular(10),
          // MENU BACKGROUND COLOR
          dropdownColor: menuBackgroundColor ?? AppColors.appColor,

          // HINT TEXT
          hint: Text(
            hintText,
            style: TextStyle(
              color: hintColor ?? AppColors.appDescriptionColor,
              fontSize: 14,
            ),
          ),

          // ICON COLOR
          icon: Icon(
            Icons.arrow_drop_down,
            color: iconColor ?? AppColors.appBodyTextColor,
          ),

          // ITEMS
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                itemToString(item),
                style: TextStyle(
                  color: textColor ?? AppColors.appBodyTextColor,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),

          // ON CHANGE
          onChanged: onChanged,
        ),
      ),
    );
  }
}
