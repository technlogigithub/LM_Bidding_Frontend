import 'package:flutter/material.dart';
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
        height: 170,
        child: ListView.separated(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(
              top: 20, bottom: 20, left: 15.0, right: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10.0),
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
      height: 160,
      child: ListView.separated(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 20, bottom: 20, left: 15.0, right: 15.0),
        scrollDirection: Axis.horizontal,
        itemCount: 3, // Number of shimmer placeholders
        separatorBuilder: (_, __) => const SizedBox(width: 10.0),
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
      width: 330,
      height: 120,
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
            height: 120,
            width: 120,
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
                    width: 150,
                    height: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 5.0),
                  // Rating and price shimmer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 40),
                      Container(
                        width: 60,
                        height: 14,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  // Seller info shimmer
                  Row(
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 100,
                            height: 14,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 2.0),
                          Container(
                            width: 60,
                            height: 12,
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
      child: Container(
        width: 330,
        height: 150,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
          border: Border.all(color: AppColors.appDescriptionColor,width: 1),
          // boxShadow: [
          //   BoxShadow(
          //     color: AppColors.appDescriptionColor,
          //     spreadRadius: 2,
          //     blurRadius: 6,
          //     offset: Offset(0, 3),
          //   ),
          // ],
          borderRadius: BorderRadius.circular(8.0),

        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildImageSection(item, index),
            _buildContentSection(item),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ServiceItem item, int index) {
    return Stack(
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: 127,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(8.0),
              topLeft: Radius.circular(8.0),
            ),
            image: DecorationImage(
              image: AssetImage(item.imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Obx(() => GestureDetector(
          onTap: () => onFavoriteToggle(index, !item.isFavorite.value),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
              height: 25,
              width: 25,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10.0,
                    spreadRadius: 1.0,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  item.isFavorite.value ? Icons.favorite : Icons.favorite_border,
                  color: item.isFavorite.value ? Colors.red : AppColors.appIconColor,
                  size: 16.0,
                ),
              ),
            ),
          ),
        )),
      ],
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
              width: 190,
              height: 60,
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
              const SizedBox(width: 2.0),
              Text(
                item.rating.toStringAsFixed(1),
                style: AppTextStyle.body(
                  color: AppColors.appDescriptionColor,
                ),
              ),
              const SizedBox(width: 2.0),
              Text(
                '(${item.reviewCount})',
                style: AppTextStyle.body(
                  color: AppColors.appDescriptionColor,
                ),
              ),
              const SizedBox(width: 40),


              Text("₹${item.price.toStringAsFixed(0)}", style: AppTextStyle.description(
                color: AppColors.appTitleColor,
              ))

            ],
          ),
          const SizedBox(height: 5.0),
          Row(
            children: [
              Container(
                height: 32,
                width: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage(item.profileImagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 5.0),
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