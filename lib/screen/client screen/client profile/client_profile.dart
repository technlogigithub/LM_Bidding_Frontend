// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:freelancer/screen/seller%20screen/seller%20popUp/seller_popup.dart';
// import 'package:freelancer/screen/widgets/button_global.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import '../../widgets/constant.dart';
// import '../../widgets/data.dart';

// class ClientProfile extends StatefulWidget {
//   const ClientProfile({super.key});

//   @override
//   State<ClientProfile> createState() => _ClientProfileState();
// }

// class _ClientProfileState extends State<ClientProfile> {
//   PageController pageController = PageController(initialPage: 0);
//   int currentIndexPage = 0;
//   double percent = 33.3;

//   //__________Language List_____________________________________________________
//   DropdownButton<String> getLanguage() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in language) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       icon: const Icon(FeatherIcons.chevronDown),
//       items: dropDownItems,
//       value: selectedLanguage,
//       style: kTextStyle.copyWith(color: kSubTitleColor),
//       onChanged: (value) {
//         setState(() {
//           selectedLanguage = value!;
//         });
//       },
//     );
//   }

//   //__________gender____________________________________________________________
//   DropdownButton<String> getGender() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in gender) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       icon: const Icon(FeatherIcons.chevronDown),
//       items: dropDownItems,
//       value: selectedGender,
//       style: kTextStyle.copyWith(color: kSubTitleColor),
//       onChanged: (value) {
//         setState(() {
//           selectedGender = value!;
//         });
//       },
//     );
//   }

//   //__________language level___________________________________________________
//   DropdownButton<String> getLevel() {
//     List<DropdownMenuItem<String>> dropDownItems = [];
//     for (String des in languageLevel) {
//       var item = DropdownMenuItem(
//         value: des,
//         child: Text(des),
//       );
//       dropDownItems.add(item);
//     }
//     return DropdownButton(
//       icon: const Icon(FeatherIcons.chevronDown),
//       items: dropDownItems,
//       value: selectedLanguageLevel,
//       style: kTextStyle.copyWith(color: kSubTitleColor),
//       onChanged: (value) {
//         setState(() {
//           selectedLanguageLevel = value!;
//         });
//       },
//     );
//   }

//   //__________Add_Language popup________________________________________________
//   void showLanguagePopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, void Function(void Function()) setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: const SellerAddLanguagePopUp(),
//             );
//           },
//         );
//       },
//     );
//   }

//   //__________Add_Skill popup________________________________________________
//   void showSkillPopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, void Function(void Function()) setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: const SellerAddSkillPopUp(),
//             );
//           },
//         );
//       },
//     );
//   }

//   //__________Import_Profile_picture_popup________________________________________________
//   void showImportProfilePopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, void Function(void Function()) setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8.0),
//               ),
//               child: const ImportImagePopUp(),
//             );
//           },
//         );
//       },
//     );
//   }

