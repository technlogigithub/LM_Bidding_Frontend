import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/app_main/App_main_controller.dart';
import '../controller/home/home_controller.dart';
import '../controller/post/app_post_controller.dart';
import '../core/app_color.dart';
import '../core/app_images.dart';
import '../models/category_model/category_model.dart';
import '../models/home/category_response_model.dart';
import '../view/search_filter_post/search_filter_screen.dart';
import 'custom_auto_image_handle.dart';
import '../core/app_imagetype_helper.dart';

import '../view/Home_screen/select_categories_screen.dart';
import 'custom_navigator.dart';

class CategoryVerticalListWidget extends StatelessWidget {
  final List<Category> categories;
  final String? bgColor;
  final String? bgImg;
  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName; // Added
  final String? nextPageViewType; // Added

  const CategoryVerticalListWidget({
    super.key, 
    required this.categories,
    this.bgColor,
    this.bgImg,
    this.label,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.nextPageName,
    this.nextPageViewType,
  });

  // Static method to build shimmer list for loading state
  static Widget buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Number of shimmer placeholders
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
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
              ),
            ],
          ),
          child: Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                leading: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                title: Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                subtitle: Container(
                  margin: const EdgeInsets.only(top: 8),
                  height: 14,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                trailing: Container(
                  height: 20,
                  width: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    if (label == null || label!.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 5),
      child: Row(
        children: [
          Text(
            label!,
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
            ),
          ),
          const Spacer(),
          if (viewAllLabel != null && viewAllLabel!.isNotEmpty)
            GestureDetector(
              onTap: () {
                CustomNavigator.navigate(
                    viewAllNextPage?.isNotEmpty == true
                        ? viewAllNextPage
                        : nextPageName);
              },
              child: Text(
                viewAllLabel!,
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
    return Stack(
      children: [
        if (ImageTypeHelper.isImage(bgImg))
          Positioned.fill(
            child: AutoNetworkImage(imageUrl: bgImg),
          ),
        Container(
          decoration: BoxDecoration(
            gradient: !ImageTypeHelper.isImage(bgImg)
                ? (bgColor != null && bgColor!.isNotEmpty
                    ? parseLinearGradient(bgColor)
                    : AppColors.appPagecolor)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               _buildHeader(),
               ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return CategoryItemWidget(category: category, isFirst: index == 0);
                },
              ),
             ]
          ),
        ),
      ],
    );
  }
}

class CategoryItemWidget extends StatefulWidget {
  final Category category;
  final bool isFirst;

  const CategoryItemWidget({
    Key? key,
    required this.category,
    required this.isFirst,
  }) : super(key: key);

  @override
  State<CategoryItemWidget> createState() => _CategoryItemWidgetState();
}

class _CategoryItemWidgetState extends State<CategoryItemWidget> {
  final ClientHomeController controller = Get.find<ClientHomeController>();
  final AppPostController appPostController = Get.find<AppPostController>();
  bool _hasBeenExpanded =
      false; // Track if category has been expanded at least once

  @override
  void initState() {
    super.initState();
    // If category is initially expanded (first category), mark as expanded and fetch subcategories
    if (widget.isFirst && widget.category.hasSubcategories) {
      _hasBeenExpanded = true;
      // Fetch subcategories if initially expanded
      if (widget.category.ukey.isNotEmpty) {
        controller.fetchSubcategories(widget.category.ukey);
      }
    }
  }

