import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:libdding/core/app_string.dart';
import 'package:shimmer/shimmer.dart';
import '../core/app_color.dart';
import '../core/app_constant.dart' as AppTextStyle;
import '../models/static models/service_items_model.dart';
import 'custom_detail_screen.dart';

class CustomVerticalListviewList extends StatelessWidget {
  final List<ServiceItem> items;
  final VoidCallback? onItemTap;
  final VoidCallback? onRemoveTap;
  final VoidCallback? onSaveForLaterTap;
  final VoidCallback? onBuyNowTap;
  final Function(int, bool) onFavoriteToggle;
  final RxBool isLoading;
  final bool isFromCartScreen;

  const CustomVerticalListviewList({
    super.key,
    required this.items,
    this.onItemTap,
    this.onRemoveTap,
    this.onSaveForLaterTap,
    this.onBuyNowTap,
    required this.onFavoriteToggle,
    required this.isLoading,
    this.isFromCartScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => isLoading.value
          ? _buildShimmerList()
          : SizedBox(
        height: items.length * 182.h,
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(
              bottom: 20, left: 0.0, right: 0.0),
          scrollDirection: Axis.vertical,
          itemCount: items.length,
          separatorBuilder: (_, __) => const SizedBox(width: 10.0),
          itemBuilder: (_, index) {
            final item = items[index];
            return Padding(
                padding: EdgeInsetsGeometry.only(top: 10),
            child: _buildItemCard(context, item, index),);
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
        scrollDirection: Axis.vertical,
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
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onItemTap ?? () => _openCustomDetailScreen(context, item),
      child: Container(
        width: 330,
        height: isFromCartScreen ? 165 : 125,
        decoration: BoxDecoration(
          color: AppColors.appWhite,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.kBorderColorTextField),
          boxShadow: [
            BoxShadow(
              color: AppColors.darkWhite,
              blurRadius: 5.0,
              spreadRadius: 2.0,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildImageSection(item, index),
                _buildContentSection(item),
              ],
            ),
            if (isFromCartScreen)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                   InkWell(
                     onTap: onRemoveTap ?? () {},
                     child: Container(
                       padding: EdgeInsetsGeometry.all(8),
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(10.r),
                         border: BoxBorder.all(color: AppColors.kBorderColorTextField)
                       ),
                       child: Text(AppStrings.remove, style: TextStyle(
                         color: AppColors.appButtonTextColor,
                         fontSize: screenWidth * 0.04,
                         fontWeight: FontWeight.bold,
                       ),),
                     ),
                   ),
                    InkWell(
                      onTap: onSaveForLaterTap ?? () {},
                      child: Container(
                        padding: EdgeInsetsGeometry.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: BoxBorder.all(color: AppColors.kBorderColorTextField)
                        ),
                        child: Text(AppStrings.saveForLater, style: TextStyle(
                          color: AppColors.appButtonTextColor,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                    InkWell(
                      onTap: onBuyNowTap ?? () {},
                      child: Container(
                        padding: EdgeInsetsGeometry.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.r),
                            border: BoxBorder.all(color: AppColors.kBorderColorTextField)
                        ),
                        child: Text(AppStrings.buyThisNow, style: TextStyle(
                          color: AppColors.appButtonTextColor,
                          fontSize: screenWidth * 0.04,
                          fontWeight: FontWeight.bold,
                        ),),
                      ),
                    ),
                  ],
                ),
              )
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
          height: 120,
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
                  color: item.isFavorite.value ? Colors.red : AppColors.neutralColor,
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
              child: Text(
                item.title,
                style: AppTextStyle.kTextStyle.copyWith(
                  color: AppColors.appTextColor,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const SizedBox(height: 5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 18.0),
              const SizedBox(width: 2.0),
              Text(
                item.rating.toStringAsFixed(1),
                style: AppTextStyle.kTextStyle.copyWith(
                  color: AppColors.neutralColor,
                ),
              ),
              const SizedBox(width: 2.0),
              Text(
                '(${item.reviewCount})',
                style: AppTextStyle.kTextStyle.copyWith(
                  color: AppColors.textgrey,
                ),
              ),
              const SizedBox(width: 40),
              RichText(
                text: TextSpan(
                  text: 'Price: ',
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.textgrey,
                  ),
                  children: [
                    TextSpan(
                      text: '₹${item.price.toStringAsFixed(0)}',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.appColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
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
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.neutralColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item.sellerLevel,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.subTitleColor,
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

  void _openCustomDetailScreen(BuildContext context, ServiceItem item) {
    // Static data for testing - you can replace these with real data from API
    final staticData = _getStaticDetailData(item);

    Get.to(() => CustomDetailScreen(
      title: staticData['title'],
      rating: staticData['rating'],
      reviewCount: staticData['reviewCount'],
      favoriteCount: staticData['favoriteCount'],
      sellerName: staticData['sellerName'],
      sellerLevel: staticData['sellerLevel'],
      profileImagePath: staticData['profileImagePath'],
      description: staticData['description'],
      status: staticData['status'],
      mediaUrls: staticData['mediaUrls'],
      htmlContent: staticData['htmlContent'],
      pricingPlans: staticData['pricingPlans'],
      recentViewedList: staticData['recentViewedList'],
      reviews: staticData['reviews'],
    ));
  }

  Map<String, dynamic> _getStaticDetailData(ServiceItem item) {
    return {
      'title': item.title,
      'rating': item.rating,
      'reviewCount': item.reviewCount,
      'favoriteCount': 150,
      'sellerName': item.sellerName,
      'sellerLevel': item.sellerLevel,
      'profileImagePath': item.profileImagePath,
      'description': 'Professional service with high quality delivery',
      'status': 'bidding', // Can be 'bidding', 'waiting', 'before_pay', 'closed'
      'mediaUrls': [

        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4',
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/SubaruOutbackOnStreetAndDirt.mp4',
        'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WeAreGoingOnBullrun.mp4',
        // Sample image URLs
        'https://picsum.photos/800/600?random=1',
        'https://picsum.photos/800/600?random=2',
        'https://picsum.photos/800/600?random=3',
        'https://picsum.photos/800/600?random=4',
      ],
      'htmlContent': '''
        <h3>Service Description</h3>
        <p>This is a comprehensive service that includes:</p>
        <ul>
          <li>High-quality deliverables</li>
          <li>Fast turnaround time</li>
          <li>Unlimited revisions</li>
          <li>24/7 customer support</li>
          <li>Money-back guarantee</li>
        </ul>
        <p>We pride ourselves on delivering exceptional results that exceed client expectations. Our team of experienced professionals ensures that every project is completed to the highest standards.</p>
        <h4>What you'll get:</h4>
        <ol>
          <li>Professional quality work</li>
          <li>Source files included</li>
          <li>Commercial use license</li>
          <li>Lifetime support</li>
        </ol>
      ''',
      'pricingPlans': [
        {
          'name': 'Basic',
          'price': item.price,
          'description': 'Perfect for small projects',
          'deliveryDays': 3,
          'revisions': '2 Revisions',
          'isHighlighted': false,
          'features': [
            {'name': 'Basic Design', 'included': true},
            {'name': 'Source Files', 'included': true},
            {'name': 'Commercial Use', 'included': false},
            {'name': 'Premium Support', 'included': false},
          ],
        },
        {
          'name': 'Standard',
          'price': (item.price * 1.5).round(),
          'description': 'Most popular choice',
          'deliveryDays': 5,
          'revisions': '5 Revisions',
          'isHighlighted': true,
          'features': [
            {'name': 'Premium Design', 'included': true},
            {'name': 'Source Files', 'included': true},
            {'name': 'Commercial Use', 'included': true},
            {'name': 'Premium Support', 'included': false},
          ],
        },
        {
          'name': 'Premium',
          'price': (item.price * 2).round(),
          'description': 'For complex projects',
          'deliveryDays': 7,
          'revisions': 'Unlimited',
          'isHighlighted': false,
          'features': [
            {'name': 'Premium Design', 'included': true},
            {'name': 'Source Files', 'included': true},
            {'name': 'Commercial Use', 'included': true},
            {'name': 'Premium Support', 'included': true},
          ],
        },
      ],
      'recentViewedList': [
        ServiceItem(
          imagePath: 'assets/images/shot5.png',
          title: 'Modern Logo Design',
          rating: 4.8,
          reviewCount: 120,
          price: 25,
          profileImagePath: 'assets/images/profilepic2.png',
          sellerName: 'John Doe',
          sellerLevel: 'Level 2 Seller',
          isFavorite: false,
        ),
        ServiceItem(
          imagePath: 'assets/images/shot5.png',
          title: 'Website Development',
          rating: 4.9,
          reviewCount: 89,
          price: 150,
          profileImagePath: 'assets/images/profilepic2.png',
          sellerName: 'Jane Smith',
          sellerLevel: 'Top Rated',
          isFavorite: true,
        ),
        ServiceItem(
          imagePath: 'assets/images/shot5.png',
          title: 'Mobile App Design',
          rating: 4.7,
          reviewCount: 67,
          price: 200,
          profileImagePath: 'assets/images/profilepic2.png',
          sellerName: 'Mike Johnson',
          sellerLevel: 'Level 1 Seller',
          isFavorite: false,
        ),
      ],
      'reviews': [
        {
          'rating': 5.0,
          'comment': 'Excellent work! Exceeded my expectations. Will definitely work with this seller again.',
          'reviewerName': 'Sarah Wilson',
          'date': '2 days ago',
        },
        {
          'rating': 4.5,
          'comment': 'Great quality and fast delivery. Very professional service.',
          'reviewerName': 'David Brown',
          'date': '1 week ago',
        },
        {
          'rating': 5.0,
          'comment': 'Perfect! Exactly what I was looking for. Highly recommended.',
          'reviewerName': 'Emily Davis',
          'date': '2 weeks ago',
        },
      ],
    };
  }
}