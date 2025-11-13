import 'package:flutter/material.dart';

import '../core/app_color.dart';

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final Function(int)? onTap;
  final Color primaryColor;
  final Color borderColor;
  final TextStyle textStyle;
  final double height;

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.onTap,
    required this.height,
    required this.primaryColor,
    required this.borderColor,
    required this.textStyle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      alignment: Alignment.centerLeft,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () {
              setState(() => selectedIndex = index);
              if (widget.onTap != null) widget.onTap!(index);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? widget.primaryColor : Colors.white,
                gradient: isSelected
                    ? LinearGradient(
                  colors: [
                    widget.primaryColor,
                    widget.primaryColor.withOpacity(0.7)
                  ],
                )
                    : null,
                borderRadius: BorderRadius.circular(30),
                boxShadow: isSelected
                    ? [
                  BoxShadow(
                    color: widget.primaryColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
                    : [],
                border: Border.all(
                  color:
                  isSelected ? widget.primaryColor : widget.borderColor,
                  width: 1.2,
                ),
              ),
              child: Text(
                widget.tabs[index],
                style: widget.textStyle.copyWith(
                  color: isSelected ? Colors.white :AppColors.appTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
