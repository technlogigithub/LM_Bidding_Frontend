import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 5)
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      ClipRRect(

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
                              color:service.isFavorite.value
                                  ? Colors.redAccent
                                  : AppColors.appTitleColor,
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    service.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:  TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.appTitleColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 3),
                      Text('${service.rating}',style: TextStyle(fontSize: 14, color: AppColors.appTitleColor)),
                      const SizedBox(width: 5),
                      Text('(${service.reviewCount} reviews)',
                          style: TextStyle(fontSize: 12, color: AppColors.appDescriptionColor)),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [

                      Text(
                        '₹${service.price}',
                        style:  TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16,color: AppColors.appTitleColor),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
