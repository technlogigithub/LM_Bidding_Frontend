// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:freelancer/screen/widgets/button_global.dart';
// import 'package:freelancer/screen/widgets/data.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../../widgets/constant.dart';

// class SetupClientProfile extends StatefulWidget {
//   const SetupClientProfile({super.key});

//   @override
//   State<SetupClientProfile> createState() => _SetupClientProfileState();
// }

// class _SetupClientProfileState extends State<SetupClientProfile> {
//   PageController pageController = PageController(initialPage: 0);
//   int currentIndexPage = 0;
//   double percent = 33.33;

//   // Form controllers
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _aadharController = TextEditingController();
//   final TextEditingController _panController = TextEditingController();
//   final TextEditingController _gstnController = TextEditingController();
//   final TextEditingController _regNoController = TextEditingController();
//   final TextEditingController _instagramHandleController = TextEditingController();

//   // File variables
//   File? _dpImage;
//   File? _bannerImage;
//   File? _bankDocument;
//   File? _aadharFrontImage;
//   File? _aadharBackImage;
//   List<File> _panCardFiles = [];
//   List<File> _gstCertificateFiles = [];
//   List<File> _regCertificateFiles = [];

//   // Dynamic lists
//   List<Map<String, dynamic>> addresses = [];
//   List<Map<String, String>> bankAccounts = [];
//   List<String> industries = []; // To store selected industries

//   // Primary bank and default address indices
//   int primaryBankIndex = -1;
//   int defaultAddressIndex = -1;

//   // API endpoint
//   final String apiUrl = 'https://phplaravel-1517766-5835172.cloudwaysapps.com/api/profile/update';

//   // Image picker
//   final ImagePicker _picker = ImagePicker();

//   // Request permissions
//   Future<bool> requestStoragePermission({bool isCamera = false}) async {
//     print('Checking permissions for image upload');
//     if (Platform.isAndroid) {
//       if (isCamera) {
//         final cameraStatus = await Permission.camera.status;
//         if (!cameraStatus.isGranted) {
//           print('Requesting camera permission');
//           final status = await Permission.camera.request();
//           if (!status.isGranted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text('Camera permission is required for taking photos')),
//             );
//             return false;
//           }
//         }
//       }

//       // Try media permissions first (Android 13+)
//       print('Checking photos permission');
//       final photoStatus = await Permission.photos.status;
//       if (photoStatus.isGranted) {
//         print('Photos permission granted');
//         return true;
//       }
//       final photoResult = await Permission.photos.request();
//       if (photoResult.isGranted) {
//         print('Photos permission granted after request');
//         return true;
//       }

//       // Fallback to storage permissions (Android 12 and below)
//       print('Checking storage permission');
//       final storageStatus = await Permission.storage.status;
//       if (storageStatus.isGranted) {
//         print('Storage permission granted');
//         return true;
//       }
//       final storageResult = await Permission.storage.request();
//       if (storageResult.isGranted) {
//         print('Storage permission granted after request');
//         return true;
//       }

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Storage or media permissions are required to pick images')),
//       );
//       return false;
//     }
//     print('Non-Android platform, skipping permission check');
//     return true; // iOS or other platforms
//   }

//   // Add/Edit Bank Account Popup
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
//                       keyboardType: TextInputType.number,
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
//                         if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$').hasMatch(value)) {
//                           return 'Please enter a valid IFSC code';
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
//                                 'primary_bank': isPrimary ? '1' : '0',
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

//   // Add/Edit Address Popup
//   Future<Map<String, dynamic>?> showAddressPopUp(
//       {Map<String, dynamic>? existingAddress, int? index}) async {
//     final addressTypeController =
//         TextEditingController(text: existingAddress?['address_type'] ?? '');
//     final addressLine1Controller =
//         TextEditingController(text: existingAddress?['address_line1'] ?? '');
//     final addressLine2Controller =
//         TextEditingController(text: existingAddress?['address_line2'] ?? '');
//     final landmarkController =
//         TextEditingController(text: existingAddress?['landmark'] ?? '');
//     final cityController = TextEditingController(text: existingAddress?['city'] ?? '');
//     final stateController = TextEditingController(text: existingAddress?['state'] ?? '');
//     final countryController =
//         TextEditingController(text: existingAddress?['country'] ?? '');
//     final postalCodeController =
//         TextEditingController(text: existingAddress?['postal_code'] ?? '');
//     final latitudeController =
//         TextEditingController(text: existingAddress?['latitude'] ?? '');
//     final longitudeController =
//         TextEditingController(text: existingAddress?['longitude'] ?? '');
//     bool isDefault = index == defaultAddressIndex;

