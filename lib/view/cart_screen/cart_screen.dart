import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/widget/custom_html_viewer.dart';
import '../../controller/home/home_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart' as AppTextStyle;
import '../../widget/custom_vertical_listview_list.dart';

class CartScreen extends StatelessWidget {
  CartScreen({super.key});
  final ClientHomeController controller = Get.put(ClientHomeController());
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      top: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.cartScreen,style: AppTextStyle.kTextStyle.copyWith(color: AppColors.appTextColor)),
            centerTitle: true,
            iconTheme: IconThemeData(color: AppColors.appTextColor),
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    spreadRadius: 2,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
                gradient: AppColors.appbarColor,
              ),
            ),
          ),
          body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
            ),
            child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                physics: const BouncingScrollPhysics(),
              child:Column(
                children: [
                  SizedBox(height: 10.h),
                  CustomVerticalListviewList(items: controller.recentViewedList, onFavoriteToggle: controller.toggleFavorite, isLoading: controller.isLoading,isFromCartScreen: true,),
                  CustomHtmlViewer(htmlContent: '''
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
  <p><strong>Note:</strong> Contact us for custom requirements.</p>
  <a href="https://example.com">Learn More</a>
'''),
                ],
              ),
            ),
          ),
        ));
  }
}
