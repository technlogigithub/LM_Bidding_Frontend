import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_color.dart';
import '../core/app_textstyle.dart';
import '../models/static models/service_items_model.dart';
import 'custom_detail_screen.dart';

class CustomHorizontalListViewList extends StatelessWidget {
  final List<ServiceItem> items;
  final VoidCallback? onItemTap;
  final Function(int, bool) onFavoriteToggle;
  final RxBool isLoading; // Added for loading state

  const CustomHorizontalListViewList({
    super.key,
    required this.items,
    this.onItemTap,
    required this.onFavoriteToggle,
    required this.isLoading, // Required for shimmer
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => isLoading.value
          ? _buildShimmerList()
          : SizedBox(
        height: 170.h,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
              top: 20, bottom: 20, left: 15.0, right: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(width: 10.0.w),
          itemBuilder: (_, index) {
            final item = items[index];
            return _buildItemCard(context, item, index);
          },
        ),
      ),
    );
  }

  // Shimmer effect for the list
  Widget _buildShimmerList() {
    return SizedBox(
      height: 160.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer placeholders
        separatorBuilder: (_, __) => SizedBox(width: 10.0.w),
        itemBuilder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: _buildShimmerItemCard(),
        ),
      ),
    );
  }

  // Shimmer placeholder for a single card
  Widget _buildShimmerItemCard() {
    return Container(
      width: 330.w,
      height: 120.h,
      decoration: BoxDecoration(
        color: AppColors.appWhite,
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: AppColors.kBorderColorTextField),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section shimmer
          Container(
            height: 120.h,
            width: 120.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              ),
            ),
          ),
          // Content section shimmer
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title shimmer
                  Container(
                    width: 150.w,
                    height: 16.h,
                    color: Colors.white,
                  ),
                  SizedBox(height: 5.0.h),
                  // Rating and price shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 40),
                      Container(
                        width: 60.w,
                        height: 14.h,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0.h),
                  // Seller info shimmer
                  Row(
                    children: [
                      Container(
                        height: 32.h,
                        width: 32.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 5.0.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100.w,
                            height: 14.h,
                            color: Colors.white,
                          ),
                          SizedBox(height: 2.0.h),
                          Container(
                            width: 60.w,
                            height: 12.h,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(BuildContext context, ServiceItem item, int index) {
    return GestureDetector(
      onTap: onItemTap ?? () =>
      Get.to(() => CustomDetailScreen(title: '',
        rating: 4.5, reviewCount: 20, favoriteCount: 50, sellerName: '', sellerLevel: '',
        profileImagePath: '', description: '', status: '', mediaUrls: [], htmlContent: '',pricingPlans: [], recentViewedList: [], reviews: [],)),
      // onTap: onItemTap ?? () => Get.to(() => const ClientServiceDetails()),
      child: Row(
        children: [
          Container(
            width: 120.w,
            height: 150.h,
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              image: DecorationImage(
                image: AssetImage(item.imagePath),
                fit: BoxFit.cover,
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8.0),
                topLeft: Radius.circular(8.0),
              ),

            ),

          ),
          Container(
            width: 210.w,
            height: 150.h,
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(8.0),
                topRight: Radius.circular(8.0),
              ),
              border: Border(
                top: BorderSide(color: AppColors.appDescriptionColor, width: 1),
                right: BorderSide(color: AppColors.appDescriptionColor, width: 1),
                bottom: BorderSide(color: AppColors.appDescriptionColor, width: 1),
              ),
            ),
            child: _buildContentSection(item),
          ),
        ],
      ),
    );
  }


  Widget _buildContentSection(ServiceItem item) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: SizedBox(
              width: 190.w,
              height: 60.h,
              child: Text(
                item.title,
                style: AppTextStyle.description(
                  color: AppColors.appTitleColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18.0),
              SizedBox(width: 2.0.w),
              Text(
                item.rating.toStringAsFixed(1),
                style: AppTextStyle.body(
                  color: AppColors.appDescriptionColor,
                ),
              ),
              SizedBox(width: 2.0.w),
              Text(
                '(${item.reviewCount})',
                style: AppTextStyle.body(
                  color: AppColors.appDescriptionColor,
                ),
              ),
              SizedBox(width: 40.w),
              Text("₹${item.price.toStringAsFixed(0)}", style: AppTextStyle.description(
                color: AppColors.appTitleColor,
              ))

            ],
          ),
          SizedBox(height: 5.0.h),
          Row(
            children: [
              Container(
                height: 32.h,
                width: 32.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(item.profileImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 5.0.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.sellerName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.body(
                      color: AppColors.appTitleColor,
                      fontWeight: FontWeight.bold,

                    ),
                  ),
                  Text(
                    item.sellerLevel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.body(
                      color: AppColors.appDescriptionColor,

                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}