//     return await showDialog<Map<String, dynamic>>(
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
//                 child: SingleChildScrollView(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Text(
//                         existingAddress == null ? 'Add Address' : 'Edit Address',
//                         style: kTextStyle.copyWith(
//                             color: kNeutralColor, fontWeight: FontWeight.bold),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: addressTypeController,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Address Type',
//                           hintText: 'e.g., billing, shipping',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter address type';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: addressLine1Controller,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Address Line 1 (Google Address)',
//                           hintText: 'Enter full address',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter address line 1';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: addressLine2Controller,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Address Line 2',
//                           hintText: 'Enter address line 2',
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: landmarkController,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Landmark',
//                           hintText: 'Enter landmark',
//                           border: const OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: cityController,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'City',
//                           hintText: 'Enter city',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter city';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: stateController,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'State',
//                           hintText: 'Enter state',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter state';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: countryController,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Country',
//                           hintText: 'Enter country',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter country';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: postalCodeController,
//                         keyboardType: TextInputType.number,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Postal Code',
//                           hintText: 'Enter postal code',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value == null || value.isEmpty) {
//                             return 'Please enter postal code';
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: latitudeController,
//                         keyboardType: TextInputType.number,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Latitude',
//                           hintText: 'Enter latitude (-90 to 90)',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value != null && value.isNotEmpty) {
//                             final numValue = double.tryParse(value);
//                             if (numValue == null || numValue < -90 || numValue > 90) {
//                               return 'Please enter a valid latitude (-90 to 90)';
//                             }
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       TextFormField(
//                         controller: longitudeController,
//                         keyboardType: TextInputType.number,
//                         decoration: kInputDecoration.copyWith(
//                           labelText: 'Longitude',
//                           hintText: 'Enter longitude (-180 to 180)',
//                           border: const OutlineInputBorder(),
//                         ),
//                         validator: (value) {
//                           if (value != null && value.isNotEmpty) {
//                             final numValue = double.tryParse(value);
//                             if (numValue == null || numValue < -180 || numValue > 180) {
//                               return 'Please enter a valid longitude (-180 to 180)';
//                             }
//                           }
//                           return null;
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       CheckboxListTile(
//                         title: Text('Set as Default',
//                             style: kTextStyle.copyWith(color: kNeutralColor)),
//                         value: isDefault,
//                         onChanged: (value) {
//                           setState(() {
//                             isDefault = value!;
//                             if (isDefault) {
//                               this.setState(() {
//                                 defaultAddressIndex = index ?? addresses.length;
//                               });
//                             } else if (index == defaultAddressIndex) {
//                               this.setState(() {
//                                 defaultAddressIndex = -1;
//                               });
//                             }
//                           });
//                         },
//                       ),
//                       const SizedBox(height: 20.0),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         children: [
//                           TextButton(
//                             onPressed: () => Navigator.pop(context),
//                             child: Text('Cancel',
//                                 style: kTextStyle.copyWith(color: kSubTitleColor)),
//                           ),
//                           TextButton(
//                             onPressed: () {
//                               if (addressTypeController.text.isNotEmpty &&
//                                   addressLine1Controller.text.isNotEmpty &&
//                                   cityController.text.isNotEmpty &&
//                                   stateController.text.isNotEmpty &&
//                                   countryController.text.isNotEmpty &&
//                                   postalCodeController.text.isNotEmpty) {
//                                 Navigator.pop(context, {
//                                   'address_type': addressTypeController.text,
//                                   'address_line1': addressLine1Controller.text,
//                                   'address_line2': addressLine2Controller.text,
//                                   'landmark': landmarkController.text,
//                                   'city': cityController.text,
//                                   'state': stateController.text,
//                                   'country': countryController.text,
//                                   'postal_code': postalCodeController.text,
//                                   'latitude': latitudeController.text,
//                                   'longitude': longitudeController.text,
//                                   'default_address': isDefault ? '1' : '0',
//                                 });
//                               }
//                             },
//                             child: Text(
//                                 existingAddress == null ? 'Add' : 'Update',
//                                 style: kTextStyle.copyWith(color: kPrimaryColor)),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // Image Upload Popup
//   Future<File?> showImageUploadPopUp(String title, {bool isAadhar = false, bool isFront = true}) async {
//     print('Starting image picker for $title');
//     if (!await requestStoragePermission(isCamera: true)) {
//       return null;
//     }

//     return await showDialog<File?>(
//       barrierDismissible: true,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Image Source for $title',
//                   style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20.0),
//                 ListTile(
//                   title: const Text('Gallery'),
//                   leading: const Icon(IconlyBold.image),
//                   onTap: () async {
//                     try {
//                       final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
//                       if (file != null) {
//                         print('Selected image from gallery: ${file.path}');
//                         Navigator.pop(context, File(file.path));
//                       } else {
//                         Navigator.pop(context, null);
//                       }
//                     } catch (e) {
//                       print('Gallery image picker error: $e');
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error picking image from gallery: $e')),
//                       );
//                       Navigator.pop(context, null);
//                     }
//                   },
//                 ),
//                 ListTile(
//                   title: const Text('Camera'),
//                   leading: const Icon(IconlyBold.camera),
//                   onTap: () async {
//                     try {
//                       final XFile? file = await _picker.pickImage(source: ImageSource.camera);
//                       if (file != null) {
//                         print('Selected image from camera: ${file.path}');
//                         Navigator.pop(context, File(file.path));
//                       } else {
//                         Navigator.pop(context, null);
//                       }
//                     } catch (e) {
//                       print('Camera image picker error: $e');
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text('Error picking image from camera: $e')),
//                       );
//                       Navigator.pop(context, null);
//                     }
//                   },
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, null),
//                   child: Text('Cancel', style: kTextStyle.copyWith(color: kSubTitleColor)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Import Profile Picture Popup
//   Future<void> showImportProfilePopUp() async {
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
//                       final file = await showImageUploadPopUp('Profile Image');
//                       if (file != null) {
//                         setState(() {
//                           _dpImage = file;
//                         });
//                         this.setState(() {});
//                       }
//                       Navigator.pop(context);
//                     },
//                   ),
//                   ListTile(
//                     title: const Text('Pick Banner Image'),
//                     onTap: () async {
//                       final file = await showImageUploadPopUp('Banner Image');
//                       if (file != null) {
//                         setState(() {
//                           _bannerImage = file;
//                         });
//                         this.setState(() {});
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

//   // Save Profile Success Popup
//   void saveProfilePopUp(String message) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   message,
//                   style: kTextStyle.copyWith(
//                       color: kNeutralColor, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20.0),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: Text('OK',
//                       style: kTextStyle.copyWith(color: kPrimaryColor)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Verify Document (Mock API)
//   Future<bool> verifyDocument(String type, String value) async {
//     try {
//       await Future.delayed(const Duration(seconds: 1)); // Simulate API call
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }
//   bool _isLoading = false;

// Future<void> submitProfile() async {
//   print('Starting profile submission');
//   setState(() => _isLoading = true);

//   // Toggle to test with minimal files (dp_image and banner_image only)
//   bool minimalFiles = false; // Set to true to test with fewer files

//   if (!_formKey.currentState!.validate()) {
//     print('Form validation failed');
//     setState(() => _isLoading = false);
//     return;
//   }

//   if (addresses.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please add at least one address')),
//     );
//     setState(() => _isLoading = false);
//     return;
//   }

//   if (bankAccounts.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please add at least one bank account')),
//     );
//     setState(() => _isLoading = false);
//     return;
//   }

//   if (_dpImage == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please upload profile image')),
//     );
//     setState(() => _isLoading = false);
//     return;
//   }

//   if (_bannerImage == null) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Please upload banner image')),
//     );
//     setState(() => _isLoading = false);
//     return;
//   }

//   if (!minimalFiles) {
//     if (_aadharFrontImage == null || _aadharBackImage == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload both Aadhar front and back images')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     if (_panCardFiles.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload PAN card image')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     if (_gstCertificateFiles.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload GST certificate')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     if (_regCertificateFiles.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload registration certificate')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     if (!await verifyDocument('aadhar', _aadharController.text)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Aadhar verification failed')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }
//     if (!await verifyDocument('pan', _panController.text)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('PAN verification failed')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }
//     if (!await verifyDocument('gstn', _gstnController.text)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('GSTN verification failed')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }
//   }

//   try {
//     // Check network connectivity
//     var connectivityResult = await Connectivity().checkConnectivity();
//     if (connectivityResult == ConnectivityResult.none) {
//       print('No internet connection');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No internet connection. Please try again.')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     // Fetch token from SharedPreferences
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('auth_token');
//     if (token == null) {
//       print('No auth token found in SharedPreferences');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Authentication token not found. Please log in again.')),
//       );
//       setState(() => _isLoading = false);
//       return;
//     }

