// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:freelancer/screen/seller%20screen/seller%20popUp/seller_popup.dart';
// import 'package:freelancer/screen/widgets/button_global.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../../widgets/constant.dart';
// import 'dart:convert';

// class SetupClientProfile extends StatefulWidget {
//   const SetupClientProfile({super.key});

//   @override
//   State<SetupClientProfile> createState() => _SetupClientProfileState();
// }

// class _SetupClientProfileState extends State<SetupClientProfile> {
//   PageController pageController = PageController(initialPage: 0);
//   int currentIndexPage = 0;
//   double percent = 33.3;

//   // Form controllers
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final TextEditingController _confirmPasswordController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//   final TextEditingController _streetAddressController = TextEditingController();
//   final TextEditingController _addressLine2Controller = TextEditingController();
//   final TextEditingController _landmarkController = TextEditingController();
//   final TextEditingController _cityController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _zipCodeController = TextEditingController();
//   final TextEditingController _latitudeController = TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();

//   // File variables for images
//   File? _dpImage;
//   File? _bannerImage;

//   // Dynamic lists
//   List<Map<String, String>> bankAccounts = [];
//   List<String> industries = [];

//   // Primary bank index
//   int primaryBankIndex = -1;

//   // Sample industry list (replace with actual data from your backend)
//   final List<String> availableIndustries = [
//     'Technology',
//     'Design',
//     'Marketing',
//     'Finance',
//     'Education',
//   ];

//   // API endpoint (replace with your actual endpoint)
//   final String apiUrl = 'https://your-api-endpoint.com/api/store';

//   // Image picker instance
//   final ImagePicker _picker = ImagePicker();

//   //__________Add/Edit Bank Account Popup_______________________________________
//   Future<Map<String, String>?> showBankAccountPopUp(
//       {Map<String, String>? existingBankAccount, int? index}) async {
//     final beneficiaryController =
//         TextEditingController(text: existingBankAccount?['beneficiary_name'] ?? '');
//     final accountNumberController =
//         TextEditingController(text: existingBankAccount?['account_number'] ?? '');
//     final ifscCodeController =
//         TextEditingController(text: existingBankAccount?['ifsc_code'] ?? '');
//     final upiAddressController =
//         TextEditingController(text: existingBankAccount?['upi_address'] ?? '');
//     bool isPrimary = index == primaryBankIndex;

