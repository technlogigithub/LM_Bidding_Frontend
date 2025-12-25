import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_color.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_textstyle.dart';
import '../../../widget/button_global.dart';
import '../../../widget/form_widgets/app_button.dart';
import '../../../widget/form_widgets/app_textfield.dart';
import '../../../widget/form_widgets/custom_textarea.dart';

class SellerReportScreen extends StatefulWidget {
  const SellerReportScreen({super.key});

  @override
  State<SellerReportScreen> createState() => _SellerReportScreenState();
}

class _SellerReportScreenState extends State<SellerReportScreen> {
  DropdownButton<String> getReportType() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in reportTitle) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      items: dropDownItems,
      value: selectedReportTitle,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedReportTitle = value!;
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
            'Report',
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
      //     'Report',
      //     style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          decoration:  BoxDecoration(gradient: AppColors.appPagecolor),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: CustomButton(
                  text: 'Cancel',
                  backgroundColor: AppColors.appButtonColor,
                  onTap: () {
                    // Your cancel action
                  },
                ),
              ),
              const SizedBox(width: 12), // spacing between buttons
              Expanded(
                child: CustomButton(
                  text: 'Send',
                  backgroundColor: AppColors.appButtonColor,
                  onTap: () {
                    // Your send action
                  },
                ),
              ),
            ],
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
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  const SizedBox(height: 30.0),
                  reportTypeDropdown(),
                  const SizedBox(height: 20.0),
                  CustomTextfield(
                    label: 'URL of original content',
                    hintText: 'Enter post url',
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),

                  const SizedBox(height: 20.0),
                  CustomTextarea(
                    label: 'Additional information',
                    hintText: 'Enter information...',
                    minLines: 3,
                    maxLines: 6,
                  ),

                ],
              ),
            ),
          ),
        ),
    );
  }
  Widget reportTypeDropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: kInputDecoration.copyWith(
            labelText: 'Why do you want to report?',
            labelStyle: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
            hintText: 'Select reason',
            hintStyle: AppTextStyle.description(),

            // ✅ TRANSPARENT BACKGROUND
            filled: true,
            fillColor: Colors.white.withOpacity(0.01),

            // ✅ NORMAL BORDER
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.appDescriptionColor,
                width: 1,
              ),
            ),

            // ✅ FOCUSED BORDER
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.appDescriptionColor,
                width: 1.5,
              ),
            ),

            // ✅ DEFAULT BORDER
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.appBodyTextColor,
                width: 1,
              ),
            ),

            contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: selectedReportTitle,
              icon: Icon(
                FeatherIcons.chevronDown,
                color: AppColors.appIconColor,
              ),
              style: AppTextStyle.description(
                color: AppColors.appTitleColor,
              ),
              items: reportTitle.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: AppTextStyle.description(
                      color: AppColors.appTitleColor,
                    ),
                  ),
                );
              }).toList(),
              hint: Text(
                'Select reason',
                style: AppTextStyle.description(
                  color: AppColors.appTitleColor,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedReportTitle = value!;
                });
              },
            ),
          ),
        );
      },
    );
  }

}
