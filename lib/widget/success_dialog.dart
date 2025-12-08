import 'package:flutter/material.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import '../view/Bottom_navigation_screen/Botom_navigation_screen.dart';

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10.0),
            Container(
              height: 124,
              width: 124,
              decoration: BoxDecoration(
                color: AppTextStyle.kPrimaryColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppTextStyle.kPrimaryColor,
                size: 50,
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'Successfully',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: AppTextStyle.kTextStyle.copyWith(
                color: AppTextStyle.kNeutralColor,
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Thank you so much you\'ve just publish your review',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyle.kTextStyle.copyWith(color: AppTextStyle.kLightNeutralColor),
            ),
            const SizedBox(height: 20.0),
            CustomButton(onTap: () {
              finish(context);
              BottomNavigationScreen().launch(context);
            }, text: 'Got it!')
          ],
        ),
      ),
    );
  }
}