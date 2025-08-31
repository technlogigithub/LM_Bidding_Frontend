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
  //final String mobile;

  const ClientOtpVerification({
    super.key,
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

  bool isLoading = false;
  int _secondsRemaining = 56; // starting seconds
  Timer? _timer;
  void _submitOtp(String pin) async {
    setState(() => isLoading = true);
    try {
      final body = {
        // "mobile_no": widget.mobile,
        "mobile_no": 9977926348,
        "otp": pin,
      };

      final response = await ApiService.postRequest("verify-otp", body);
      print("OTP Verification Response: $response");

      // Here you can check response status
      // For example, if(response['status'] == 'success') ...

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ClientHome()),
      );
      toast("OTP Verified Successfully");
    } catch (e) {
      print("OTP Verification Error: $e");
      toast("OTP Verification Failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
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
                // widget.mobile,
                '9977926348',
                style: kTextStyle.copyWith(
                    color: kNeutralColor, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20.0),
              Pinput(
                length: 4, // adjust OTP length
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
                  // _submitOtp(pin);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const ClientHome()),
                  );
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
