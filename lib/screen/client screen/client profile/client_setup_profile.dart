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
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:freelancer/screen/seller%20screen/seller%20popUp/seller_popup.dart';
// import 'package:freelancer/screen/widgets/button_global.dart';
// import 'package:freelancer/screen/widgets/data.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../../widgets/constant.dart';

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
                  
//                    Row(
//                           children: [
//                             Text(
//                               'Address',
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

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:freelancer/screen/widgets/data.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../widgets/constant.dart';

class SetupClientProfile extends StatefulWidget {
  const SetupClientProfile({super.key});

  @override
  State<SetupClientProfile> createState() => _SetupClientProfileState();
}

class _SetupClientProfileState extends State<SetupClientProfile> {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  double percent = 33.33;

  // Form controllers
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _gstnController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _instagramHandleController = TextEditingController();

  // File variables
  File? _dpImage;
  File? _bannerImage;
  File? _bankDocument;
  File? _aadharFrontImage;
  File? _aadharBackImage;
  List<File> _panCardFiles = [];
  List<File> _gstCertificateFiles = [];
  List<File> _regCertificateFiles = [];

  // Dynamic lists
  List<Map<String, dynamic>> addresses = [];
  List<Map<String, String>> bankAccounts = [];
  List<String> industries = []; // To store selected industries

  // Primary bank and default address indices
  int primaryBankIndex = -1;
  int defaultAddressIndex = -1;

  // API endpoint
  final String apiUrl = 'https://phplaravel-1517766-5835172.cloudwaysapps.com/api/profile/update';

  // Image picker
  final ImagePicker _picker = ImagePicker();

