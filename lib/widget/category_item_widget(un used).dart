import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:libdding/core/app_textstyle.dart';

import '../core/app_color.dart';
import '../core/app_images.dart';
import '../models/category_model/category_model.dart';

class CategoryListWidget extends StatelessWidget {
  final List<Category> categories;

  const CategoryListWidget({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: categories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final category = categories[index];
        return CategoryItemWidget(category: category, isFirst: index == 0);
      },
    );
  }
}

class CategoryItemWidget extends StatelessWidget {
  final Category category;
  final bool isFirst;

  const CategoryItemWidget({
    Key? key,
    required this.category,
    required this.isFirst,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(

      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.appMutedColor,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 10),
            // blurRadius: 1,
            // spreadRadius: 1,
            // offset: Offset(0, 6),
          ),
        ],
        // border: Border.all(color: const Color(0xFFE0E0E0)), // AppColors.kBorderColorTextField
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isFirst && category.hasSubcategories,
          tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                category.image,fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    AppImage.placeholder,
                    fit: BoxFit.cover,
                  );
                },
              ),
            ),
          ),
          title: Text(
            category.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:  AppTextStyle.title(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.bold,

            ),
          ),
          subtitle: Text(
            category.categoryDetail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style:AppTextStyle.description(
              color: AppColors.appDescriptionColor, // AppColors.appTextColor with alpha 0.45
              // fontWeight: FontWeight.bold,

            ),
          ),
          trailing: category.hasSubcategories
              ?  Icon(
            FeatherIcons.chevronDown,
            color: AppColors.appIconColor, // AppColors.subTitleColor
          )
              : SizedBox.shrink(),
          children: category.hasSubcategories
              ? [
             Divider(
              height: 1,
              thickness: 1.0,
              color:AppColors.appMutedColor, // AppColors.kBorderColorTextField
            ),
            // Static subcategory items
            _buildSubcategoryItem(context, 'Logo Design'),
             Divider(
              thickness: 1.0,
              color:AppColors.appMutedColor,
            ),
            _buildSubcategoryItem(context, 'Brand Style Guides'),
             Divider(
              thickness: 1.0,
              color:AppColors.appMutedColor,
            ),
            _buildSubcategoryItem(context, 'Fonts & Typography'),
             Divider(
              thickness: 1.0,
                 color:AppColors.appMutedColor
            ),
            _buildSubcategoryItem(context, 'Business Cards & Stationery'),
          ]
              : [],
        ),
      ),
    );
  }

  Widget _buildSubcategoryItem(BuildContext context, String title) {
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
      horizontalTitleGap: 10,
      title: Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.description(
            color:AppColors.appDescriptionColor

        ),
      ),
      trailing:  Icon(
        FeatherIcons.chevronRight,
          color:AppColors.appIconColor // AppColors.subTitleColor
      ),
    );
  }
}