  void _onExpansionChanged(bool expanded) {
    // Mark as expanded when user expands the category
    if (expanded) {
      _hasBeenExpanded = true;
    }

    // Fetch subcategories when expanded
    if (expanded &&
        widget.category.hasSubcategories &&
        widget.category.ukey.isNotEmpty) {
      controller.fetchSubcategories(widget.category.ukey);
    }
  }
  void _onCategoryTap() {
    // Agar subcategories nahi hain
    if (!widget.category.hasSubcategories) {
      final appController = Get.find<AppSettingsController>();
      final appPostController = Get.find<AppPostController>();

      final categoryPage =
          appController.appSettings.value?.result?.categoryPage;

      final pageName = categoryPage?.pageName;

      // ✅ page_name store karo
      if (pageName != null && pageName.isNotEmpty) {
        appPostController.updatePageName(pageName);
      }

      // ✅ category ukey store karo (API call nahi)
      final categoryUkey = widget.category.ukey;
      if (categoryUkey.isNotEmpty) {
        appPostController.updateCategory(categoryUkey);
      } else {
        appPostController.updateCategory('');
      }

      // ✅ Sirf navigation
      Get.to(() => SearchFilterScreen());
    }
  }


  // void _onCategoryTap() {
  //   // If category has no subcategories, call API with category ukey
  //   // Call API even if ukey is null/empty - pass ukey only if it's not empty
  //   if (!widget.category.hasSubcategories) {
  //     // Get endpoint and pageName from categoryPage configuration
  //     final appController = Get.find<AppSettingsController>();
  //     final categoryPage =
  //         appController.appSettings.value?.result?.categoryPage;
  //     final endpoint = categoryPage?.apiEndpoint;
  //     final pageName = categoryPage?.pageName;
  //
  //     // Update page_name in AppPostController if available
  //     if (pageName != null && pageName.isNotEmpty) {
  //       appPostController.updatePageName(pageName);
  //     }
  //
  //     final categoryUkey = widget.category.ukey;
  //     appPostController.getPostListWithParams(
  //       endpoint: endpoint,
  //       categoryParam: categoryUkey.isNotEmpty ? categoryUkey : null,
  //     );
  //
  //     Get.to(SeachFilterScreen());
  //   }
  // }

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
          ),
        ],
      ),
      child: widget.category.hasSubcategories
          ? Theme(
              data: Theme.of(
                context,
              ).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded:
                    widget.isFirst && widget.category.hasSubcategories,
                onExpansionChanged: _onExpansionChanged,
                tilePadding: const EdgeInsets.symmetric(horizontal: 10.0),
                childrenPadding: EdgeInsets.zero,
                leading: Container(
                  height: 40.h,
                  width: 40.w,
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      widget.category.image,
                      fit: BoxFit.cover,
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
                  widget.category.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.title(
                    color: AppColors.appTitleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  widget.category.categoryDetail,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.description(
                    color: AppColors.appDescriptionColor,
                  ),
                ),
                trailing: Icon(
                  FeatherIcons.chevronDown,
                  color: AppColors.appIconColor,
                ),
                children: [
                  Obx(() {
                    final subcategories =
                        controller.subcategoriesMap[widget.category.ukey] ?? [];
                    final isLoading =
                        controller.loadingSubcategories[widget.category.ukey] ??
                        false;

                    if (isLoading) {
                      return _buildSubcategoryShimmer();
                    }

                    // If not expanded yet, don't show anything
                    if (!_hasBeenExpanded) {
                      return const SizedBox.shrink();
                    }

                    // If expanded and has subcategories, show them
                    if (subcategories.isNotEmpty) {
                      return Column(
                        children: subcategories.asMap().entries.map((entry) {
                          final index = entry.key;
                          final subcategory = entry.value;

                          return Column(
                            children: [
                              if (index > 0)
                                Divider(
                                  thickness: 1.0,
                                  color: AppColors.appMutedColor,
                                ),
                              // Use SubcategoryItemWidget for nested subcategories support
                              SubcategoryItemWidget(
                                subcategory: subcategory,
                                level:
                                    0, // Level 0 for first level subcategories
                              ),
                            ],
                          );
                        }).toList(),
                      );
                    }

                    // Only show "No subcategories available" if:
                    // 1. Category has been expanded at least once (_hasBeenExpanded)
                    // 2. API call is complete (not loading)
                    // 3. Subcategories list is empty
                    // ❌ REMOVED: "No subcategories available" text logic
                    // if (_hasBeenExpanded && !isLoading && subcategories.isEmpty) { ... }
                    
                    if (_hasBeenExpanded &&
                        !isLoading &&
                        subcategories.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    // Default: return empty widget
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            )
          : GestureDetector(
              onTap: _onCategoryTap,
              child: Theme(
                data: Theme.of(
                  context,
                ).copyWith(dividerColor: Colors.transparent),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                  leading: Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: ClipRRect(
                      // borderRadius: BorderRadius.circular(8.0),
                      child: Image.network(
                        widget.category.image,
                        fit: BoxFit.cover,
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
                    widget.category.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.title(
                      color: AppColors.appTitleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    widget.category.categoryDetail,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.description(
                      color: AppColors.appDescriptionColor,
                    ),
                  ),
                  trailing: Icon(
                    FeatherIcons.chevronRight,
                    color: AppColors.appIconColor,
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildSubcategoryShimmer() {
    return Column(
      children: List.generate(3, (index) {
        return Column(
          children: [
            if (index > 0)
              Divider(thickness: 1.0, color: AppColors.appMutedColor),
            Shimmer.fromColors(
              baseColor: AppColors.appMutedColor,
              highlightColor: AppColors.appMutedTextColor,
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                horizontalTitleGap: 10,
                title: Container(
                  height: 16,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                trailing: Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Widget for subcategory items that can be expandable for nested subcategories
class SubcategoryItemWidget extends StatefulWidget {
  final CategoryResult subcategory;
  final int level; // Nesting level for indentation

  const SubcategoryItemWidget({
    Key? key,
    required this.subcategory,
    this.level = 0,
  }) : super(key: key);

  @override
  State<SubcategoryItemWidget> createState() => _SubcategoryItemWidgetState();
}

class _SubcategoryItemWidgetState extends State<SubcategoryItemWidget> {
  final ClientHomeController controller = Get.find<ClientHomeController>();
  final AppPostController appPostController = Get.find<AppPostController>();
  bool _hasBeenExpanded =
      false; // Track if subcategory has been expanded at least once

  void _onExpansionChanged(bool expanded) {
    // Mark as expanded when user expands the subcategory
    if (expanded) {
      _hasBeenExpanded = true;
    }

    // Fetch nested subcategories when expanded
    if (expanded &&
        widget.subcategory.hasSubcategories == true &&
        widget.subcategory.ukey != null &&
        widget.subcategory.ukey!.isNotEmpty) {
      controller.fetchSubcategories(widget.subcategory.ukey!);
    }
  }

  void _onSubcategoryTap() {
    // Agar further subcategories nahi hain
    if (widget.subcategory.hasSubcategories != true) {
      final appController = Get.find<AppSettingsController>();
      final appPostController = Get.find<AppPostController>();

      final categoryPage =
          appController.appSettings.value?.result?.categoryPage;

      final pageName = categoryPage?.pageName;

      // ✅ page_name store karo
      if (pageName != null && pageName.isNotEmpty) {
        appPostController.updatePageName(pageName);
      }

      // ✅ subcategory ukey ko category param me store karo
      final subcategoryUkey = widget.subcategory.ukey;

      if (subcategoryUkey != null && subcategoryUkey.isNotEmpty) {
        appPostController.updateCategory(subcategoryUkey);
      } else {
        appPostController.updateCategory('');
      }

      // ✅ sirf navigation
      Get.to(() => SearchFilterScreen());
    }
  }


  // void _onSubcategoryTap() {
  //   // If subcategory has no subcategories, call API with subcategory ukey
  //   // Call API even if ukey is null/empty - pass ukey only if it's not empty
  //   if (widget.subcategory.hasSubcategories != true) {
  //     // Get endpoint and pageName from categoryPage configuration
  //     final appController = Get.find<AppSettingsController>();
  //     final categoryPage =
  //         appController.appSettings.value?.result?.categoryPage;
  //     final endpoint = categoryPage?.apiEndpoint;
  //     final pageName = categoryPage?.pageName;
  //
  //     // Update page_name in AppPostController if available
  //     if (pageName != null && pageName.isNotEmpty) {
  //       appPostController.updatePageName(pageName);
  //     }
  //
  //     final subcategoryUkey = widget.subcategory.ukey;
  //     appPostController.getPostListWithParams(
  //       endpoint: endpoint,
  //       categoryParam: (subcategoryUkey != null && subcategoryUkey.isNotEmpty)
  //           ? subcategoryUkey
  //           : null,
  //     );
  //
  //     Get.to(SeachFilterScreen());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // If subcategory has subcategories, make it expandable
    if (widget.subcategory.hasSubcategories == true) {
      return Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          onExpansionChanged: _onExpansionChanged,
          tilePadding: EdgeInsets.only(
            left: 10.0 + (widget.level * 20.0), // Indent based on level
            right: 10.0,
          ),
          childrenPadding: EdgeInsets.zero,
          title: Text(
            widget.subcategory.title ?? widget.subcategory.name ?? '',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
          trailing: Icon(
            FeatherIcons.chevronDown,
            color: AppColors.appIconColor,
          ),
          children: [
            Obx(() {
              final nestedSubcategories =
                  controller.subcategoriesMap[widget.subcategory.ukey ?? ''] ??
                  [];
              final isLoading =
                  controller.loadingSubcategories[widget.subcategory.ukey ??
                      ''] ??
                  false;

              if (isLoading) {
                return _buildNestedSubcategoryShimmer();
              }

              // If not expanded yet, don't show anything
              if (!_hasBeenExpanded) {
                return const SizedBox.shrink();
              }

              // If expanded and has nested subcategories, show them
              if (nestedSubcategories.isNotEmpty) {
                return Column(
                  children: nestedSubcategories.asMap().entries.map((entry) {
                    final index = entry.key;
                    final nestedSubcategory = entry.value;

                    return Column(
                      children: [
                        if (index > 0)
                          Divider(
                            thickness: 1.0,
                            color: AppColors.appMutedColor,
                          ),
                        // Recursively render nested subcategories
                        SubcategoryItemWidget(
                          subcategory: nestedSubcategory,
                          level:
                              widget.level + 1, // Increment level for nesting
                        ),
                      ],
                    );
                  }).toList(),
                );
              }

              // Only show "No subcategories available" if:
              // 1. Subcategory has been expanded at least once (_hasBeenExpanded)
              // 2. API call is complete (not loading)
              // 3. Nested subcategories list is empty
              // ❌ REMOVED: "No subcategories available" text logic
              if (_hasBeenExpanded &&
                  !isLoading &&
                  nestedSubcategories.isEmpty) {
                return const SizedBox.shrink();
              }

              // Default: return empty widget
              return const SizedBox.shrink();
            }),
          ],
        ),
      );
    }

    // If no subcategories, show as simple list item
    return ListTile(
      visualDensity: const VisualDensity(vertical: -4),
      contentPadding: EdgeInsets.only(
        left: 10.0 + (widget.level * 20.0), // Indent based on level
        right: 10.0,
      ),
      horizontalTitleGap: 10,
      title: Text(
        widget.subcategory.title ?? widget.subcategory.name ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: AppTextStyle.description(color: AppColors.appDescriptionColor),
      ),
      trailing: Icon(FeatherIcons.chevronRight, color: AppColors.appIconColor),
      onTap: _onSubcategoryTap,
    );
  }

  Widget _buildNestedSubcategoryShimmer() {
    return Column(
      children: List.generate(2, (index) {
        return Column(
          children: [
            if (index > 0)
              Divider(thickness: 1.0, color: AppColors.appMutedColor),
            Shimmer.fromColors(
              baseColor: AppColors.appMutedColor,
              highlightColor: AppColors.appMutedTextColor,
              child: ListTile(
                visualDensity: const VisualDensity(vertical: -4),
                contentPadding: EdgeInsets.only(
                  left: 10.0 + (widget.level * 20.0),
                  right: 10.0,
                ),
                horizontalTitleGap: 10,
                title: Container(
                  height: 14,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                trailing: Container(
                  height: 14,
                  width: 14,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