  // Request permissions
  Future<bool> requestStoragePermission({bool isCamera = false}) async {
    print('Checking permissions for image upload');
    if (Platform.isAndroid) {
      if (isCamera) {
        final cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted) {
          print('Requesting camera permission');
          final status = await Permission.camera.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera permission is required for taking photos')),
            );
            return false;
          }
        }
      }

      // Try media permissions first (Android 13+)
      print('Checking photos permission');
      final photoStatus = await Permission.photos.status;
      if (photoStatus.isGranted) {
        print('Photos permission granted');
        return true;
      }
      final photoResult = await Permission.photos.request();
      if (photoResult.isGranted) {
        print('Photos permission granted after request');
        return true;
      }

      // Fallback to storage permissions (Android 12 and below)
      print('Checking storage permission');
      final storageStatus = await Permission.storage.status;
      if (storageStatus.isGranted) {
        print('Storage permission granted');
        return true;
      }
      final storageResult = await Permission.storage.request();
      if (storageResult.isGranted) {
        print('Storage permission granted after request');
        return true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage or media permissions are required to pick images')),
      );
      return false;
    }
    print('Non-Android platform, skipping permission check');
    return true; // iOS or other platforms
  }

  // Add/Edit Bank Account Popup
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
                      keyboardType: TextInputType.number,
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
                        if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
                          return 'Please enter a valid IFSC code';
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
                                'primary_bank': isPrimary ? '1' : '0',
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

  // Add/Edit Address Popup
  Future<Map<String, dynamic>?> showAddressPopUp(
      {Map<String, dynamic>? existingAddress, int? index}) async {
    final addressTypeController =
        TextEditingController(text: existingAddress?['address_type'] ?? '');
    final addressLine1Controller =
        TextEditingController(text: existingAddress?['address_line1'] ?? '');
    final addressLine2Controller =
        TextEditingController(text: existingAddress?['address_line2'] ?? '');
    final landmarkController =
        TextEditingController(text: existingAddress?['landmark'] ?? '');
    final cityController = TextEditingController(text: existingAddress?['city'] ?? '');
    final stateController = TextEditingController(text: existingAddress?['state'] ?? '');
    final countryController =
        TextEditingController(text: existingAddress?['country'] ?? '');
    final postalCodeController =
        TextEditingController(text: existingAddress?['postal_code'] ?? '');
    final latitudeController =
        TextEditingController(text: existingAddress?['latitude'] ?? '');
    final longitudeController =
        TextEditingController(text: existingAddress?['longitude'] ?? '');
    bool isDefault = index == defaultAddressIndex;

    return await showDialog<Map<String, dynamic>>(
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
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        existingAddress == null ? 'Add Address' : 'Edit Address',
                        style: kTextStyle.copyWith(
                            color: kNeutralColor, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: addressTypeController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Address Type',
                          hintText: 'e.g., billing, shipping',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address type';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: addressLine1Controller,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Address Line 1 (Google Address)',
                          hintText: 'Enter full address',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter address line 1';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: addressLine2Controller,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Address Line 2',
                          hintText: 'Enter address line 2',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: landmarkController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Landmark',
                          hintText: 'Enter landmark',
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: cityController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'City',
                          hintText: 'Enter city',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter city';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: stateController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'State',
                          hintText: 'Enter state',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter state';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: countryController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Country',
                          hintText: 'Enter country',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter country';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: postalCodeController,
                        keyboardType: TextInputType.number,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Postal Code',
                          hintText: 'Enter postal code',
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter postal code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: latitudeController,
                        keyboardType: TextInputType.number,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Latitude',
                          hintText: 'Enter latitude (-90 to 90)',
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
                        controller: longitudeController,
                        keyboardType: TextInputType.number,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Longitude',
                          hintText: 'Enter longitude (-180 to 180)',
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
                      CheckboxListTile(
                        title: Text('Set as Default',
                            style: kTextStyle.copyWith(color: kNeutralColor)),
                        value: isDefault,
                        onChanged: (value) {
                          setState(() {
                            isDefault = value!;
                            if (isDefault) {
                              this.setState(() {
                                defaultAddressIndex = index ?? addresses.length;
                              });
                            } else if (index == defaultAddressIndex) {
                              this.setState(() {
                                defaultAddressIndex = -1;
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
                              if (addressTypeController.text.isNotEmpty &&
                                  addressLine1Controller.text.isNotEmpty &&
                                  cityController.text.isNotEmpty &&
                                  stateController.text.isNotEmpty &&
                                  countryController.text.isNotEmpty &&
                                  postalCodeController.text.isNotEmpty) {
                                Navigator.pop(context, {
                                  'address_type': addressTypeController.text,
                                  'address_line1': addressLine1Controller.text,
                                  'address_line2': addressLine2Controller.text,
                                  'landmark': landmarkController.text,
                                  'city': cityController.text,
                                  'state': stateController.text,
                                  'country': countryController.text,
                                  'postal_code': postalCodeController.text,
                                  'latitude': latitudeController.text,
                                  'longitude': longitudeController.text,
                                  'default_address': isDefault ? '1' : '0',
                                });
                              }
                            },
                            child: Text(
                                existingAddress == null ? 'Add' : 'Update',
                                style: kTextStyle.copyWith(color: kPrimaryColor)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Image Upload Popup
  Future<File?> showImageUploadPopUp(String title, {bool isAadhar = false, bool isFront = true}) async {
    print('Starting image picker for $title');
    if (!await requestStoragePermission(isCamera: true)) {
      return null;
    }

    return await showDialog<File?>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Image Source for $title',
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                ListTile(
                  title: const Text('Gallery'),
                  leading: const Icon(IconlyBold.image),
                  onTap: () async {
                    try {
                      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        print('Selected image from gallery: ${file.path}');
                        Navigator.pop(context, File(file.path));
                      } else {
                        Navigator.pop(context, null);
                      }
                    } catch (e) {
                      print('Gallery image picker error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error picking image from gallery: $e')),
                      );
                      Navigator.pop(context, null);
                    }
                  },
                ),
                ListTile(
                  title: const Text('Camera'),
                  leading: const Icon(IconlyBold.camera),
                  onTap: () async {
                    try {
                      final XFile? file = await _picker.pickImage(source: ImageSource.camera);
                      if (file != null) {
                        print('Selected image from camera: ${file.path}');
                        Navigator.pop(context, File(file.path));
                      } else {
                        Navigator.pop(context, null);
                      }
                    } catch (e) {
                      print('Camera image picker error: $e');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error picking image from camera: $e')),
                      );
                      Navigator.pop(context, null);
                    }
                  },
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, null),
                  child: Text('Cancel', style: kTextStyle.copyWith(color: kSubTitleColor)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Import Profile Picture Popup
  Future<void> showImportProfilePopUp() async {
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
                      final file = await showImageUploadPopUp('Profile Image');
                      if (file != null) {
                        setState(() {
                          _dpImage = file;
                        });
                        this.setState(() {});
                      }
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    title: const Text('Pick Banner Image'),
                    onTap: () async {
                      final file = await showImageUploadPopUp('Banner Image');
                      if (file != null) {
                        setState(() {
                          _bannerImage = file;
                        });
                        this.setState(() {});
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

  // Save Profile Success Popup
  void saveProfilePopUp(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
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
                  message,
                  style: kTextStyle.copyWith(
                      color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK',
                      style: kTextStyle.copyWith(color: kPrimaryColor)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Verify Document (Mock API)
  Future<bool> verifyDocument(String type, String value) async {
    try {
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return true;
    } catch (e) {
      return false;
    }
  }
  bool _isLoading = false;

Future<void> submitProfile() async {
  print('Starting profile submission');
  setState(() => _isLoading = true);

  // Toggle to test with minimal files (dp_image and banner_image only)
  bool minimalFiles = false; // Set to true to test with fewer files

  if (!_formKey.currentState!.validate()) {
    print('Form validation failed');
    setState(() => _isLoading = false);
    return;
  }

  if (addresses.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please add at least one address')),
    );
    setState(() => _isLoading = false);
    return;
  }

  if (bankAccounts.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please add at least one bank account')),
    );
    setState(() => _isLoading = false);
    return;
  }

  if (_dpImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please upload profile image')),
    );
    setState(() => _isLoading = false);
    return;
  }

  if (_bannerImage == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please upload banner image')),
    );
    setState(() => _isLoading = false);
    return;
  }

  if (!minimalFiles) {
    if (_aadharFrontImage == null || _aadharBackImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both Aadhar front and back images')),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (_panCardFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload PAN card image')),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (_gstCertificateFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload GST certificate')),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (_regCertificateFiles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload registration certificate')),
      );
      setState(() => _isLoading = false);
      return;
    }

    if (!await verifyDocument('aadhar', _aadharController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aadhar verification failed')),
      );
      setState(() => _isLoading = false);
      return;
    }
    if (!await verifyDocument('pan', _panController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PAN verification failed')),
      );
      setState(() => _isLoading = false);
      return;
    }
    if (!await verifyDocument('gstn', _gstnController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('GSTN verification failed')),
      );
      setState(() => _isLoading = false);
      return;
    }
  }

  try {
    // Check network connectivity
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No internet connection. Please try again.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Fetch token from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token == null) {
      print('No auth token found in SharedPreferences');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Authentication token not found. Please log in again.')),
      );
      setState(() => _isLoading = false);
      return;
    }

    // Validate file sizes (max 5MB per file)
    const maxFileSize = 5 * 1024 * 1024; // 5MB
    for (var file in [
      _dpImage,
      _bannerImage,
      if (!minimalFiles) ...[_aadharFrontImage, _aadharBackImage, ..._panCardFiles, ..._gstCertificateFiles, ..._regCertificateFiles]
    ]) {
      if (file != null) {
        final fileSize = await file.length();
        print('File size: ${file.path} (${fileSize / 1024 / 1024} MB)');
        if (fileSize > maxFileSize) {
          print('File too large: ${file.path} (${fileSize / 1024 / 1024} MB)');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('File ${file.path.split('/').last} is too large. Max size is 5MB.')),
          );
          setState(() => _isLoading = false);
          return;
        }
      }
    }

    // Define headers (match sample)
    final Map<String, String> headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers.addAll(headers);
    print('API URL: $apiUrl');
    print('Using token: $token');

    // Fields (match sample)
    request.fields.addAll({
      'user_key': '',
      'username': "dfedf",
      'name': _nameController.text,
      'email': _emailController.text,
      'mobile': _mobileController.text,
      'aadhar': _aadharController.text,
      'pan': _panController.text,
      'gstn': _gstnController.text,
      'reg_no': _regNoController.text,
      'new_password': 'password@123',
      'new_password_confirmation': "password@123",
    });

    // Bank Accounts (match sample)
    bankAccounts.asMap().forEach((index, bank) {
      request.fields['bank_accounts[$index][beneficiary_name]'] = bank['beneficiary_name']!;
      request.fields['bank_accounts[$index][account_number]'] = bank['account_number']!;
      request.fields['bank_accounts[$index][ifsc_code]'] = bank['ifsc_code']!;
      request.fields['bank_accounts[$index][upi_address]'] = bank['upi_address'] ?? '';
    });
    request.fields['primary_bank'] = primaryBankIndex.toString();

    // Addresses (match sample)
    addresses.asMap().forEach((index, address) {
      request.fields['addresses[$index][address_type]'] = address['address_type']!;
      request.fields['addresses[$index][address_line1]'] = address['address_line1']!;
      request.fields['addresses[$index][address_line2]'] = address['address_line2'] ?? '';
      request.fields['addresses[$index][landmark]'] = address['landmark'] ?? '';
      request.fields['addresses[$index][city]'] = address['city']!;
      request.fields['addresses[$index][state]'] = address['state']!;
      request.fields['addresses[$index][country]'] = address['country']!;
      request.fields['addresses[$index][postal_code]'] = address['postal_code']!;
      request.fields['addresses[$index][latitude]'] = address['latitude'] ?? '';
      request.fields['addresses[$index][longitude]'] = address['longitude'] ?? '';
    });
    request.fields['default_address_index'] = defaultAddressIndex.toString();

    // Files (match sample: direct uploads)
    if (_dpImage != null) {
      request.files.add(await http.MultipartFile.fromPath('dp_image', _dpImage!.path));
      print('Added dp_image: ${_dpImage!.path}');
    }
    if (_bannerImage != null) {
      request.files.add(await http.MultipartFile.fromPath('banner_image', _bannerImage!.path));
      print('Added banner_image: ${_bannerImage!.path}');
    }
    if (!minimalFiles) {
      if (_aadharFrontImage != null) {
        request.files.add(await http.MultipartFile.fromPath('aadhar_card[]', _aadharFrontImage!.path));
        print('Added aadhar_card[] (front): ${_aadharFrontImage!.path}');
      }
      if (_aadharBackImage != null) {
        request.files.add(await http.MultipartFile.fromPath('aadhar_card[]', _aadharBackImage!.path));
        print('Added aadhar_card[] (back): ${_aadharBackImage!.path}');
      }
      for (var file in _panCardFiles) {
        request.files.add(await http.MultipartFile.fromPath('pan_card[]', file.path));
        print('Added pan_card[]: ${file.path}');
      }
      for (var file in _gstCertificateFiles) {
        request.files.add(await http.MultipartFile.fromPath('gst_certificate[]', file.path));
        print('Added gst_certificate[]: ${file.path}');
      }
      for (var file in _regCertificateFiles) {
        request.files.add(await http.MultipartFile.fromPath('reg_certificate[]', file.path));
        print('Added reg_certificate[]: ${file.path}');
      }
    }

    // Log request details
    print('Request fields: ${request.fields}');
    print('Request files: ${request.files.map((f) => f.field).toList()}');

    // Send request with timeout
    print('Sending API request');
    var response = await request.send().timeout(
      const Duration(seconds: 30), // Increased to 30s
      onTimeout: () {
        print('Request timed out after 30 seconds');
        throw TimeoutException('The request timed out after 30 seconds');
      },
    );

    print('Received response with status: ${response.statusCode}');
    final responseBody = await response.stream.bytesToString();
    print('API response body: $responseBody');

    if (response.statusCode == 200) {
      try {
        final decodedResponse = jsonDecode(responseBody);
        if (decodedResponse['response_code'] == 200 && decodedResponse['success'] == true) {
          saveProfilePopUp(decodedResponse['message'] ?? 'Profile updated successfully');
          setState(() {
            _nameController.text = decodedResponse['user']['name'] ?? _nameController.text;
            _emailController.text = decodedResponse['user']['email'] ?? _emailController.text;
            _mobileController.text = decodedResponse['user']['mobile'] ?? _mobileController.text;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['message'] ?? 'Failed to save profile')),
          );
        }
      } catch (e) {
        print('JSON decoding error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid response format from server')),
        );
      }
    } else if (response.statusCode == 401) {
      print('Unauthorized: Invalid or expired token');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Session expired. Please log in again.')),
      );
      // Optionally redirect to login screen
      // Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: ${response.statusCode} ${response.reasonPhrase}')),
      );
    }
  } on TimeoutException catch (e) {
    print('Timeout error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Request timed out. Please check your internet connection.')),
    );
  } on SocketException catch (e) {
    print('Network error: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Network error. Please check your internet connection.')),
    );
  } catch (e, stackTrace) {
    print('API submission error: $e\n$stackTrace');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
  Widget buildImagePreview(File? image, String label, VoidCallback onTap, VoidCallback onDelete) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: kPrimaryColor),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: image != null
                ? Stack(
                    fit: StackFit.expand,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.file(image, fit: BoxFit.cover),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: onDelete,
                          child: Container(
                            padding: const EdgeInsets.all(2.0),
                            color: Colors.red.withOpacity(0.7),
                            child: const Icon(
                              IconlyBold.delete,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Icon(IconlyBold.image, color: kBorderColorTextField, size: 50),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(label, style: kTextStyle.copyWith(color: kSubTitleColor)),
      ],
    );
  }

  // Widget for displaying Aadhar images (front and back)
  Widget buildAadharPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aadhar Card', style: kTextStyle.copyWith(color: kNeutralColor)),
        const SizedBox(height: 8.0),
        Row(
          children: [
            buildImagePreview(
              _aadharFrontImage,
              'Aadhar Front',
              () async {
                final file = await showImageUploadPopUp('Aadhar Card Front', isAadhar: true, isFront: true);
                if (file != null) {
                  setState(() {
                    _aadharFrontImage = file;
                  });
                }
              },
              () => setState(() => _aadharFrontImage = null),
            ),
            const SizedBox(width: 16.0),
            buildImagePreview(
              _aadharBackImage,
              'Aadhar Back',
              () async {
                final file = await showImageUploadPopUp('Aadhar Card Back', isAadhar: true, isFront: false);
                if (file != null) {
                  setState(() {
                    _aadharBackImage = file;
                  });
                }
              },
              () => setState(() => _aadharBackImage = null),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          _aadharFrontImage != null && _aadharBackImage != null
              ? 'Aadhar Front & Back Uploaded'
              : _aadharFrontImage != null
                  ? 'Aadhar Back Missing'
                  : _aadharBackImage != null
                      ? 'Aadhar Front Missing'
                      : 'Upload Aadhar Front & Back',
          style: kTextStyle.copyWith(color: kSubTitleColor),
        ),
      ],
    );
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
            percent = 33.33 * (index + 1);
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
                          'Step ${currentIndexPage + 1} of 3',
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
                    // Step 1: Basic Info
                    if (currentIndexPage == 0)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basic Information',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildImagePreview(
                                _dpImage,
                                'Display Picture',
                                () => showImportProfilePopUp(),
                                () => setState(() => _dpImage = null),
                              ),
                              buildImagePreview(
                                _bannerImage,
                                'Banner Image',
                                () => showImportProfilePopUp(),
                                () => setState(() => _bannerImage = null),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30.0),
                          TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.name,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Name',
                              hintText: 'Enter your name',
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
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Email',
                              hintText: 'Enter email',
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
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Mobile Number',
                              hintText: 'Enter mobile number',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your mobile number';
                              }
                              if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                                return 'Please enter a valid 10-digit mobile number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            initialValue: 'INDIVIDUAL',
                            readOnly: true,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'User Type',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Industries',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10.0),
                          Wrap(
                            spacing: 8.0,
                            children: ['1', '2', '3'].map((industry) {
                              return FilterChip(
                                label: Text('Industry $industry'),
                                selected: industries.contains(industry),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      industries.add(industry);
                                    } else {
                                      industries.remove(industry);
                                    }
                                  });
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _instagramHandleController,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Instagram Handle',
                              hintText: 'Enter Instagram handle',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                        ],
                      ),
                    // Step 2: Addresses and Bank Accounts
                    if (currentIndexPage == 1)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Addresses',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
                              const Spacer(),
                              const Icon(FeatherIcons.plusCircle,
                                  color: kSubTitleColor, size: 18.0),
                              const SizedBox(width: 5.0),
                              GestureDetector(
                                onTap: () async {
                                  final result = await showAddressPopUp();
                                  if (result != null) {
                                    setState(() {
                                      addresses.add(result);
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
                          ...addresses.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> address = entry.value;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: InfoShowCase(
                                        title: address['address_type']!,
                                        subTitle:
                                            '${address['address_line1']}, ${address['city']}, ${address['state']}, ${address['country']} ${address['postal_code']}',
                                        onEdit: () async {
                                          final result = await showAddressPopUp(
                                              existingAddress: address, index: index);
                                          if (result != null) {
                                            setState(() {
                                              addresses[index] = result;
                                              if (result['default_address'] != '1' &&
                                                  index == defaultAddressIndex) {
                                                defaultAddressIndex = -1;
                                              }
                                            });
                                          }
                                        },
                                        onDelete: () {
                                          setState(() {
                                            if (index == defaultAddressIndex) {
                                              defaultAddressIndex = -1;
                                            } else if (index < defaultAddressIndex) {
                                              defaultAddressIndex--;
                                            }
                                            addresses.removeAt(index);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                CheckboxListTile(
                                  title: Text('Set as Default',
                                      style: kTextStyle.copyWith(color: kNeutralColor)),
                                  value: index == defaultAddressIndex,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        defaultAddressIndex = index;
                                        addresses[index]['default_address'] = '1';
                                        for (int i = 0; i < addresses.length; i++) {
                                          if (i != index) {
                                            addresses[i]['default_address'] = '0';
                                          }
                                        }
                                      } else {
                                        defaultAddressIndex = -1;
                                        addresses[index]['default_address'] = '0';
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            );
                          }),
                          const SizedBox(height: 20.0),
                          Text(
                            'Bank Accounts',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          Row(
                            children: [
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
                                              if (result['primary_bank'] != '1' &&
                                                  index == primaryBankIndex) {
                                                primaryBankIndex = -1;
                                              }
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
                                CheckboxListTile(
                                  title: Text('Set as Primary',
                                      style: kTextStyle.copyWith(color: kNeutralColor)),
                                  value: index == primaryBankIndex,
                                  onChanged: (value) {
                                    setState(() {
                                      if (value == true) {
                                        primaryBankIndex = index;
                                        bankAccounts[index]['primary_bank'] = '1';
                                        for (int i = 0; i < bankAccounts.length; i++) {
                                          if (i != index) {
                                            bankAccounts[i]['primary_bank'] = '0';
                                          }
                                        }
                                      } else {
                                        primaryBankIndex = -1;
                                        bankAccounts[index]['primary_bank'] = '0';
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(height: 20.0),
                              ],
                            );
                          }),
                          const SizedBox(height: 20.0),
                          buildImagePreview(
                            _bankDocument,
                            'Bank Document',
                            () async {
                              final file = await showImageUploadPopUp('Bank Document');
                              if (file != null) {
                                setState(() {
                                  _bankDocument = file;
                                });
                              }
                            },
                            () => setState(() => _bankDocument = null),
                          ),
                        ],
                      ),
                    // Step 3: Documents & Other and Review
                    if (currentIndexPage == 2)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Documents & Other Information',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _aadharController,
                            keyboardType: TextInputType.number,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Aadhar Number',
                              hintText: 'Enter 12-digit Aadhar number',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter Aadhar number';
                              }
                              if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                                return 'Please enter a valid 12-digit Aadhar number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          buildAadharPreview(),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _panController,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'PAN Number',
                              hintText: 'Enter PAN number (e.g., ABCDE1234F)',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter PAN number';
                              }
                              if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
                                return 'Please enter a valid PAN number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          buildImagePreview(
                            _panCardFiles.isNotEmpty ? _panCardFiles[0] : null,
                            'PAN Card',
                            () async {
                              final file = await showImageUploadPopUp('PAN Card');
                              if (file != null) {
                                setState(() {
                                  _panCardFiles = [file];
                                });
                              }
                            },
                            () => setState(() => _panCardFiles = []),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _gstnController,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'GST Number',
                              hintText: 'Enter GST number (e.g., 22AAAAA0000A1Z5)',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter GST number';
                              }
                              if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9A-Z]{3}$')
                                  .hasMatch(value)) {
                                return 'Please enter a valid GST number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          buildImagePreview(
                            _gstCertificateFiles.isNotEmpty ? _gstCertificateFiles[0] : null,
                            'GST Certificate',
                            () async {
                              final file = await showImageUploadPopUp('GST Certificate');
                              if (file != null) {
                                setState(() {
                                  _gstCertificateFiles = [file];
                                });
                              }
                            },
                            () => setState(() => _gstCertificateFiles = []),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _regNoController,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'Registration Number',
                              hintText: 'Enter registration number',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter registration number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
                          buildImagePreview(
                            _regCertificateFiles.isNotEmpty ? _regCertificateFiles[0] : null,
                            'Registration Certificate',
                            () async {
                              final file = await showImageUploadPopUp('Registration Certificate');
                              if (file != null) {
                                setState(() {
                                  _regCertificateFiles = [file];
                                });
                              }
                            },
                            () => setState(() => _regCertificateFiles = []),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            'Review Your Profile',
                            style: kTextStyle.copyWith(
                                color: kNeutralColor, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15.0),
                          Text(
                            'Basic Info:',
                            style: kTextStyle.copyWith(color: kNeutralColor),
                          ),
                          Text('Name: ${_nameController.text}'),
                          Text('Email: ${_emailController.text}'),
                          Text('Mobile No: ${_mobileController.text}'),
                          Text('User Type: INDIVIDUAL'),
                          Text('Industries: ${industries.join(', ')}'),
                          Text('Instagram Handle: ${_instagramHandleController.text}'),
                          const SizedBox(height: 10.0),
                          Text(
                            'Addresses:',
                            style: kTextStyle.copyWith(color: kNeutralColor),
                          ),
                          ...addresses.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, dynamic> address = entry.value;
                            return Text(
                                '${address['address_type']}: ${address['address_line1']}, ${address['city']}, ${address['state']}, ${address['country']} ${address['postal_code']} ${index == defaultAddressIndex ? '(Default)' : ''}');
                          }),
                          const SizedBox(height: 10.0),
                          Text(
                            'Bank Accounts:',
                            style: kTextStyle.copyWith(color: kNeutralColor),
                          ),
                          ...bankAccounts.asMap().entries.map((entry) {
                            int index = entry.key;
                            Map<String, String> bank = entry.value;
                            return Text(
                                '${bank['beneficiary_name']} - ${bank['account_number']} ${index == primaryBankIndex ? '(Primary)' : ''}');
                          }),
                          Text('Bank Document: ${_bankDocument != null ? 'Uploaded' : 'Not Uploaded'}'),
                          const SizedBox(height: 10.0),
                          Text(
                            'Documents & Other:',
                            style: kTextStyle.copyWith(color: kNeutralColor),
                          ),
                          Text('Aadhar Number: ${_aadharController.text}'),
                          Text('Aadhar Card: ${_aadharFrontImage != null && _aadharBackImage != null ? 'Front & Back Uploaded' : 'Not Uploaded'}'),
                          Text('PAN Number: ${_panController.text}'),
                          Text('PAN Card: ${_panCardFiles.isNotEmpty ? 'Uploaded' : 'Not Uploaded'}'),
                          Text('GST Number: ${_gstnController.text}'),
                          Text('GST Certificate: ${_gstCertificateFiles.isNotEmpty ? 'Uploaded' : 'Not Uploaded'}'),
                          Text('Registration Number: ${_regNoController.text}'),
                          Text('Registration Certificate: ${_regCertificateFiles.isNotEmpty ? 'Uploaded' : 'Not Uploaded'}'),
                        ],
                      ),
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
            if (currentIndexPage == 1) {
              if (addresses.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add at least one address')),
                );
                return;
              }
              if (bankAccounts.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please add at least one bank account')),
                );
                return;
              }
              if (_bankDocument == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please upload bank document')),
                );
                return;
              }
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
    _aadharController.dispose();
    _panController.dispose();
    _gstnController.dispose();
    _regNoController.dispose();
    _instagramHandleController.dispose();
    pageController.dispose();
    super.dispose();
  }
}