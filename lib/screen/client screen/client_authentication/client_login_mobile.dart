import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_log_in.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_otp_verification.dart';
import 'package:freelancer/screen/client%20screen/client_authentication/client_sign_up.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../app_config/app_config.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';

class ClientLogInMobile extends StatefulWidget {
  const ClientLogInMobile({super.key});

  @override
  State<ClientLogInMobile> createState() => _ClientLogInMobileState();
}

class _ClientLogInMobileState extends State<ClientLogInMobile> {
  bool hidePassword = false;

final  TextEditingController mobileController=TextEditingController();


static Future<void> loginWithOtp(BuildContext context, String mobileNo) async {
  try {
    final response = await ApiService.postRequest(
      "login",
      {
        "mobile_no": mobileNo,
      },
    );

    print("Login Response: $response");

    final otp = response['result']['otp'];

    toast("OTP: $otp");

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ClientOtpVerification(mobile: mobileNo,)),
    );
  } catch (e) {
    print("Login error: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Login failed: $e")),
    );
  }
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  image: DecorationImage(image: AssetImage(AppInfo.logo), fit: BoxFit.cover),
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
              const SizedBox(height: 20.0),
              Center(
                child: Text(
                  'Log In Your Account',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 30.0),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: mobileController,
                cursorColor: kNeutralColor,
                textInputAction: TextInputAction.next,
                decoration: kInputDecoration.copyWith(
                  labelText: 'Mobile Number',
                  labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                  hintText: 'Enter your Mobile Number',
                  hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                  focusColor: kNeutralColor,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20.0),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => const ClientLogIn().launch(context),
                    child: Text(
                      'Login with Password',
                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ButtonGlobalWithoutIcon(
                  buttontext: 'Log In',
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: () {
                    // const ClientOtpVerification().launch(context);
                     loginWithOtp(context,mobileController.text);
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
                  
                ],
              ),
              
              const SizedBox(height: 20.0),
              Center(
                child: GestureDetector(
                   onTap: () => const ClientSignUp().launch(context),
                  
                  child: RichText(
                    text: TextSpan(
                      text: 'Don’t have an account? ',
                      style: kTextStyle.copyWith(color: kSubTitleColor),
                      children: [
                        TextSpan(
                          text: 'Create New Account',
                          style: kTextStyle.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
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
    );
  }
}
