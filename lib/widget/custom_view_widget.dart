import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/home/home_controller.dart';
import '../controller/post/app_post_controller.dart';
import '../models/Post/Get_Post_List_Model.dart';
import '../models/category_model/category_model.dart';
import 'custom_banner.dart';
import 'custom_banner_with_video.dart';
import 'custom_category_horizontal_list.dart';
import 'custom_navigator.dart';
import 'custom_searchbar.dart';
import 'my_post_list_custom.dart';
import 'custom_vertical_listview_list.dart';
import 'custom_vertical_gridview_list.dart';
import 'custom_horizontal_listview_list.dart';
import 'custom_horizontal_gridview_list.dart';
import 'category_vertical_list_widget.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import '../core/app_textstyle.dart';
import '../core/app_color.dart';
import '../core/app_images.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../view/Home_screen/search_history_screen.dart';
import 'custom_tapbar.dart';

/// Dynamic Post View Widget
/// This widget displays different post list views based on the provided type.
/// It uses AppPostController for data prefilling.
class CustomViewWidget extends StatelessWidget {
  const CustomViewWidget({
    super.key,
    required this.type,
    this.onActionTap,
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
    this.bgColor,
    this.bgImg,
    this.label,
    this.viewAllLabel,
    this.viewAllNextPage,
    this.nextPageName,
    this.nextPageViewType,
    this.itemData,
    this.itemDataList,
  });

  final String type;
  final Function(Map<String, dynamic> buttonData, String userKey)? onActionTap;

  final AppPostController? controller;

  // Common callbacks
  final Function(String)? onItemTap;
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
  final String? statusValue;
  final bool isFromCartScreen;

  // Search Bar
  final String? title;

  // TabBar
  final List<String>? tabOptions;
  final Function(int)? onTabChanged;

  // Model config
  final bool useHomeModel;

  // Background config
  final String? bgColor;
  final String? bgImg;

  // Header/Label config
  final String? label;
  final String? viewAllLabel;
  final String? viewAllNextPage;
  final String? nextPageName;
  final String? nextPageViewType;
  final Map<String, dynamic>? itemData;
  final List<dynamic>? itemDataList;

