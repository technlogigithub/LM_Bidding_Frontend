// import 'package:flutter/material.dart';
// import 'package:freelancer/screen/client%20screen/client%20home/client_home.dart';
// import 'package:freelancer/screen/widgets/button_global.dart';
// import 'package:pinput/pinput.dart';

// import '../../widgets/constant.dart';

// class ClientOtpVerification extends StatefulWidget {
//   const ClientOtpVerification({super.key});

//   @override
//   State<ClientOtpVerification> createState() => _ClientOtpVerificationState();
// }

// class _ClientOtpVerificationState extends State<ClientOtpVerification> {
//   final defaultPinTheme = const PinTheme(
//     width: 56,
//     height: 56,
//     textStyle: TextStyle(fontSize: 20, color: kNeutralColor, fontWeight: FontWeight.w600),
//   );

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: kWhite,
//       appBar: AppBar(
//         elevation: 0,
//         automaticallyImplyLeading: true,
//         iconTheme: const IconThemeData(color: kNeutralColor),
//         backgroundColor: kDarkWhite,
//         shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(50.0),
//             bottomRight: Radius.circular(50.0),
//           ),
//         ),
//         toolbarHeight: 80,
//         centerTitle: true,
//         title: Text(
//           'Verification',
//           style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Text(
//                 'We’ve the code send to your email-',
//                 style: kTextStyle.copyWith(color: kSubTitleColor),
//               ),
//               Text(
//                 'shadulislam@gmail.com',
//                 style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 20.0),
//               Pinput(
//                 defaultPinTheme: defaultPinTheme.copyWith(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: kBorderColorTextField),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 focusedPinTheme: defaultPinTheme.copyWith(
//                   decoration: BoxDecoration(
//                     border: Border.all(color: kNeutralColor),
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
//                 showCursor: true,
//               ),
//               const SizedBox(height: 20.0),
//               Text(
//                 '00:56',
//                 style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10.0),
//               RichText(
//                 text: TextSpan(
//                   text: 'Didn’t receive code? ',
//                   style: kTextStyle.copyWith(color: kSubTitleColor),
//                   children: [
//                     TextSpan(
//                       text: 'Resend Code',
//                       style: kTextStyle.copyWith(color: kPrimaryColor),
//                     ),
//                   ],
//                 ),
//               ),
//               const Spacer(),
//               ButtonGlobalWithoutIcon(
//                   buttontext: 'Send',
//                   buttonDecoration: kButtonDecoration.copyWith(
//                     color: kPrimaryColor,
//                     borderRadius: BorderRadius.circular(30.0),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>  const ClientHome(),
//                       ),
//                     );
//                   },
//                   buttonTextColor: kWhite),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:freelancer/screen/client%20screen/client%20home/client_home.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:freelancer/screen/app_config/api_config.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';

import '../../widgets/constant.dart';

class ClientOtpVerification extends StatefulWidget {
  final String mobile;

  const ClientOtpVerification({
    super.key,
    required this.mobile,
  });

  @override
  State<ClientOtpVerification> createState() => _ClientOtpVerificationState();
}

class _ClientOtpVerificationState extends State<ClientOtpVerification> {
  final defaultPinTheme = const PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20, color: kNeutralColor, fontWeight: FontWeight.w600),
  );
  final TextEditingController pinController = TextEditingController();

  bool isLoading = false;
  int _secondsRemaining = 56;
  Timer? _timer;
  bool isLoggedIn = false;

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    });
  }

  Future<void> saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);

    print("Auth Token Saved: $token");
  }

  void _submitOtp(BuildContext context, String pin) async {
    setState(() => isLoading = true);
    try {
      final body = {
        "mobile_no": widget.mobile,
        "otp": pin,
      };

      final response = await ApiService.postRequest("verify-otp", body);
      print("OTP Verification Response: $response");

      if (response['success'] == true) {
        final token = response['result']['token'];
        await saveAuthToken(token);
        final prefs = await SharedPreferences.getInstance();

        await prefs.setBool('isLoggedIn', true);

        setState(() {
          isLoggedIn = true;
        });
        toast(response['message'] ?? "OTP Verified Successfully");

        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const ClientHome()),
          (route) => false,
        );
      } else {
        if (response['status_code'] == 401) {
          toast("Invalid OTP");
        } else {
          toast(response['message'] ?? "Verification failed");
        }
      }
    } catch (e) {
      print("OTP Verification Error: $e");
      toast("OTP Verification Failed: $e");
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
    startTimer();
  }

  void startTimer() {
    _timer?.cancel();
    _secondsRemaining = 56;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: kNeutralColor),
        backgroundColor: kDarkWhite,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
        ),
        toolbarHeight: 80,
        centerTitle: true,
        title: Text(
          'Verification',
          style: kTextStyle.copyWith(
              color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'We’ve sent the code to your mobile number:',
                style: kTextStyle.copyWith(color: kSubTitleColor),
                textAlign: TextAlign.center,
              ),
              Text(
                widget.mobile,
                style: kTextStyle.copyWith(
                    color: kNeutralColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Pinput(
                length: 4,
                controller: pinController,
                defaultPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: kBorderColorTextField),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: kNeutralColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                showCursor: true,
                onCompleted: (pin) {
                  _submitOtp(context, pin);
                },
              ),
              const SizedBox(height: 20.0),
              Text(
                '${(_secondsRemaining ~/ 60).toString().padLeft(2, '0')}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}',
                style: kTextStyle.copyWith(
                    color: kNeutralColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              RichText(
                text: TextSpan(
                  text: 'Didn’t receive code? ',
                  style: kTextStyle.copyWith(color: kSubTitleColor),
                  children: [
                    WidgetSpan(
                      child: GestureDetector(
                        onTap: () {
                          // Call resend OTP API here
                          toast("Resend OTP clicked");
                        },
                        child: Text(
                          'Resend Code',
                          style: kTextStyle.copyWith(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              ButtonGlobalWithoutIcon(
                  buttontext: isLoading ? "Verifying..." : 'Send',
                  buttonDecoration: kButtonDecoration.copyWith(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  onPressed: isLoading
                      ? null
                      : () {
                          // Manually submit OTP if user presses button
                          toast("Please complete OTP field above");
                        },
                  buttonTextColor: kWhite),
            ],
          ),
        ),
      ),
    );
  }
}
