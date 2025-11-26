import 'package:flutter/material.dart';
import 'package:libdding/core/app_color.dart';

class CustomRadioButton<T> extends StatelessWidget {
  final T value;
  final T groupValue;
  final String title;
  final ValueChanged<T?> onChanged;

  const CustomRadioButton({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.title,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSelected = value == groupValue;

    // Responsive sizes based on screen width
    final outerSize = screenWidth * 0.055; // ~22 on 400px width
    final innerSize = outerSize * 0.55;    // Inner dot size
    final fontSize = screenWidth * 0.04;   // ~16 on 400px width

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => onChanged(value),
      child: Row(
        children: [
          // Custom Circle
          Container(
            height: outerSize,
            width: outerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? AppColors.appColor :AppColors.appBodyTextColor,
                width: 2,
              ),
            ),
            child: isSelected
                ? Center(
              child: Container(
                height: innerSize,
                width: innerSize,
                decoration: BoxDecoration(
                  color: AppColors.appColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
                : null,
          ),

          SizedBox(width: screenWidth * 0.025), // Responsive spacing

          // Title
          Text(
            title,
            style: TextStyle(
              fontSize: fontSize,
              color: AppColors.appBodyTextColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
