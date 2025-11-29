import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../core/app_textstyle.dart';
import '../models/static models/service_items_model.dart';
import '../core/app_color.dart';

class CustomVerticalGridviewList extends StatelessWidget {
  final RxList<ServiceItem> services;

  const CustomVerticalGridviewList({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GridView.builder(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.65,
        ),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return GestureDetector(
            onTap: () {
              print('Tapped: ${service.title}');
              // Navigate or show details here
            },
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                        child: Image.asset(
                          service.imagePath,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 5,
                        right: 5,
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
                                  ? Colors.redAccent
                                  : AppColors.appIconColor,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                    border: Border(
                      left: BorderSide(color: AppColors.appDescriptionColor, width: 1),
                      right: BorderSide(color: AppColors.appDescriptionColor, width: 1),
                      bottom: BorderSide(color: AppColors.appDescriptionColor, width: 1),
                      // top: BorderSide.none,  // optional, default none hi hota hai
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          service.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyle.description(
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTitleColor,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 3),
                            Text(
                              '${service.rating}',
                              style: AppTextStyle.body(color: AppColors.appTitleColor),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              '(${service.reviewCount} reviews)',
                              style: AppTextStyle.body(color: AppColors.appDescriptionColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Text(
                          '₹${service.price}',
                          style: AppTextStyle.description(
                            fontWeight: FontWeight.bold,
                            color: AppColors.appTitleColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Container(
                //   decoration: BoxDecoration(
                //     gradient: AppColors.appPagecolor,
                //     border: Border.all(color: AppColors.appDescriptionColor, width: 1),
                //     borderRadius: BorderRadius.circular(12),
                //     // boxShadow: [
                //     //   BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5),
                //     // ],
                //   ),
                //   child: Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //
                //       // 🔹 IMAGE WITHOUT PADDING
                //       Stack(
                //         children: [
                //           ClipRRect(
                //             borderRadius: BorderRadius.only(
                //               topLeft: Radius.circular(12),
                //               topRight: Radius.circular(12),
                //             ),
                //             child: Image.asset(
                //               service.imagePath,
                //               height: 100,
                //               width: double.infinity,
                //               fit: BoxFit.cover,
                //             ),
                //           ),
                //           Positioned(
                //             top: 5,
                //             right: 5,
                //             child: Obx(() {
                //               return GestureDetector(
                //                 onTap: () {
                //                   service.isFavorite.value = !service.isFavorite.value;
                //                 },
                //                 child: Icon(
                //                   service.isFavorite.value
                //                       ? Icons.favorite
                //                       : Icons.favorite_border,
                //                   color: service.isFavorite.value
                //                       ? Colors.redAccent
                //                       : AppColors.appIconColor,
                //                 ),
                //               );
                //             }),
                //           ),
                //         ],
                //       ),
                //
                //       // 🔹 CONTENT WITH PADDING
                //       Padding(
                //         padding: const EdgeInsets.all(10),
                //         child: Column(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             const SizedBox(height: 8),
                //             Text(
                //               service.title,
                //               maxLines: 2,
                //               overflow: TextOverflow.ellipsis,
                //               style: AppTextStyle.description(
                //                 fontWeight: FontWeight.bold,
                //                 color: AppColors.appTitleColor,
                //               ),
                //             ),
                //             const SizedBox(height: 5),
                //             Row(
                //               children: [
                //                 Icon(Icons.star, color: Colors.amber, size: 16),
                //                 const SizedBox(width: 3),
                //                 Text(
                //                   '${service.rating}',
                //                   style: AppTextStyle.body(color: AppColors.appTitleColor),
                //                 ),
                //                 const SizedBox(width: 5),
                //                 Text(
                //                   '(${service.reviewCount} reviews)',
                //                   style: AppTextStyle.body(color: AppColors.appDescriptionColor),
                //                 ),
                //               ],
                //             ),
                //             const SizedBox(height: 5),
                //             Text(
                //               '₹${service.price}',
                //               style: AppTextStyle.description(
                //                 fontWeight: FontWeight.bold,
                //                 color: AppColors.appTitleColor,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),

          );
        },
      );
    });
  }
}