//     return await showDialog<Map<String, String>>(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       existingBankAccount == null ? 'Add Bank Account' : 'Edit Bank Account',
//                       style: kTextStyle.copyWith(
//                           color: kNeutralColor, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextFormField(
//                       controller: beneficiaryController,
//                       decoration: kInputDecoration.copyWith(
//                         labelText: 'Beneficiary Name',
//                         hintText: 'Enter beneficiary name',
//                         border: const OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter beneficiary name';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextFormField(
//                       controller: accountNumberController,
//                       decoration: kInputDecoration.copyWith(
//                         labelText: 'Account Number',
//                         hintText: 'Enter account number',
//                         border: const OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter account number';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextFormField(
//                       controller: ifscCodeController,
//                       decoration: kInputDecoration.copyWith(
//                         labelText: 'IFSC Code',
//                         hintText: 'Enter IFSC code',
//                         border: const OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter IFSC code';
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextFormField(
//                       controller: upiAddressController,
//                       decoration: kInputDecoration.copyWith(
//                         labelText: 'UPI Address',
//                         hintText: 'Enter UPI address',
//                         border: const OutlineInputBorder(),
//                       ),
//                     ),
//                     const SizedBox(height: 20.0),
//                     CheckboxListTile(
//                       title: Text('Set as Primary',
//                           style: kTextStyle.copyWith(color: kNeutralColor)),
//                       value: isPrimary,
//                       onChanged: (value) {
//                         setState(() {
//                           isPrimary = value!;
//                           if (isPrimary) {
//                             this.setState(() {
//                               primaryBankIndex = index ?? bankAccounts.length;
//                             });
//                           } else if (index == primaryBankIndex) {
//                             this.setState(() {
//                               primaryBankIndex = -1;
//                             });
//                           }
//                         });
//                       },
//                     ),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text('Cancel',
//                               style: kTextStyle.copyWith(color: kSubTitleColor)),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             if (beneficiaryController.text.isNotEmpty &&
//                                 accountNumberController.text.isNotEmpty &&
//                                 ifscCodeController.text.isNotEmpty) {
//                               Navigator.pop(context, {
//                                 'beneficiary_name': beneficiaryController.text,
//                                 'account_number': accountNumberController.text,
//                                 'ifsc_code': ifscCodeController.text,
//                                 'upi_address': upiAddressController.text,
//                               });
//                             }
//                           },
//                           child: Text(
//                               existingBankAccount == null ? 'Add' : 'Update',
//                               style: kTextStyle.copyWith(color: kPrimaryColor)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   //__________Select Industries Popup___________________________________________
//   Future<List<String>?> showIndustriesPopUp({List<String>? selectedIndustries}) async {
//     List<String> tempSelected = List.from(selectedIndustries ?? []);
//     return await showDialog<List<String>>(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.0),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       'Select Industries',
//                       style: kTextStyle.copyWith(
//                           color: kNeutralColor, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20.0),
//                     ...availableIndustries.map((industry) {
//                       return CheckboxListTile(
//                         title: Text(industry,
//                             style: kTextStyle.copyWith(color: kNeutralColor)),
//                         value: tempSelected.contains(industry),
//                         onChanged: (value) {
//                           setState(() {
//                             if (value == true) {
//                               tempSelected.add(industry);
//                             } else {
//                               tempSelected.remove(industry);
//                             }
//                           });
//                         },
//                       );
//                     }),
//                     const SizedBox(height: 20.0),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.end,
//                       children: [
//                         TextButton(
//                           onPressed: () => Navigator.pop(context),
//                           child: Text('Cancel',
//                               style: kTextStyle.copyWith(color: kSubTitleColor)),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             Navigator.pop(context, tempSelected);
//                           },
//                           child: Text('Save',
//                               style: kTextStyle.copyWith(color: kPrimaryColor)),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   //__________Import Profile Picture Popup_______________________________________
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
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   ListTile(
//                     title: const Text('Pick Profile Image'),
//                     onTap: () async {
//                       final XFile? image =
//                           await _picker.pickImage(source: ImageSource.gallery);
//                       if (image != null) {
//                         setState(() {
//                           _dpImage = File(image.path);
//                         });
//                       }
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     title: const Text('Pick Banner Image'),
//                     onTap: () async {
//                       final XFile? image =
//                           await _picker.pickImage(source: ImageSource.gallery);
//                       if (image != null) {
//                         setState(() {
//                           _bannerImage = File(image.path);
//                         });
//                       }
//                       Navigator.pop(context);
//                     },
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   //__________Save Profile Success Popup________________________________________
//   void saveProfilePopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: const SaveProfilePopUp(),
//         );
//       },
//     );
//   }

//   //__________Submit to API____________________________________________________
//   Future<void> submitProfile() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

//       // Add text fields
//       request.fields['name'] = _nameController.text;
//       request.fields['email'] = _emailController.text;
//       request.fields['mobile'] = _mobileController.text;
//       request.fields['password'] = _passwordController.text;
//       request.fields['password_confirmation'] = _confirmPasswordController.text;
//       request.fields['user_type'] = 'client';
//       request.fields['status'] = 'active';

//       // Add address
//       request.fields['addresses[0][address_type]'] = 'primary';
//       request.fields['addresses[0][address_line1]'] = _streetAddressController.text;
//       request.fields['addresses[0][address_line2]'] = _addressLine2Controller.text;
//       request.fields['addresses[0][landmark]'] = _landmarkController.text;
//       request.fields['addresses[0][city]'] = _cityController.text;
//       request.fields['addresses[0][state]'] = _stateController.text;
//       request.fields['addresses[0][country]'] = _countryController.text;
//       request.fields['addresses[0][postal_code]'] = _zipCodeController.text;
//       request.fields['addresses[0][latitude]'] = _latitudeController.text;
//       request.fields['addresses[0][longitude]'] = _longitudeController.text;
//       request.fields['default_address_index'] = '0';

//       // Add bank accounts
//       bankAccounts.asMap().forEach((index, bank) {
//         request.fields['bank_accounts[$index][beneficiary_name]'] = bank['beneficiary_name']!;
//         request.fields['bank_accounts[$index][account_number]'] = bank['account_number']!;
//         request.fields['bank_accounts[$index][ifsc_code]'] = bank['ifsc_code']!;
//         request.fields['bank_accounts[$index][upi_address]'] = bank['upi_address'] ?? '';
//       });
//       request.fields['primary_bank_index'] = primaryBankIndex.toString();

//       // Add industries
//       industries.asMap().forEach((index, industry) {
//         request.fields['industries[$index]'] = industry;
//       });

//       // Add images
//       if (_dpImage != null) {
//         request.files.add(await http.MultipartFile.fromPath('dp_image', _dpImage!.path));
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Profile image is required')),
//         );
//         return;
//       }
//       if (_bannerImage != null) {
//         request.files.add(await http.MultipartFile.fromPath('banner_image', _bannerImage!.path));
//       }

//       // Send request
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         saveProfilePopUp();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to save profile: ${response.statusCode}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//     }
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
//       body: Form(
//         key: _formKey,
//         child: PageView.builder(
//           itemCount: 3,
//           physics: const PageScrollPhysics(),
//           controller: pageController,
//           onPageChanged: (int index) => setState(() {
//             currentIndexPage = index;
//             percent = 33.3 * (index + 1);
//           }),
//           itemBuilder: (_, i) {
//             return Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SingleChildScrollView(
//                 physics: const BouncingScrollPhysics(),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           currentIndexPage == 0
//                               ? 'Step 1 of 3'
//                               : currentIndexPage == 1
//                                   ? 'Step 2 of 3'
//                                   : 'Step 3 of 3',
//                           style: kTextStyle.copyWith(color: kNeutralColor),
//                         ),
//                         const SizedBox(width: 10.0),
//                         Expanded(
//                           child: StepProgressIndicator(
//                             totalSteps: 3,
//                             currentStep: currentIndexPage + 1,
//                             size: 8,
//                             padding: 0,
//                             selectedColor: kPrimaryColor,
//                             unselectedColor: kPrimaryColor.withOpacity(0.2),
//                             roundedEdges: const Radius.circular(10),
//                           ),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 20.0),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Upload Your Photo',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10.0),
//                         Center(
//                           child: Stack(
//                             alignment: Alignment.bottomRight,
//                             children: [
//                               Container(
//                                 height: 120,
//                                 width: 120,
//                                 decoration: BoxDecoration(
//                                   shape: BoxShape.circle,
//                                   border: Border.all(color: kPrimaryColor),
//                                   image: _dpImage != null
//                                       ? DecorationImage(
//                                           image: FileImage(_dpImage!),
//                                           fit: BoxFit.cover,
//                                         )
//                                       : null,
//                                 ),
//                                 child: _dpImage == null
//                                     ? const Icon(IconlyBold.profile,
//                                         color: kBorderColorTextField, size: 68)
//                                     : null,
//                               ),
//                               GestureDetector(
//                                 onTap: () {
//                                   showImportProfilePopUp();
//                                 },
//                                 child: Container(
//                                   padding: const EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                     color: kWhite,
//                                     shape: BoxShape.circle,
//                                     border: Border.all(color: kPrimaryColor),
//                                   ),
//                                   child: const Icon(
//                                     IconlyBold.camera,
//                                     color: kPrimaryColor,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         const SizedBox(height: 30.0),
//                         TextFormField(
//                           controller: _nameController,
//                           keyboardType: TextInputType.name,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'User Name',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Enter user name',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your name';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Email',
//                             hintText: 'Enter email',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your email';
//                             }
//                             if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                                 .hasMatch(value)) {
//                               return 'Please enter a valid email';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _mobileController,
//                           keyboardType: TextInputType.phone,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Phone Number',
//                             hintText: 'Enter Phone No.',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your phone number';
//                             }
//                             if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                               return 'Please enter a valid 10-digit phone number';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _countryController,
//                           keyboardType: TextInputType.name,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Country',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Enter Country Name',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your country';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _streetAddressController,
//                           keyboardType: TextInputType.streetAddress,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Street Address (won’t show on profile)',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Enter street address',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your street address';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _addressLine2Controller,
//                           keyboardType: TextInputType.streetAddress,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Address Line 2',
//                             hintText: 'Enter additional address details',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _landmarkController,
//                           keyboardType: TextInputType.text,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Landmark',
//                             hintText: 'Enter landmark',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _cityController,
//                           keyboardType: TextInputType.name,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'City',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Enter city',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your city';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _stateController,
//                           keyboardType: TextInputType.name,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'State',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Enter state',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your state';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _zipCodeController,
//                           keyboardType: TextInputType.number,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'ZIP/Postal Code',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Enter zip/post code',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter your ZIP/Postal code';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _latitudeController,
//                           keyboardType: TextInputType.number,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Latitude',
//                             hintText: 'Enter latitude (-90 to 90)',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value != null && value.isNotEmpty) {
//                               final numValue = double.tryParse(value);
//                               if (numValue == null || numValue < -90 || numValue > 90) {
//                                 return 'Please enter a valid latitude (-90 to 90)';
//                               }
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _longitudeController,
//                           keyboardType: TextInputType.number,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Longitude',
//                             hintText: 'Enter longitude (-180 to 180)',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value != null && value.isNotEmpty) {
//                               final numValue = double.tryParse(value);
//                               if (numValue == null || numValue < -180 || numValue > 180) {
//                                 return 'Please enter a valid longitude (-180 to 180)';
//                               }
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _passwordController,
//                           keyboardType: TextInputType.text,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.next,
//                           obscureText: true,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Password',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Enter password',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please enter a password';
//                             }
//                             if (value.length < 6) {
//                               return 'Password must be at least 6 characters';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _confirmPasswordController,
//                           keyboardType: TextInputType.text,
//                           cursorColor: kNeutralColor,
//                           textInputAction: TextInputAction.done,
//                           obscureText: true,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Confirm Password',
//                             labelStyle: kTextStyle.copyWith(color: kNeutralColor),
//                             hintText: 'Confirm your password',
//                             hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
//                             focusColor: kNeutralColor,
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Please confirm your password';
//                             }
//                             if (value != _passwordController.text) {
//                               return 'Passwords do not match';
//                             }
//                             return null;
//                           },
//                         ),
//                       ],
//                     ).visible(currentIndexPage == 0),
//                     Column(
//                       children: [
//                         Row(
//                           children: [
//                             Text(
//                               'Bank Accounts',
//                               style: kTextStyle.copyWith(
//                                   color: kNeutralColor, fontWeight: FontWeight.bold),
//                             ),
//                             const Spacer(),
//                             const Icon(FeatherIcons.plusCircle,
//                                 color: kSubTitleColor, size: 18.0),
//                             const SizedBox(width: 5.0),
//                             GestureDetector(
//                               onTap: () async {
//                                 final result = await showBankAccountPopUp();
//                                 if (result != null) {
//                                   setState(() {
//                                     bankAccounts.add(result);
//                                   });
//                                 }
//                               },
//                               child: Text(
//                                 'Add New',
//                                 style: kTextStyle.copyWith(color: kSubTitleColor),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20.0),
//                         ...bankAccounts.asMap().entries.map((entry) {
//                           int index = entry.key;
//                           Map<String, String> bank = entry.value;
//                           return Column(
//                             children: [
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: InfoShowCase(
//                                       title: bank['beneficiary_name']!,
//                                       subTitle:
//                                           '${bank['account_number']} ${bank['ifsc_code']} ${bank['upi_address'] ?? ''}',
//                                       onEdit: () async {
//                                         final result = await showBankAccountPopUp(
//                                             existingBankAccount: bank, index: index);
//                                         if (result != null) {
//                                           setState(() {
//                                             bankAccounts[index] = result;
//                                           });
//                                         }
//                                       },
//                                       onDelete: () {
//                                         setState(() {
//                                           if (index == primaryBankIndex) {
//                                             primaryBankIndex = -1;
//                                           } else if (index < primaryBankIndex) {
//                                             primaryBankIndex--;
//                                           }
//                                           bankAccounts.removeAt(index);
//                                         });
//                                       },
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 20.0),
//                             ],
//                           );
//                         }),
//                         const SizedBox(height: 10.0),
//                         Row(
//                           children: [
//                             Text(
//                               'Industries',
//                               style: kTextStyle.copyWith(
//                                   color: kNeutralColor, fontWeight: FontWeight.bold),
//                             ),
//                             const Spacer(),
//                             const Icon(FeatherIcons.plusCircle,
//                                 color: kSubTitleColor, size: 18.0),
//                             const SizedBox(width: 5.0),
//                             GestureDetector(
//                               onTap: () async {
//                                 final result = await showIndustriesPopUp(selectedIndustries: industries);
//                                 if (result != null) {
//                                   setState(() {
//                                     industries = result;
//                                   });
//                                 }
//                               },
//                               child: Text(
//                                 'Add New',
//                                 style: kTextStyle.copyWith(color: kSubTitleColor),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20.0),
//                         Wrap(
//                           spacing: 10.0,
//                           children: industries.map((industry) {
//                             return Chip(
//                               label: Text(industry,
//                                   style: kTextStyle.copyWith(color: kNeutralColor)),
//                               onDeleted: () {
//                                 setState(() {
//                                   industries.remove(industry);
//                                 });
//                               },
//                               deleteIcon: const Icon(FeatherIcons.x, size: 18.0),
//                             );
//                           }).toList(),
//                         ),
//                       ],
//                     ).visible(currentIndexPage == 1),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Review Your Profile',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 15.0),
//                         Text(
//                           'Please review all details before saving.',
//                           style: kTextStyle.copyWith(color: kSubTitleColor),
//                         ),
//                       ],
//                     ).visible(currentIndexPage == 2),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//       bottomNavigationBar: ButtonGlobalWithoutIcon(
//         buttontext: currentIndexPage < 2 ? 'Continue' : 'Save Profile',
//         buttonDecoration: kButtonDecoration.copyWith(
//           color: kPrimaryColor,
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         onPressed: () {
//           if (currentIndexPage < 2) {
//             if (currentIndexPage == 0 && !_formKey.currentState!.validate()) {
//               return;
//             }
//             pageController.nextPage(
//               duration: const Duration(milliseconds: 300),
//               curve: Curves.bounceInOut,
//             );
//           } else {
//             submitProfile();
//           }
//         },
//         buttonTextColor: kWhite,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _emailController.dispose();
//     _mobileController.dispose();
//     _passwordController.dispose();
//     _confirmPasswordController.dispose();
//     _countryController.dispose();
//     _streetAddressController.dispose();
//     _addressLine2Controller.dispose();
//     _landmarkController.dispose();
//     _cityController.dispose();
//     _stateController.dispose();
//     _zipCodeController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     pageController.dispose();
//     super.dispose();
//   }
// }

// // Placeholder for InfoShowCase widget (assuming it exists in your codebase)
// class InfoShowCase extends StatelessWidget {
//   final String title;
//   final String subTitle;
//   final VoidCallback onEdit;
//   final VoidCallback onDelete;

//   const InfoShowCase({
//     super.key,
//     required this.title,
//     required this.subTitle,
//     required this.onEdit,
//     required this.onDelete,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(title, style: kTextStyle.copyWith(color: kNeutralColor)),
//       subtitle: Text(subTitle, style: kTextStyle.copyWith(color: kSubTitleColor)),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           IconButton(
//             icon: const Icon(FeatherIcons.edit, color: kPrimaryColor),
//             onPressed: onEdit,
//           ),
//           IconButton(
//             icon: const Icon(FeatherIcons.trash, color: kPrimaryColor),
//             onPressed: onDelete,
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/seller%20screen/seller%20popUp/seller_popup.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:freelancer/screen/widgets/data.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/constant.dart';
import 'dart:convert';

class SetupClientProfile extends StatefulWidget {
  const SetupClientProfile({super.key});

  @override
  State<SetupClientProfile> createState() => _SetupClientProfileState();
}

class _SetupClientProfileState extends State<SetupClientProfile> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  double percent = 33.3;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _streetAddressController = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _zipCodeController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();

  // File variables for images
  File? _dpImage;
  File? _bannerImage;

  // Dynamic lists
  List<Map<String, String>> bankAccounts = [];
  List<String> industries = [];

  // Primary bank index
  int primaryBankIndex = -1;

  // Sample industry list (replace with actual data from your backend)
  final List<String> availableIndustries = [
    'Technology',
    'Design',
    'Marketing',
    'Finance',
    'Education',
  ];

  // API endpoint (replace with your actual endpoint)
  final String apiUrl = 'https://your-api-endpoint.com/api/store';

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  //__________Add/Edit Bank Account Popup_______________________________________
  Future<Map<String, String>?> showBankAccountPopUp(
      {Map<String, String>? existingBankAccount, int? index}) async {
    final beneficiaryController =
        TextEditingController(text: existingBankAccount?['beneficiary_name'] ?? '');
    final accountNumberController =
        TextEditingController(text: existingBankAccount?['account_number'] ?? '');
    final ifscCodeController =
        TextEditingController(text: existingBankAccount?['ifsc_code'] ?? '');
    final upiAddressController =
        TextEditingController(text: existingBankAccount?['upi_address'] ?? '');
    bool isPrimary = index == primaryBankIndex;

    return await showDialog<Map<String, String>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      existingBankAccount == null ? 'Add Bank Account' : 'Edit Bank Account',
                      style: kTextStyle.copyWith(
                          color: kNeutralColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: beneficiaryController,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Beneficiary Name',
                        hintText: 'Enter beneficiary name',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter beneficiary name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: accountNumberController,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Account Number',
                        hintText: 'Enter account number',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter account number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: ifscCodeController,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'IFSC Code',
                        hintText: 'Enter IFSC code',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter IFSC code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: upiAddressController,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'UPI Address',
                        hintText: 'Enter UPI address',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    CheckboxListTile(
                      title: Text('Set as Primary',
                          style: kTextStyle.copyWith(color: kNeutralColor)),
                      value: isPrimary,
                      onChanged: (value) {
                        setState(() {
                          isPrimary = value!;
                          if (isPrimary) {
                            this.setState(() {
                              primaryBankIndex = index ?? bankAccounts.length;
                            });
                          } else if (index == primaryBankIndex) {
                            this.setState(() {
                              primaryBankIndex = -1;
                            });
                          }
                        });
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel',
                              style: kTextStyle.copyWith(color: kSubTitleColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (beneficiaryController.text.isNotEmpty &&
                                accountNumberController.text.isNotEmpty &&
                                ifscCodeController.text.isNotEmpty) {
                              Navigator.pop(context, {
                                'beneficiary_name': beneficiaryController.text,
                                'account_number': accountNumberController.text,
                                'ifsc_code': ifscCodeController.text,
                                'upi_address': upiAddressController.text,
                              });
                            }
                          },
                          child: Text(
                              existingBankAccount == null ? 'Add' : 'Update',
                              style: kTextStyle.copyWith(color: kPrimaryColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //__________Select Industries Popup___________________________________________
  Future<List<String>?> showIndustriesPopUp({List<String>? selectedIndustries}) async {
    List<String> tempSelected = List.from(selectedIndustries ?? []);
    return await showDialog<List<String>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Select Industries',
                      style: kTextStyle.copyWith(
                          color: kNeutralColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    ...availableIndustries.map((industry) {
                      return CheckboxListTile(
                        title: Text(industry,
                            style: kTextStyle.copyWith(color: kNeutralColor)),
                        value: tempSelected.contains(industry),
                        onChanged: (value) {
                          setState(() {
                            if (value == true) {
                              tempSelected.add(industry);
                            } else {
                              tempSelected.remove(industry);
                            }
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text('Cancel',
                              style: kTextStyle.copyWith(color: kSubTitleColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, tempSelected);
                          },
                          child: Text('Save',
                              style: kTextStyle.copyWith(color: kPrimaryColor)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  //__________Import Profile Picture Popup_______________________________________
  void showImportProfilePopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: const Text('Pick Profile Image'),
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _dpImage = File(image.path);
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Pick Banner Image'),
                    onTap: () async {
                      final XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
                      if (image != null) {
                        setState(() {
                          _bannerImage = File(image.path);
                        });
                      }
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //__________Save Profile Success Popup________________________________________
  void saveProfilePopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: const SaveProfilePopUp(),
        );
      },
    );
  }

  //__________Submit to API____________________________________________________
  Future<void> submitProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add text fields
      request.fields['name'] = _nameController.text;
      request.fields['email'] = _emailController.text;
      request.fields['mobile'] = _mobileController.text;
      request.fields['password'] = _passwordController.text;
      request.fields['password_confirmation'] = _confirmPasswordController.text;
      request.fields['user_type'] = 'client';
      request.fields['status'] = 'active';

      // Add address
      request.fields['addresses[0][address_type]'] = 'primary';
      request.fields['addresses[0][address_line1]'] = _streetAddressController.text;
      request.fields['addresses[0][address_line2]'] = _addressLine2Controller.text;
      request.fields['addresses[0][landmark]'] = _landmarkController.text;
      request.fields['addresses[0][city]'] = _cityController.text;
      request.fields['addresses[0][state]'] = _stateController.text;
      request.fields['addresses[0][country]'] = _countryController.text;
      request.fields['addresses[0][postal_code]'] = _zipCodeController.text;
      request.fields['addresses[0][latitude]'] = _latitudeController.text;
      request.fields['addresses[0][longitude]'] = _longitudeController.text;
      request.fields['default_address_index'] = '0';

      // Add bank accounts
      bankAccounts.asMap().forEach((index, bank) {
        request.fields['bank_accounts[$index][beneficiary_name]'] = bank['beneficiary_name']!;
        request.fields['bank_accounts[$index][account_number]'] = bank['account_number']!;
        request.fields['bank_accounts[$index][ifsc_code]'] = bank['ifsc_code']!;
        request.fields['bank_accounts[$index][upi_address]'] = bank['upi_address'] ?? '';
      });
      request.fields['primary_bank_index'] = primaryBankIndex.toString();

      // Add industries
      industries.asMap().forEach((index, industry) {
        request.fields['industries[$index]'] = industry;
      });

      // Add images
      if (_dpImage != null) {
        request.files.add(await http.MultipartFile.fromPath('dp_image', _dpImage!.path));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile image is required')),
        );
        return;
      }
      if (_bannerImage != null) {
        request.files.add(await http.MultipartFile.fromPath('banner_image', _bannerImage!.path));
      }

      // Send request
      var response = await request.send();
      if (response.statusCode == 200) {
        saveProfilePopUp();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
          'Setup Profile',
          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView.builder(
          itemCount: 3,
          physics: const PageScrollPhysics(),
          controller: pageController,
          onPageChanged: (int index) => setState(() {
            currentIndexPage = index;
            percent = 33.3 * (index + 1);
          }),
          itemBuilder: (_, i) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          currentIndexPage == 0
                              ? 'Step 1 of 3'
                              : currentIndexPage == 1
                                  ? 'Step 2 of 3'
                                  : 'Step 3 of 3',
                          style: kTextStyle.copyWith(color: kNeutralColor),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: StepProgressIndicator(
                            totalSteps: 3,
                            currentStep: currentIndexPage + 1,
                            size: 8,
                            padding: 0,
                            selectedColor: kPrimaryColor,
                            unselectedColor: kPrimaryColor.withOpacity(0.2),
                            roundedEdges: const Radius.circular(10),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Your Photo',
                          style: kTextStyle.copyWith(
                              color: kNeutralColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10.0),
                        Center(
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                height: 120,
                                width: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: kPrimaryColor),
                                  image: _dpImage != null
                                      ? DecorationImage(
                                          image: FileImage(_dpImage!),
                                          fit: BoxFit.cover,
                                        )
                                      : null,
                                ),
                                child: _dpImage == null
                                    ? const Icon(IconlyBold.profile,
                                        color: kBorderColorTextField, size: 68)
                                    : null,
                              ),
                              GestureDetector(
                                onTap: () {
                                  showImportProfilePopUp();
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: kPrimaryColor),
                                  ),
                                  child: const Icon(
                                    IconlyBold.camera,
                                    color: kPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: _nameController,
                          keyboardType: TextInputType.name,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'User Name',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter user name',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Email',
                            hintText: 'Enter email',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Phone Number',
                            hintText: 'Enter Phone No.',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _countryController,
                          keyboardType: TextInputType.name,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Country',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter Country Name',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your country';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _streetAddressController,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Street Address (won’t show on profile)',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter street address',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your street address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _addressLine2Controller,
                          keyboardType: TextInputType.streetAddress,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Address Line 2',
                            hintText: 'Enter additional address details',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _landmarkController,
                          keyboardType: TextInputType.text,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Landmark',
                            hintText: 'Enter landmark',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _cityController,
                          keyboardType: TextInputType.name,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'City',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter city',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your city';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _stateController,
                          keyboardType: TextInputType.name,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'State',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter state',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your state';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _zipCodeController,
                          keyboardType: TextInputType.number,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'ZIP/Postal Code',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter zip/post code',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your ZIP/Postal code';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _latitudeController,
                          keyboardType: TextInputType.number,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Latitude',
                            hintText: 'Enter latitude (-90 to 90)',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final numValue = double.tryParse(value);
                              if (numValue == null || numValue < -90 || numValue > 90) {
                                return 'Please enter a valid latitude (-90 to 90)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _longitudeController,
                          keyboardType: TextInputType.number,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Longitude',
                            hintText: 'Enter longitude (-180 to 180)',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              final numValue = double.tryParse(value);
                              if (numValue == null || numValue < -180 || numValue > 180) {
                                return 'Please enter a valid longitude (-180 to 180)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _passwordController,
                          keyboardType: TextInputType.text,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.next,
                          obscureText: true,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Password',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Enter password',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: _confirmPasswordController,
                          keyboardType: TextInputType.text,
                          cursorColor: kNeutralColor,
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Confirm Password',
                            labelStyle: kTextStyle.copyWith(color: kNeutralColor),
                            hintText: 'Confirm your password',
                            hintStyle: kTextStyle.copyWith(color: kSubTitleColor),
                            focusColor: kNeutralColor,
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                      ],
                    ).visible(currentIndexPage == 0),
                    Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Bank Accounts',
                              style: kTextStyle.copyWith(
                                  color: kNeutralColor, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Icon(FeatherIcons.plusCircle,
                                color: kSubTitleColor, size: 18.0),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () async {
                                final result = await showBankAccountPopUp();
                                if (result != null) {
                                  setState(() {
                                    bankAccounts.add(result);
                                  });
                                }
                              },
                              child: Text(
                                'Add New',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        ...bankAccounts.asMap().entries.map((entry) {
                          int index = entry.key;
                          Map<String, String> bank = entry.value;
                          return Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: InfoShowCase(
                                      title: bank['beneficiary_name']!,
                                      subTitle:
                                          '${bank['account_number']} ${bank['ifsc_code']} ${bank['upi_address'] ?? ''}',
                                      onEdit: () async {
                                        final result = await showBankAccountPopUp(
                                            existingBankAccount: bank, index: index);
                                        if (result != null) {
                                          setState(() {
                                            bankAccounts[index] = result;
                                          });
                                        }
                                      },
                                      onDelete: () {
                                        setState(() {
                                          if (index == primaryBankIndex) {
                                            primaryBankIndex = -1;
                                          } else if (index < primaryBankIndex) {
                                            primaryBankIndex--;
                                          }
                                          bankAccounts.removeAt(index);
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20.0),
                            ],
                          );
                        }),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Text(
                              'Industries',
                              style: kTextStyle.copyWith(
                                  color: kNeutralColor, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Icon(FeatherIcons.plusCircle,
                                color: kSubTitleColor, size: 18.0),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () async {
                                final result = await showIndustriesPopUp(selectedIndustries: industries);
                                if (result != null) {
                                  setState(() {
                                    industries = result;
                                  });
                                }
                              },
                              child: Text(
                                'Add New',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Wrap(
                          spacing: 10.0,
                          children: industries.map((industry) {
                            return Chip(
                              label: Text(industry,
                                  style: kTextStyle.copyWith(color: kNeutralColor)),
                              onDeleted: () {
                                setState(() {
                                  industries.remove(industry);
                                });
                              },
                              deleteIcon: const Icon(FeatherIcons.x, size: 18.0),
                            );
                          }).toList(),
                        ),
                      ],
                    ).visible(currentIndexPage == 1),
                  
                   Row(
                          children: [
                            Text(
                              'Address',
                              style: kTextStyle.copyWith(
                                  color: kNeutralColor, fontWeight: FontWeight.bold),
                            ),
                            const Spacer(),
                            const Icon(FeatherIcons.plusCircle,
                                color: kSubTitleColor, size: 18.0),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () async {
                                final result = await showBankAccountPopUp();
                                if (result != null) {
                                  setState(() {
                                    bankAccounts.add(result);
                                  });
                                }
                              },
                              child: Text(
                                'Add New',
                                style: kTextStyle.copyWith(color: kSubTitleColor),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                  
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Review Your Profile',
                          style: kTextStyle.copyWith(
                              color: kNeutralColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 15.0),
                        Text(
                          'Please review all details before saving.',
                          style: kTextStyle.copyWith(color: kSubTitleColor),
                        ),
                      ],
                    ).visible(currentIndexPage == 2),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: ButtonGlobalWithoutIcon(
        buttontext: currentIndexPage < 2 ? 'Continue' : 'Save Profile',
        buttonDecoration: kButtonDecoration.copyWith(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: () {
          if (currentIndexPage < 2) {
            if (currentIndexPage == 0 && !_formKey.currentState!.validate()) {
              return;
            }
            pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.bounceInOut,
            );
          } else {
            submitProfile();
          }
        },
        buttonTextColor: kWhite,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _countryController.dispose();
    _streetAddressController.dispose();
    _addressLine2Controller.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    pageController.dispose();
    super.dispose();
  }
}

