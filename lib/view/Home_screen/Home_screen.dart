import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_images.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:libdding/view/Home_screen/recently_view.dart';
import 'package:libdding/widget/custom_vertical_listview_list.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/home/home_controller.dart';
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
import '../../widget/form_widgets/custom_banner_with_video.dart';
import '../cart_screen/cart_screen.dart';
import 'client_all_categories.dart' hide AppColors;

class ClientHomeScreen extends StatelessWidget {
  ClientHomeScreen({super.key});

  final ClientHomeController controller = Get.put(ClientHomeController());

  @override
  Widget build(BuildContext context) {


    Widget buildSearchBar() {
      return Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          decoration: BoxDecoration(color: AppColors.appTextColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10.0)),
          child: ListTile(
            horizontalTitleGap: 0,
            visualDensity: const VisualDensity(vertical: -2),
            leading: Icon(FeatherIcons.search, color: AppColors.appWhite),
            title: Text('Search services...', style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor)),
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
        backgroundColor: AppColors.appWhite,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: screenHeight * 0.072,
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: AppColors.appbarColor),
            padding: EdgeInsets.only(top: screenHeight * 0.045, left: 10, right: 10),
            child: Obx(
              () => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => controller.handleRestrictedFeature(() {}),
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: AssetImage(AppImage.profile), fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.isLoggedIn.value ? 'Shaidulislam' : AppStrings.guest,
                          style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        GestureDetector(
                          onTap: () => controller.changeLocation(),
                          child: Row(
                            children: [
                              Icon(Icons.place_outlined,color: AppColors.appTextColor,),
                              Obx(() => SizedBox(
                                width: screenWidth * 0.45,
                                child: Marquee(
                                  child: Text(
                                    controller.currentLocation.value.isEmpty
                                        ? 'Fetching location...'
                                        : controller.currentLocation.value,
                                    style: AppTextStyle.kTextStyle.copyWith(
                                      color: AppColors.appTextColor,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              )),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.handleRestrictedFeature(() {
                          // Get.toNamed('/notifications');
                        }),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.appColor.withValues(alpha: 0.2)),
                          ),
                          child: Icon(IconlyLight.notification, color: AppColors.appTextColor),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          // Get.toNamed('/recent-posts'); // Replace with actual recent posts route
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.appColor.withValues(alpha: 0.2)),
                          ),
                          child: Icon(IconlyLight.infoSquare, color: AppColors.appTextColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          bottom: PreferredSize(preferredSize: Size.fromHeight(70.0), child: buildSearchBar()),
        ),
        body: Container(
          height: screenHeight,
          width: screenWidth,
          decoration: BoxDecoration(gradient: AppColors.appPagecolor),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(top: 15.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() => CustomBanner(
                    banners: controller.bannerList.map((banner) => {'image': banner.image ?? '', 'redirectUrl': banner.redirectUrl ?? ''}).toList(),
                    isLoading: controller.isLoading,
                    width: screenWidth,
                  ),),
                  CustomBannerWithVideo(mediaItems: controller.staticMediaItems,),
                  const SizedBox(height: 25.0),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.categories,
                          style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () => const ClientAllCategories().launch(context),
                          // onTap: () => controller.handleRestrictedFeature(() {
                          //   Get.toNamed('/categories'); // Replace with actual categories route
                          // }),
                          child: Text(AppStrings.viewAll, style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Obx(() => CustomCategoryHorizontalList(
                    categories: controller.categoryList
                        .map((category) => {
                      'image': category.image ?? '',
                      'name': category.name ?? '',
                    })
                        .toList(),
                    isLoading: controller.isLoading,
                  )),

                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: Row(
                      children: [
                        Text(
                          AppStrings.upcomingPost,
                          style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor, fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () {
                            // const PopularServices().launch(context);
                          },
                          child: Text(AppStrings.viewAll, style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor)),
                        ),
                      ],
                    ),
                  ),
                  CustomHorizontalListViewList(items: controller.services, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading,),
                  Padding(
                    padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          'Top Poster',
                          style: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => controller.handleRestrictedFeature(() {
                            // const TopSeller().launch(context);
                          }),
                          child: Text(
                            'View All',
                            style:
                            kTextStyle.copyWith(color: kLightNeutralColor),
                          ),
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
                    padding:
                    const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: Row(
                      children: [
                        Text(
                          'Recent Viewed',
                          style: kTextStyle.copyWith(
                              color: kNeutralColor,
                              fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => controller.handleRestrictedFeature(() {
                            const RecentlyView().launch(context);
                          }),
                          child: Text(
                            'View All',
                            style:
                            kTextStyle.copyWith(color: kLightNeutralColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CustomHorizontalListViewList(items: controller.recentViewedList, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading,),
                  SizedBox(height: screenHeight*0.03,),
                  CustomTabBar(
                    height: 50,
                    tabs: controller.serviceList,
                    primaryColor: AppColors.appColor    ,
                    borderColor: Colors.grey.shade300,
                    textStyle: const TextStyle(fontSize: 14),
                    onTap: (index) {
                      // do something when tapped
                      print("Selected tab index: $index");
                    },
                  ),
                  SizedBox(height: screenHeight*0.03,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomVerticalGridviewList(services: controller.services),
                  ),
                  SizedBox(height: screenHeight*0.03,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomVerticalListviewList(items: controller.recentViewedList, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading,),
                  ),
                  SizedBox(height: screenHeight*0.03,),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomButton(
                        onTap: (){
                          controller.initiatePayment();
                    }, text: 'Pay 1000/- Rs. Now'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15.0, top: 10),
                    child: CustomButton(
                        onTap: (){
                      Get.to(CartScreen());
                    }, text: 'Go To Cart Screen'),
                  ),
                  SizedBox(height: screenHeight*0.03,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
