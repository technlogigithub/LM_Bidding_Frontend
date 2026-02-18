import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../core/api_config.dart';
import '../../core/app_color.dart';
import '../../core/app_constant.dart';
import '../../core/app_textstyle.dart';
import '../../widget/button_global.dart';
import '../../widget/form_widgets/app_textfield.dart';
import '../client popup/client_popup.dart';

class PostRequirementsSendScreen extends StatefulWidget {
  const PostRequirementsSendScreen({super.key});

  @override
  State<PostRequirementsSendScreen> createState() => _PostRequirementsSendScreenState();
}

class _PostRequirementsSendScreenState extends State<PostRequirementsSendScreen> {
   List<dynamic> notifications = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // fetchOrders();
  }
  Future<void> fetchOrders() async {
    try {
      final res = await  ApiService.getRequest("ordersApi");
      setState(() {
        notifications = res["data"] ?? []; // <-- API response structure ke hisaab se adjust karna
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      toast("Error: $e");
    }

  }
  //__________Show_upload_popup________________________________________________
  void showUploadDocPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const UploadRequirementsPopUp(),
            );
          },
        );
      },
    );
  }

  //__________Show_success_popup________________________________________________
  void uploadCompletePopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: const UploadCompletePopUp(),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: ButtonGlobalWithoutIcon(
          buttontext: 'Submit Requirements',
          buttonDecoration: kButtonDecoration.copyWith(
            color: AppColors.appButtonColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          onPressed: () {
            setState(() {
              uploadCompletePopUp();

            });
          },
          buttonTextColor: AppColors.appButtonTextColor,
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: const BoxDecoration(
      //     color: kWhite
      //   ),
      //   child: ButtonGlobalWithoutIcon(
      //       buttontext: 'Submit Requirements',
      //       buttonDecoration: kButtonDecoration.copyWith(
      //         color: kPrimaryColor,
      //         borderRadius: BorderRadius.circular(30.0),
      //       ),
      //       onPressed: () {
      //         setState(() {
      //           uploadCompletePopUp();
      //         });
      //       },
      //       buttonTextColor: kWhite),
      // ),
      // backgroundColor: kDarkWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme:  IconThemeData(color: AppColors.appTextColor,),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppColors.appbarColor,
            // borderRadius: const BorderRadius.only(
            //   bottomLeft: Radius.circular(50.0),
            //   bottomRight: Radius.circular(50.0),
            // ),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Obx(() {
          return Text(
            'Send Requirements',
            // controller.referral.value?.label ?? '',
            style:  AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,

            ),
          );
        }),
      ),
      // appBar: AppBar(
      //   backgroundColor: kDarkWhite,
      //   elevation: 0,
      //   iconTheme: const IconThemeData(color: kNeutralColor),
      //   title: Text(
      //     'Send Requirements',
      //     style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Please give me your file, photo.',
                style: AppTextStyle.title(),
              ),
              const SizedBox(height: 20.0),
              CustomTextfield(
                label: 'Upload file, photo and document',
                hintText: 'Tap icon to attach a file',
                readOnly: true,
                onTap: () {
                  showUploadDocPopUp();
                },
                keyboardType: TextInputType.name,
                suffixIcon:  Icon(
                  FeatherIcons.upload,
                  color: AppColors.appIconColor,
                ),
              ),

              const SizedBox(height: 20.0),
              ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 10.0,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.appButtonColor.withOpacity(0.1),
                    // color: kPrimaryColor.withOpacity(0.1),
                  ),
                  child:  Icon(
                    IconlyBold.document,
                    color:AppColors.appButtonColor,
                  ),
                ),
                title: Text(
                  'Uploading file 23564 2545265',
                  style: AppTextStyle.description(color: AppColors.appBodyTextColor),
                ),
                subtitle: StepProgressIndicator(
                  totalSteps: 100,
                  currentStep: 60,
                  size: 8,
                  padding: 0,
                  selectedColor: AppColors.appButtonColor,
                  unselectedColor: AppColors.appMutedColor ,
                  roundedEdges: const Radius.circular(10),
                ),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 10.0,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.appButtonColor.withOpacity(0.1),
                    // color: kPrimaryColor.withOpacity(0.1),
                  ),
                  child:  Icon(
                    IconlyBold.document,
                    color:AppColors.appButtonColor,
                  ),
                ),
                title: Text(
                  'Uploading file 23564 2545265',
                  style: AppTextStyle.description(color: AppColors.appBodyTextColor),
                ),
                subtitle: StepProgressIndicator(
                  totalSteps: 100,
                  currentStep: 60,
                  size: 8,
                  padding: 0,
                  selectedColor: AppColors.appButtonColor,
                  unselectedColor: AppColors.appMutedColor ,
                  roundedEdges: const Radius.circular(10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
