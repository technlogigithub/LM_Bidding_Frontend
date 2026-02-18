import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import 'custom_auto_image_handle.dart';

import '../../core/app_textstyle.dart';
import '../../view/Home_screen/search_history_screen.dart';
import '../../view/Home_screen/select_categories_screen.dart';
import 'package:get/get.dart';
import 'custom_navigator.dart';

class CustomTabBar extends StatefulWidget implements PreferredSizeWidget {
  final List<String> tabs;
  final Function(int)? onTap;
  final TextStyle textStyle;
  final int? initialIndex;
  final String? bgColor;
  final String? bgImg;
  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName; // Added
  final String? nextPageViewType; // Added

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  const CustomTabBar({
    super.key,
    required this.tabs,
    this.onTap,
    required this.textStyle,
    this.initialIndex,
    this.bgColor,
    this.bgImg,
    this.label,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.nextPageName,
    this.nextPageViewType,
  });

  @override
  State<CustomTabBar> createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();

    // ✅ ONLY select if valid index is passed from backend
    if (widget.initialIndex != null &&
        widget.initialIndex! >= 0 &&
        widget.initialIndex! < widget.tabs.length) {
      selectedIndex = widget.initialIndex;
    } else {
      selectedIndex = null; // ✅ GUARANTEED no default selection
    }
  }

  @override
  void didUpdateWidget(covariant CustomTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ If backend value changes later, update selection
    if (widget.initialIndex != oldWidget.initialIndex) {
      if (widget.initialIndex != null &&
          widget.initialIndex! >= 0 &&
          widget.initialIndex! < widget.tabs.length) {
        selectedIndex = widget.initialIndex;
      } else {
        selectedIndex = null;
      }
      setState(() {});
    }
  }

  Widget _buildHeader() {
    if (widget.label == null || widget.label!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Row(
        children: [
          Text(
            widget.label!,
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
            ),
          ),
          const Spacer(),
          if (widget.viewAllLabel != null && widget.viewAllLabel!.isNotEmpty)
            GestureDetector(
              onTap: () {
                CustomNavigator.navigate(
                    widget.viewAllNextPage?.isNotEmpty == true
                        ? widget.viewAllNextPage
                        : widget.nextPageName);
              },
              child: Text(
                widget.viewAllLabel!,
                style: AppTextStyle.description(
                  color: AppColors.appLinkColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool hasValidImage = ImageTypeHelper.isImage(widget.bgImg);

    Widget tabList = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: List.generate(widget.tabs.length, (index) {
            final isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() => selectedIndex = index);
                widget.onTap?.call(index);

                // Navigate if nextPageName is provided
                if (widget.nextPageName != null && widget.nextPageName!.isNotEmpty) {
                  // We might want to pass the selected tab as an argument or filter
                  // For now, based on user request, just navigate

                  // If navigating to SearchFilterScreen, we likely want to pass the selected filter
                  final selectedTab = widget.tabs[index];
                  CustomNavigator.navigate(widget.nextPageName, arguments: selectedTab);
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                margin: const EdgeInsets.only(right: 10),
                decoration: _getDecoration(isSelected),
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

    Widget contentWithHeader = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        tabList,
      ],
    );

    if (hasValidImage) {
      return Stack(
        children: [
          AutoNetworkImage(imageUrl: widget.bgImg),
          Positioned.fill(child: contentWithHeader),
        ],
      );
    }

      return Container(
        decoration: BoxDecoration(
          gradient: _resolveGradient(),
          color: _resolveGradient() == null ? Colors.transparent : null,
        ),
        child: contentWithHeader,
      );
  }
  Gradient? _resolveGradient() {
    if (widget.bgColor == null || widget.bgColor!.trim().isEmpty) {
      return null; // means no gradient
    }

    try {
      return parseLinearGradient(widget.bgColor!);
    } catch (e) {
      return null;
    }
  }


  BoxDecoration _getDecoration(bool isSelected) {
    if (!isSelected) {
      return BoxDecoration(
        color: AppColors.appMutedColor,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.appMutedColor,
          width: 1,
        ),
      );
    }

    // 1. Priority: Checked bgImg
    if (widget.bgImg != null && widget.bgImg!.isNotEmpty) {
      return BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(widget.bgImg!),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(30),
        // Optional: keep border if needed, or remove.
        // Keeping it consistent with other states:
        border: Border.all(
          color: AppColors.appButtonColor, // Or transparent
          width: 1,
        ),
      );
    }

    // 2. Priority: bgColor
    if (widget.bgColor != null && widget.bgColor!.isNotEmpty) {
      Color? dynamicColor;
      try {
        dynamicColor = _getColorFromHex(widget.bgColor!);
      } catch (e) {
        debugPrint("Error parsing color: $e");
      }

      if (dynamicColor != null) {
        return BoxDecoration(
          color: dynamicColor,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: dynamicColor,
            width: 1,
          ),
        );
      }
    }

    // 3. Fallback: Existing Gradient/Color
    return BoxDecoration(
      color: AppColors.appButtonColor,
      gradient: LinearGradient(
        colors: [
          AppColors.appButtonColor,
          AppColors.appButtonColor.withOpacity(0.7),
        ],
      ),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: AppColors.appButtonColor,
        width: 1,
      ),
    );
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return Color(int.parse("0x$hexColor"));
  }
}


