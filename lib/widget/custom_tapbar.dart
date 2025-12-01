import 'package:flutter/material.dart';
import '../core/app_color.dart';

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final Function(int)? onTap;

  final TextStyle textStyle;

  /// Remove fixed height, use kToolbarHeight as safe fallback
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.onTap,
    required this.textStyle,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(widget.tabs.length, (index) {
            final isSelected = index == selectedIndex;

            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                widget.onTap?.call(index);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10, // Auto height
                ),
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.appButtonColor
                      : AppColors.appMutedColor,
                  gradient: isSelected
                      ? LinearGradient(
                    colors: [
                      AppColors.appButtonColor,
                      AppColors.appButtonColor.withOpacity(0.7),
                    ],
                  )
                      : null,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.appButtonColor
                        : AppColors.appMutedColor,
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.tabs[index],
                  style: widget.textStyle.copyWith(
                    color: isSelected
                        ? AppColors.appButtonTextColor
                        : AppColors.appMutedTextColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
