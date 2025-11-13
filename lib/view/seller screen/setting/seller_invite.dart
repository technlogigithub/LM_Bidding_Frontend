import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:libdding/core/app_color.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../core/app_constant.dart';
import '../../../widget/app_social_icons.dart';


class SellerInvite extends StatefulWidget {
  const SellerInvite({super.key});

  @override
  State<SellerInvite> createState() => _SellerInviteState();
}

class _SellerInviteState extends State<SellerInvite> {
  Future<void> _copyToClipboard(String code) async {
    await Clipboard.setData(ClipboardData(text: code));
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Code Copied'),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkWhite,
      appBar: AppBar(
        backgroundColor: AppColors.darkWhite,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.neutralColor),
        title: Text(
          'Invite',
          style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Container(
          padding: const EdgeInsets.only(
            left: 15.0,
            right: 15.0,
          ),
          width: context.width(),
          height: context.height(),
          decoration: BoxDecoration(
            color: AppColors.appWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20.0),
                Container(
                  height: 120,
                  width: 120,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(image: AssetImage('images/refer.png'), fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 30.0),
                Text(
                  'Refer a friend',
                  style: kTextStyle.copyWith(color: AppColors.neutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Share your code with 4 friends. When they use it for the first login, you and your friends earn \$10.00',
                  style: kTextStyle.copyWith(color: AppColors.textgrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        height: 60,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.kBorderColorTextField),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            bottomLeft: Radius.circular(8.0),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'AHDJAEL2021RV1',
                              style: kTextStyle.copyWith(color: AppColors.subTitleColor, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          _copyToClipboard('AHDJAEL2021RV1');
                        },
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.appColor,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(8.0),
                              bottomRight: Radius.circular(8.0),
                            ),
                          ),
                          child: Icon(
                            FeatherIcons.copy,
                            color: AppColors.appWhite,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: AppColors.kBorderColorTextField,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        'Or',
                        style: kTextStyle.copyWith(color: AppColors.subTitleColor),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: AppColors.kBorderColorTextField,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SocialIcon(
                        bgColor: AppColors.neutralColor,
                        iconColor: AppColors.appWhite,
                        icon: FontAwesomeIcons.facebookF,
                        borderColor: Colors.transparent,
                      ),
                      SocialIcon(
                        bgColor: AppColors.appWhite,
                        iconColor: AppColors.neutralColor,
                        icon: FontAwesomeIcons.google,
                        borderColor: AppColors.kBorderColorTextField,
                      ),
                      SocialIcon(
                        bgColor: AppColors.appWhite,
                        iconColor: Color(0xFF76A9EA),
                        icon: FontAwesomeIcons.twitter,
                        borderColor: AppColors.kBorderColorTextField,
                      ),
                      SocialIcon(
                        bgColor: AppColors.appWhite,
                        iconColor: Color(0xFFFF554A),
                        icon: FontAwesomeIcons.instagram,
                        borderColor: AppColors.kBorderColorTextField,
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
}
