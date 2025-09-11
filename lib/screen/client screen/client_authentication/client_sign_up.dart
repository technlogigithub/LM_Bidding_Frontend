// import 'package:country_code_picker/country_code_picker.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_log_in.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../app_config/app_config.dart';
import '../../widgets/constant.dart';
import '../../widgets/icons.dart';
import 'client_otp_verification.dart';

class ClientSignUp extends StatefulWidget {
  const ClientSignUp({super.key});

  @override
  State<ClientSignUp> createState() => _ClientSignUpState();
}

class _ClientSignUpState extends State<ClientSignUp> {
  bool hidePassword = true;
  bool isCheck = true;
  static Future<dynamic> signUpApi(String mobileNo, String password) async {
    try {
      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}api/login"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer <your_token_here>", 
        },
        body: jsonEncode({
          "mobile_no": mobileNo,
          "password": "123456",
          "confirm_password": "123456",
     
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed: ${response.statusCode} ${response.body}");
      }
    } catch (e) {
      throw Exception("Login error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: kDarkWhite,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.0),
              bottomRight: Radius.circular(50.0),
            ),
          ),
          toolbarHeight: 180,
          flexibleSpace: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Icon(Icons.arrow_back),
                ),
              ),
              Center(
                child: Container(
                  height: 85,
                  width: 110,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(AppInfo.logo), fit: BoxFit.cover),
                  ),
                ),
              )
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    'Create a New Account',
                    style: kTextStyle.copyWith(
                        color: kNeutralColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0),
                  ),
                ),
                
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: kNeutralColor,
                  textInputAction: TextInputAction.next,
                  decoration: kInputDecoration.copyWith(
                      labelText: 'Phone',
                      labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                      hintText: 'Enter Mobile Number',
                      hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                      focusColor: kNeutralColor,
                      border: const OutlineInputBorder(),
                     
                      floatingLabelBehavior: FloatingLabelBehavior.always),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  cursorColor: kNeutralColor,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: hidePassword,
                  textInputAction: TextInputAction.done,
                  decoration: kInputDecoration.copyWith(
                    border: const OutlineInputBorder(),
                    labelText: 'Password*',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                    hintText: 'Please enter your password',
                    hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: kLightNeutralColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  cursorColor: kNeutralColor,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: hidePassword,
                  textInputAction: TextInputAction.done,
                  decoration: kInputDecoration.copyWith(
                    border: const OutlineInputBorder(),
                    labelText: 'Confirm Password*',
                    labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                    hintText: 'Please confirm your password',
                    hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: kLightNeutralColor,
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Checkbox(
                        activeColor: kPrimaryColor,
                        visualDensity: const VisualDensity(horizontal: -4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        value: isCheck,
                        onChanged: (value) {
                          setState(() {
                            isCheck = !isCheck;
                          });
                        }),
                    Flexible(
                      child: RichText(
                        text: TextSpan(
                          text: 'Yes, I understand and agree to the ',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                          children: [
                            TextSpan(
                              text: 'Terms of Service.',
                              style: kTextStyle.copyWith(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                ButtonGlobalWithoutIcon(
                    buttontext: 'Sign Up',
                    buttonDecoration: kButtonDecoration.copyWith(
                      color: kPrimaryColor,
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    onPressed: () {
                      const ClientOtpVerification(mobile: '').launch(context);
                    },
                    buttonTextColor: kWhite),
                const SizedBox(height: 20.0),
                Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: kBorderColorTextField,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                      child: Text(
                        'Or Sign up with',
                        style: kTextStyle.copyWith(color: kSubTitleColor),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        thickness: 1.0,
                        color: kBorderColorTextField,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: const [
                      SocialIcon(
                        bgColor: kNeutralColor,
                        iconColor: kWhite,
                        icon: FontAwesomeIcons.facebookF,
                        borderColor: Colors.transparent,
                      ),
                      SocialIcon(
                        bgColor: kWhite,
                        iconColor: kNeutralColor,
                        icon: FontAwesomeIcons.google,
                        borderColor: kBorderColorTextField,
                      ),
                      SocialIcon(
                        bgColor: kWhite,
                        iconColor: Color(0xFF76A9EA),
                        icon: FontAwesomeIcons.twitter,
                        borderColor: kBorderColorTextField,
                      ),
                      SocialIcon(
                        bgColor: kWhite,
                        iconColor: Color(0xFFFF554A),
                        icon: FontAwesomeIcons.instagram,
                        borderColor: kBorderColorTextField,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20.0),
                GestureDetector(
                  onTap: () => const ClientLogIn().launch(context),
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: 'Already have an account? ',
                        style: kTextStyle.copyWith(color: kLightNeutralColor),
                        children: [
                          TextSpan(
                            text: 'Log In',
                            style: kTextStyle.copyWith(
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
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
