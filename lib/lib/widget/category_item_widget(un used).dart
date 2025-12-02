import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

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
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: const Color(0xFFE0E0E0)), // AppColors.kBorderColorTextField
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isFirst && category.hasSubcategories,
          tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
          childrenPadding: EdgeInsets.zero,
          leading: Container(
            height: 40,
            width: 40,
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
            style: const TextStyle(
              color: Color(0xFF212121), // AppColors.appTextColor
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          subtitle: Text(
            category.categoryDetail,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0x73212121), // AppColors.appTextColor with alpha 0.45
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          trailing: category.hasSubcategories
              ? const Icon(
            FeatherIcons.chevronDown,
            color: Color(0xFF757575), // AppColors.subTitleColor
          )
              : SizedBox.shrink(),
          children: category.hasSubcategories
              ? [
            const Divider(
              height: 1,
              thickness: 1.0,
              color: Color(0xFFE0E0E0), // AppColors.kBorderColorTextField
            ),
            // Static subcategory items
            _buildSubcategoryItem(context, 'Logo Design'),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFE0E0E0),
            ),
            _buildSubcategoryItem(context, 'Brand Style Guides'),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFE0E0E0),
            ),
            _buildSubcategoryItem(context, 'Fonts & Typography'),
            const Divider(
              thickness: 1.0,
              color: Color(0xFFE0E0E0),
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
        style: const TextStyle(
          color: Color(0xFF757575), // AppColors.subTitleColor
          fontSize: 14,
        ),
      ),
      trailing: const Icon(
        FeatherIcons.chevronRight,
        color: Color(0xFF757575), // AppColors.subTitleColor
      ),
    );
  }
}