//   //__________Save_Profile_success_popup________________________________________________
//   void saveProfilePopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (BuildContext context, void Function(void Function()) setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: const SaveProfilePopUp(),
//             );
//           },
//         );
//       },
//     );
//   }

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
//           'Setup Profile',
//           style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: PageView.builder(
//         itemCount: 3,
//         physics: const PageScrollPhysics(),
//         controller: pageController,
//         onPageChanged: (int index) => setState(() => currentIndexPage = index),
//         itemBuilder: (_, i) {
//           return Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: SingleChildScrollView(
//               physics: const BouncingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         currentIndexPage == 0
//                             ? 'Step 1 of 3'
//                             : currentIndexPage == 1
//                                 ? 'Step 2 of 3'
//                                 : 'Step 3 of 3',
//                         style: kTextStyle.copyWith(color: kNeutralColor),
//                       ),
//                       const SizedBox(width: 10.0),
//                       Expanded(
//                         child: StepProgressIndicator(
//                           totalSteps: 3,
//                           currentStep: currentIndexPage + 1,
//                           size: 8,
//                           padding: 0,
//                           selectedColor: kPrimaryColor,
//                           unselectedColor: kPrimaryColor.withOpacity(0.2),
//                           roundedEdges: const Radius.circular(10),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 20.0),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'Uplaod Your Photo',
//                         style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 10.0),
//                       Center(
//                         child: Stack(
//                           alignment: Alignment.bottomRight,
//                           children: [
//                             Container(
//                               height: 120,
//                               width: 120,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 border: Border.all(color: kPrimaryColor),
//                               ),
//                               child: const Icon(IconlyBold.profile, color: kBorderColorTextField, size: 68),
//                             ),
//                             GestureDetector(
//                               onTap: () {
//                                 showImportProfilePopUp();
//                               },
//                               child: Container(
//                                 padding: const EdgeInsets.all(5),
//                                 decoration: BoxDecoration(
//                                   color: kWhite,
//                                   shape: BoxShape.circle,
//                                   border: Border.all(color: kPrimaryColor),
//                                 ),
//                                 child: const Icon(
//                                   IconlyBold.camera,
//                                   color: kPrimaryColor,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 30.0),
//                       TextFormField(
//                         keyboardType: TextInputType.name,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'User Name',
//                           labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                           hintText: 'Enter user name',
//                           hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         keyboardType: TextInputType.emailAddress,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           hintText: 'Enter Phone No.',
//                           hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                           // prefixIcon: CountryCodePicker(
//                           //   padding: EdgeInsets.zero,
//                           //   onChanged: print,
//                           //   initialSelection: 'BD',
//                           //   showFlag: true,
//                           //   showDropDownButton: true,
//                           //   alignLeft: false,
//                           // ),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         keyboardType: TextInputType.name,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Country',
//                           labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                           hintText: 'Enter Country Name',
//                           hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         keyboardType: TextInputType.name,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Street Address (won’t show on profile)',
//                           labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                           hintText: 'Enter street address',
//                           hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         keyboardType: TextInputType.name,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'City',
//                           labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                           hintText: 'Enter city',
//                           hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         keyboardType: TextInputType.name,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'State',
//                           labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                           hintText: 'Enter state',
//                           hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         keyboardType: TextInputType.name,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'ZIP/Postal Code',
//                           labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                           hintText: 'Enter zip/post code',
//                           hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       FormField(
//                         builder: (FormFieldState<dynamic> field) {
//                           return InputDecorator(
//                             decoration: InputDecoration(
//                               enabledBorder: const OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(8.0),
//                                 ),
//                                 borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                               ),
//                               contentPadding: const EdgeInsets.all(7.0),
//                               floatingLabelBehavior: FloatingLabelBehavior.always,
//                               labelText: 'Select Language',
//                               labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                             ),
//                             child: DropdownButtonHideUnderline(child: getLanguage()),
//                           );
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       FormField(
//                         builder: (FormFieldState<dynamic> field) {
//                           return InputDecorator(
//                             decoration: kInputDecoration.copyWith(
//                               enabledBorder: const OutlineInputBorder(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(8.0),
//                                 ),
//                                 borderSide: BorderSide(color: kBorderColorTextField, width: 2),
//                               ),
//                               contentPadding: const EdgeInsets.all(7.0),
//                               floatingLabelBehavior: FloatingLabelBehavior.always,
//                               labelText: 'Select Gender',
//                               labelStyle: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                             ),
//                             child: DropdownButtonHideUnderline(child: getGender()),
//                           );
//                         },
//                       ),
//                     ],
//                   ).visible(currentIndexPage == 0),
//                   Column(
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           setState(() {
//                             showLanguagePopUp();
//                           });
//                         },
//                         child: Row(
//                           children: [
//                             Text(
//                               'Languages',
//                               style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                             ),
//                             const Spacer(),
//                             const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
//                             const SizedBox(width: 5.0),
//                             Text(
//                               'Add New',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                             ),
//                           ],
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       const InfoShowCase(
//                         title: 'English',
//                         subTitle: 'Fluent',
//                       ),
//                       const SizedBox(height: 20.0),
//                       const InfoShowCase(
//                         title: 'Bengali',
//                         subTitle: 'Fluent',
//                       ),
//                       const SizedBox(height: 30.0),
//                       Row(
//                         children: [
//                           Text(
//                             'Skills',
//                             style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const Spacer(),
//                           const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
//                           const SizedBox(width: 5.0),
//                           GestureDetector(
//                             onTap: () {
//                               setState(() {
//                                 showSkillPopUp();
//                               });
//                             },
//                             child: Text(
//                               'Add New',
//                               style: kTextStyle.copyWith(color: kSubTitleColor),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20.0),
//                       const InfoShowCase(
//                         title: 'Ui Design',
//                         subTitle: 'Expert',
//                       ),
//                       const SizedBox(height: 20.0),
//                       const InfoShowCase(
//                         title: 'Visual Design',
//                         subTitle: 'Expert',
//                       ),
//                       const SizedBox(height: 30.0),
//                       Row(
//                         children: [
//                           Text(
//                             'Education',
//                             style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const Spacer(),
//                           const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
//                           const SizedBox(width: 5.0),
//                           Text(
//                             'Add Education',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20.0),
//                       const InfoShowCase2(
//                         title: 'B.Sc. - grapich design',
//                         subTitle: 'Khilgaon model university, Bangladesh,, Bangladesh, Graduated 2018',
//                       ),
//                       const SizedBox(height: 30.0),
//                       Row(
//                         children: [
//                           Text(
//                             'Certification',
//                             style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const Spacer(),
//                           const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
//                           const SizedBox(width: 5.0),
//                           Text(
//                             'Add Certification',
//                             style: kTextStyle.copyWith(color: kSubTitleColor),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 20.0),
//                       const InfoShowCase2(
//                         title: 'UI/UX Design',
//                         subTitle: 'Shikhbe Shobai Institute 2018',
//                       ),
//                     ],
//                   ).visible(currentIndexPage == 1),
//                   Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         'About Us',
//                         style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 15.0),
//                       TextFormField(
//                         keyboardType: TextInputType.multiline,
//                         maxLines: 8,
//                         cursorColor: kNeutralColor,
//                         textInputAction: TextInputAction.next,
//                         decoration: kInputDecoration.copyWith(
//                           hintText: 'Write a brief description about you..',
//                           hintStyle: kTextStyle.copyWith(color: kLightNeutralColor),
//                           focusColor: kNeutralColor,
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                     ],
//                   ).visible(currentIndexPage == 2),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//       bottomNavigationBar: ButtonGlobalWithoutIcon(
//           buttontext: currentIndexPage < 2 ? 'Continue' : 'Save Profile',
//           buttonDecoration: kButtonDecoration.copyWith(
//             color: kPrimaryColor,
//             borderRadius: BorderRadius.circular(30.0),
//           ),
//           onPressed: () {
//             currentIndexPage < 2;
//             currentIndexPage < 2 ? pageController.nextPage(duration: const Duration(microseconds: 3000), curve: Curves.bounceInOut) : saveProfilePopUp();
//           },
//           buttonTextColor: kWhite),
//     );
//   }
// } 
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../widgets/constant.dart';
import '../../widgets/button_global.dart';
import 'package:http/http.dart' as http;

class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile> {
  final PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;

  // ------------ Form Controllers ------------
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController passwordCtrl = TextEditingController();
  final TextEditingController passwordConfirmCtrl = TextEditingController();
  final TextEditingController aboutCtrl = TextEditingController();

  // Address Controllers
  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController streetCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController postalCtrl = TextEditingController();

  // Dropdown values
  String selectedGender = "Male";
  String selectedLanguage = "English";
  String selectedLevel = "Fluent";

  // Images
  File? profileImage;
  File? bannerImage;

  // ------------ Image Picker ------------

Future<void> pickImage(bool isProfile) async {
  final status = await Permission.photos.request();
  if (!status.isGranted) return;

  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked != null) {
    setState(() {
      if (isProfile) {
        profileImage = File(picked.path);
      } else {
        bannerImage = File(picked.path);
      }
    });
  }
}


  // ------------ API Call ------------
  Future<void> updateProfile() async {
    var url = Uri.parse("http://127.0.0.1:8000/api/profile/update");

    var request = http.MultipartRequest("POST", url);

    // ✅ Authorization Header
    request.headers['Authorization'] =
        "Bearer <your_token_here>";

    // ✅ Normal Fields (from form controllers)
    request.fields['name'] = nameCtrl.text;
    request.fields['email'] = emailCtrl.text;
    request.fields['mobile_no'] = mobileCtrl.text;
    request.fields['password'] = passwordCtrl.text;
    request.fields['password_confirmation'] = passwordConfirmCtrl.text;
    request.fields['gender'] = selectedGender;
    request.fields['language'] = selectedLanguage;
    request.fields['language_level'] = selectedLevel;
    request.fields['about'] = aboutCtrl.text;
    request.fields['user_type'] = "INDIVIDUAL";
    request.fields['status'] = "ACTIVE";

    // ✅ Industries Example
    request.fields['industries[]'] = "1";
    request.fields['industries[]'] = "2";

    // ✅ Address (Array of Objects)
    request.fields['addresses[0][address_type]'] = "billing";
    request.fields['addresses[0][address_line1]'] = streetCtrl.text;
    request.fields['addresses[0][city]'] = cityCtrl.text;
    request.fields['addresses[0][state]'] = stateCtrl.text;
    request.fields['addresses[0][country]'] = countryCtrl.text;
    request.fields['addresses[0][postal_code]'] = postalCtrl.text;
    request.fields['addresses[0][latitude]'] = "30.710280";
    request.fields['addresses[0][longitude]'] = "76.713115";
    request.fields['addresses[0][default_address]'] = "1";

    // ✅ File Uploads
    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'dp_image',
        profileImage!.path,
      ));
    }
    if (bannerImage != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'banner_image',
        bannerImage!.path,
      ));
    }

    // ✅ Send Request
    var response = await request.send();

    if (response.statusCode == 200) {
      final res = await response.stream.bytesToString();
      debugPrint("✅ Profile Updated Successfully: $res");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile Updated Successfully ✅")),
      );
    } else {
      final res = await response.stream.bytesToString();
      debugPrint("❌ Failed: ${response.statusCode}, $res");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed: $res")),
      );
    }
  }

  // ------------ UI Dropdown Helpers ------------
  DropdownButton<String> genderDropdown() {
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      value: selectedGender,
      items: ["Male", "Female", "Other"].map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: (val) => setState(() => selectedGender = val!),
    );
  }

  DropdownButton<String> languageDropdown() {
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      value: selectedLanguage,
      items: ["English", "Hindi", "Bengali"].map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: (val) => setState(() => selectedLanguage = val!),
    );
  }

  DropdownButton<String> levelDropdown() {
    return DropdownButton(
      icon: const Icon(FeatherIcons.chevronDown),
      value: selectedLevel,
      items: ["Fluent", "Intermediate", "Basic"].map((e) {
        return DropdownMenuItem(value: e, child: Text(e));
      }).toList(),
      onChanged: (val) => setState(() => selectedLevel = val!),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: kDarkWhite,
        centerTitle: true,
        title: Text("Setup Profile",
            style: kTextStyle.copyWith(
                color: kNeutralColor, fontWeight: FontWeight.bold)),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
      ),
      body: PageView.builder(
        itemCount: 3,
        controller: pageController,
        onPageChanged: (i) => setState(() => currentIndexPage = i),
        itemBuilder: (_, i) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Step Indicator
                  Row(
                    children: [
                      Text("Step ${i + 1} of 3",
                          style: kTextStyle.copyWith(color: kNeutralColor)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: StepProgressIndicator(
                          totalSteps: 3,
                          currentStep: i + 1,
                          selectedColor: kPrimaryColor,
                          unselectedColor: kPrimaryColor.withOpacity(0.2),
                          size: 8,
                          roundedEdges: const Radius.circular(10),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ---------------- Step 1 ----------------
                  if (i == 0) ...[
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: profileImage != null
                                ? FileImage(profileImage!)
                                : null,
                            child: profileImage == null
                                ? const Icon(IconlyBold.profile,
                                    size: 60, color: kBorderColorTextField)
                                : null,
                          ),
                          GestureDetector(
                            onTap: () => pickImage(true),
                            child: const CircleAvatar(
                              backgroundColor: kPrimaryColor,
                              child: Icon(Icons.camera_alt, color: kWhite),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: nameCtrl,
                      decoration:
                          kInputDecoration.copyWith(labelText: "Full Name"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: emailCtrl,
                      decoration:
                          kInputDecoration.copyWith(labelText: "Email"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: mobileCtrl,
                      decoration:
                          kInputDecoration.copyWith(labelText: "Mobile"),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordCtrl,
                      obscureText: true,
                      decoration:
                          kInputDecoration.copyWith(labelText: "Password"),
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordConfirmCtrl,
                      obscureText: true,
                      decoration: kInputDecoration.copyWith(
                          labelText: "Confirm Password"),
                    ),
                    const SizedBox(height: 15),
                    InputDecorator(
                        decoration: kInputDecoration.copyWith(
                            labelText: "Gender"),
                        child: genderDropdown()),
                  ],

                  // ---------------- Step 2 ----------------
                  if (i == 1) ...[
                    InputDecorator(
                        decoration: kInputDecoration.copyWith(
                            labelText: "Select Language"),
                        child: languageDropdown()),
                    const SizedBox(height: 15),
                    InputDecorator(
                        decoration: kInputDecoration.copyWith(
                            labelText: "Proficiency"),
                        child: levelDropdown()),
                  ],

                  // ---------------- Step 3 ----------------
                  if (i == 2) ...[
                    TextFormField(
                        controller: countryCtrl,
                        decoration: kInputDecoration.copyWith(
                            labelText: "Country")),
                    const SizedBox(height: 15),
                    TextFormField(
                        controller: streetCtrl,
                        decoration: kInputDecoration.copyWith(
                            labelText: "Street Address")),
                    const SizedBox(height: 15),
                    TextFormField(
                        controller: cityCtrl,
                        decoration:
                            kInputDecoration.copyWith(labelText: "City")),
                    const SizedBox(height: 15),
                    TextFormField(
                        controller: stateCtrl,
                        decoration:
                            kInputDecoration.copyWith(labelText: "State")),
                    const SizedBox(height: 15),
                    TextFormField(
                        controller: postalCtrl,
                        decoration: kInputDecoration.copyWith(
                            labelText: "ZIP/Postal Code")),
                    const SizedBox(height: 25),
                    Text("About You",
                        style: kTextStyle.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: aboutCtrl,
                      maxLines: 5,
                      decoration: kInputDecoration.copyWith(
                          hintText: "Write a brief description about you..."),
                    ),
                    const SizedBox(height: 20),
                    // Banner Image Picker
                    ElevatedButton.icon(
                      onPressed: () => pickImage(false),
                      icon: const Icon(Icons.image),
                      label: const Text("Pick Banner Image"),
                    ),
                    if (bannerImage != null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.file(bannerImage!, height: 120),
                      ),
                  ]
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: ButtonGlobalWithoutIcon(
        buttontext: currentIndexPage < 2 ? "Continue" : "Save Profile",
        buttonDecoration: kButtonDecoration.copyWith(
            color: kPrimaryColor,
            borderRadius: BorderRadius.circular(30.0)),
        buttonTextColor: kWhite,
        onPressed: () {
          if (currentIndexPage < 2) {
            pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          } else {
            updateProfile(); // ✅ Final API Call
          }
        },
      ),
    );
  }
}
