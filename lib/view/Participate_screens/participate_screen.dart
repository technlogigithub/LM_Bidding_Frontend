import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:libdding/view/Participate_screens/participate_details_screen.dart';
import 'package:libdding/widget/custom_tapbar.dart';
import 'package:libdding/widget/participation_list_custom_widget.dart';
import 'package:libdding/core/app_string.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../controller/participation/participate_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import 'package:libdding/models/App_moduls/AppResponseModel.dart' show AppMenuItem;

class ParticipateScreen extends StatefulWidget {
  final String? apiEndpoint;
  final AppMenuItem? menuItem;

  const ParticipateScreen({super.key, this.apiEndpoint, this.menuItem});

  @override
  State<ParticipateScreen> createState() => _ParticipateScreenState();
}

class _ParticipateScreenState extends State<ParticipateScreen> {
  final ParticipateController controller = Get.put(ParticipateController());

  @override
  void initState() {
    super.initState();
    if (widget.menuItem?.design != null && 
        widget.menuItem!.design is Map && 
        widget.menuItem!.design['inputs'] != null &&
        widget.menuItem!.design['inputs']['select'] != null &&
        widget.menuItem!.design['inputs']['select']['options'] != null) {
        
        final options = widget.menuItem!.design['inputs']['select']['options'] as List;
        if (options.isNotEmpty) {
           // Set initial status to the value of the first option
           controller.currentStatus.value = options[0]['value'].toString();
        }
    }

    if (widget.apiEndpoint != null && widget.apiEndpoint!.isNotEmpty) {
      controller.dynamicEndpoint.value = widget.apiEndpoint!;
      controller.fetchParticipateList();
    }
  }

  @override
  Widget build(BuildContext context) {
    List<String> tabs = [];
    
    // Parse tabs from design if available
    if (widget.menuItem?.design != null && 
        widget.menuItem!.design is Map && 
        widget.menuItem!.design['inputs'] != null &&
        widget.menuItem!.design['inputs']['select'] != null &&
        widget.menuItem!.design['inputs']['select']['options'] != null) {
        
        final options = widget.menuItem!.design['inputs']['select']['options'] as List;
        if (options.isNotEmpty) {
           tabs = options.map((e) => e['label'].toString()).toList();
        }
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = kIsWeb || screenWidth > 800;

    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: isWeb ? null : AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,
            ),
          ),
          centerTitle: true,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          title: Obx(() => Text(
            widget.menuItem?.title ?? widget.menuItem?.label ?? "",
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          )),
        ),
        // appBar: AppBar(
        //   title: Text(
        //     "Participate",
        //     style: AppTextStyle.kTextStyle.copyWith(
        //       color: AppColors.appTextColor,
        //       fontSize: 16,
        //       fontWeight: FontWeight.bold,
        //     ),
        //   ),
        //   centerTitle: true,
        //   backgroundColor: AppColors.appWhite,
        // ),
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppColors.appPagecolor
          ),
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isWeb ? screenWidth * 0.03 : screenWidth * 0.01),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 1200), // Max width for web dashboard feel
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: screenHeight * 0.010),
                    CustomTabBar(
                      // height: 50,
                      tabs: tabs,
                      initialIndex: 0,
                      // primaryColor: AppColors.appColor,
                      // borderColor: Colors.grey.shade300,
                        textStyle: AppTextStyle.description(),
                      onTap: (index) {
                        String statusValue = "";
                         if (widget.menuItem?.design != null && 
                            widget.menuItem!.design is Map && 
                            widget.menuItem!.design['inputs'] != null &&
                            widget.menuItem!.design['inputs']['select'] != null &&
                            widget.menuItem!.design['inputs']['select']['options'] != null) {
                            
                            final options = widget.menuItem!.design['inputs']['select']['options'] as List;
                            if (index < options.length) {
                               statusValue = options[index]['value'].toString();
                            }
                        }
                        controller.updateTab(index, statusValue);
                      },
                    ),
                    SizedBox(height: screenHeight * 0.010),
                    Obx(() {
                      if (!controller.isLoading.value && controller.currentList.isEmpty) {
                        return SizedBox(
                          height: screenHeight * 0.7,
                          child: Center(
                            child: Text(
                             "No participate found",
                              style: AppTextStyle.description(color: AppColors.appDescriptionColor),
                            ),
                          ),
                        );
                      }
    
                      return ParticipationListCustomWidget(
                        items: controller.currentList.map((e) {
                          final detailsMap = e.details?.toJson() ?? {};
                          // Remove keys that are null
                          detailsMap.removeWhere((key, value) => value == null);
    
                          return ParticipationCardUiModel(
                            orderId: e.hidden?.orderId?.toString() ?? e.hidden?.postKey?.toString() ?? '',
                            date: e.details?.orderDate,
                            title: e.info?.title,
                            countdownDt: e.info?.countdownDt,
                            media: e.media,
                            dynamicDetails: detailsMap,
                            // actionButtons: e.,
                            nextPageName: e.hidden?.nextPageName,
                            nextPageApiEndpoint: e.hidden?.nextPageApiEndpoint,
                          );
                        }).toList(),
                        isLoading: controller.isLoading,
                        onItemTap: (item) {
                          // API call logic reserved if re-enabled
                        },
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}