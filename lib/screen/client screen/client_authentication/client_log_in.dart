import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../app_config/app_config.dart';
import '../../widgets/button_global.dart';
import '../../widgets/constant.dart';
import 'client_login_mobile.dart';
import 'client_otp_verification.dart';
import 'client_sign_up.dart';

class ClientLogIn extends StatefulWidget {
  const ClientLogIn({super.key});

  @override
  State<ClientLogIn> createState() => _ClientLogInState();
}

class _ClientLogInState extends State<ClientLogIn> {
  bool hidePassword = true;
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  bool isLoading = false;

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
   // initMobileNumber();
   // loadSavedCredentials();
  }

  Future<void> initMobileNumber() async {
  bool permissionGranted = await MobileNumber.hasPhonePermission;

  try {
    if (!permissionGranted) {
      await MobileNumber.requestPhonePermission;

    
      permissionGranted = await MobileNumber.hasPhonePermission;
    }

    if (permissionGranted) {
      String? simNumber = await MobileNumber.mobileNumber;
      if (simNumber != null && simNumber.isNotEmpty) {
        mobileCtrl.text = simNumber;
      }
    }
  } catch (e) {
    print("Cannot read SIM number: $e");
  }
}

  Future<void> loadSavedCredentials() async {
    String? savedMobile = await secureStorage.read(key: 'mobile');
    String? savedPassword = await secureStorage.read(key: 'password');

    if (savedMobile != null) mobileCtrl.text = savedMobile;
    if (savedPassword != null) passwordCtrl.text = savedPassword;
  }

  Future<void> saveCredentials() async {
    await secureStorage.write(key: 'mobile', value: mobileCtrl.text);
    await secureStorage.write(key: 'password', value: passwordCtrl.text);
  }

 
  void loginApiCall() async {
    if (mobileCtrl.text.isEmpty || passwordCtrl.text.isEmpty) {
      toast("Please enter mobile number and password");
      return;
    }

    setState(() => isLoading = true);

    try {
      final body = {
        "mobile_no": mobileCtrl.text,
        "password": passwordCtrl.text,
      };

      final response = await ApiService.postRequest("login-pin", body);
      print("Login Response: $response");

      toast("Login Successful");

      await saveCredentials();

      const ClientOtpVerification().launch(context);
    } catch (e) {
      print("Login Error: $e");
      toast("Login Failed: $e");
    } finally {
      setState(() => isLoading = false);
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
                  image: DecorationImage(
                      image: AssetImage(AppInfo.logo), fit: BoxFit.cover),
                ),
              ),
            ),
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
                  style: kTextStyle.copyWith(
                      color: kNeutralColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0),
                ),
              ),
              const SizedBox(height: 30.0),

              AutofillGroup(
                child: Column(
                  children: [
                    TextFormField(
                      controller: mobileCtrl,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      textInputAction: TextInputAction.next,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Mobile Number',
                        hintText: 'Enter your Mobile Number',
                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                        hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: hidePassword,
                      keyboardType: TextInputType.visiblePassword,
                      autofillHints: const [AutofillHints.password],
                      textInputAction: TextInputAction.done,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Password*',
                        hintText: 'Please enter your password',
                        labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                        hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() => hidePassword = !hidePassword);
                          },
                          icon: Icon(
                            hidePassword ? Icons.visibility_off : Icons.visibility,
                            color: kLightNeutralColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 5.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () => const ClientLogInMobile().launch(context),
                    child: Text(
                      'Login with OTP',
                      style: kTextStyle.copyWith(color: kLightNeutralColor),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              ButtonGlobalWithoutIcon(
                buttontext: isLoading ? "Logging In..." : 'Log In',
                buttonDecoration: kButtonDecoration.copyWith(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                 onPressed: isLoading ? null : loginApiCall,
                // onPressed:  ClientOtpVerification().launch(context),
                buttonTextColor: kWhite,
              ),
              const SizedBox(height: 20.0),
              const Divider(thickness: 1.0, color: kBorderColorTextField),
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
                          style: kTextStyle.copyWith(
                              color: kPrimaryColor, fontWeight: FontWeight.bold),
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
