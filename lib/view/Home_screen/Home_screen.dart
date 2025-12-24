import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/controller/app_main/App_main_controller.dart';
import 'package:libdding/core/app_images.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/Home_screen/recently_view.dart';
import 'package:libdding/widget/custom_vertical_listview_list.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/post/app_post_controller.dart';
import '../../controller/profile/profile_controller.dart';
import '../../core/app_color.dart';
import '../../models/home/banner_response_model.dart';
import '../search_filter_post/seach_filter_screen.dart';
import 'search_screen.dart';
import '../../widget/custom_banner.dart';
import '../../widget/custom_category_horizontal_list.dart';
import '../../widget/custom_horizontal_gridview_list.dart';
import '../../widget/custom_horizontal_listview_list.dart';
import '../../widget/custom_tapbar.dart';
import '../../widget/custom_vertical_gridview_list.dart';
import '../../widget/custom_banner_with_video.dart';
import '../cart_screen/cart_screen.dart';
import '../notifications/notifications_screen.dart';
import 'client_all_categories.dart';
import '../../widget/custom_view_widget.dart';

class ClientHomeScreen extends StatelessWidget {
  ClientHomeScreen({super.key});

  final ClientHomeController controller = Get.put(ClientHomeController());
  final AppSettingsController appcontroller = Get.put(AppSettingsController());