//     // Validate file sizes (max 5MB per file)
//     const maxFileSize = 5 * 1024 * 1024; // 5MB
//     for (var file in [
//       _dpImage,
//       _bannerImage,
//       if (!minimalFiles) ...[_aadharFrontImage, _aadharBackImage, ..._panCardFiles, ..._gstCertificateFiles, ..._regCertificateFiles]
//     ]) {
//       if (file != null) {
//         final fileSize = await file.length();
//         print('File size: ${file.path} (${fileSize / 1024 / 1024} MB)');
//         if (fileSize > maxFileSize) {
//           print('File too large: ${file.path} (${fileSize / 1024 / 1024} MB)');
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('File ${file.path.split('/').last} is too large. Max size is 5MB.')),
//           );
//           setState(() => _isLoading = false);
//           return;
//         }
//       }
//     }

//     // Define headers (match sample)
//     final Map<String, String> headers = {
//       'Accept': 'application/json',
//       'Authorization': 'Bearer $token',
//     };

//     var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//     request.headers.addAll(headers);
//     print('API URL: $apiUrl');
//     print('Using token: $token');

//     // Fields (match sample)
//     request.fields.addAll({
//       'user_key': '',
//       'username': "dfedf",
//       'name': _nameController.text,
//       'email': _emailController.text,
//       'mobile': _mobileController.text,
//       'aadhar': _aadharController.text,
//       'pan': _panController.text,
//       'gstn': _gstnController.text,
//       'reg_no': _regNoController.text,
//       'new_password': 'password@123',
//       'new_password_confirmation': "password@123",
//     });

//     // Bank Accounts (match sample)
//     bankAccounts.asMap().forEach((index, bank) {
//       request.fields['bank_accounts[$index][beneficiary_name]'] = bank['beneficiary_name']!;
//       request.fields['bank_accounts[$index][account_number]'] = bank['account_number']!;
//       request.fields['bank_accounts[$index][ifsc_code]'] = bank['ifsc_code']!;
//       request.fields['bank_accounts[$index][upi_address]'] = bank['upi_address'] ?? '';
//     });
//     request.fields['primary_bank'] = primaryBankIndex.toString();

//     // Addresses (match sample)
//     addresses.asMap().forEach((index, address) {
//       request.fields['addresses[$index][address_type]'] = address['address_type']!;
//       request.fields['addresses[$index][address_line1]'] = address['address_line1']!;
//       request.fields['addresses[$index][address_line2]'] = address['address_line2'] ?? '';
//       request.fields['addresses[$index][landmark]'] = address['landmark'] ?? '';
//       request.fields['addresses[$index][city]'] = address['city']!;
//       request.fields['addresses[$index][state]'] = address['state']!;
//       request.fields['addresses[$index][country]'] = address['country']!;
//       request.fields['addresses[$index][postal_code]'] = address['postal_code']!;
//       request.fields['addresses[$index][latitude]'] = address['latitude'] ?? '';
//       request.fields['addresses[$index][longitude]'] = address['longitude'] ?? '';
//     });
//     request.fields['default_address_index'] = defaultAddressIndex.toString();

//     // Files (match sample: direct uploads)
//     if (_dpImage != null) {
//       request.files.add(await http.MultipartFile.fromPath('dp_image', _dpImage!.path));
//       print('Added dp_image: ${_dpImage!.path}');
//     }
//     if (_bannerImage != null) {
//       request.files.add(await http.MultipartFile.fromPath('banner_image', _bannerImage!.path));
//       print('Added banner_image: ${_bannerImage!.path}');
//     }
//     if (!minimalFiles) {
//       if (_aadharFrontImage != null) {
//         request.files.add(await http.MultipartFile.fromPath('aadhar_card[]', _aadharFrontImage!.path));
//         print('Added aadhar_card[] (front): ${_aadharFrontImage!.path}');
//       }
//       if (_aadharBackImage != null) {
//         request.files.add(await http.MultipartFile.fromPath('aadhar_card[]', _aadharBackImage!.path));
//         print('Added aadhar_card[] (back): ${_aadharBackImage!.path}');
//       }
//       for (var file in _panCardFiles) {
//         request.files.add(await http.MultipartFile.fromPath('pan_card[]', file.path));
//         print('Added pan_card[]: ${file.path}');
//       }
//       for (var file in _gstCertificateFiles) {
//         request.files.add(await http.MultipartFile.fromPath('gst_certificate[]', file.path));
//         print('Added gst_certificate[]: ${file.path}');
//       }
//       for (var file in _regCertificateFiles) {
//         request.files.add(await http.MultipartFile.fromPath('reg_certificate[]', file.path));
//         print('Added reg_certificate[]: ${file.path}');
//       }
//     }

//     // Log request details
//     print('Request fields: ${request.fields}');
//     print('Request files: ${request.files.map((f) => f.field).toList()}');

//     // Send request with timeout
//     print('Sending API request');
//     var response = await request.send().timeout(
//       const Duration(seconds: 30), // Increased to 30s
//       onTimeout: () {
//         print('Request timed out after 30 seconds');
//         throw TimeoutException('The request timed out after 30 seconds');
//       },
//     );

//     print('Received response with status: ${response.statusCode}');
//     final responseBody = await response.stream.bytesToString();
//     print('API response body: $responseBody');

