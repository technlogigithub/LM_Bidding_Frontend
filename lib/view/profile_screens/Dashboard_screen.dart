import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:nb_utils/nb_utils.dart';

import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/chart.dart';
import '../../widget/data.dart';
import '../seller screen/seller home/seller_home_screen.dart';


class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  DropdownButton<String> getPerformancePeriod() {
    List<DropdownMenuItem<String>> dropDownItems = [];

    for (String des in period) {
      var item = DropdownMenuItem<String>(
        value: des,
        child: Text(
          des,
          overflow: TextOverflow.ellipsis, // ✅ prevents cut text
          maxLines: 1,
          style: AppTextStyle.body(
            color: AppColors.appBodyTextColor,
          ),
        ),
      );
      dropDownItems.add(item);
    }

    return DropdownButton<String>(
      isExpanded: true, // ✅ FIXES OVERFLOW ISSUE
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedPeriod,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedPeriod = value!;
        });
      },
    );
  }


  DropdownButton<String> getStatisticsPeriod() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in staticsPeriod) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(
          des,
          style: AppTextStyle.body()
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedStaticsPeriod,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedStaticsPeriod = value!;
        });
      },
    );
  }
  DropdownButton<String> getEarningPeriod() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in earningPeriod) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(
          des,
          style: AppTextStyle.body(),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedEarningPeriod,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedEarningPeriod = value!;
        });
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
          ),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: AppColors.appTextColor),

        /// ❌ Removed Obx (you were not using Rx here)
        title: Text(
          'Dashboard',
          style: AppTextStyle.title(
            color: AppColors.appTextColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15.0),
                Row(
                  children: const [
                    Expanded(
                      child: DashBoardInfo(
                        count: '$currencySign${4000.00}',
                        title: 'Current Balance',
                        image: 'assets/images/cb.png',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: DashBoardInfo(
                        count: '$currencySign${5000.00}',
                        title: 'Live Bid',
                        image: 'assets/images/td.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: const [
                    Expanded(
                      child: DashBoardInfo(
                        count: '$currencySign${4000.00}',
                        title: 'Total Deposite',
                        image: 'assets/images/td.png',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: DashBoardInfo(
                        count: '10',
                        title: 'Total Bid',
                        image: 'assets/images/to.png',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: const [
                    Expanded(
                      child: DashBoardInfo(
                        count: '08',
                        title: 'Total Withdrawal',
                        image: 'assets/images/tt.png',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: DashBoardInfo(
                        count: '02',
                        title: 'Total Post',
                        image: 'assets/images/io.png',
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 20),

                const SizedBox(height: 15.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appMutedColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 10),

                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Performance',
                            style: AppTextStyle.title(),
                          ),
                          // SizedBox(width: 60.w,),
                          // // const Spacer(),
                          // Expanded(
                          //   child: Container(
                          //     padding: const EdgeInsets.all(5.0),
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(30.0),
                          //       border: Border.all(color: kLightNeutralColor),
                          //     ),
                          //     child: DropdownButtonHideUnderline(
                          //       child: getPerformancePeriod(),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Summary(
                              title: '80 Participation',
                              subtitle: 'Completions',
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Summary2(
                              title1: '4.5/',
                              title2: '243',
                              subtitle: 'Ratings / Reviews',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        children: const [
                          Expanded(
                            flex: 1,
                            child: Summary(
                              title: '90% of Win',
                              subtitle: 'Total-win-bid',
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Expanded(
                            flex: 1,
                            child: Summary(
                              title: '100% on Time',
                              subtitle: 'On-time-delivery',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
             gradient: AppColors.appPagecolor,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appMutedColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 10),

                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Statistics',
                            style: AppTextStyle.title()
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 30,
                            child: Container(
                              padding: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                border: Border.all(color: kLightNeutralColor),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: getStatisticsPeriod(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: RecordStatistics(
                              dataMap: dataMap,
                              colorList: colorList,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: const [
                                ChartLegend(
                                  iconColor: Color(0xFF69B22A),
                                  title: 'Impressions',
                                  value: '5.3K',
                                ),
                                ChartLegend(
                                  iconColor: Color(0xFF144BD6),
                                  title: 'Interaction',
                                  value: '3.5K',
                                ),
                                ChartLegend(
                                  iconColor: Color(0xFFFF3B30),
                                  title: 'Reached-Out',
                                  value: '2.3K',
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),



              ],
            ),
          ),
        ),
      ),


    );
  }
}
