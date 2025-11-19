import 'package:flutter/material.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../models/App_moduls/AppResponseModel.dart';

class CustomHeader extends StatelessWidget {
  final String username;
  final double balance;
  final String images;
  final UserInfo? userInfo;   // 👈 Add this

  const CustomHeader({
    super.key,
    required this.username,
    required this.balance,
    required this.images,
    this.userInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.darkWhite,
      child: Row(
        children: [
          // ***** SHOW DP ONLY IF API SAYS dp = true *****
          // if (userInfo?.dp == true)
            Container(
              height: 50,
              width: 50,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: ClipOval(
                child: images.isNotEmpty
                    ? Image.network(
                  images,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
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

          // ***** SHOW NAME or BALANCE based on API flags *****
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME (only if allowed)
                // if (userInfo?.name == true)
                  Text(
                    username,
                    style: AppTextStyle.kTextStyle.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.neutralColor,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),

                // BALANCE (only if allowed)
                // if (userInfo?.walletBalance == true)
                  RichText(
                    text: TextSpan(
                      text: 'Balance: ',
                      style: AppTextStyle.kTextStyle.copyWith(
                        color: AppColors.neutralColor,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: "\$${balance.toStringAsFixed(2)}",
                          style: AppTextStyle.kTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.neutralColor,
                            fontSize: 13,
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
    );
  }
}