//     if (response.statusCode == 200) {
//       try {
//         final decodedResponse = jsonDecode(responseBody);
//         if (decodedResponse['response_code'] == 200 && decodedResponse['success'] == true) {
//           saveProfilePopUp(decodedResponse['message'] ?? 'Profile updated successfully');
//           setState(() {
//             _nameController.text = decodedResponse['user']['name'] ?? _nameController.text;
//             _emailController.text = decodedResponse['user']['email'] ?? _emailController.text;
//             _mobileController.text = decodedResponse['user']['mobile'] ?? _mobileController.text;
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text(decodedResponse['message'] ?? 'Failed to save profile')),
//           );
//         }
//       } catch (e) {
//         print('JSON decoding error: $e');
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid response format from server')),
//         );
//       }
//     } else if (response.statusCode == 401) {
//       print('Unauthorized: Invalid or expired token');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Session expired. Please log in again.')),
//       );
//       // Optionally redirect to login screen
//       // Navigator.pushReplacementNamed(context, '/login');
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to save profile: ${response.statusCode} ${response.reasonPhrase}')),
//       );
//     }
//   } on TimeoutException catch (e) {
//     print('Timeout error: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Request timed out. Please check your internet connection.')),
//     );
//   } on SocketException catch (e) {
//     print('Network error: $e');
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Network error. Please check your internet connection.')),
//     );
//   } catch (e, stackTrace) {
//     print('API submission error: $e\n$stackTrace');
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Error: $e')),
//     );
//   } finally {
//     setState(() => _isLoading = false);
//   }
// }
//   Widget buildImagePreview(File? image, String label, VoidCallback onTap, VoidCallback onDelete) {
//     return Column(
//       children: [
//         GestureDetector(
//           onTap: onTap,
//           child: Container(
//             width: 100,
//             height: 100,
//             decoration: BoxDecoration(
//               border: Border.all(color: kPrimaryColor),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: image != null
//                 ? Stack(
//                     fit: StackFit.expand,
//                     children: [
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(8.0),
//                         child: Image.file(image, fit: BoxFit.cover),
//                       ),
//                       Positioned(
//                         top: 0,
//                         right: 0,
//                         child: GestureDetector(
//                           onTap: onDelete,
//                           child: Container(
//                             padding: const EdgeInsets.all(2.0),
//                             color: Colors.red.withOpacity(0.7),
//                             child: const Icon(
//                               IconlyBold.delete,
//                               color: Colors.white,
//                               size: 16,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 : const Icon(IconlyBold.image, color: kBorderColorTextField, size: 50),
//           ),
//         ),
//         const SizedBox(height: 8.0),
//         Text(label, style: kTextStyle.copyWith(color: kSubTitleColor)),
//       ],
//     );
//   }

