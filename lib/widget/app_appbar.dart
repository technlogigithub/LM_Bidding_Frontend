import 'package:flutter/material.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';


class CustomHeader extends StatelessWidget {
  final String username;
  final double balance;

  const CustomHeader({
    super.key,
    required this.username,
    required this.balance,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: AppColors.darkWhite,
      child: Row(
        children: [
          // Profile
          Container(
            height: 50,
            width: 50,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('assets/images/profilepic2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name + Balance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  username,
                  style: AppTextStyle.kTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutralColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
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

