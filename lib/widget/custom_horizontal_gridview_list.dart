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
  final double? height;

    const CustomHorizontalGridViewList({
    super.key,
    required this.items,
    required this.isLoading,
    this.onItemTap,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => isLoading.value
          ? _buildShimmerList()
          : _buildFlexibleListView(context),
    );
  }

  Widget _buildFlexibleListView(BuildContext context) {
    // Calculate default height: image (135.h) + content min (100.h) + padding (40.h) + extra space (20.h)
    final defaultHeight = 135.h + 100.h + 40.h + 20.h;
    final listViewHeight = height ?? defaultHeight;

    return SizedBox(
      height: listViewHeight,
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
    );
  }

  // Shimmer effect for the list
  Widget _buildShimmerList() {
    // Calculate default height: image (135.h) + content min (100.h) + padding (40.h) + extra space (20.h)
    final defaultHeight = 135.h + 100.h + 40.h + 20.h;
    final listViewHeight = height ?? defaultHeight;

    return SizedBox(
      height: listViewHeight,
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Image section shimmer
          Container(
            height: 135.h,
            width: 156.w,
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8.r),
                topLeft: Radius.circular(8.r),
              ),
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
          ),
          // Content section shimmer
          Container(
            width: 156.w,
            constraints: BoxConstraints(
              minHeight: 100.h,
            ),
            decoration: BoxDecoration(
              color: AppColors.appWhite,
              border: Border(
                left: BorderSide(color: AppColors.kBorderColorTextField, width: 1),
                right: BorderSide(color: AppColors.kBorderColorTextField, width: 1),
                bottom: BorderSide(color: AppColors.kBorderColorTextField, width: 1),
              ),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8.r),
                bottomLeft: Radius.circular(8.r),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.darkWhite,
                  blurRadius: 5.r,
                  spreadRadius: 2.r,
                  offset: Offset(0, 5.h),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.all(6.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
          ),
        ],
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
          width: 156.w,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor,

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


            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- IMAGE ---
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  topRight: Radius.circular(8.r),
                ),
                child: Image.asset(
                  item.imagePath,
                  height: 135.h,
                  width: 156.w,
                  fit: BoxFit.cover,
                ),
              ),

              // --- DETAILS ---
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
                      children: [
                        Icon(IconlyBold.star, color: Colors.amber, size: 18.sp),
                        SizedBox(width: 3.w),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: AppTextStyle.body(
                            color: AppColors.appTitleColor,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            '(${item.reviewCount} review)',
                            style: AppTextStyle.body(
                              color: AppColors.appDescriptionColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 6.h),

                    RichText(
                      text: TextSpan(
                        text: "Seller Level - ",
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