//   // Widget for displaying Aadhar images (front and back)
//   Widget buildAadharPreview() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Aadhar Card', style: kTextStyle.copyWith(color: kNeutralColor)),
//         const SizedBox(height: 8.0),
//         Row(
//           children: [
//             buildImagePreview(
//               _aadharFrontImage,
//               'Aadhar Front',
//               () async {
//                 final file = await showImageUploadPopUp('Aadhar Card Front', isAadhar: true, isFront: true);
//                 if (file != null) {
//                   setState(() {
//                     _aadharFrontImage = file;
//                   });
//                 }
//               },
//               () => setState(() => _aadharFrontImage = null),
//             ),
//             const SizedBox(width: 16.0),
//             buildImagePreview(
//               _aadharBackImage,
//               'Aadhar Back',
//               () async {
//                 final file = await showImageUploadPopUp('Aadhar Card Back', isAadhar: true, isFront: false);
//                 if (file != null) {
//                   setState(() {
//                     _aadharBackImage = file;
//                   });
//                 }
//               },
//               () => setState(() => _aadharBackImage = null),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8.0),
//         Text(
//           _aadharFrontImage != null && _aadharBackImage != null
//               ? 'Aadhar Front & Back Uploaded'
//               : _aadharFrontImage != null
//                   ? 'Aadhar Back Missing'
//                   : _aadharBackImage != null
//                       ? 'Aadhar Front Missing'
//                       : 'Upload Aadhar Front & Back',
//           style: kTextStyle.copyWith(color: kSubTitleColor),
//         ),
//       ],
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
//       body: Form(
//         key: _formKey,
//         child: PageView.builder(
//           itemCount: 3,
//           physics: const PageScrollPhysics(),
//           controller: pageController,
//           onPageChanged: (int index) => setState(() {
//             currentIndexPage = index;
//             percent = 33.33 * (index + 1);
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
//                           'Step ${currentIndexPage + 1} of 3',
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
//                     // Step 1: Basic Info
//                     if (currentIndexPage == 0)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Basic Information',
//                             style: kTextStyle.copyWith(
//                                 color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 10.0),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               buildImagePreview(
//                                 _dpImage,
//                                 'Display Picture',
//                                 () => showImportProfilePopUp(),
//                                 () => setState(() => _dpImage = null),
//                               ),
//                               buildImagePreview(
//                                 _bannerImage,
//                                 'Banner Image',
//                                 () => showImportProfilePopUp(),
//                                 () => setState(() => _bannerImage = null),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 30.0),
//                           TextFormField(
//                             controller: _nameController,
//                             keyboardType: TextInputType.name,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Name',
//                               hintText: 'Enter your name',
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your name';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _emailController,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Email',
//                               hintText: 'Enter email',
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your email';
//                               }
//                               if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                                   .hasMatch(value)) {
//                                 return 'Please enter a valid email';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _mobileController,
//                             keyboardType: TextInputType.phone,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Mobile Number',
//                               hintText: 'Enter mobile number',
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter your mobile number';
//                               }
//                               if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                                 return 'Please enter a valid 10-digit mobile number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             initialValue: 'INDIVIDUAL',
//                             readOnly: true,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'User Type',
//                               border: const OutlineInputBorder(),
//                             ),
//                           ),
//                           const SizedBox(height: 20.0),
//                           Text(
//                             'Industries',
//                             style: kTextStyle.copyWith(
//                                 color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 10.0),
//                           Wrap(
//                             spacing: 8.0,
//                             children: ['1', '2', '3'].map((industry) {
//                               return FilterChip(
//                                 label: Text('Industry $industry'),
//                                 selected: industries.contains(industry),
//                                 onSelected: (selected) {
//                                   setState(() {
//                                     if (selected) {
//                                       industries.add(industry);
//                                     } else {
//                                       industries.remove(industry);
//                                     }
//                                   });
//                                 },
//                               );
//                             }).toList(),
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _instagramHandleController,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Instagram Handle',
//                               hintText: 'Enter Instagram handle',
//                               border: const OutlineInputBorder(),
//                             ),
//                           ),
//                         ],
//                       ),
//                     // Step 2: Addresses and Bank Accounts
//                     if (currentIndexPage == 1)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Addresses',
//                             style: kTextStyle.copyWith(
//                                 color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             children: [
//                               const Spacer(),
//                               const Icon(FeatherIcons.plusCircle,
//                                   color: kSubTitleColor, size: 18.0),
//                               const SizedBox(width: 5.0),
//                               GestureDetector(
//                                 onTap: () async {
//                                   final result = await showAddressPopUp();
//                                   if (result != null) {
//                                     setState(() {
//                                       addresses.add(result);
//                                     });
//                                   }
//                                 },
//                                 child: Text(
//                                   'Add New',
//                                   style: kTextStyle.copyWith(color: kSubTitleColor),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           ...addresses.asMap().entries.map((entry) {
//                             int index = entry.key;
//                             Map<String, dynamic> address = entry.value;
//                             return Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: InfoShowCase(
//                                         title: address['address_type']!,
//                                         subTitle:
//                                             '${address['address_line1']}, ${address['city']}, ${address['state']}, ${address['country']} ${address['postal_code']}',
//                                         onEdit: () async {
//                                           final result = await showAddressPopUp(
//                                               existingAddress: address, index: index);
//                                           if (result != null) {
//                                             setState(() {
//                                               addresses[index] = result;
//                                               if (result['default_address'] != '1' &&
//                                                   index == defaultAddressIndex) {
//                                                 defaultAddressIndex = -1;
//                                               }
//                                             });
//                                           }
//                                         },
//                                         onDelete: () {
//                                           setState(() {
//                                             if (index == defaultAddressIndex) {
//                                               defaultAddressIndex = -1;
//                                             } else if (index < defaultAddressIndex) {
//                                               defaultAddressIndex--;
//                                             }
//                                             addresses.removeAt(index);
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 CheckboxListTile(
//                                   title: Text('Set as Default',
//                                       style: kTextStyle.copyWith(color: kNeutralColor)),
//                                   value: index == defaultAddressIndex,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         defaultAddressIndex = index;
//                                         addresses[index]['default_address'] = '1';
//                                         for (int i = 0; i < addresses.length; i++) {
//                                           if (i != index) {
//                                             addresses[i]['default_address'] = '0';
//                                           }
//                                         }
//                                       } else {
//                                         defaultAddressIndex = -1;
//                                         addresses[index]['default_address'] = '0';
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 const SizedBox(height: 20.0),
//                               ],
//                             );
//                           }),
//                           const SizedBox(height: 20.0),
//                           Text(
//                             'Bank Accounts',
//                             style: kTextStyle.copyWith(
//                                 color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 20.0),
//                           Row(
//                             children: [
//                               const Spacer(),
//                               const Icon(FeatherIcons.plusCircle,
//                                   color: kSubTitleColor, size: 18.0),
//                               const SizedBox(width: 5.0),
//                               GestureDetector(
//                                 onTap: () async {
//                                   final result = await showBankAccountPopUp();
//                                   if (result != null) {
//                                     setState(() {
//                                       bankAccounts.add(result);
//                                     });
//                                   }
//                                 },
//                                 child: Text(
//                                   'Add New',
//                                   style: kTextStyle.copyWith(color: kSubTitleColor),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           ...bankAccounts.asMap().entries.map((entry) {
//                             int index = entry.key;
//                             Map<String, String> bank = entry.value;
//                             return Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: InfoShowCase(
//                                         title: bank['beneficiary_name']!,
//                                         subTitle:
//                                             '${bank['account_number']} ${bank['ifsc_code']} ${bank['upi_address'] ?? ''}',
//                                         onEdit: () async {
//                                           final result = await showBankAccountPopUp(
//                                               existingBankAccount: bank, index: index);
//                                           if (result != null) {
//                                             setState(() {
//                                               bankAccounts[index] = result;
//                                               if (result['primary_bank'] != '1' &&
//                                                   index == primaryBankIndex) {
//                                                 primaryBankIndex = -1;
//                                               }
//                                             });
//                                           }
//                                         },
//                                         onDelete: () {
//                                           setState(() {
//                                             if (index == primaryBankIndex) {
//                                               primaryBankIndex = -1;
//                                             } else if (index < primaryBankIndex) {
//                                               primaryBankIndex--;
//                                             }
//                                             bankAccounts.removeAt(index);
//                                           });
//                                         },
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 CheckboxListTile(
//                                   title: Text('Set as Primary',
//                                       style: kTextStyle.copyWith(color: kNeutralColor)),
//                                   value: index == primaryBankIndex,
//                                   onChanged: (value) {
//                                     setState(() {
//                                       if (value == true) {
//                                         primaryBankIndex = index;
//                                         bankAccounts[index]['primary_bank'] = '1';
//                                         for (int i = 0; i < bankAccounts.length; i++) {
//                                           if (i != index) {
//                                             bankAccounts[i]['primary_bank'] = '0';
//                                           }
//                                         }
//                                       } else {
//                                         primaryBankIndex = -1;
//                                         bankAccounts[index]['primary_bank'] = '0';
//                                       }
//                                     });
//                                   },
//                                 ),
//                                 const SizedBox(height: 20.0),
//                               ],
//                             );
//                           }),
//                           const SizedBox(height: 20.0),
//                           buildImagePreview(
//                             _bankDocument,
//                             'Bank Document',
//                             () async {
//                               final file = await showImageUploadPopUp('Bank Document');
//                               if (file != null) {
//                                 setState(() {
//                                   _bankDocument = file;
//                                 });
//                               }
//                             },
//                             () => setState(() => _bankDocument = null),
//                           ),
//                         ],
//                       ),
//                     // Step 3: Documents & Other and Review
//                     if (currentIndexPage == 2)
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Documents & Other Information',
//                             style: kTextStyle.copyWith(
//                                 color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _aadharController,
//                             keyboardType: TextInputType.number,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Aadhar Number',
//                               hintText: 'Enter 12-digit Aadhar number',
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter Aadhar number';
//                               }
//                               if (!RegExp(r'^\d{12}$').hasMatch(value)) {
//                                 return 'Please enter a valid 12-digit Aadhar number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20.0),
//                           buildAadharPreview(),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _panController,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'PAN Number',
//                               hintText: 'Enter PAN number (e.g., ABCDE1234F)',
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter PAN number';
//                               }
//                               if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
//                                 return 'Please enter a valid PAN number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20.0),
//                           buildImagePreview(
//                             _panCardFiles.isNotEmpty ? _panCardFiles[0] : null,
//                             'PAN Card',
//                             () async {
//                               final file = await showImageUploadPopUp('PAN Card');
//                               if (file != null) {
//                                 setState(() {
//                                   _panCardFiles = [file];
//                                 });
//                               }
//                             },
//                             () => setState(() => _panCardFiles = []),
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _gstnController,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'GST Number',
//                               hintText: 'Enter GST number (e.g., 22AAAAA0000A1Z5)',
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter GST number';
//                               }
//                               if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9A-Z]{3}$')
//                                   .hasMatch(value)) {
//                                 return 'Please enter a valid GST number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20.0),
//                           buildImagePreview(
//                             _gstCertificateFiles.isNotEmpty ? _gstCertificateFiles[0] : null,
//                             'GST Certificate',
//                             () async {
//                               final file = await showImageUploadPopUp('GST Certificate');
//                               if (file != null) {
//                                 setState(() {
//                                   _gstCertificateFiles = [file];
//                                 });
//                               }
//                             },
//                             () => setState(() => _gstCertificateFiles = []),
//                           ),
//                           const SizedBox(height: 20.0),
//                           TextFormField(
//                             controller: _regNoController,
//                             decoration: kInputDecoration.copyWith(
//                               labelText: 'Registration Number',
//                               hintText: 'Enter registration number',
//                               border: const OutlineInputBorder(),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'Please enter registration number';
//                               }
//                               return null;
//                             },
//                           ),
//                           const SizedBox(height: 20.0),
//                           buildImagePreview(
//                             _regCertificateFiles.isNotEmpty ? _regCertificateFiles[0] : null,
//                             'Registration Certificate',
//                             () async {
//                               final file = await showImageUploadPopUp('Registration Certificate');
//                               if (file != null) {
//                                 setState(() {
//                                   _regCertificateFiles = [file];
//                                 });
//                               }
//                             },
//                             () => setState(() => _regCertificateFiles = []),
//                           ),
//                           const SizedBox(height: 20.0),
//                           Text(
//                             'Review Your Profile',
//                             style: kTextStyle.copyWith(
//                                 color: kNeutralColor, fontWeight: FontWeight.bold),
//                           ),
//                           const SizedBox(height: 15.0),
//                           Text(
//                             'Basic Info:',
//                             style: kTextStyle.copyWith(color: kNeutralColor),
//                           ),
//                           Text('Name: ${_nameController.text}'),
//                           Text('Email: ${_emailController.text}'),
//                           Text('Mobile No: ${_mobileController.text}'),
//                           Text('User Type: INDIVIDUAL'),
//                           Text('Industries: ${industries.join(', ')}'),
//                           Text('Instagram Handle: ${_instagramHandleController.text}'),
//                           const SizedBox(height: 10.0),
//                           Text(
//                             'Addresses:',
//                             style: kTextStyle.copyWith(color: kNeutralColor),
//                           ),
//                           ...addresses.asMap().entries.map((entry) {
//                             int index = entry.key;
//                             Map<String, dynamic> address = entry.value;
//                             return Text(
//                                 '${address['address_type']}: ${address['address_line1']}, ${address['city']}, ${address['state']}, ${address['country']} ${address['postal_code']} ${index == defaultAddressIndex ? '(Default)' : ''}');
//                           }),
//                           const SizedBox(height: 10.0),
//                           Text(
//                             'Bank Accounts:',
//                             style: kTextStyle.copyWith(color: kNeutralColor),
//                           ),
//                           ...bankAccounts.asMap().entries.map((entry) {
//                             int index = entry.key;
//                             Map<String, String> bank = entry.value;
//                             return Text(
//                                 '${bank['beneficiary_name']} - ${bank['account_number']} ${index == primaryBankIndex ? '(Primary)' : ''}');
//                           }),
//                           Text('Bank Document: ${_bankDocument != null ? 'Uploaded' : 'Not Uploaded'}'),
//                           const SizedBox(height: 10.0),
//                           Text(
//                             'Documents & Other:',
//                             style: kTextStyle.copyWith(color: kNeutralColor),
//                           ),
//                           Text('Aadhar Number: ${_aadharController.text}'),
//                           Text('Aadhar Card: ${_aadharFrontImage != null && _aadharBackImage != null ? 'Front & Back Uploaded' : 'Not Uploaded'}'),
//                           Text('PAN Number: ${_panController.text}'),
//                           Text('PAN Card: ${_panCardFiles.isNotEmpty ? 'Uploaded' : 'Not Uploaded'}'),
//                           Text('GST Number: ${_gstnController.text}'),
//                           Text('GST Certificate: ${_gstCertificateFiles.isNotEmpty ? 'Uploaded' : 'Not Uploaded'}'),
//                           Text('Registration Number: ${_regNoController.text}'),
//                           Text('Registration Certificate: ${_regCertificateFiles.isNotEmpty ? 'Uploaded' : 'Not Uploaded'}'),
//                         ],
//                       ),
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
//             if (currentIndexPage == 1) {
//               if (addresses.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please add at least one address')),
//                 );
//                 return;
//               }
//               if (bankAccounts.isEmpty) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please add at least one bank account')),
//                 );
//                 return;
//               }
//               if (_bankDocument == null) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please upload bank document')),
//                 );
//                 return;
//               }
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
//     _aadharController.dispose();
//     _panController.dispose();
//     _gstnController.dispose();
//     _regNoController.dispose();
//     _instagramHandleController.dispose();
//     pageController.dispose();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:freelancer/screen/app_config/app_config.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:freelancer/screen/widgets/data.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
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
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _gstnController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _instagramHandleController = TextEditingController();
  final TextEditingController _addressSearchController = TextEditingController();

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
  List<String> industries = [];

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

  Future<Map<String, String>?> getLatLngFromPlaceId(String placeId) async {
    if (placeId.isEmpty) {
      print('Error: Place ID is empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid address')),
      );
      return null;
    }

    final String apiKey = AppInfo.googleAddressKey;
    if (apiKey.isEmpty) {
      print('Error: Google API key is missing');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google API key is missing. Contact support.')),
      );
      return null;
    }

    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,geometry&key=$apiKey',
    );

    try {
      final headers = await GoogleApiHeaders().getHeaders();
      print('Fetching place details for placeId: $placeId with headers: $headers');
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      print('Place details response: ${response.statusCode} ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          final location = data['result']['geometry']['location'];
          print('Geocoding successful: Lat ${location['lat']}, Lng ${location['lng']}');
          return {
            'address': data['result']['formatted_address'], // Matches backend 'address'
            'latitude': location['lat'].toString(),
            'longitude': location['lng'].toString(),
          };
        } else {
          print('Geocoding error: ${data['status']} - ${data['error_message'] ?? 'No results found'}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geocoding failed: ${data['error_message'] ?? 'No results found'}')),
          );
          return null;
        }
      } else {
        print('Geocoding request failed: ${response.statusCode} - ${response.reasonPhrase}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geocoding request failed: ${response.statusCode}')),
        );
        return null;
      }
    } catch (e) {
      print('Geocoding error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching coordinates. Please try again.')),
      );
      return null;
    }
  }

  // Add/Edit Address Popup with Google Places Autocomplete and Manual Entry
  Future<Map<String, dynamic>?> showAddressPopUp(
      {Map<String, dynamic>? existingAddress, int? index}) async {
    final addressTypeController =
        TextEditingController(text: existingAddress?['address_type'] ?? '');
    final addressLine1Controller =
        TextEditingController(text: existingAddress?['address'] ?? '');
    final landmarkController =
        TextEditingController(text: existingAddress?['landmark'] ?? '');
    final latitudeController =
        TextEditingController(text: existingAddress?['latitude'] ?? '');
    final longitudeController =
        TextEditingController(text: existingAddress?['longitude'] ?? '');
    bool isDefault = index == defaultAddressIndex;
    bool isLoadingCoordinates = false;
    bool useAutocomplete = true;
    String? placeId = existingAddress?['place_id'];
    String? errorMessage;

    // Check connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    bool hasInternet = connectivityResult != ConnectivityResult.none;
    if (!hasInternet || AppInfo.googleAddressKey.isEmpty) {
      useAutocomplete = false;
    }

    // Log initial state
    print('Opening address popup. Has internet: $hasInternet, API key: ${AppInfo.googleAddressKey}');
    print('Existing address: $existingAddress');
    print('Address search controller initial text: ${_addressSearchController.text}');

    _addressSearchController.clear();
    // Add listener for real-time input logging
    final addressListener = () {
      print('Address search input: ${_addressSearchController.text}');
      if (errorMessage != null) {
        setState(() => errorMessage = null);
      }
    };
    _addressSearchController.addListener(addressListener);

    final result = await showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8, // Ensure enough space for suggestions
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
                            hintText: 'e.g., office, home',
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
                        CheckboxListTile(
                          title: Text('Use Google Autocomplete',
                              style: kTextStyle.copyWith(color: kNeutralColor)),
                          value: useAutocomplete,
                          onChanged: hasInternet && AppInfo.googleAddressKey.isNotEmpty
                              ? (value) {
                                  setState(() {
                                    useAutocomplete = value!;
                                    if (!useAutocomplete) {
                                      _addressSearchController.clear();
                                      addressLine1Controller.clear();
                                      landmarkController.clear();
                                      latitudeController.clear();
                                      longitudeController.clear();
                                      errorMessage = null;
                                    }
                                  });
                                  print('Autocomplete toggled: $useAutocomplete');
                                }
                              : null,
                          subtitle: !hasInternet
                              ? const Text(
                                  'No internet. Manual entry only.',
                                  style: TextStyle(color: Colors.red),
                                )
                              : AppInfo.googleAddressKey.isEmpty
                                  ? const Text(
                                      'Google API key missing. Manual entry only.',
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : null,
                        ),
                        const SizedBox(height: 20.0),
                        useAutocomplete
                            ? GooglePlaceAutoCompleteTextField(
                                textEditingController: _addressSearchController,
                                googleAPIKey: AppInfo.googleAddressKey,
                                inputDecoration: kInputDecoration.copyWith(
                                  labelText: 'Address (Google Search)',
                                  hintText: 'Search for address (e.g., Delhi)',
                                  border: const OutlineInputBorder(),
                                  suffixIcon: isLoadingCoordinates
                                      ? const Padding(
                                          padding: EdgeInsets.all(12.0),
                                          child: CircularProgressIndicator(strokeWidth: 2.0),
                                        )
                                      : const Icon(IconlyBold.location, color: kPrimaryColor),
                                  errorText: errorMessage,
                                ),
                                isLatLngRequired: true,
                                countries: ['in'],
                                debounceTime: 300,
                                getPlaceDetailWithLatLng: (Prediction prediction) async {
                                  print('Selected prediction: ${prediction.description}');
                                  print('Place ID: ${prediction.placeId}');
                                  setState(() => isLoadingCoordinates = true);
                                  final coords = await getLatLngFromPlaceId(prediction.placeId!);
                                  if (coords != null) {
                                    setState(() {
                                      addressLine1Controller.text = coords['address']!;
                                      latitudeController.text = coords['latitude']!;
                                      longitudeController.text = coords['longitude']!;
                                      _addressSearchController.text = coords['address']!;
                                      placeId = prediction.placeId;
                                      errorMessage = null;
                                      isLoadingCoordinates = false;
                                    });
                                    print('Populated address fields: $coords');
                                  } else {
                                    setState(() {
                                      errorMessage = 'Failed to fetch address details';
                                      isLoadingCoordinates = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to fetch address details')),
                                    );
                                    print('Error: Failed to fetch address details');
                                  }
                                },
                                itemClick: (Prediction prediction) {
                                  print('Item clicked: ${prediction.description}');
                                  _addressSearchController.text = prediction.description ?? '';
                                  _addressSearchController.selection = TextSelection.fromPosition(
                                    TextPosition(offset: _addressSearchController.text.length),
                                  );
                                },
                                textStyle: kTextStyle.copyWith(color: kNeutralColor),
                              )
                            : TextFormField(
                                controller: addressLine1Controller,
                                decoration: kInputDecoration.copyWith(
                                  labelText: 'Address',
                                  hintText: 'Enter address manually (e.g., 123 MG Road)',
                                  border: const OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter address';
                                  }
                                  return null;
                                },
                              ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: landmarkController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Landmark',
                            hintText: 'Enter landmark (e.g., Near Metro Station)',
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: latitudeController,
                          keyboardType: TextInputType.number,
                          readOnly: useAutocomplete,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Latitude',
                            hintText: useAutocomplete
                                ? 'Auto-filled after address lookup'
                                : 'Enter latitude (e.g., 12.971599)',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (!useAutocomplete && (value == null || value.isEmpty)) {
                              return 'Please enter latitude';
                            }
                            if (value != null && value.isNotEmpty) {
                              final numValue = double.tryParse(value);
                              if (numValue == null || numValue < -90 || numValue > 90) {
                                return 'Invalid latitude (-90 to 90)';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: longitudeController,
                          keyboardType: TextInputType.number,
                          readOnly: useAutocomplete,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Longitude',
                            hintText: useAutocomplete
                                ? 'Auto-filled after address lookup'
                                : 'Enter longitude (e.g., 77.594566)',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (!useAutocomplete && (value == null || value.isEmpty)) {
                              return 'Please enter longitude';
                            }
                            if (value != null && value.isNotEmpty) {
                              final numValue = double.tryParse(value);
                              if (numValue == null || numValue < -180 || numValue > 180) {
                                return 'Invalid longitude (-180 to 180)';
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
                            print('Default address set: $isDefault, Index: $defaultAddressIndex');
                          },
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                print('Address popup cancelled');
                                Navigator.pop(context);
                              },
                              child: Text('Cancel',
                                  style: kTextStyle.copyWith(color: kSubTitleColor)),
                            ),
                            TextButton(
                              onPressed: () {
                                if (addressTypeController.text.isNotEmpty &&
                                    addressLine1Controller.text.isNotEmpty &&
                                    (!useAutocomplete ||
                                        (latitudeController.text.isNotEmpty &&
                                            longitudeController.text.isNotEmpty))) {
                                  final address = {
                                    'address_key': existingAddress?['address_key'] ?? '',
                                    'address_type': addressTypeController.text,
                                    'address': addressLine1Controller.text, // Matches backend API
                                    'landmark': landmarkController.text,
                                    'latitude': latitudeController.text,
                                    'longitude': longitudeController.text,
                                    'default_address': isDefault ? '1' : '0',
                                    'place_id': placeId ?? '',
                                  };
                                  print('Saving address: $address');
                                  Navigator.pop(context, address);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please fill all required fields')),
                                  );
                                  print('Validation failed: Required fields missing');
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
              ),
            );
          },
        );
      },
    );

    _addressSearchController.removeListener(addressListener); // Clean up listener
    return result;
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
                        print('Primary bank set: $isPrimary, Index: $primaryBankIndex');
                      },
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            print('Bank account popup cancelled');
                            Navigator.pop(context);
                          },
                          child: Text('Cancel',
                              style: kTextStyle.copyWith(color: kSubTitleColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (beneficiaryController.text.isNotEmpty &&
                                accountNumberController.text.isNotEmpty &&
                                ifscCodeController.text.isNotEmpty) {
                              final bankAccount = {
                                'beneficiary_name': beneficiaryController.text,
                                'account_number': accountNumberController.text,
                                'ifsc_code': ifscCodeController.text,
                                'upi_address': upiAddressController.text,
                                'primary_bank': isPrimary ? '1' : '0',
                              };
                              print('Saving bank account: $bankAccount');
                              Navigator.pop(context, bankAccount);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all required fields')),
                              );
                              print('Bank account validation failed');
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
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        print('No internet connection');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection. Please try again.')),
        );
        setState(() => _isLoading = false);
        return;
      }

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

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll(headers);
      print('API URL: $apiUrl');
      print('Using token: $token');

      request.fields.addAll({
        'user_key': '',
        'name': _nameController.text,
        'username': _userNameController.text,
        'email': _emailController.text,
        'mobile': _mobileController.text,
        'aadhar': _aadharController.text,
        'pan': _panController.text,
        'gstn': _gstnController.text,
        'reg_no': _regNoController.text,
        'new_password': 'password@123',
        'new_password_confirmation': 'password@123',
      });

      bankAccounts.asMap().forEach((index, bank) {
        request.fields['bank_accounts[$index][account_key]'] = bank['account_key'] ?? '';
        request.fields['bank_accounts[$index][beneficiary_name]'] = bank['beneficiary_name']!;
        request.fields['bank_accounts[$index][account_number]'] = bank['account_number']!;
        request.fields['bank_accounts[$index][ifsc_code]'] = bank['ifsc_code']!;
        request.fields['bank_accounts[$index][upi_address]'] = bank['upi_address'] ?? '';
      });
      request.fields['primary_bank'] = primaryBankIndex.toString();

      addresses.asMap().forEach((index, address) {
        request.fields['addresses[$index][address_key]'] = address['address_key'] ?? '';
        request.fields['addresses[$index][address_type]'] = address['address_type']!;
        request.fields['addresses[$index][address]'] = address['address']!;
        request.fields['addresses[$index][landmark]'] = address['landmark'] ?? '';
        request.fields['addresses[$index][latitude]'] = address['latitude'] ?? '';
        request.fields['addresses[$index][longitude]'] = address['longitude'] ?? '';
      });
      request.fields['default_address_index'] = defaultAddressIndex.toString();

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
          request.files.add(await http.MultipartFile.fromPath('aadhar_front_file', _aadharFrontImage!.path));
          print('Added aadhar_card[] (front): ${_aadharFrontImage!.path}');
        }
        if (_aadharBackImage != null) {
          request.files.add(await http.MultipartFile.fromPath('aadhar_back_file', _aadharBackImage!.path));
          print('Added aadhar_card[] (back): ${_aadharBackImage!.path}');
        }
        for (var file in _panCardFiles) {
          request.files.add(await http.MultipartFile.fromPath('pan_file', file.path));
          print('Added pan_card[]: ${file.path}');
        }
        for (var file in _gstCertificateFiles) {
          request.files.add(await http.MultipartFile.fromPath('gst_file', file.path));
          print('Added gst_certificate[]: ${file.path}');
        }
        for (var file in _regCertificateFiles) {
          request.files.add(await http.MultipartFile.fromPath('reg_file', file.path));
          print('Added reg_certificate: ${file.path}');
        }
      }

      print('Request fields: ${request.fields}');
      print('Request files: ${request.files.map((f) => f.field).toList()}');

      print('Sending API request');
      var response = await request.send().timeout(
        const Duration(seconds: 30),
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
                            initialValue: 'INDIVIDUAL',
                            readOnly: true,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'User Type',
                              border: const OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 20.0),
                          TextFormField(
                            controller: _userNameController,
                            keyboardType: TextInputType.name,
                            decoration: kInputDecoration.copyWith(
                              labelText: 'User Name',
                              hintText: 'Enter your user name',
                              border: const OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your user name';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20.0),
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
                        ],
                      ),
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
                                      print('Added address: $result');
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
                                        subTitle: '${address['address']}, ${address['landmark']}',
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
                                              print('Edited address: $result');
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
                                            print('Deleted address at index: $index');
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
                                      print('Default address updated: Index $defaultAddressIndex');
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
                                      print('Added bank account: $result');
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
                                              print('Edited bank account: $result');
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
                                            print('Deleted bank account at index: $index');
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
                                      print('Primary bank updated: Index $primaryBankIndex');
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
                                  print('Added bank document: ${file.path}');
                                });
                              }
                            },
                            () => setState(() {
                              _bankDocument = null;
                              print('Deleted bank document');
                            }),
                          ),
                        ],
                      ),
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
                                  print('Added PAN card: ${file.path}');
                                });
                              }
                            },
                            () => setState(() {
                              _panCardFiles = [];
                              print('Deleted PAN card');
                            }),
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
                                  print('Added GST certificate: ${file.path}');
                                });
                              }
                            },
                            () => setState(() {
                              _gstCertificateFiles = [];
                              print('Deleted GST certificate');
                            }),
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
                                  print('Added registration certificate: ${file.path}');
                                });
                              }
                            },
                            () => setState(() {
                              _regCertificateFiles = [];
                              print('Deleted registration certificate');
                            }),
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
                                '${address['address_type']}: ${address['address']}, ${address['landmark']} ${index == defaultAddressIndex ? '(Default)' : ''}');
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
      )
      ),
      bottomNavigationBar: ButtonGlobalWithoutIcon(
        buttontext: currentIndexPage < 2 ? 'Continue' : 'Save Profile',
        buttonDecoration: kButtonDecoration.copyWith(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: _isLoading
            ? null
            : () {
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
    _userNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _aadharController.dispose();
    _panController.dispose();
    _gstnController.dispose();
    _regNoController.dispose();
    _instagramHandleController.dispose();
    _addressSearchController.dispose();
    pageController.dispose();
    super.dispose();
  }
}