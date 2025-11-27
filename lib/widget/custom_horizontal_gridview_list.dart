import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/app_color.dart';
import '../../models/static models/service_items_model.dart';
import '../core/app_textstyle.dart';

class CustomHorizontalGridViewList extends StatelessWidget {
  final List<ServiceItem> items;
  final RxBool isLoading;
  final VoidCallback? onItemTap;

  const CustomHorizontalGridViewList({
    super.key,
    required this.items,
    required this.isLoading,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => isLoading.value
          ? _buildShimmerList()
          : SizedBox(
        height: 270.h, // Responsive height
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.only(
            top: 20.h,
            bottom: 20.h,
            left: 15.w,
            right: 15.w,
          ),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => SizedBox(width: 10.w),
          itemBuilder: (_, i) => _buildItemCard(context, items[i]),
        ),
      ),
    );
  }

  // Shimmer effect for the list
  Widget _buildShimmerList() {
    return SizedBox(
      height: 270.h,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.only(
          top: 20.h,
          bottom: 20.h,
          left: 15.w,
          right: 15.w,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer placeholders
        separatorBuilder: (_, __) => SizedBox(width: 10.w),
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
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: Container(
        height: 220.h,
        width: 156.w,
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.kBorderColorTextField),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkWhite,
              blurRadius: 5.r,
              spreadRadius: 2.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image section shimmer
            Container(
              height: 135.h,
              width: 156.w,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  topLeft: Radius.circular(8.r),
                ),
              ),
            ),
            // Content section shimmer
            Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Seller name shimmer
                  Container(
                    width: 100.w,
                    height: 16.sp,
                    color: Colors.white,
                  ),
                  SizedBox(height: 6.h),
                  // Rating shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80.w,
                        height: 14.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  // Seller level shimmer
                  Container(
                    width: 80.w,
                    height: 14.sp,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Actual item card
  Widget _buildItemCard(BuildContext context, ServiceItem item) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.h),
      child: GestureDetector(
        onTap: onItemTap,
        child: Container(
          height: 220.h,
          width: 156.w,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,
            border: Border.all(color: AppColors.appDescriptionColor,width: 1),
            borderRadius: BorderRadius.circular(8.r),

          ),
          child: Column(
            children: [
              Container(
                height: 135.h,
                width: 156.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8.r),
                    topLeft: Radius.circular(8.r),
                  ),
                  image: DecorationImage(
                    image: AssetImage(item.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.sellerName,
                      style: AppTextStyle.title(
                        color: AppColors.appTitleColor,
                        fontWeight: FontWeight.bold,

                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          IconlyBold.star,
                          color: Colors.amber,
                          size: 18.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: AppTextStyle.body(
                            color: AppColors.appTitleColor,

                          ),
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '(${item.reviewCount} review)',
                          style: AppTextStyle.body(
                            color: AppColors.appDescriptionColor,

                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    RichText(
                      text: TextSpan(
                        text: 'Seller Level - ',
                        style: AppTextStyle.body(
                          color: AppColors.appTitleColor,

                        ),
                        children: [
                          TextSpan(
                            text: item.sellerLevel,
                            style: AppTextStyle.body(
                              color: AppColors.appDescriptionColor,

                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}