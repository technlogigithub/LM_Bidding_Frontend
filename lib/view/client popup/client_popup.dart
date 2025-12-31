import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../core/app_textstyle.dart';
import '../../widget/app_social_icons.dart';
import '../../widget/form_widgets/app_textfield.dart';
import '../Bottom_navigation_screen/Botom_navigation_screen.dart';


class ProcessingPopUp extends StatefulWidget {
  const ProcessingPopUp({super.key});

  @override
  State<ProcessingPopUp> createState() => _ProcessingPopUpState();
}

class _ProcessingPopUpState extends State<ProcessingPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 166,
              width: 208,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/robot.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            Text(
              'We’re processing\nyour Order',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyle.kTextStyle.copyWith(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,
                  fontSize: 18.0
              ),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Stay tuned...',
              maxLines: 2,
              textAlign: TextAlign.center,
              style: AppTextStyle.kTextStyle.copyWith(
                  color: AppColors.appTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UploadRequirementsPopUp extends StatefulWidget {
  const UploadRequirementsPopUp({super.key});

  @override
  State<UploadRequirementsPopUp> createState() => _UploadRequirementsPopUpState();
}

class _UploadRequirementsPopUpState extends State<UploadRequirementsPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Choose your Action',
                  style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appTextColor,
                      fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => finish(context),
                  child: Icon(FeatherIcons.x, color: AppColors.subTitleColor),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Icon(
                      FontAwesomeIcons.images,
                      color: AppColors.appColor,
                      size: 40,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Open Gallery',
                      style: AppTextStyle.kTextStyle.copyWith(
                          color: AppColors.appColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 20.0),
                Column(
                  children: [
                    Icon(
                      IconlyBold.document,
                      color: AppColors.textgrey,
                      size: 40,
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      'Open File',
                      style: AppTextStyle.kTextStyle.copyWith(
                          color: AppColors.appTextColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}

class UploadCompletePopUp extends StatefulWidget {
  const UploadCompletePopUp({super.key});

  @override
  State<UploadCompletePopUp> createState() => _UploadCompletePopUpState();
}

class _UploadCompletePopUpState extends State<UploadCompletePopUp> {
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
            Container(
              height: 186,
              width: 209,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(image: AssetImage("${AppImage.success}"), fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 15.0),
            Text(
              'Congratulations!',
              style: AppTextStyle.title(),
            ),
            const SizedBox(height: 10.0),
            Text(
              'Your profile is successfully completed. You can more changes after it\'s live.',
              style: AppTextStyle.description(color: AppColors.appBodyTextColor),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10.0),
            Button(
              containerBg: AppColors.appColor,
              borderColor: Colors.transparent,
              buttonText: 'Done',
              textColor: AppColors.appWhite,
              onPressed: () {
                BottomNavigationScreen().launch(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

class CancelJobPopUp extends StatefulWidget {
  const CancelJobPopUp({super.key});

  @override
  State<CancelJobPopUp> createState() => _CancelJobPopUpState();
}

class _CancelJobPopUpState extends State<CancelJobPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Are You Sure Cancel Your\nJob Post!',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyle.kTextStyle.copyWith(
                    color: AppColors.appTextColor,
                      fontWeight: FontWeight.bold
                  ),
                ),
                const Spacer(),
                Icon(
                  FeatherIcons.x,
                  color: AppColors.subTitleColor,
                )
              ],
            ),
            const SizedBox(height: 15.0),
            Text(
              'Lorem ipsum dolor sit amet conse ctetur. Nunc habitant felis pharetra nibh elementum ut.',
              style: AppTextStyle.kTextStyle.copyWith(
                  color: AppColors.textgrey,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: AppColors.appColor,
                    borderColor: redColor,
                    buttonText: 'No',
                    textColor: Colors.red,
                    onPressed: () {
                      setState(() {
                        finish(context);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: AppColors.appColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Yes',
                    textColor: AppColors.appWhite,
                    onPressed: () {
                      setState(() {
                        finish(context);
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class CancelOrderPopUp extends StatefulWidget {
  const CancelOrderPopUp({super.key});

  @override
  State<CancelOrderPopUp> createState() => _CancelOrderPopUpState();
}

class _CancelOrderPopUpState extends State<CancelOrderPopUp> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Why are you Cancelling?',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyle.kTextStyle.copyWith(
                color: AppColors.textgrey,fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 10.0),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: AppColors.kBorderColorTextField,
            ),
            const SizedBox(height: 20.0),
            CustomTextfield(
              label: 'Enter Reason',
              hintText: 'Lorem ipsum dolor sit amet, cons ectetur adipiscing elit.',),
            const SizedBox(height: 10.0),
            Row(
              children: [
                Expanded(
                  child: Button(
                    containerBg: AppColors.appWhite,
                    borderColor: redColor,
                    buttonText: 'Cancel',
                    textColor: Colors.red,
                    onPressed: () {
                      setState(() {
                        finish(context);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Button(
                    containerBg: AppColors.appColor,
                    borderColor: Colors.transparent,
                    buttonText: 'Confirm',
                    textColor: AppColors.appWhite,
                    onPressed: () {
                      setState(() {
                        finish(context);
                      });
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