  @override
  Widget build(BuildContext context) {
    debugPrint("🟡 Widget type: ${type}");

    // Define which widget types need a controller
    const postWidgetTypes = {
      'custom_vertical_gridview_list',
      'custom_horizontal_gridview_list',
      'custom_vertical_listview_list',
      'custom_horizontal_listview_list',
      'my_post_list_custom',
    };

    // Only get controller for widgets that need it
    AppPostController? postController;
    late Rx<GetPostListResponseModel?> model;
    late RxBool isLoading;

    if (postWidgetTypes.contains(type)) {
      try {
        postController = controller ?? Get.find<AppPostController>();
        
        // If itemDataList is provided, we use it to create a local model.
        // This prevents showing old data from the global AppPostController.
        if (itemDataList != null && itemDataList!.isNotEmpty) {
          final localModel = GetPostListResponseModel(
            success: true,
            result: itemDataList!.map((e) => Result.fromJson(e)).toList(),
          );
          model = Rx<GetPostListResponseModel?>(localModel);
          isLoading = false.obs;
        } else {
          model = useHomeModel
              ? postController.getPostForHomeResponseModel
              : postController.getPostListResponseModel;
          isLoading = postController.isLoading;
        }
      } catch (e) {
        debugPrint("❌ CustomViewWidget: controller is null for type: ${type}");
        return const SizedBox.shrink();
      }
    }

    switch (type) {
      case "search_bar":
        // debugPrint("🔍 Search bar title: $title");
        // print(" case in $bgImg");
        // print(" case in $bgColor");
        return SearchBarWidget(
          title: title,
          bgColor: bgColor,
          bgImg: bgImg,
          nextPageName: nextPageName,
        );

      case "custom_banner":
        debugPrint("🖼 Banner Items: ${bannerItems?.length}");
        debugPrint("🖼 Banner Data: ${bannerItems}");
        return CustomBanner(
          banners: bannerItems ?? [],
          isLoading: bannerLoading ?? false.obs,
          width: MediaQuery.of(context).size.width,
          bgColor: bgColor,
          bgImg: bgImg,
        );

      case "custom_banner_with_video":
        debugPrint("🎬 Banner With Video Data: ${bannerItems}");
        return CustomBannerWithVideo(
          mediaItems: bannerItems ?? [],
          isLoading: bannerLoading ?? false.obs,
          bgColor: bgColor,
          bgImg: bgImg,
        );

      case "custom_category_horizontal_list":
      case "category_horizontal_icon_widget":
        if (categories == null || categories!.isEmpty) {
          return const SizedBox.shrink();
        }
        print(" Category image $bgImg");
        print(" Category image $bgColor");
        debugPrint("📂 Categories count: ${categories?.length}");
        debugPrint("📂 Categories Data: ${categories}");
        return CustomCategoryHorizontalList(
          categories: categories ?? [],
          isLoading: categoryLoading ?? false.obs,
          bgColor: bgColor,
          bgImg: bgImg,
          label: label,
          viewAllLabel: viewAllLabel,
          viewAllNextPage: viewAllNextPage,
          nextPageName: nextPageName,
          nextPageViewType: nextPageViewType,
        );

      case "custom_horizontal_listview_list":
        if (model == null || isLoading == null) {
          debugPrint("❌ Controller not available for horizontal list");
          return const SizedBox.shrink();
        }
        debugPrint("➡ Horizontal List Model: ${model.value?.result?.length}");
        debugPrint("➡ Model Data: ${model.value}");
        return Obx(() {
          // If loading, show widget (it handles shimmer). If NOT loading and empty, hide.
          if (!isLoading!.value && (model!.value?.result == null ||
              model!.value!.result!.isEmpty)) {
            return const SizedBox.shrink();
          }
          return CustomHorizontalListViewList(
            model: model,
            isLoading: isLoading,
            onItemTap: onItemTap ??
                (String id) {
                  if (nextPageName?.isNotEmpty == true) {
                    CustomNavigator.navigate(nextPageName, arguments: id);
                  }
                },
            onFavoriteToggle: onFavoriteToggle ?? (index, status) {},
            bgColor: bgColor,
            bgImg: bgImg,
            label: label,
            viewAllLabel: viewAllLabel,
            viewAllNextPage: viewAllNextPage,
            nextPageName: nextPageName,
            nextPageViewType: nextPageViewType,
          );
        });

      case "custom_horizontal_gridview_list":
        if (model == null || isLoading == null) {
          // debugPrint("❌ Controller not available for horizontal grid");
          return const SizedBox.shrink();
        }
        // debugPrint("🟦 Horizontal Grid Data: ${model.value}");
        return Obx(() {
          // If loading, show widget (it handles shimmer). If NOT loading and empty, hide.
          if (!isLoading!.value && (model!.value?.result == null ||
              model!.value!.result!.isEmpty)) {
            return const SizedBox.shrink();
          }
          return CustomHorizontalGridViewList(
            model: model,
            isLoading: isLoading,
            height: height,
            onItemTap: onItemTap ??
                (String id) {
                  if (nextPageName?.isNotEmpty == true) {
                    CustomNavigator.navigate(nextPageName, arguments: id);
                  }
                },
            onFavoriteToggle: onFavoriteToggle,
            bgColor: bgColor,
            bgImg: bgImg,
            label: label,
            viewAllLabel: viewAllLabel,
            viewAllNextPage: viewAllNextPage,
            nextPageName: nextPageName,
            nextPageViewType: nextPageViewType,
          );
        });

      case "custom_vertical_gridview_list":
        if (model == null || isLoading == null) {
          // debugPrint("❌ Controller not available for vertical grid");
          return const SizedBox.shrink();
        }
        // debugPrint("🟥 Vertical Grid Data: ${model.value}");
        return Obx(() {
          // If loading, show widget (it handles shimmer). If NOT loading and empty, hide.
          // 🛑 User Request: "jo data nahi hai to show nahi karvana" (If no data, don't show).
          // "continue simmer chal raha hai" (Shimmer is running continuously).
          // "data ho tabhi hi simmer show karvana hai" (Only show shimmer if there is data).
          // So, if result is empty, we wrap in shrink, effectively disabling initial shimmer if no data.
          if (model!.value?.result == null ||
              model!.value!.result!.isEmpty) {
            return const SizedBox.shrink();
          }
          return CustomVerticalGridviewList(
            model: model,
            isLoading: isLoading,
            childAspectRatio: childAspectRatio,
            onItemTap: onItemTap ??
                (String id) {
                  if (nextPageName?.isNotEmpty == true) {
                    CustomNavigator.navigate(nextPageName, arguments: id);
                  }
                },
            onFavoriteToggle: onFavoriteToggle,
            bgColor: bgColor,
            bgImg: bgImg,
            label: label,
            viewAllLabel: viewAllLabel,
            viewAllNextPage: viewAllNextPage,
            nextPageName: nextPageName,
            nextPageViewType: nextPageViewType,
          );
        });

      case "custom_vertical_listview_list":
        if (model == null || isLoading == null) {
          debugPrint("❌ Controller not available for vertical list");
          return const SizedBox.shrink();
        }
        // debugPrint("📃 Vertical List Data: ${model.value}");
        return Obx(() {
          final list = model.value?.result;

          // 🔥 PRINT LENGTH IN UI
          debugPrint("📦 VerticalList result length: ${list?.length ?? 0}");

          // If loading is false and list empty → hide
          if (!isLoading.value && (list == null || list.isEmpty)) {
            return const SizedBox.shrink();
          }

          return CustomVerticalListviewList(
            model: model,
            isLoading: isLoading,
            isFromCartScreen: isFromCartScreen,
            onActionTap: onActionTap,
            onItemTap: onItemTap ??
                    (String id) {
                  if (nextPageName?.isNotEmpty == true) {
                    CustomNavigator.navigate(nextPageName, arguments: id);
                  }
                },
            onFavoriteToggle: onFavoriteToggle ?? (index, status) {},
            bgColor: bgColor,
            bgImg: bgImg,
            label: label,
            viewAllLabel: viewAllLabel,
            viewAllNextPage: viewAllNextPage,
            nextPageName: nextPageName,
            nextPageViewType: nextPageViewType,
          );
        });


      case "my_post_list_custom":
        if (model == null || isLoading == null) {
          debugPrint("❌ Controller not available for my post list");
          return const SizedBox.shrink();
        }
        // debugPrint("👤 My Post List Data: ${model.value}");
        // debugPrint("👤 Status Value: ${statusValue}");
        return Obx(() {
          // If loading, show widget (it handles shimmer). If NOT loading and empty, hide.
          if (!isLoading!.value && (model!.value?.result == null ||
              model!.value!.result!.isEmpty)) {
            return const SizedBox.shrink();
          }
          return MypostListCustomWidget(
            model: model,
            isLoading: isLoading,
            statusValue: statusValue ?? '',
            onItemTap: onItemTap ??
                (String id) {
                  if (nextPageName?.isNotEmpty == true) {
                    CustomNavigator.navigate(nextPageName, arguments: id);
                  }
                },
            bgColor: bgColor,
            bgImg: bgImg,
          );
        });

      case "custom_tapbar":
        if (tabOptions != null && tabOptions!.isNotEmpty) {
          return CustomTabBar(
            tabs: tabOptions!,
            textStyle: AppTextStyle.description(),
            bgColor: bgColor,
            bgImg: bgImg,
            // initialIndex: 0,
            onTap: (index) {
              if (onTabChanged != null) {
                onTabChanged!(index);
              }
            },
            label: label,
            viewAllLabel: viewAllLabel,
            viewAllNextPage: viewAllNextPage,
            nextPageName: nextPageName,
            nextPageViewType: nextPageViewType,
          );
        }
        return const SizedBox.shrink();

      case "category_vertical_list_widget":
        final homeController = Get.find<ClientHomeController>();

        return Obx(() {
          // Check if data is loading and list is empty -> Hide (no shimmer on empty)
          if (homeController.categoryLoading.value &&
              homeController.categoryList.isEmpty) {
            return const SizedBox.shrink();
          }
          
          if (homeController.categoryLoading.value) {
            return CategoryVerticalListWidget.buildShimmerList();
          }

          if (homeController.categoryList.isEmpty) {
            return const SizedBox.shrink();
          }

          final categories = homeController.filteredCategoryList.map((e) {
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

          return CategoryVerticalListWidget(
            categories: categories,
            bgColor: bgColor,
            bgImg: bgImg,
            label: label,
            viewAllLabel: viewAllLabel,
            viewAllNextPage: viewAllNextPage,
            nextPageName: nextPageName,
            nextPageViewType: nextPageViewType,
          );
        });



      default:
        debugPrint("❌ Unknown widget type: ${type}");
        return Center(
          child: Text(
            'Unknown widget type: ${type}',
            style: TextStyle(color: Colors.red),
          ),
        );
    }
  }
}
