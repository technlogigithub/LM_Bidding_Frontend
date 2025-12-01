import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_textstyle.dart';
import '../models/static models/service_items_model.dart';
import '../core/app_color.dart';

class CustomVerticalGridviewList extends StatelessWidget {
  final RxList<ServiceItem> services;
  final double? childAspectRatio;
  final double? height;

  const CustomVerticalGridviewList({
    super.key,
    required this.services,
    this.childAspectRatio,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Calculate default aspect ratio if not provided
      // Default: 0.65 (allows for image 100 + content ~54 = ~154 height for ~100 width)
      final aspectRatio = childAspectRatio ?? 0.64;
      
      Widget gridView = GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: aspectRatio,
        ),
        itemCount: services.length,
          itemBuilder: (context, index) {
            final service = services[index];

            return GestureDetector(
              onTap: () {
                print('Tapped: ${service.title}');
              },
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: AppColors.appPagecolor,
                  borderRadius: BorderRadius.circular(12),

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


                  // border: Border.all(
                  //   color: AppColors.appDescriptionColor,
                  //   width: 1,
                  // ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ---------------- IMAGE + FAVORITE ICON ----------------
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.asset(
                            service.imagePath,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),

                        Positioned(
                          top: 8,
                          right: 8,
                          child: Obx(() {
                            return GestureDetector(
                              onTap: () {
                                service.isFavorite.value = !service.isFavorite.value;
                              },
                              child: Icon(
                                service.isFavorite.value
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: service.isFavorite.value
                                    ? Colors.red
                                    : AppColors.appIconColor,
                              ),
                            );
                          }),
                        )
                      ],
                    ),

                    // ---------------- DETAILS SECTION ----------------
                    Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          // Title
                          Text(
                            service.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyle.description(
                              fontWeight: FontWeight.bold,
                              color: AppColors.appTitleColor,
                            ),
                          ),

                          SizedBox(height: 8),

                          // Rating Row
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.amber, size: 16),
                              SizedBox(width: 4),
                              Text(
                                service.rating.toString(),
                                style: AppTextStyle.body(
                                  color: AppColors.appTitleColor,
                                ),
                              ),
                              SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  "(${service.reviewCount} reviews)",
                                  style: AppTextStyle.body(
                                    color: AppColors.appDescriptionColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 8),

                          // Price
                          Text(
                            "₹${service.price}",
                            style: AppTextStyle.description(
                              fontWeight: FontWeight.bold,
                              color: AppColors.appTitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

      );

      if (height != null) {
        return SizedBox(
          height: height,
          child: gridView,
        );
      }

      return gridView;
    });
  }
}