  @override
  Widget build(BuildContext context) {
    final ClientHomeController controller = Get.put(ClientHomeController());
    final AppSettingsController appController = Get.put(
      AppSettingsController(),
    );
    final homePage = appController.homePage.value; // <-- HomePage? model
    final headerConfig = homePage?.design?.headerMenu; // <-- HeaderMenuSection?
    final search = homePage?.design?.searchBar?.title;
    final AppPostController appPostController = Get.find<AppPostController>();
    // appPostController.getPostList();

    final profilecontroller = Get.put(ProfileController());

    Widget shimmerCircle(double size) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey.shade300,
        ),
      );
    }

    Widget shimmerLine({double height = 12, double width = 120}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(4),
        ),
      );
    }

    Widget buildSearchBar() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.appTextColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            horizontalTitleGap: 0,
            visualDensity: const VisualDensity(vertical: -2),
            leading: Icon(
              FeatherIcons.search,
              color: AppColors.appTextColor,
              size: 18,
            ),
            title: Text(
              search ?? '',
              style: AppTextStyle.description(color: AppColors.appTextColor),
            ),
            onTap: () {
              Get.to(() => SearchScreen());
            },
          ),
        ),
      );
    }

    List<Map<String, dynamic>> buildMediaItemsFromVideoList(
      List<BannerVidepResult> banners,
    ) {
      return banners.map((banner) {
        // Filter based on media_type
        if (banner.mediaType == 'video' &&
            banner.filePath != null &&
            banner.filePath!.isNotEmpty) {
          return {
            'type': 'video',
            'url': banner.filePath!,
            'redirectUrl': banner.actionUrl,
          };
        } else if (banner.mediaType == 'image' &&
            banner.filePath != null &&
            banner.filePath!.isNotEmpty) {
          return {
            'type': 'image',
            'url': banner.filePath!,
            'redirectUrl': banner.actionUrl,
          };
        }
        // Return empty map if media_type is not recognized
        return {
          'type': 'image',
          'url': banner.filePath ?? '',
          'redirectUrl': banner.actionUrl,
        };
      }).toList();
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: parseColor(headerConfig?.bgColor),
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: screenHeight * 0.072,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.appbarColor),
            padding: EdgeInsets.only(
              top: screenHeight * 0.045,
              left: 10,
              right: 10,
            ),

            child: Obx(() {
              // ============================
              // 🔥 SHIMMER LOADING UI
              // ============================
              if (profilecontroller.isLoading.value) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerCircle(44),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          shimmerLine(width: 150, height: 16),
                          const SizedBox(height: 6),
                          shimmerLine(width: 200, height: 12),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        shimmerCircle(36),
                        const SizedBox(width: 6),
                        shimmerCircle(36),
                      ],
                    ),
                  ],
                );
              }

              // ============================
              // 🔥 MAIN UI
              // ============================
              final dpUrl =
                  profilecontroller
                      .profileDetailsResponeModel
                      .value
                      ?.result
                      ?.dp
                      ?.dp ??
                  "";
              print(headerConfig?.userInfo);
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // PROFILE IMAGE with shimmer
                  GestureDetector(
                    onTap: () => controller.handleRestrictedFeature(() {}),
                    child: headerConfig?.userInfo == true
                        ? ClipOval(
                            child: Image.network(
                              dpUrl,
                              height: 44,
                              width: 44,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return shimmerCircle(
                                      44,
                                    ); // shimmer until loaded
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  AppImage.profile,
                                  height: 44,
                                  width: 44,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          )
                        : SizedBox.shrink(),
                  ),

                  const SizedBox(width: 12),

                  // USER NAME + LOCATION
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        headerConfig?.userInfo == true
                            ? Text(
                                profilecontroller
                                        .profileDetailsResponeModel
                                        .value
                                        ?.result
                                        ?.basicInfo
                                        ?.name ??
                                    "User",
                                style: AppTextStyle.title(
                                  color: AppColors.appTextColor,
                                ),
                                // style: AppTextStyle.kTextStyle.copyWith(
                                //   color: AppColors.appTextColor,
                                //   fontWeight: FontWeight.bold,
                                //   fontSize: 16,
                                // ),
                              )
                            : SizedBox.shrink(),

                        GestureDetector(
                          onTap: () => controller.changeLocation(),
                          child: headerConfig?.currentLocation == true
                              ? Row(
                                  children: [
                                    Icon(
                                      Icons.place_outlined,
                                      color: AppColors.appTextColor,
                                    ),
                                    Obx(
                                      () => SizedBox(
                                        width: screenWidth * 0.45,
                                        child: Marquee(
                                          child: Text(
                                            controller
                                                    .currentLocation
                                                    .value
                                                    .isEmpty
                                                ? 'Fetching location...'
                                                : controller
                                                      .currentLocation
                                                      .value,
                                            style: AppTextStyle.description(
                                              color: AppColors.appTextColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),

                  // RIGHT SIDE ICONS WITH SHIMMER
                  Row(
                    children: [
                      // 🔔 ICON 1
                      GestureDetector(
                        onTap: () {
                          const NotificationsScreen().launch(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.appColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              headerConfig?.headerMenu?[0].icon ?? "",
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return shimmerCircle(25);
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  IconlyLight.notification,
                                  color: AppColors.appTextColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      // ℹ️ ICON 2
                      GestureDetector(
                        onTap: () {
                          const RecentlyView().launch(context);
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppColors.appColor.withValues(alpha: 0.2),
                            ),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              headerConfig?.headerMenu?[1].icon ?? "",
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return shimmerCircle(25);
                                  },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  IconlyLight.infoSquare,
                                  color: AppColors.appTextColor,
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }),
          ),
          bottom: homePage?.design?.searchBar?.isActive == true
              ? PreferredSize(
                  preferredSize: Size.fromHeight(70.0),
                  child: buildSearchBar(),
                )
              : null,
        ),

        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: RefreshIndicator(
            color: AppColors.appButtonColor,
            onRefresh: () async {
              await controller.initializeData();
              await profilecontroller.fetchProfileDetails();
            },
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(gradient: AppColors.appPagecolor),
                child: Obx(() {
                  final homePage = appController.homePage.value;
                  final bodySections = homePage?.design?.body;

                  if (bodySections == null || bodySections.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    children: bodySections.map((section) {
                      final viewType = section.viewType ?? '';
                      final String? rawEndpoint = section.apiEndpoint;

                      // 🔹 Lazy Loading Logic
                      if (viewType == 'category_horizontal_icon_widget' ||
                          viewType == 'custom_category_horizontal_list' ||
                          viewType == 'category_vertical_list_widget') {
                        if (rawEndpoint != null &&
                            rawEndpoint.isNotEmpty &&
                            !controller.isCategoryFetched.value &&
                            !controller.categoryLoading.value) {
                          Future.microtask(
                            () => controller.fetchCategory(rawEndpoint),
                          );
                        }
                      } else if (viewType == 'custom_banner') {
                        if (rawEndpoint != null &&
                            rawEndpoint.isNotEmpty &&
                            !controller.isBannerFetched.value &&
                            !controller.bannerLoading.value) {
                          Future.microtask(
                            () => controller.fetchBanner(rawEndpoint),
                          );
                        }
                      } else if (viewType == 'custom_banner_with_video') {
                        if (rawEndpoint != null &&
                            rawEndpoint.isNotEmpty &&
                            !controller.isVideoBannerFetched.value &&
                            !controller.bannerVideoLoading.value) {
                          Future.microtask(
                            () => controller.fetchBannerForVideo(rawEndpoint),
                          );
                        }
                      } else {
                        if (rawEndpoint != null && rawEndpoint.isNotEmpty) {
                          final sectionController = Get.put(
                            AppPostController(),
                            tag: rawEndpoint,
                          );

                          if (sectionController
                                      .getPostForHomeResponseModel
                                      .value ==
                                  null &&
                              !sectionController.isLoading.value) {
                            // Fetch data immediately for this section
                            print(
                              "🔄 Fetching data for endpoint: $rawEndpoint",
                            );
                            sectionController
                                .getPostListForHomeScreen(endpoint: rawEndpoint)
                                .then((_) {
                                  print(
                                    "✅ Data fetched for $rawEndpoint, result length: ${sectionController.getPostForHomeResponseModel.value?.result?.length}",
                                  );
                                  // Force UI update after data is fetched
                                  sectionController.update();
                                });
                          }
                        }
                      }

                      // 🔹 Search Bar
                      if (viewType == 'search_bar') {
                        return CustomViewWidget(
                          type: 'search_bar',
                          title: section.title,
                          bgColor: section.bgColor,
                          bgImg: section.bgImg,
                        );
                      }

                      // 🔹 Categories
                      if (viewType == 'category_horizontal_icon_widget' ||
                          viewType == 'custom_category_horizontal_list') {
                        Widget titleWidget = const SizedBox.shrink();
                        if (section.label != null &&
                            section.label!.isNotEmpty) {
                          titleWidget = Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  section.label!,
                                  style: AppTextStyle.title(
                                    color: AppColors.appTitleColor,
                                  ),
                                ),
                                const Spacer(),
                                if (section.viewAllLabel != null && section.viewAllLabel!.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      final nextPage = section.viewAllNextPage;

                                      if (nextPage != null && nextPage.isNotEmpty) {
                                        if (nextPage == "search_page") {
                                          Get.to(() => SeachFilterScreen());
                                        }
                                        else if (nextPage == "select_category") {
                                          Get.to(() => ClientAllCategories());
                                        }
                                        else {
                                          debugPrint("⚠️ Unknown next page: $nextPage");
                                        }
                                      }
                                    },
                                    child: Text(
                                      section.viewAllLabel!,
                                      style: AppTextStyle.description(
                                        color: AppColors.appLinkColor,
                                      ),
                                    ),
                                  ),

                              ],
                            ),
                          );
                        }

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            titleWidget,
                            CustomViewWidget(
                              type: 'category_horizontal_icon_widget',
                              categories: controller.categoryList
                                  .map(
                                    (category) => {
                                      'image': category.image ?? '',
                                      'name': category.title ?? '',
                                    },
                                  )
                                  .toList(),
                              categoryLoading: controller.categoryLoading,
                              bgColor: section.bgColor,
                              bgImg: section.bgImg,
                            ),
                          ],
                        );
                      }

                      // 🔹 Banners
                      if (viewType == 'custom_banner') {
                        // Image only banner
                        return Obx(() {
                          if (controller.bannerLoading.value &&
                              controller.bannerList.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          if (controller.bannerList.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return CustomViewWidget(
                            type: 'custom_banner',
                            bannerItems: controller.bannerList
                                .map(
                                  (banner) => {
                                    'image': banner.filePath ?? '',
                                    'redirectUrl': banner.actionUrl ?? '',
                                  },
                                )
                                .toList(),
                            bannerLoading: controller.bannerLoading,
                          );
                        });
                      }

                      if (viewType == 'custom_banner_with_video') {
                        // Video/Image banner
                        return Obx(() {
                          if (controller.bannerVideoLoading.value &&
                              controller.bannerVideoAndImageList.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          if (controller.bannerVideoAndImageList.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return CustomViewWidget(
                            type: 'custom_banner_with_video',
                            bannerItems: buildMediaItemsFromVideoList(
                              controller.bannerVideoAndImageList,
                            ),
                            bannerLoading: controller.bannerVideoLoading,
                          );
                        });
                      }

                      // 🔹 Custom TabBar (Fast Move)
                      if (viewType == 'custom_tapbar') {
                        List<String> options = [];
                        if (section.design is Map) {
                          final inputs = section.design['inputs'];
                          if (inputs is Map && inputs.containsKey('select')) {
                            final select = inputs['select'];
                            if (select['options'] is List) {
                              // Check if it is a list of maps or strings
                              final opts = select['options'] as List;
                              if (opts.isNotEmpty) {
                                if (opts.first is Map) {
                                  options = opts
                                      .map<String>((e) => e['label'].toString())
                                      .toList();
                                } else {
                                  options = opts
                                      .map<String>((e) => e.toString())
                                      .toList();
                                }
                              }
                            }
                          }
                        }

                        if (options.isNotEmpty) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (section.label != null &&
                                  section.label!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0,
                                    vertical: 8,
                                  ),
                                  child: Text(
                                    section.label!,
                                    style: AppTextStyle.title(
                                      color: AppColors.appTitleColor,
                                    ),
                                  ),
                                ),
                              CustomViewWidget(
                                type: 'custom_tapbar',
                                tabOptions: options,
                                onTabChanged: (index) {
                                  print("Tab selected: $index");
                                },
                              ),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }

                      // 🔹 Pre-defined Post Lists (Lists, Grids)

                      if (viewType == 'custom_vertical_listview_list' ||
                          viewType == 'custom_horizontal_listview_list' ||
                          viewType == 'custom_vertical_gridview_list' ||
                          viewType == 'custom_horizontal_gridview_list') {
                        Widget titleWidget = const SizedBox.shrink();
                        if (section.label != null &&
                            section.label!.isNotEmpty) {
                          titleWidget = Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15.0,
                              vertical: 10,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  section.label!,
                                  style: AppTextStyle.title(
                                    color: AppColors.appTitleColor,
                                  ),
                                ),
                                const Spacer(),
                                if (section.viewAllLabel != null && section.viewAllLabel!.isNotEmpty)
                                  GestureDetector(
                                    onTap: () {
                                      final nextPage = section.viewAllNextPage;

                                      if (nextPage != null && nextPage.isNotEmpty) {
                                        if (nextPage == "search_page") {
                                          Get.to(() => SeachFilterScreen());
                                        }
                                        else if (nextPage == "select_category") {
                                          Get.to(() => ClientAllCategories());
                                        }
                                        else {
                                          debugPrint("⚠️ Unknown next page: $nextPage");
                                        }
                                      }
                                    },
                                    child: Text(
                                      section.viewAllLabel!,
                                      style: AppTextStyle.description(
                                        color: AppColors.appLinkColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }

                        // 🔹 Create unique controller for this section if it has an endpoint
                        AppPostController? sectionController;
                        if (section.apiEndpoint != null &&
                            section.apiEndpoint!.isNotEmpty) {
                          // Use apiEndpoint as tag to ensure uniqueness per content source
                          final tag = section.apiEndpoint!;
                          if (!Get.isRegistered<AppPostController>(tag: tag)) {
                            sectionController = Get.put(
                              AppPostController(),
                              tag: tag,
                            );
                          } else {
                            sectionController = Get.find<AppPostController>(
                              tag: tag,
                            );
                          }
                        }

                        return Obx(() {
                          // Watch for data changes in the section controller
                          final controllerToWatch =
                              sectionController ?? appPostController;
                          
                          // Access the data to make Obx reactive
                          final isLoading = controllerToWatch.isLoading.value;
                          final model = sectionController != null
                              ? controllerToWatch.getPostForHomeResponseModel.value
                              : controllerToWatch.getPostListResponseModel.value;

                          // 🛑 User Request: If loading, show UI (shimmer). If NOT loading and empty, hide UI.
                          if (!isLoading && (model?.result == null || (model?.result?.isEmpty ?? true))) {
                            return const SizedBox.shrink();
                          }

                          return Column(
                            children: [
                              titleWidget,
                              CustomViewWidget(
                                type: viewType,
                                controller: controllerToWatch,
                                useHomeModel: sectionController != null,
                                onItemTap: () {
                                  // Detail navigation
                                },
                                onFavoriteToggle: (index, isFav) {
                                  // Favorite logic
                                },
                                bgColor: section.bgColor,
                                bgImg: section.bgImg,
                              ),
                            ],
                          );
                        });
                      }

                      // 🔹 Default fallback for unknown types - Try to render generically or simply pass the type
                      // This allows future view_types to be potentially handled by CustomViewWidget if updated, without changing this file
                      return CustomViewWidget(
                        type: viewType,
                        // Pass common props just in case
                        title: section.title,
                        // we can pass more generic props if CustomViewWidget supports them
                        bgColor: section.bgColor,
                        bgImg: section.bgImg,
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Gradient? parseGradient(String? input) {
    if (input == null) return null;
    if (!input.startsWith("linear-gradient")) return null;

    try {
      final cleaned = input
          .replaceAll("linear-gradient(", "")
          .replaceAll(")", "");

      final parts = cleaned.split(",");

      final direction = parts.first.trim();
      final colors = parts.sublist(1).map((e) => e.trim()).toList();

      return LinearGradient(
        begin: direction.contains("right")
            ? Alignment.centerLeft
            : Alignment.topCenter,
        end: direction.contains("right")
            ? Alignment.centerRight
            : Alignment.bottomCenter,
        colors: colors
            .map((hex) => Color(int.parse("0xFF${hex.replaceAll('#', '')}")))
            .toList(),
      );
    } catch (e) {
      return null;
    }
  }

  Color? parseColor(String? hex) {
    if (hex == null) return null;
    if (hex.startsWith("#")) {
      return Color(int.parse("0xFF${hex.replaceAll('#', '')}"));
    }
    return null;
  }

  IconData getHeaderIcon(String? icon) {
    switch (icon) {
      case "notification":
        return IconlyLight.notification;
      case "info":
        return IconlyLight.infoSquare;
      case "settings":
        return IconlyLight.setting;
      default:
        return Icons.help_outline;
    }
  }
}
