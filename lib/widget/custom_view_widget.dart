import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home/home_controller.dart';
import '../controller/post/app_post_controller.dart';
import '../models/Post/Get_Post_List_Model.dart';
import '../models/category_model/category_model.dart';
import 'custom_banner.dart';
import 'custom_banner_with_video.dart';
import 'custom_category_horizontal_list.dart';
import 'my_post_list_custom.dart';
import 'custom_vertical_listview_list.dart';
import 'custom_vertical_gridview_list.dart';
import 'custom_horizontal_listview_list.dart';
import 'custom_horizontal_gridview_list.dart';
import 'category_vertical_list_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../core/app_textstyle.dart';
import '../core/app_color.dart';
import '../view/Home_screen/search_screen.dart';
import 'custom_tapbar.dart';
/// Dynamic Post View Widget
/// This widget displays different post list views based on the provided type.
/// It uses AppPostController for data prefilling.
class CustomViewWidget extends StatelessWidget {
  final String type;

  final AppPostController? controller;

  // Common callbacks
  final VoidCallback? onItemTap;
  final Function(int, bool)? onFavoriteToggle;

  // Banner
  final List<Map<String, dynamic>>? bannerItems;
  final RxBool? bannerLoading;

  // Category Horizontal
  final List<Map<String, String>>? categories;
  final RxBool? categoryLoading;

  // Grid/List config
  final double? childAspectRatio;
  final double? height;

  // My post
  // My post
  final String? statusValue;
  final bool isFromCartScreen;

  // Search Bar
  final String? title;

  // TabBar
  final List<String>? tabOptions;
  final Function(int)? onTabChanged;

  // Model config
  final bool useHomeModel;

  const CustomViewWidget({
    super.key,
    required this.type,
    this.controller,
    this.onItemTap,
    this.onFavoriteToggle,
    this.bannerItems,
    this.bannerLoading,
    this.categories,
    this.categoryLoading,
    this.childAspectRatio,
    this.height,
    this.statusValue,
    this.isFromCartScreen = false,
    this.title,
    this.tabOptions,
    this.onTabChanged,
    this.useHomeModel = false,
  });

  @override
  Widget build(BuildContext context) {
    final AppPostController postController =
        controller ?? Get.find<AppPostController>();

    final model = useHomeModel
        ? postController.getPostForHomeResponseModel
        : postController.getPostListResponseModel;
    final isLoading = postController.isLoading;

    switch (type) {

    /// 🔹 SEARCH BAR
      case "search_bar":
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.appDescriptionColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              horizontalTitleGap: 0,
              visualDensity: const VisualDensity(vertical: -2),
              leading: Icon(
                FeatherIcons.search,
                color: AppColors.appBodyTextColor,
                size: 18,
              ),
              title: Text(
                title ?? 'Search keyword...',
                style: AppTextStyle.description(color: AppColors.appBodyTextColor),
              ),
              onTap: () {
                Get.to(() => SearchScreen());
              },
            ),
          ),
        );

    /// 🔹 IMAGE BANNER
      case "custom_banner":
        if ((bannerLoading?.value == false) && (bannerItems == null || bannerItems!.isEmpty)) {
          return const SizedBox.shrink();
        }
        return CustomBanner(
          banners: bannerItems ?? [],
          isLoading: bannerLoading ?? false.obs,
          width: MediaQuery.of(context).size.width,
        );

    /// 🔹 IMAGE + VIDEO BANNER
      case "custom_banner_with_video":
        if ((bannerLoading?.value == false) && (bannerItems == null || bannerItems!.isEmpty)) {
          return const SizedBox.shrink();
        }
        return CustomBannerWithVideo(
          mediaItems: bannerItems ?? [],
          isLoading: bannerLoading ?? false.obs,
        );

    /// 🔹 CATEGORY HORIZONTAL LIST
      case "custom_category_horizontal_list":
      case "category_horizontal_icon_widget":
        if ((categoryLoading?.value == false) && (categories == null || categories!.isEmpty)) {
          return const SizedBox.shrink();
        }
        return CustomCategoryHorizontalList(
          categories: categories ?? [],
          isLoading: categoryLoading ?? false.obs,
        );

    /// 🔹 HORIZONTAL LIST
      case "custom_horizontal_listview_list":
        return CustomHorizontalListViewList(
          model: model,
          isLoading: isLoading,
          onItemTap: onItemTap,
          onFavoriteToggle: onFavoriteToggle!,
        );

    /// 🔹 HORIZONTAL GRID
      case "custom_horizontal_gridview_list":
        return CustomHorizontalGridViewList(
          model: model,
          isLoading: isLoading,
          height: height,
          onItemTap: onItemTap,
          onFavoriteToggle: onFavoriteToggle,
        );

    /// 🔹 VERTICAL GRID
      case "custom_vertical_gridview_list":
        return CustomVerticalGridviewList(
          model: model,
          isLoading: isLoading,
          childAspectRatio: childAspectRatio,
          onItemTap: onItemTap,
          onFavoriteToggle: onFavoriteToggle,
        );

    /// 🔹 VERTICAL LIST
      case "custom_vertical_listview_list":
        return Padding(
          padding: const EdgeInsets.all(10),
          child: CustomVerticalListviewList(
            model: model,
            isLoading: isLoading,
            isFromCartScreen: isFromCartScreen,
            onItemTap: onItemTap,
            onFavoriteToggle: onFavoriteToggle!,
          ),
        );

    /// 🔹 MY POSTS
      case "my_post_list_custom":
        return MypostListCustomWidget(
          model: model,
          isLoading: isLoading,
          statusValue: statusValue ?? '',
          onItemTap: onItemTap,
        );

      /// 🔹 CUSTOM TABBAR
      case "custom_tapbar":
        if (tabOptions != null && tabOptions!.isNotEmpty) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: CustomTabBar(
              tabs: tabOptions!,
              textStyle: AppTextStyle.description(),
              initialIndex: 0,
              onTap: (index) {
                if (onTabChanged != null) {
                  onTabChanged!(index);
                }
              },
            ),
          );
        }
        return const SizedBox.shrink();

    /// 🔹 CATEGORY VERTICAL LIST
      case "category_vertical_list_widget":
        final homeController = Get.find<ClientHomeController>();

        return Obx(() {
          if (homeController.isLoading.value) {
            return CategoryVerticalListWidget.buildShimmerList();
          }

          if (homeController.categoryList.isEmpty) {
            return const SizedBox.shrink();
          }

          final categories = homeController.categoryList.map((e) {
            return Category(
              ukey: e.ukey ?? '',
              parentUkey: null,
              name: e.name ?? '',
              title: e.title ?? '',
              categoryDetail: e.categoryDetail ?? '',
              image: e.image ?? '',
              hasSubcategories: e.hasSubcategories ?? false,
            );
          }).toList();

          return CategoryVerticalListWidget(categories: categories);
        });

      default:
        return Center(
          child: Text(
            'Unknown widget type: $type',
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }
}

