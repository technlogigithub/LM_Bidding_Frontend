import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:freelancer/screen/seller%20screen/seller%20home/seller_home_screen.dart';
import 'package:freelancer/screen/widgets/chart.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/constant.dart';
import '../../widgets/data.dart';

class ClientDashBoard extends StatefulWidget {
  const ClientDashBoard({super.key});

  @override
  State<ClientDashBoard> createState() => _ClientDashBoardState();
}

class _ClientDashBoardState extends State<ClientDashBoard> {
  DropdownButton<String> getPerformancePeriod() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in period) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(
          des,
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
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
          style: kTextStyle.copyWith(color: kSubTitleColor),
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
          style: kTextStyle.copyWith(color: kSubTitleColor),
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
      backgroundColor: kDarkWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        elevation: 0,
        iconTheme: const IconThemeData(color: kNeutralColor),
        title: Text(
          'Dashboard',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0,bottom: 20),
          child: Container(
            padding: const EdgeInsets.only(left: 15.0, right: 15.0),
            width: context.width(),
            decoration: const BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0),
              ),
            ),
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
                        image: 'images/cb.png',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: DashBoardInfo(
                        count: '$currencySign${5000.00}',
                        title: 'Live Bid',
                        image: 'images/td.png',
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
                        image: 'images/td.png',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: DashBoardInfo(
                        count: '10',
                        title: 'Total Bid',
                        image: 'images/to.png',
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
                        image: 'images/tt.png',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Expanded(
                      child: DashBoardInfo(
                        count: '02',
                        title: 'Total Post',
                        image: 'images/io.png',
                      ),
                    ),
                  ],
                ),
        
                
                const SizedBox(height: 20),
        
                const SizedBox(height: 15.0),
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: kBorderColorTextField),
                        boxShadow: const [
                          BoxShadow(
                            color: kDarkWhite,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Performance',
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
                                    child: getPerformancePeriod(),
                                  ),
                                ),
                              ),
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
                        color: kWhite,
                        borderRadius: BorderRadius.circular(16.0),
                        border: Border.all(color: kBorderColorTextField),
                        boxShadow: const [
                          BoxShadow(
                            color: kDarkWhite,
                            blurRadius: 5.0,
                            spreadRadius: 2.0,
                            offset: Offset(0, 5),
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
                                style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
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
