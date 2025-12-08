import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../models/App_moduls/AppResponseModel.dart';

class CustomHeader extends StatelessWidget {
  final String username;
  final double balance;
  final String images;
  final UserInfo? userInfo;

  const CustomHeader({
    super.key,
    required this.username,
    required this.balance,
    required this.images,
    this.userInfo,
  });

  Future<bool> _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),

      /// 🔥 Apply dynamic gradient as Header Background
      decoration: BoxDecoration(
        gradient: AppColors.appbarColor,   // ⬅ HERE
      ),

      child: Row(
        children: [
          // Profile Image
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(shape: BoxShape.circle),
            child: ClipOval(
              child: images.isNotEmpty
                  ? CachedNetworkImage(
                imageUrl: images,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: AppColors.simmerColor,
                  highlightColor: AppColors.appWhite,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) {
                  return Image.asset(
                    'assets/images/profilepic2.png',
                    fit: BoxFit.cover,
                  );
                },
              )
                  : Image.asset(
                'assets/images/profilepic2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // USERNAME OR GUEST
                FutureBuilder<bool>(
                  future: _checkLogin(),
                  builder: (context, snapshot) {
                    bool isLoggedIn = snapshot.data ?? false;

                    return Obx(() => Text(
                      isLoggedIn ? username : "Guest",
                      style: AppTextStyle.title(
                        fontWeight: FontWeight.w600,
                        color: AppColors.appTextColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ));
                  },
                ),

                // BALANCE
                Obx(() => RichText(
                  text: TextSpan(
                    text: 'Balance: ',
                    style: AppTextStyle.description(
                      color: AppColors.appTextColor,

                    ),
                    children: [
                      TextSpan(
                        text: "\$${balance.toStringAsFixed(2)}",
                        style: AppTextStyle.description(
                          fontWeight: FontWeight.bold,
                          color: AppColors.appTextColor,

                        ),
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}