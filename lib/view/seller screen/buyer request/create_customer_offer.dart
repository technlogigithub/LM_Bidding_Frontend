import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:libdding/widget/form_widgets/app_button.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../../core/app_color.dart';
import '../../../core/app_constant.dart';
import '../../../core/app_textstyle.dart';
import '../../../widget/button_global.dart';
import '../../../widget/form_widgets/app_textfield.dart';
import '../../client review/client_review.dart';

class CreateCustomerOffer extends StatefulWidget {
  const CreateCustomerOffer({super.key});

  @override
  State<CreateCustomerOffer> createState() => _CreateCustomerOfferState();
}

class _CreateCustomerOfferState extends State<CreateCustomerOffer> {
  //__________deliveryTime___________________________________________________
  DropdownButton<String> getDeliveryTime() {
    List<DropdownMenuItem<String>> dropDownItems = [];
    for (String des in deliveryTimeList) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropDownItems.add(item);
    }
    return DropdownButton(
      icon:  Icon(FeatherIcons.chevronDown,color: AppColors.appIconColor,),
      items: dropDownItems,
      value: selectedDeliveryTimeList,
      style: kTextStyle.copyWith(color: kSubTitleColor),
      onChanged: (value) {
        setState(() {
          selectedDeliveryTimeList = value!;
        });
      },
    );
  }

  //__________revisionTime___________________________________________________
  DropdownButton<String> getRevisionTime() {
    List<DropdownMenuItem<String>> dropdownItems = [];
    for (String des in revisionTime) {
      var item = DropdownMenuItem(
        value: des,
        child: Text(des),
      );
      dropdownItems.add(item);
    }
    return DropdownButton(
        items: dropdownItems,
        icon: const Icon(FeatherIcons.chevronDown),
        value: selectedRevisionTime,
        style: kTextStyle.copyWith(color: kSubTitleColor),
        onChanged: (value) {
          setState(() {
            selectedRevisionTime = value!;
          });
        });
  }

  List<String> offerScopeList = [
    'Source File',
    'High Resolution',
  ];

  List<String> selectedOfferScopeList = ['Source File'];
  bool isExpanded = true;


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
            'Create a custom Offer',
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
      //     'Create a custom Offer',
      //     style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
      //   ),
      //   centerTitle: true,
      // ),
      bottomNavigationBar: Container(
        decoration:  BoxDecoration(gradient: AppColors.appPagecolor),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: CustomButton(onTap: () {
            const SellerHome().launch(context);
          }, text: "Submit Offer"),
        ),
        // child: ButtonGlobalWithoutIcon(
        //     buttontext: 'Submit Offer',
        //     buttonDecoration: kButtonDecoration.copyWith(color: kPrimaryColor, borderRadius: BorderRadius.circular(30.0)),
        //     onPressed: () {
        //       const SellerHome().launch(context);
        //     },
        //     buttonTextColor: kWhite),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20.0),
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    gradient: AppColors.appPagecolor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.appMutedColor,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 10),
                          // blurRadius: 1,
                          // spreadRadius: 1,
                          // offset: Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Container(
                          height: 44.h,
                          width: 44.w,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/images/profilepic2.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          'Shaidul Islam',
                          style: AppTextStyle.title(),
                        ),
                        subtitle: Text(
                          '28 Jun 2023',
                          style: AppTextStyle.description(),
                        ),
                      ),
                       Divider(
                        height: 0,
                        thickness: 1.0,
                        color:AppColors.appMutedColor,
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        'I Need UI UX Designer',
                        style: AppTextStyle.title(),
                      ),
                      const SizedBox(height: 5.0),
                      ReadMoreText(
                        'Lorem ipsum dolor sit amet consectetur. Elementum nulla quis nunc Lorem ipsum dolor sit amet consectetur. O rci pulvinar sit nec donec pellentesque ve nenatis nunc vel pretium. Dictumst bib en dum pharetra hendrerit tortor nisl. Nulla accumsan ',
                        style: AppTextStyle.description(),
                        trimLines: 2,
                        colorClickableText: AppColors.appColor,
                        trimMode: TrimMode.Line,
                        trimCollapsedText: '..Read more',
                        trimExpandedText: '..Read less',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15.0),
                Container(
                  decoration: BoxDecoration(
                      gradient: AppColors.appPagecolor,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.appMutedColor,
                          blurRadius: 5,
                          spreadRadius: 1,
                          offset: Offset(0, 10),
                          // blurRadius: 1,
                          // spreadRadius: 1,
                          // offset: Offset(0, 6),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Row(
                    children: [
                      Container(
                        height: 67.h,
                        width: 79.w,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            bottomLeft: Radius.circular(10.0),
                          ),
                          image: DecorationImage(image: AssetImage('images/shot2.png'), fit: BoxFit.cover),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: Text(
                            'Mobile UI UX design or app UI UX design.',
                            maxLines: 2,
                            style: AppTextStyle.description(color: AppColors.appTitleColor, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                Text(
                  'Description',
                  style: AppTextStyle.title(),
                ),
                const SizedBox(height: 15.0),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    gradient: AppColors.appPagecolor,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.appMutedColor,
                        blurRadius: 5,
                        spreadRadius: 1,
                        offset: Offset(0, 10),
                        // blurRadius: 1,
                        // spreadRadius: 1,
                        // offset: Offset(0, 6),
                      ),
                    ],

                  ),
                  child: Text(
                    'Hello there, This is Ibne Riead! A professional UI/UX Design experience with 2+ years in this field. I specialize in Mobile Apps and Website Design. I always try to meet the needs of my client. ',
                    style: AppTextStyle.description(),
                  ),
                ),
                const SizedBox(height: 20.0),
                CustomTextfield(
                  label: 'Total Offer Amount',
                  hintText: 'Enter amount',
                  keyboardType: TextInputType.number, // amount ke liye better
                  // controller: totalOfferController,   // optional agar use karna ho
                  onChanged: (value) {
                    print(value);
                  },
                  textInputAction: TextInputAction.done,
                  maxLength: 10, // optional
                ),

                const SizedBox(height: 20.0),
                deliveryTimeDropdown(),

                const SizedBox(height: 20.0),
                revisionTimeDropdown(),

                Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    initiallyExpanded: true,
                    childrenPadding: EdgeInsets.zero,
                    tilePadding: EdgeInsets.zero,
                    iconColor: kLightNeutralColor,
                    collapsedIconColor: kLightNeutralColor,
                    trailing:  Icon(FeatherIcons.chevronDown,color: AppColors.appIconColor,),
                    title: Text(
                      'Define the offer scope',
                      style: AppTextStyle.description(color: AppColors.appTitleColor,fontWeight: FontWeight.bold),
                    ),
                    children: [
                      ListView.builder(
                        itemCount: offerScopeList.length,
                        shrinkWrap: true,
                        itemBuilder: (_, i) {
                          return Column(
                            children: [
                              ListTile(
                                onTap: () {
                                  setState(
                                    () {
                                      selectedOfferScopeList.contains(offerScopeList[i])
                                          ? selectedOfferScopeList.remove(offerScopeList[i])
                                          : selectedOfferScopeList.add(offerScopeList[i]);
                                    },
                                  );
                                },
                                contentPadding: EdgeInsets.zero,
                                visualDensity: const VisualDensity(vertical: -3),
                                title: Text(
                                  offerScopeList[i],
                                  style: AppTextStyle.description(),
                                ),
                                trailing: Icon(
                                  selectedOfferScopeList.contains(offerScopeList[i]) ? Icons.check_circle : Icons.circle_outlined,
                                  color: selectedOfferScopeList.contains(offerScopeList[i]) ? AppColors.appButtonColor : AppColors.appIconColor,
                                ),
                              ),
                               Divider(
                                thickness: 1.0,
                                color: AppColors.appMutedColor,
                                height: 1,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget deliveryTimeDropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: kInputDecoration.copyWith(
            labelText: 'Delivery Time',
            labelStyle: AppTextStyle.description(color: AppColors.appDescriptionColor,),
            hintText: 'Select delivery time',
            hintStyle: AppTextStyle.description(),

            // ✅ TRANSPARENT BACKGROUND
            filled: true,
            fillColor: Colors.white.withOpacity(0.01),

            // ✅ NORMAL BORDER COLOR
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.appDescriptionColor, // ✅ YOUR BORDER COLOR
                width: 1,
              ),
            ),

            // ✅ FOCUSED BORDER COLOR
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.appDescriptionColor, // focus color
                width: 1.5,
              ),
            ),

            // ✅ DEFAULT BORDER (Fallback)
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
              value: selectedDeliveryTimeList,
              icon: Icon(
                FeatherIcons.chevronDown,
                color: AppColors.appIconColor,
              ),
              style: AppTextStyle.description(
                color: AppColors.appTitleColor,
              ),
              items: deliveryTimeList.map((String value) {
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
                'Select delivery time',
                style: AppTextStyle.description(
                  color: AppColors.appTitleColor,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedDeliveryTimeList = value!;
                });
              },
            ),
          ),
        );
      },
    );
  }
  Widget revisionTimeDropdown() {
    return FormField<String>(
      builder: (FormFieldState<String> field) {
        return InputDecorator(
          decoration: kInputDecoration.copyWith(
            labelText: 'Revisions (optional)',
            labelStyle:
            AppTextStyle.description(color: AppColors.appDescriptionColor,),
            hintText: 'Select revisions',
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
              value: selectedRevisionTime, // ✅ apna variable
              icon: Icon(
                FeatherIcons.chevronDown,
                color: AppColors.appIconColor,
              ),
              style: AppTextStyle.description(
                color: AppColors.appTitleColor,
              ),
              items: revisionTime.map((String value) {
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
                'Select revisions',
                style: AppTextStyle.description(
                  color: AppColors.appTitleColor,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  selectedRevisionTime = value!;
                });
              },
            ),
          ),
        );
      },
    );
  }



}
