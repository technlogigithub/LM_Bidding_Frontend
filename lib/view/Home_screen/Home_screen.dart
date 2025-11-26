import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
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
import '../../controller/profile/profile_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../models/static models/service_items_model.dart';
import '../../widget/appSearchDelegate.dart';
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

class ClientHomeScreen extends StatelessWidget {
  ClientHomeScreen({super.key});

  final ClientHomeController controller = Get.put(ClientHomeController());
  final AppSettingsController appcontroller = Get.put(AppSettingsController());

  @override
  Widget build(BuildContext context) {
    final ClientHomeController controller = Get.put(ClientHomeController());
    final AppSettingsController appController = Get.put(AppSettingsController());
    final homePage = appController.homePage.value; // <-- HomePage? model
    final headerConfig = homePage?.design?.headerMenu; // <-- HeaderMenuSection?

    final profilecontroller = Get.put(ProfileController());

    Widget shimmerCircle(double size) {
      return Container(
        height: size,
        width: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.grey.shade300),
      );
    }

    Widget shimmerLine({double height = 12, double width = 120}) {
      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(4)),
      );
    }

    Widget buildSearchBar() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(color: AppColors.appTextColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.0)),
          child: ListTile(
            horizontalTitleGap: 0,
            visualDensity: const VisualDensity(vertical: -2),
            leading: Icon(FeatherIcons.search, color: AppColors.appTextColor,size: 18,),
            title: Text(' Search...', style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor)),
            onTap: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          ),
        ),
      );
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
            padding: EdgeInsets.only(top: screenHeight * 0.045, left: 10, right: 10),

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
              final dpUrl = profilecontroller.profileDetailsResponeModel.value
                  ?.result?.dp?.dp ??
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
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return shimmerCircle(44); // shimmer until loaded
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
                          profilecontroller.profileDetailsResponeModel.value
                              ?.result?.basicInfo?.name ??
                              "",
                          style: AppTextStyle.kTextStyle.copyWith(
                            color: AppColors.appTextColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        )
                            : SizedBox.shrink(),

                        GestureDetector(
                          onTap: () => controller.changeLocation(),
                          child: headerConfig?.currentLocation == true
                              ? Row(
                            children: [
                              Icon(Icons.place_outlined,
                                  color: AppColors.appTextColor),
                              Obx(
                                    () => SizedBox(
                                  width: screenWidth * 0.45,
                                  child: Marquee(
                                    child: Text(
                                      controller.currentLocation.value.isEmpty
                                          ? 'Fetching location...'
                                          : controller.currentLocation.value,
                                      style: AppTextStyle.kTextStyle.copyWith(
                                          color: AppColors.appTextColor,
                                          fontSize: 12),
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
                                color: AppColors.appColor.withValues(alpha: 0.2)),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              headerConfig?.headerMenu?[0].icon ?? "",
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return shimmerCircle(25);
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(IconlyLight.notification,
                                    color: AppColors.appTextColor);
                              },
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 6),

                      // ℹ️ ICON 2
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: AppColors.appColor.withValues(alpha: 0.2)),
                          ),
                          child: ClipOval(
                            child: Image.network(
                              headerConfig?.headerMenu?[1].icon ?? "",
                              height: 25,
                              width: 25,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return shimmerCircle(25);
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(IconlyLight.infoSquare,
                                    color: AppColors.appTextColor);
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
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(70.0),
            child: buildSearchBar(),
          ),
        ),


        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            // padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
                // borderRadius: const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(
                    () => CustomBanner(
                      banners: controller.bannerList.map((banner) => {'image': banner.image ?? '', 'redirectUrl': banner.redirectUrl ?? ''}).toList(),
                      isLoading: controller.isLoading,
                      width: screenWidth,
                    ),
                  ),
                  CustomBannerWithVideo(mediaItems: controller.staticMediaItems),
                  const SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.categories,
                          style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => const ClientAllCategories().launch(context),
                          // onTap: () => controller.handleRestrictedFeature(() {
                          //   Get.toNamed('/categories'); // Replace with actual categories route
                          // }),
                          child: Text(AppStrings.viewAll, style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appLinkColor)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(
                    () => CustomCategoryHorizontalList(
                      categories: controller.categoryList.map((category) => {'image': category.image ?? '', 'name': category.name ?? ''}).toList(),
                      isLoading: controller.isLoading,
                    ),
                  ),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: Row(
                      children: [
                        Text(
                          AppStrings.upcomingPost,
                          style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // const PopularServices().launch(context);
                          },
                          child: Text(AppStrings.viewAll, style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appLinkColor)),
                        ),
                      ],
                    ),
                  ),
                  CustomHorizontalListViewList(items: controller.services, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          'Top Poster',
                          style: kTextStyle.copyWith(color: AppColors.appTitleColor, fontWeight: FontWeight.bold,),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => controller.handleRestrictedFeature(() {
                            // const TopSeller().launch(context);
                          }),
                          child: Text('View All', style: kTextStyle.copyWith(color: AppColors.appLinkColor)),
                        ),
                      ],
                    ),
                  ),
                  CustomHorizontalGridViewList(
                    items: [
                      ServiceItem(
                        imagePath: 'assets/images/dev1.png',
                        title: 'Mobile UI/UX Design',
                        rating: 5.0,
                        reviewCount: 520,
                        price: 30,
                        profileImagePath: 'assets/images/profilepic2.png',
                        sellerName: 'William Liam',
                        sellerLevel: '2',
                        isFavorite: false,
                      ),
                      ServiceItem(
                        imagePath: 'assets/images/dev1.png',
                        title: 'Mobile UI/UX Design',
                        rating: 5.0,
                        reviewCount: 520,
                        price: 30,
                        profileImagePath: 'assets/images/profilepic2.png',
                        sellerName: 'William Liam',
                        sellerLevel: '2',
                        isFavorite: false,
                      ),
                      ServiceItem(
                        imagePath: 'assets/images/dev1.png',
                        title: 'Mobile UI/UX Design',
                        rating: 5.0,
                        reviewCount: 520,
                        price: 30,
                        profileImagePath: 'assets/images/profilepic2.png',
                        sellerName: 'William Liam',
                        sellerLevel: '2',
                        isFavorite: false,
                      ),
                      ServiceItem(
                        imagePath: 'assets/images/dev1.png',
                        title: 'Mobile UI/UX Design',
                        rating: 5.0,
                        reviewCount: 520,
                        price: 30,
                        profileImagePath: 'assets/images/profilepic2.png',
                        sellerName: 'William Liam',
                        sellerLevel: '2',
                        isFavorite: false,
                      ),
                      ServiceItem(
                        imagePath: 'assets/images/dev1.png',
                        title: 'Mobile UI/UX Design',
                        rating: 5.0,
                        reviewCount: 520,
                        price: 30,
                        profileImagePath: 'assets/images/profilepic2.png',
                        sellerName: 'William Liam',
                        sellerLevel: '2',
                        isFavorite: false,
                      ),
                      ServiceItem(
                        imagePath: 'assets/images/dev1.png',
                        title: 'Mobile UI/UX Design',
                        rating: 5.0,
                        reviewCount: 520,
                        price: 30,
                        profileImagePath: 'assets/images/profilepic2.png',
                        sellerName: 'William Liam',
                        sellerLevel: '2',
                        isFavorite: false,
                      ),
                    ],
                    isLoading: controller.isLoading,
                    onItemTap: () => controller.handleRestrictedFeature(() {
                      // Navigation logic
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          'Recent Viewed',
                          style: kTextStyle.copyWith(color: AppColors.appTitleColor, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => controller.handleRestrictedFeature(() {
                            const RecentlyView().launch(context);
                          }),
                          child: Text('View All', style: kTextStyle.copyWith(color: AppColors.appLinkColor)),
                        ),
                      ],
                    ),
                  ),
                  CustomHorizontalListViewList(items: controller.recentViewedList, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading),
                  SizedBox(height: screenHeight * 0.03),
                  CustomTabBar(
                    height: 50,
                    tabs: controller.serviceList,
                    // primaryColor: AppColors.appColor,
                    // borderColor: Colors.grey.shade300,
                    textStyle: const TextStyle(fontSize: 14),
                    onTap: (index) {
                      // do something when tapped
                      print("Selected tab index: $index");
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomVerticalGridviewList(services: controller.services),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomVerticalListviewList(items: controller.recentViewedList, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomButton(
                      onTap: () {
                        controller.initiatePayment();
                      },
                      text: 'Pay 1000/- Rs. Now',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomButton(
                      onTap: () {
                        Get.to(CartScreen());
                      },
                      text: 'Go To Cart Screen',
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                ],
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
      final cleaned = input.replaceAll("linear-gradient(", "").replaceAll(")", "");

      final parts = cleaned.split(",");

      final direction = parts.first.trim();
      final colors = parts.sublist(1).map((e) => e.trim()).toList();

      return LinearGradient(
        begin: direction.contains("right") ? Alignment.centerLeft : Alignment.topCenter,
        end: direction.contains("right") ? Alignment.centerRight : Alignment.bottomCenter,
        colors: colors.map((hex) => Color(int.parse("0xFF${hex.replaceAll('#', '')}"))).toList(),
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
