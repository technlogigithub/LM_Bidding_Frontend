import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../core/app_color.dart';
import '../core/app_imagetype_helper.dart';
import '../../core/app_textstyle.dart';
import 'custom_auto_image_handle.dart';

class CustomHorizontalBullets extends StatelessWidget implements PreferredSizeWidget {
  final List<String> items;
  final TextStyle textStyle;
  final String? bgColor;
  final String? bgImg;

  const CustomHorizontalBullets({
    super.key,
    required this.items,
    required this.textStyle,
    this.bgColor,
    this.bgImg,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool hasValidImage = ImageTypeHelper.isImage(bgImg);

    Widget bulletList = Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        // padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: List.generate(items.length, (index) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: const EdgeInsets.only(right: 10),
              decoration: _bulletDecoration(),
              child: Text(
                items[index],
                style: textStyle.copyWith(
                  color: AppColors.appMutedTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }),
        ),
      ),
    );

    if (hasValidImage) {
      return Stack(
        children: [
          AutoNetworkImage(imageUrl: bgImg),
          Positioned.fill(child: bulletList),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(

        color: Colors.transparent
        // gradient: (bgColor != null && bgColor!.isNotEmpty)
        //     ? parseLinearGradient(bgColor!)
        //     : AppColors.appPagecolor,
      ),
      child: bulletList,
    );
  }

  BoxDecoration _bulletDecoration() {
    return BoxDecoration(
      color: AppColors.appMutedColor,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: AppColors.appMutedColor,
        width: 1,
      ),
    );
  }
}
