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

// class JobPostScreen extends StatefulWidget {
//   const JobPostScreen({super.key});

//   @override
//   State<JobPostScreen> createState() => _JobPostScreenState();
// }

// class _JobPostScreenState extends State<JobPostScreen> {
//   PageController pageController = PageController(initialPage: 0);
//   int currentIndexPage = 0;
//   double percent = 33.3;

//   // Form controllers for Post fields
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _locationController = TextEditingController();
//   final TextEditingController _landmarkController = TextEditingController();
//   final TextEditingController _latitudeController = TextEditingController();
//   final TextEditingController _longitudeController = TextEditingController();
//   final TextEditingController _totalQuantityController = TextEditingController();
//   final TextEditingController _unitController = TextEditingController();
//   final TextEditingController _lotSizeController = TextEditingController();
//   final TextEditingController _reservePriceController = TextEditingController();
//   final TextEditingController _incrementValueController = TextEditingController();
//   final TextEditingController _emdAmountController = TextEditingController();
//   final TextEditingController _feeController = TextEditingController();
//   final TextEditingController _inspectionOpenController = TextEditingController();
//   final TextEditingController _inspectionCloseController = TextEditingController();
//   final TextEditingController _emdLastDateController = TextEditingController();
//   final TextEditingController _startController = TextEditingController();
//   final TextEditingController _endController = TextEditingController();
//   final TextEditingController _securityDepositDaysController = TextEditingController();
//   final TextEditingController _paymentDepositDaysController = TextEditingController();
//   final TextEditingController _loadCompleteDaysController = TextEditingController();

//   // Form controllers for PostBuyerSellerInfo fields
//   final TextEditingController _fullNameController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _addressController = TextEditingController();
//   final TextEditingController _panTanController = TextEditingController();
//   final TextEditingController _gstnController = TextEditingController();
//   final TextEditingController _establishmentYearController = TextEditingController();

//   // File variables for media
//   List<Map<String, dynamic>> _mediaFiles = []; // {file: File, type: String}

//   // Dynamic lists
//   List<String> industrySpecificFields = [];
//   List<String> features = [];
//   List<Map<String, String>> bankAccounts = [];

//   // Dropdown values
//   String? _creatorType;
//   String? _categoryId;
//   String? _subcategoryId;
//   String? _itemId;
//   String? _condition;
//   String? _type;
//   String? _mode;
//   String? _bidList = 'SINGLE';
//   String? _bidVisibility = 'MASKED';
//   bool _bidApprovalRequired = false;
//   bool _bidDocumentRequired = false;
//   String? _status = 'CREATED';
//   String? _buyerSellerType;
//   String? _buyerSellerStatus;

//   // Primary bank index
//   int primaryBankIndex = -1;

//   // Sample dropdown data (replace with actual data from your backend)
//   final List<String> creatorTypes = ['SELLER', 'BUYER'];
//   final List<String> categories = ['Electronics', 'Furniture', 'Vehicles'];
//   final List<String> subcategories = ['Mobile Phones', 'Chairs', 'Cars'];
//   final List<String> items = ['Smartphone', 'Office Chair', 'Sedan'];
//   final List<String> conditions = ['NEW', 'USED', 'REFURBISHED'];
//   final List<String> types = ['AUCTION', 'SALE'];
//   final List<String> modes = ['ONLINE', 'OFFLINE'];
//   final List<String> bidLists = ['SINGLE', 'MULTIPLE'];
//   final List<String> bidVisibilities = ['MASKED', 'OPEN'];
//   final List<String> statuses = ['CREATED', 'ACTIVE', 'CLOSED'];
//   final List<String> buyerSellerTypes = ['BUYER', 'SELLER'];
//   final List<String> buyerSellerStatuses = ['ACTIVE', 'PENDING', 'INACTIVE'];
//   final List<String> availableIndustryFields = ['Tech Specs', 'Material', 'Warranty'];
//   final List<String> availableFeatures = ['Waterproof', 'Portable', 'Durable'];

//   // API endpoint (replace with your actual endpoint)
//   final String apiUrl = 'https://your-api-endpoint.com/api/posts';

//   // Image picker instance
//   final ImagePicker _picker = ImagePicker();

//   //__________Add/Edit Bank Account Popup_______________________________________
//   Future<Map<String, String>?> showBankAccountPopUp(
//       {Map<String, String>? existingBankAccount, int? index}) async {
//     final beneficiaryController =
//         TextEditingController(text: existingBankAccount?['beneficiary_name'] ?? '');
//     final bankNameController =
//         TextEditingController(text: existingBankAccount?['bank_name'] ?? '');
//     final accountNumberController =
//         TextEditingController(text: existingBankAccount?['account_number'] ?? '');
//     final ifscController =
//         TextEditingController(text: existingBankAccount?['ifsc'] ?? '');
//     final upiController =
//         TextEditingController(text: existingBankAccount?['upi'] ?? '');
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
//                       controller: bankNameController,
//                       decoration: kInputDecoration.copyWith(
//                         labelText: 'Bank Name',
//                         hintText: 'Enter bank name',
//                         border: const OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter bank name';
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
//                       controller: ifscController,
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
//                       controller: upiController,
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
//                                 bankNameController.text.isNotEmpty &&
//                                 accountNumberController.text.isNotEmpty &&
//                                 ifscController.text.isNotEmpty) {
//                               Navigator.pop(context, {
//                                 'beneficiary_name': beneficiaryController.text,
//                                 'bank_name': bankNameController.text,
//                                 'account_number': accountNumberController.text,
//                                 'ifsc': ifscController.text,
//                                 'upi': upiController.text,
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

//   //__________Select Industry Specific Fields Popup_____________________________
//   Future<List<String>?> showIndustryFieldsPopUp({List<String>? selectedFields}) async {
//     List<String> tempSelected = List.from(selectedFields ?? []);
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
//                       'Select Industry Fields',
//                       style: kTextStyle.copyWith(
//                           color: kNeutralColor, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20.0),
//                     ...availableIndustryFields.map((field) {
//                       return CheckboxListTile(
//                         title: Text(field,
//                             style: kTextStyle.copyWith(color: kNeutralColor)),
//                         value: tempSelected.contains(field),
//                         onChanged: (value) {
//                           setState(() {
//                             if (value == true) {
//                               tempSelected.add(field);
//                             } else {
//                               tempSelected.remove(field);
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

//   //__________Select Features Popup_____________________________________________
//   Future<List<String>?> showFeaturesPopUp({List<String>? selectedFeatures}) async {
//     List<String> tempSelected = List.from(selectedFeatures ?? []);
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
//                       'Select Features',
//                       style: kTextStyle.copyWith(
//                           color: kNeutralColor, fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 20.0),
//                     ...availableFeatures.map((feature) {
//                       return CheckboxListTile(
//                         title: Text(feature,
//                             style: kTextStyle.copyWith(color: kNeutralColor)),
//                         value: tempSelected.contains(feature),
//                         onChanged: (value) {
//                           setState(() {
//                             if (value == true) {
//                               tempSelected.add(feature);
//                             } else {
//                               tempSelected.remove(feature);
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

//   //__________Import Media Files Popup__________________________________________
//   Future<Map<String, dynamic>?> showImportMediaPopUp() async {
//     final TextEditingController fileTypeController = TextEditingController();
//     return await showDialog<Map<String, dynamic>>(
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
//                     title: const Text('Pick Media File'),
//                     onTap: () async {
//                       final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
//                       if (file != null) {
//                         Navigator.pop(context, {
//                           'file': File(file.path),
//                           'type': fileTypeController.text.isEmpty ? 'IMAGE' : fileTypeController.text,
//                         });
//                       }
//                     },
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                     child: TextFormField(
//                       controller: fileTypeController,
//                       decoration: kInputDecoration.copyWith(
//                         labelText: 'File Type',
//                         hintText: 'e.g., IMAGE, VIDEO',
//                         border: const OutlineInputBorder(),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10.0),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   //__________Save Post Success Popup___________________________________________
//   void savePostPopUp() {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20.0),
//           ),
//           child: const SaveProfilePopUp(), // Reuse or replace with SavePostPopUp
//         );
//       },
//     );
//   }

//   //__________Submit to API____________________________________________________
//   Future<void> submitPost() async {
//     if (!_formKey.currentState!.validate()) {
//       return;
//     }

//     try {
//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

//       // Add Post fields
//       request.fields['creator_type'] = _creatorType ?? '';
//       request.fields['category_id'] = _categoryId ?? '';
//       request.fields['subcategory_id'] = _subcategoryId ?? '';
//       request.fields['item_id'] = _itemId ?? '';
//       request.fields['title'] = _titleController.text;
//       request.fields['description'] = _descriptionController.text;
//       request.fields['latitude'] = _latitudeController.text;
//       request.fields['longitude'] = _longitudeController.text;
//       request.fields['location'] = _locationController.text;
//       request.fields['landmark'] = _landmarkController.text;
//       request.fields['condition'] = _condition ?? '';
//       request.fields['type'] = _type ?? '';
//       request.fields['mode'] = _mode ?? '';
//       request.fields['total_quantity'] = _totalQuantityController.text;
//       request.fields['unit'] = _unitController.text;
//       request.fields['lot_size'] = _lotSizeController.text;
//       request.fields['reserve_price_per_unit'] = _reservePriceController.text;
//       request.fields['increment_value'] = _incrementValueController.text;
//       request.fields['emd_amount'] = _emdAmountController.text;
//       request.fields['fee'] = _feeController.text.isEmpty ? '0' : _feeController.text;
//       request.fields['inspection_open'] = _inspectionOpenController.text;
//       request.fields['inspection_close'] = _inspectionCloseController.text;
//       request.fields['emd_last_date'] = _emdLastDateController.text;
//       request.fields['start'] = _startController.text;
//       request.fields['end'] = _endController.text;
//       request.fields['security_deposit_days'] = _securityDepositDaysController.text;
//       request.fields['payment_deposit_days'] = _paymentDepositDaysController.text;
//       request.fields['load_complete_days'] = _loadCompleteDaysController.text;
//       request.fields['bid_list'] = _bidList ?? 'SINGLE';
//       request.fields['bid_visibility'] = _bidVisibility ?? 'MASKED';
//       request.fields['bid_approval_required'] = _bidApprovalRequired.toString();
//       request.fields['bid_document_required'] = _bidDocumentRequired.toString();
//       request.fields['status'] = _status ?? 'CREATED';

//       // Add industry_specific_fields
//       industrySpecificFields.asMap().forEach((index, field) {
//         request.fields['industry_specific_fields[$index]'] = field;
//       });

//       // Add features
//       features.asMap().forEach((index, feature) {
//         request.fields['features[$index]'] = feature;
//       });

//       // Add media files
//       for (var i = 0; i < _mediaFiles.length; i++) {
//         request.files.add(await http.MultipartFile.fromPath(
//             'file_url[$i]', _mediaFiles[i]['file'].path));
//         request.fields['file_type[$i]'] = _mediaFiles[i]['type'];
//       }

//       // Add PostBuyerSellerInfo fields
//       request.fields['type'] = _buyerSellerType ?? '';
//       request.fields['status'] = _buyerSellerStatus ?? '';
//       request.fields['full_name'] = _fullNameController.text;
//       request.fields['mobile'] = _mobileController.text;
//       request.fields['email'] = _emailController.text;
//       request.fields['address'] = _addressController.text;
//       request.fields['pan_tan'] = _panTanController.text;
//       request.fields['gstn'] = _gstnController.text;
//       request.fields['establishment_year'] = _establishmentYearController.text;

//       // Add bank account for PostBuyerSellerInfo
//       if (bankAccounts.isNotEmpty) {
//         request.fields['beneficiary_name'] = bankAccounts[0]['beneficiary_name']!;
//         request.fields['bank_name'] = bankAccounts[0]['bank_name']!;
//         request.fields['account_number'] = bankAccounts[0]['account_number']!;
//         request.fields['ifsc'] = bankAccounts[0]['ifsc']!;
//         request.fields['upi'] = bankAccounts[0]['upi'] ?? '';
//       }

//       // Send request
//       var response = await request.send();
//       if (response.statusCode == 200) {
//         savePostPopUp();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create post: ${response.statusCode}')),
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
//           'Create Job Post',
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
//                           'Upload Media Files',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 10.0),
//                         Wrap(
//                           spacing: 10.0,
//                           children: _mediaFiles.asMap().entries.map((entry) {
//                             return Chip(
//                               label: Text(
//                                 'File ${entry.key + 1} (${entry.value['type']})',
//                                 style: kTextStyle.copyWith(color: kNeutralColor),
//                               ),
//                               onDeleted: () {
//                                 setState(() {
//                                   _mediaFiles.removeAt(entry.key);
//                                 });
//                               },
//                               deleteIcon: const Icon(FeatherIcons.x, size: 18.0),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 10.0),
//                         GestureDetector(
//                           onTap: () async {
//                             final result = await showImportMediaPopUp();
//                             if (result != null) {
//                               setState(() {
//                                 _mediaFiles.add(result);
//                               });
//                             }
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(10),
//                             decoration: BoxDecoration(
//                               color: kWhite,
//                               border: Border.all(color: kPrimaryColor),
//                               borderRadius: BorderRadius.circular(8.0),
//                             ),
//                             child: const Icon(IconlyBold.camera, color: kPrimaryColor),
//                           ),
//                         ),
//                         const SizedBox(height: 30.0),
//                         DropdownButtonFormField<String>(
//                           value: _creatorType,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Creator Type',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: creatorTypes
//                               .map((type) => DropdownMenuItem(
//                                     value: type,
//                                     child: Text(type),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _creatorType = value),
//                           validator: (value) =>
//                               value == null ? 'Please select creator type' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _categoryId,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Category',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: categories
//                               .map((category) => DropdownMenuItem(
//                                     value: category,
//                                     child: Text(category),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _categoryId = value),
//                           validator: (value) =>
//                               value == null ? 'Please select a category' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _subcategoryId,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Subcategory',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: subcategories
//                               .map((subcategory) => DropdownMenuItem(
//                                     value: subcategory,
//                                     child: Text(subcategory),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _subcategoryId = value),
//                           validator: (value) =>
//                               value == null ? 'Please select a subcategory' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _itemId,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Item',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: items
//                               .map((item) => DropdownMenuItem(
//                                     value: item,
//                                     child: Text(item),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _itemId = value),
//                           validator: (value) =>
//                               value == null ? 'Please select an item' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _titleController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Title',
//                             hintText: 'Enter post title',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter a title' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _descriptionController,
//                           maxLines: 4,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Description',
//                             hintText: 'Enter description',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter a description' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _locationController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Location',
//                             hintText: 'Enter location',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter a location' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _landmarkController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Landmark',
//                             hintText: 'Enter landmark',
//                             border: const OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _latitudeController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Latitude',
//                             hintText: 'Enter latitude (-90 to 90)',
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
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Longitude',
//                             hintText: 'Enter longitude (-180 to 180)',
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
//                       ],
//                     ).visible(currentIndexPage == 0),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         DropdownButtonFormField<String>(
//                           value: _condition,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Condition',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: conditions
//                               .map((condition) => DropdownMenuItem(
//                                     value: condition,
//                                     child: Text(condition),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _condition = value),
//                           validator: (value) =>
//                               value == null ? 'Please select a condition' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _type,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Type',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: types
//                               .map((type) => DropdownMenuItem(
//                                     value: type,
//                                     child: Text(type),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _type = value),
//                           validator: (value) =>
//                               value == null ? 'Please select a type' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _mode,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Mode',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: modes
//                               .map((mode) => DropdownMenuItem(
//                                     value: mode,
//                                     child: Text(mode),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _mode = value),
//                           validator: (value) =>
//                               value == null ? 'Please select a mode' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _totalQuantityController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Total Quantity',
//                             hintText: 'Enter total quantity',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter total quantity' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _unitController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Unit',
//                             hintText: 'Enter unit (e.g., kg, pieces)',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter a unit' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _lotSizeController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Lot Size',
//                             hintText: 'Enter lot size',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter lot size' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _reservePriceController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Reserve Price per Unit',
//                             hintText: 'Enter reserve price',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter reserve price' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _incrementValueController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Increment Value',
//                             hintText: 'Enter increment value',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter increment value' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _emdAmountController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'EMD Amount',
//                             hintText: 'Enter EMD amount',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter EMD amount' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _feeController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Fee (Optional)',
//                             hintText: 'Enter fee',
//                             border: const OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _inspectionOpenController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Inspection Open Date',
//                             hintText: 'YYYY-MM-DD',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter inspection open date' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _inspectionCloseController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Inspection Close Date',
//                             hintText: 'YYYY-MM-DD',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter inspection close date' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _emdLastDateController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'EMD Last Date',
//                             hintText: 'YYYY-MM-DD',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter EMD last date' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _startController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Start Date',
//                             hintText: 'YYYY-MM-DD',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter start date' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _endController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'End Date',
//                             hintText: 'YYYY-MM-DD',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter end date' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _securityDepositDaysController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Security Deposit Days',
//                             hintText: 'Enter days',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter security deposit days' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _paymentDepositDaysController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Payment Deposit Days',
//                             hintText: 'Enter days',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter payment deposit days' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _loadCompleteDaysController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Load Complete Days',
//                             hintText: 'Enter days',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter load complete days' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _bidList,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Bid List',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: bidLists
//                               .map((bid) => DropdownMenuItem(
//                                     value: bid,
//                                     child: Text(bid),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _bidList = value),
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _bidVisibility,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Bid Visibility',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: bidVisibilities
//                               .map((visibility) => DropdownMenuItem(
//                                     value: visibility,
//                                     child: Text(visibility),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _bidVisibility = value),
//                         ),
//                         const SizedBox(height: 20.0),
//                         CheckboxListTile(
//                           title: Text('Bid Approval Required',
//                               style: kTextStyle.copyWith(color: kNeutralColor)),
//                           value: _bidApprovalRequired,
//                           onChanged: (value) =>
//                               setState(() => _bidApprovalRequired = value!),
//                         ),
//                         const SizedBox(height: 20.0),
//                         CheckboxListTile(
//                           title: Text('Bid Document Required',
//                               style: kTextStyle.copyWith(color: kNeutralColor)),
//                           value: _bidDocumentRequired,
//                           onChanged: (value) =>
//                               setState(() => _bidDocumentRequired = value!),
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _status,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Status',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: statuses
//                               .map((status) => DropdownMenuItem(
//                                     value: status,
//                                     child: Text(status),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _status = value),
//                         ),
//                         const SizedBox(height: 20.0),
//                         Row(
//                           children: [
//                             Text(
//                               'Industry Specific Fields',
//                               style: kTextStyle.copyWith(
//                                   color: kNeutralColor, fontWeight: FontWeight.bold),
//                             ),
//                             const Spacer(),
//                             const Icon(FeatherIcons.plusCircle,
//                                 color: kSubTitleColor, size: 18.0),
//                             const SizedBox(width: 5.0),
//                             GestureDetector(
//                               onTap: () async {
//                                 final result = await showIndustryFieldsPopUp(
//                                     selectedFields: industrySpecificFields);
//                                 if (result != null) {
//                                   setState(() {
//                                     industrySpecificFields = result;
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
//                           children: industrySpecificFields.map((field) {
//                             return Chip(
//                               label: Text(field,
//                                   style: kTextStyle.copyWith(color: kNeutralColor)),
//                               onDeleted: () {
//                                 setState(() {
//                                   industrySpecificFields.remove(field);
//                                 });
//                               },
//                               deleteIcon: const Icon(FeatherIcons.x, size: 18.0),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 20.0),
//                         Row(
//                           children: [
//                             Text(
//                               'Features',
//                               style: kTextStyle.copyWith(
//                                   color: kNeutralColor, fontWeight: FontWeight.bold),
//                             ),
//                             const Spacer(),
//                             const Icon(FeatherIcons.plusCircle,
//                                 color: kSubTitleColor, size: 18.0),
//                             const SizedBox(width: 5.0),
//                             GestureDetector(
//                               onTap: () async {
//                                 final result =
//                                     await showFeaturesPopUp(selectedFeatures: features);
//                                 if (result != null) {
//                                   setState(() {
//                                     features = result;
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
//                           children: features.map((feature) {
//                             return Chip(
//                               label: Text(feature,
//                                   style: kTextStyle.copyWith(color: kNeutralColor)),
//                               onDeleted: () {
//                                 setState(() {
//                                   features.remove(feature);
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
//                           'Buyer/Seller Information',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor, fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _buyerSellerType,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Type',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: buyerSellerTypes
//                               .map((type) => DropdownMenuItem(
//                                     value: type,
//                                     child: Text(type),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _buyerSellerType = value),
//                           validator: (value) =>
//                               value == null ? 'Please select a type' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         DropdownButtonFormField<String>(
//                           value: _buyerSellerStatus,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Status',
//                             border: const OutlineInputBorder(),
//                           ),
//                           items: buyerSellerStatuses
//                               .map((status) => DropdownMenuItem(
//                                     value: status,
//                                     child: Text(status),
//                                   ))
//                               .toList(),
//                           onChanged: (value) => setState(() => _buyerSellerStatus = value),
//                           validator: (value) =>
//                               value == null ? 'Please select a status' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _fullNameController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Full Name',
//                             hintText: 'Enter full name',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter full name' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _mobileController,
//                           keyboardType: TextInputType.phone,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Mobile',
//                             hintText: 'Enter mobile number',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter mobile number';
//                             }
//                             if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                               return 'Please enter a valid 10-digit mobile number';
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Email',
//                             hintText: 'Enter email',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (value!.isEmpty) {
//                               return 'Please enter an email';
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
//                           controller: _addressController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Address',
//                             hintText: 'Enter address',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter an address' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _panTanController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'PAN/TAN',
//                             hintText: 'Enter PAN/TAN number',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter PAN/TAN' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _gstnController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'GSTN',
//                             hintText: 'Enter GSTN number',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter GSTN' : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: _establishmentYearController,
//                           keyboardType: TextInputType.number,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Establishment Year',
//                             hintText: 'Enter establishment year',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) =>
//                               value!.isEmpty ? 'Please enter establishment year' : null,
//                         ),
//                         const SizedBox(height: 20.0),
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
//                                           '${bank['bank_name']} ${bank['account_number']} ${bank['ifsc']} ${bank['upi'] ?? ''}',
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
//                         const SizedBox(height: 20.0),
//                         Text(
//                           'Review Your Post',
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
//         buttontext: currentIndexPage < 2 ? 'Continue' : 'Save Post',
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
//             submitPost();
//           }
//         },
//         buttonTextColor: kWhite,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _titleController.dispose();
//     _descriptionController.dispose();
//     _locationController.dispose();
//     _landmarkController.dispose();
//     _latitudeController.dispose();
//     _longitudeController.dispose();
//     _totalQuantityController.dispose();
//     _unitController.dispose();
//     _lotSizeController.dispose();
//     _reservePriceController.dispose();
//     _incrementValueController.dispose();
//     _emdAmountController.dispose();
//     _feeController.dispose();
//     _inspectionOpenController.dispose();
//     _inspectionCloseController.dispose();
//     _emdLastDateController.dispose();
//     _startController.dispose();
//     _endController.dispose();
//     _securityDepositDaysController.dispose();
//     _paymentDepositDaysController.dispose();
//     _loadCompleteDaysController.dispose();
//     _fullNameController.dispose();
//     _mobileController.dispose();
//     _emailController.dispose();
//     _addressController.dispose();
//     _panTanController.dispose();
//     _gstnController.dispose();
//     _establishmentYearController.dispose();
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
import 'package:freelancer/screen/seller%20screen/seller%20popUp/seller_popup.dart';
import 'package:freelancer/screen/widgets/button_global.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../widgets/constant.dart';
import 'package:intl/intl.dart';
class JobPostScreen extends StatefulWidget {
  const JobPostScreen({super.key});

  @override
  State<JobPostScreen> createState() => _JobPostScreenState();
}

class _JobPostScreenState extends State<JobPostScreen> with SingleTickerProviderStateMixin {
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  double percent = 33.3;
  late AnimationController _animationController;
  late Animation<double> _buttonAnimation;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _landmarkController = TextEditingController();
  final TextEditingController _latitudeController = TextEditingController();
  final TextEditingController _longitudeController = TextEditingController();
  final TextEditingController _totalQuantityController = TextEditingController();
  final TextEditingController _unitController = TextEditingController();
  final TextEditingController _lotSizeController = TextEditingController();
  final TextEditingController _reservePriceController = TextEditingController();
  final TextEditingController _incrementValueController = TextEditingController();
  final TextEditingController _emdAmountController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _inspectionOpenController = TextEditingController();
  final TextEditingController _inspectionCloseController = TextEditingController();
  final TextEditingController _emdLastDateController = TextEditingController();
  final TextEditingController _startController = TextEditingController();
  final TextEditingController _endController = TextEditingController();
  final TextEditingController _securityDepositDaysController = TextEditingController();
  final TextEditingController _paymentDepositDaysController = TextEditingController();
  final TextEditingController _loadCompleteDaysController = TextEditingController();
  // Form controllers for PostBuyerSellerInfo fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _panTanController = TextEditingController();
  final TextEditingController _gstnController = TextEditingController();
  final TextEditingController _establishmentYearController = TextEditingController();

  // File variables for media
  List<Map<String, dynamic>> _mediaFiles = []; // {file: File, type: String}

  // Dynamic lists
  List<String> industrySpecificFields = [];
  List<String> features = [];
  List<Map<String, String>> bankAccounts = [];

  // Dropdown values
  String? _creatorType;
  String? _categoryId;
  String? _subcategoryId;
  String? _itemId;
  String? _condition;
  String? _type;
  String? _mode;
  String? _bidList = 'SINGLE';
  String? _bidVisibility = 'MASKED';
  bool _bidApprovalRequired = false;
  bool _bidDocumentRequired = false;
  String? _status = 'CREATED';
  String? _buyerSellerType;
  String? _buyerSellerStatus;

  // Primary bank index
  int primaryBankIndex = -1;
  // Sample dropdown data
  final List<String> creatorTypes = ['SELLER', 'BUYER'];
  final List<String> categories = ['Electronics', 'Furniture', 'Vehicles'];
  final List<String> subcategories = ['Mobile Phones', 'Chairs', 'Cars'];
  final List<String> items = ['Smartphone', 'Office Chair', 'Sedan'];
  final List<String> conditions = ['NEW', 'USED', 'REFURBISHED'];
  final List<String> types = ['AUCTION', 'SALE'];
  final List<String> modes = ['ONLINE', 'OFFLINE'];
  final List<String> bidLists = ['SINGLE', 'MULTIPLE'];
  final List<String> bidVisibilities = ['MASKED', 'OPEN'];
  final List<String> statuses = ['CREATED', 'ACTIVE', 'CLOSED'];
  final List<String> buyerSellerTypes = ['BUYER', 'SELLER'];
  final List<String> buyerSellerStatuses = ['ACTIVE', 'PENDING', 'INACTIVE'];
  final List<String> availableIndustryFields = ['Tech Specs', 'Material', 'Warranty'];
  final List<String> availableFeatures = ['Waterproof', 'Portable', 'Durable'];

  // API endpoint
  final String apiUrl = 'https://your-api-endpoint.com/api/posts';

  // Image picker instance
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _buttonAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  //__________Select Date______________________________________________________
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: kPrimaryColor,
              onPrimary: kWhite,
              onSurface: kNeutralColor,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: kPrimaryColor),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  //__________Add/Edit Bank Account Popup_______________________________________
  Future<Map<String, String>?> showBankAccountPopUp(
      {Map<String, String>? existingBankAccount, int? index}) async {
    final beneficiaryController =
        TextEditingController(text: existingBankAccount?['beneficiary_name'] ?? '');
    final bankNameController =
        TextEditingController(text: existingBankAccount?['bank_name'] ?? '');
    final accountNumberController =
        TextEditingController(text: existingBankAccount?['account_number'] ?? '');
    final ifscController =
        TextEditingController(text: existingBankAccount?['ifsc'] ?? '');
    final upiController =
        TextEditingController(text: existingBankAccount?['upi'] ?? '');
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
              elevation: 5,
              backgroundColor: kWhite,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [kWhite, kDarkWhite],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        existingBankAccount == null ? 'Add Bank Account' : 'Edit Bank Account',
                        style: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      TextFormField(
                        controller: beneficiaryController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Beneficiary Name',
                          hintText: 'Enter beneficiary name',
                          prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter beneficiary name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: bankNameController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Bank Name',
                          hintText: 'Enter bank name',
                          prefixIcon: Icon(Icons.account_balance, color: kPrimaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter bank name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: accountNumberController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'Account Number',
                          hintText: 'Enter account number',
                          prefixIcon: Icon(Icons.credit_card, color: kPrimaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: ifscController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'IFSC Code',
                          hintText: 'Enter IFSC code',
                          prefixIcon: Icon(Icons.code, color: kPrimaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter IFSC code';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: upiController,
                        decoration: kInputDecoration.copyWith(
                          labelText: 'UPI Address',
                          hintText: 'Enter UPI address',
                          prefixIcon: Icon(Icons.payment, color: kPrimaryColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      CheckboxListTile(
                        title: Text('Set as Primary',
                            style: kTextStyle.copyWith(color: kNeutralColor)),
                        value: isPrimary,
                        activeColor: kPrimaryColor,
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
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel',
                                style: kTextStyle.copyWith(color: kSubTitleColor)),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (beneficiaryController.text.isNotEmpty &&
                                  bankNameController.text.isNotEmpty &&
                                  accountNumberController.text.isNotEmpty &&
                                  ifscController.text.isNotEmpty) {
                                Navigator.pop(context, {
                                  'beneficiary_name': beneficiaryController.text,
                                  'bank_name': bankNameController.text,
                                  'account_number': accountNumberController.text,
                                  'ifsc': ifscController.text,
                                  'upi': upiController.text,
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: kWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                                existingBankAccount == null ? 'Add' : 'Update',
                                style: kTextStyle.copyWith(color: kWhite)),
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

  //__________Select Industry Specific Fields Popup_____________________________
  Future<List<String>?> showIndustryFieldsPopUp({List<String>? selectedFields}) async {
    List<String> tempSelected = List.from(selectedFields ?? []);
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
              elevation: 5,
              backgroundColor: kWhite,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [kWhite, kDarkWhite],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Industry Fields',
                        style: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ...availableIndustryFields.map((field) {
                        return CheckboxListTile(
                          title: Text(field,
                              style: kTextStyle.copyWith(color: kNeutralColor)),
                          value: tempSelected.contains(field),
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                tempSelected.add(field);
                              } else {
                                tempSelected.remove(field);
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, tempSelected);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: kWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text('Save',
                                style: kTextStyle.copyWith(color: kWhite)),
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

  //__________Select Features Popup_____________________________________________
  Future<List<String>?> showFeaturesPopUp({List<String>? selectedFeatures}) async {
    List<String> tempSelected = List.from(selectedFeatures ?? []);
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
              elevation: 5,
              backgroundColor: kWhite,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: LinearGradient(
                    colors: [kWhite, kDarkWhite],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select Features',
                        style: kTextStyle.copyWith(
                          color: kNeutralColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ...availableFeatures.map((feature) {
                        return CheckboxListTile(
                          title: Text(feature,
                              style: kTextStyle.copyWith(color: kNeutralColor)),
                          value: tempSelected.contains(feature),
                          activeColor: kPrimaryColor,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                tempSelected.add(feature);
                              } else {
                                tempSelected.remove(feature);
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, tempSelected);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              foregroundColor: kWhite,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text('Save',
                                style: kTextStyle.copyWith(color: kWhite)),
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

  //__________Import Media Files Popup__________________________________________
  Future<Map<String, dynamic>?> showImportMediaPopUp() async {
    final TextEditingController fileTypeController = TextEditingController();
    return await showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          elevation: 5,
          backgroundColor: kWhite,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [kWhite, kDarkWhite],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Upload Media',
                    style: kTextStyle.copyWith(
                      color: kNeutralColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: fileTypeController,
                    decoration: kInputDecoration.copyWith(
                      labelText: 'File Type',
                      hintText: 'e.g., IMAGE, VIDEO',
                      prefixIcon: Icon(Icons.file_present, color: kPrimaryColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final XFile? file = await _picker.pickImage(source: ImageSource.gallery);
                      if (file != null) {
                        Navigator.pop(context, {
                          'file': File(file.path),
                          'type': fileTypeController.text.isEmpty ? 'IMAGE' : fileTypeController.text,
                        });
                      }
                    },
                    icon: Icon(Icons.upload_file, color: kWhite),
                    label: Text('Pick File', style: kTextStyle.copyWith(color: kWhite)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: kTextStyle.copyWith(color: kSubTitleColor)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  //__________Save Post Success Popup___________________________________________
  void savePostPopUp() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              gradient: LinearGradient(
                colors: [kWhite, kDarkWhite],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: const SaveProfilePopUp(), // Replace with SavePostPopUp if available
          ),
        );
      },
    );
  }

  //__________Submit to API____________________________________________________
  Future<void> submitPost() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

      // Add Post fields
      request.fields['creator_type'] = _creatorType ?? '';
      request.fields['category_id'] = _categoryId ?? '';
      request.fields['subcategory_id'] = _subcategoryId ?? '';
      request.fields['item_id'] = _itemId ?? '';
      request.fields['title'] = _titleController.text;
      request.fields['description'] = _descriptionController.text;
      request.fields['latitude'] = _latitudeController.text;
      request.fields['longitude'] = _longitudeController.text;
      request.fields['location'] = _locationController.text;
      request.fields['landmark'] = _landmarkController.text;
      request.fields['condition'] = _condition ?? '';
      request.fields['type'] = _type ?? '';
      request.fields['mode'] = _mode ?? '';
      request.fields['total_quantity'] = _totalQuantityController.text;
      request.fields['unit'] = _unitController.text;
      request.fields['lot_size'] = _lotSizeController.text;
      request.fields['reserve_price_per_unit'] = _reservePriceController.text;
      request.fields['increment_value'] = _incrementValueController.text;
      request.fields['emd_amount'] = _emdAmountController.text;
      request.fields['fee'] = _feeController.text.isEmpty ? '0' : _feeController.text;
      request.fields['inspection_open'] = _inspectionOpenController.text;
      request.fields['inspection_close'] = _inspectionCloseController.text;
      request.fields['emd_last_date'] = _emdLastDateController.text;
      request.fields['start'] = _startController.text;
      request.fields['end'] = _endController.text;
      request.fields['security_deposit_days'] = _securityDepositDaysController.text;
      request.fields['payment_deposit_days'] = _paymentDepositDaysController.text;
      request.fields['load_complete_days'] = _loadCompleteDaysController.text;
      request.fields['bid_list'] = _bidList ?? 'SINGLE';
      request.fields['bid_visibility'] = _bidVisibility ?? 'MASKED';
      request.fields['bid_approval_required'] = _bidApprovalRequired.toString();
      request.fields['bid_document_required'] = _bidDocumentRequired.toString();
      request.fields['status'] = _status ?? 'CREATED';

      // Add industry_specific_fields
      industrySpecificFields.asMap().forEach((index, field) {
        request.fields['industry_specific_fields[$index]'] = field;
      });

      // Add features
      features.asMap().forEach((index, feature) {
        request.fields['features[$index]'] = feature;
      });

      // Add media files
      for (var i = 0; i < _mediaFiles.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
            'file_url[$i]', _mediaFiles[i]['file'].path));
        request.fields['file_type[$i]'] = _mediaFiles[i]['type'];
      }

      // Add PostBuyerSellerInfo fields
      request.fields['type'] = _buyerSellerType ?? '';
      request.fields['status'] = _buyerSellerStatus ?? '';
      request.fields['full_name'] = _fullNameController.text;
      request.fields['mobile'] = _mobileController.text;
      request.fields['email'] = _emailController.text;
      request.fields['address'] = _addressController.text;
      request.fields['pan_tan'] = _panTanController.text;
      request.fields['gstn'] = _gstnController.text;
      request.fields['establishment_year'] = _establishmentYearController.text;

      // Add bank account for PostBuyerSellerInfo
      if (bankAccounts.isNotEmpty) {
        request.fields['beneficiary_name'] = bankAccounts[0]['beneficiary_name']!;
        request.fields['bank_name'] = bankAccounts[0]['bank_name']!;
        request.fields['account_number'] = bankAccounts[0]['account_number']!;
        request.fields['ifsc'] = bankAccounts[0]['ifsc']!;
        request.fields['upi'] = bankAccounts[0]['upi'] ?? '';
      }

      // Send request
      var response = await request.send();
      if (response.statusCode == 200) {
        savePostPopUp();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create post: ${response.statusCode}')),
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
        elevation: 2,
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
          'Create Job Post',
          style: kTextStyle.copyWith(
            color: kNeutralColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [kDarkWhite, kWhite],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: PageView.builder(
          itemCount: 3,
          physics: const BouncingScrollPhysics(),
          controller: pageController,
          onPageChanged: (int index) => setState(() {
            currentIndexPage = index;
            percent = 33.3 * (index + 1);
          }),
          itemBuilder: (_, i) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: kNeutralColor.withOpacity(0.1),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentIndexPage == 0
                              ? 'Step 1: Basic Info'
                              : currentIndexPage == 1
                                  ? 'Step 2: Post Details'
                                  : 'Step 3: Buyer/Seller Info',
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: kPrimaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${currentIndexPage + 1}/3',
                            style: kTextStyle.copyWith(
                              color: kPrimaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    StepProgressIndicator(
                      totalSteps: 3,
                      currentStep: currentIndexPage + 1,
                      size: 8,
                      padding: 0,
                      selectedColor: kPrimaryColor,
                      unselectedColor: kPrimaryColor.withOpacity(0.2),
                      roundedEdges: const Radius.circular(10),
                      selectedGradientColor: LinearGradient(
                        colors: [kPrimaryColor, kPrimaryColor.withOpacity(0.7)],
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Upload Media Files',
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12.0),
                        _mediaFiles.isEmpty
                            ? Center(
                                child: Text(
                                  'No media uploaded',
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                  childAspectRatio: 1,
                                ),
                                itemCount: _mediaFiles.length,
                                itemBuilder: (context, index) {
                                  return Stack(
                                    children: [
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(12.0),
                                          image: DecorationImage(
                                            image: FileImage(_mediaFiles[index]['file']),
                                            fit: BoxFit.cover,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: kNeutralColor.withOpacity(0.2),
                                              blurRadius: 5,
                                              offset: Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                        child: Align(
                                          alignment: Alignment.bottomCenter,
                                          child: Container(
                                            color: kNeutralColor.withOpacity(0.6),
                                            child: Text(
                                              _mediaFiles[index]['type'],
                                              style: kTextStyle.copyWith(
                                                color: kWhite,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 4,
                                        right: 4,
                                        child: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _mediaFiles.removeAt(index);
                                            });
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: kWhite,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: kNeutralColor.withOpacity(0.3),
                                                  blurRadius: 3,
                                                ),
                                              ],
                                            ),
                                            child: Icon(
                                              FeatherIcons.x,
                                              size: 16,
                                              color: kPrimaryColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                        const SizedBox(height: 12.0),
                        Center(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final result = await showImportMediaPopUp();
                              if (result != null) {
                                setState(() {
                                  _mediaFiles.add(result);
                                });
                              }
                            },
                            icon: Icon(Icons.upload_file, color: kWhite),
                            label: Text('Add Media', style: kTextStyle.copyWith(color: kWhite)),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24.0),
                        const Divider(color: kBorderColorTextField),
                        const SizedBox(height: 16.0),
                        Text(
                          'Post Information',
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _creatorType,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Creator Type',
                            prefixIcon: Icon(Icons.person_outline, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: creatorTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _creatorType = value),
                          validator: (value) =>
                              value == null ? 'Please select creator type' : null,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _categoryId,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Category',
                            prefixIcon: Icon(Icons.category, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: categories
                              .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _categoryId = value),
                          validator: (value) =>
                              value == null ? 'Please select a category' : null,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _subcategoryId,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Subcategory',
                            prefixIcon: Icon(Icons.category, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: subcategories
                              .map((subcategory) => DropdownMenuItem(
                                    value: subcategory,
                                    child: Text(subcategory),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _subcategoryId = value),
                          validator: (value) =>
                              value == null ? 'Please select a subcategory' : null,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _itemId,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Item',
                            prefixIcon: Icon(Icons.inventory, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: items
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Text(item),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _itemId = value),
                          validator: (value) =>
                              value == null ? 'Please select an item' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _titleController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Title',
                            hintText: 'Enter post title',
                            prefixIcon: Icon(Icons.title, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a title' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Description',
                            hintText: 'Enter description',
                            prefixIcon: Icon(Icons.description, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a description' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _locationController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Location',
                            hintText: 'Enter location',
                            prefixIcon: Icon(Icons.location_on, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a location' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _landmarkController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Landmark',
                            hintText: 'Enter landmark',
                            prefixIcon: Icon(Icons.place, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _latitudeController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Latitude',
                            hintText: 'Enter latitude (-90 to 90)',
                            prefixIcon: Icon(Icons.map, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
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
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _longitudeController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Longitude',
                            hintText: 'Enter longitude (-180 to 180)',
                            prefixIcon: Icon(Icons.map, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
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
                      ],
                    ).visible(currentIndexPage == 0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Auction Details',
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(color: kBorderColorTextField),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _condition,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Condition',
                            prefixIcon: Icon(Icons.build, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: conditions
                              .map((condition) => DropdownMenuItem(
                                    value: condition,
                                    child: Text(condition),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _condition = value),
                          validator: (value) =>
                              value == null ? 'Please select a condition' : null,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _type,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Type',
                            prefixIcon: Icon(Icons.swap_horiz, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: types
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _type = value),
                          validator: (value) =>
                              value == null ? 'Please select a type' : null,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _mode,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Mode',
                            prefixIcon: Icon(Icons.wifi, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: modes
                              .map((mode) => DropdownMenuItem(
                                    value: mode,
                                    child: Text(mode),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _mode = value),
                          validator: (value) =>
                              value == null ? 'Please select a mode' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _totalQuantityController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Total Quantity',
                            hintText: 'Enter total quantity',
                            prefixIcon: Icon(Icons.numbers, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter total quantity' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _unitController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Unit',
                            hintText: 'Enter unit (e.g., kg, pieces)',
                            prefixIcon: Icon(Icons.scale, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter a unit' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _lotSizeController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Lot Size',
                            hintText: 'Enter lot size',
                            prefixIcon: Icon(Icons.group_work, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter lot size' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _reservePriceController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Reserve Price per Unit',
                            hintText: 'Enter reserve price',
                            prefixIcon: Icon(Icons.attach_money, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter reserve price' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _incrementValueController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Increment Value',
                            hintText: 'Enter increment value',
                            prefixIcon: Icon(Icons.add_circle, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter increment value' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emdAmountController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'EMD Amount',
                            hintText: 'Enter EMD amount',
                            prefixIcon: Icon(Icons.security, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter EMD amount' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _feeController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Fee (Optional)',
                            hintText: 'Enter fee',
                            prefixIcon: Icon(Icons.payment, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _inspectionOpenController,
                          readOnly: true,
                          onTap: () => _selectDate(context, _inspectionOpenController),
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Inspection Open Date',
                            hintText: 'Select date',
                            prefixIcon: Icon(Icons.calendar_today, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please select inspection open date' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _inspectionCloseController,
                          readOnly: true,
                          onTap: () => _selectDate(context, _inspectionCloseController),
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Inspection Close Date',
                            hintText: 'Select date',
                            prefixIcon: Icon(Icons.calendar_today, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please select inspection close date' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emdLastDateController,
                          readOnly: true,
                          onTap: () => _selectDate(context, _emdLastDateController),
                          decoration: kInputDecoration.copyWith(
                            labelText: 'EMD Last Date',
                            hintText: 'Select date',
                            prefixIcon: Icon(Icons.calendar_today, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please select EMD last date' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _startController,
                          readOnly: true,
                          onTap: () => _selectDate(context, _startController),
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Start Date',
                            hintText: 'Select date',
                            prefixIcon: Icon(Icons.calendar_today, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please select start date' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _endController,
                          readOnly: true,
                          onTap: () => _selectDate(context, _endController),
                          decoration: kInputDecoration.copyWith(
                            labelText: 'End Date',
                            hintText: 'Select date',
                            prefixIcon: Icon(Icons.calendar_today, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please select end date' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _securityDepositDaysController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Security Deposit Days',
                            hintText: 'Enter days',
                            prefixIcon: Icon(Icons.lock, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter security deposit days' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _paymentDepositDaysController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Payment Deposit Days',
                            hintText: 'Enter days',
                            prefixIcon: Icon(Icons.payment, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter payment deposit days' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _loadCompleteDaysController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Load Complete Days',
                            hintText: 'Enter days',
                            prefixIcon: Icon(Icons.local_shipping, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter load complete days' : null,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _bidList,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Bid List',
                            prefixIcon: Icon(Icons.list, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: bidLists
                              .map((bid) => DropdownMenuItem(
                                    value: bid,
                                    child: Text(bid),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _bidList = value),
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _bidVisibility,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Bid Visibility',
                            prefixIcon: Icon(Icons.visibility, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: bidVisibilities
                              .map((visibility) => DropdownMenuItem(
                                    value: visibility,
                                    child: Text(visibility),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _bidVisibility = value),
                        ),
                        const SizedBox(height: 16.0),
                        CheckboxListTile(
                          title: Text('Bid Approval Required',
                              style: kTextStyle.copyWith(color: kNeutralColor)),
                          value: _bidApprovalRequired,
                          activeColor: kPrimaryColor,
                          onChanged: (value) =>
                              setState(() => _bidApprovalRequired = value!),
                        ),
                        const SizedBox(height: 16.0),
                        CheckboxListTile(
                          title: Text('Bid Document Required',
                              style: kTextStyle.copyWith(color: kNeutralColor)),
                          value: _bidDocumentRequired,
                          activeColor: kPrimaryColor,
                          onChanged: (value) =>
                              setState(() => _bidDocumentRequired = value!),
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _status,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Status',
                            prefixIcon: Icon(Icons.info, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: statuses
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _status = value),
                        ),
                        const SizedBox(height: 24.0),
                        const Divider(color: kBorderColorTextField),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Text(
                              'Industry Specific Fields',
                              style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () async {
                                final result = await showIndustryFieldsPopUp(
                                    selectedFields: industrySpecificFields);
                                if (result != null) {
                                  setState(() {
                                    industrySpecificFields = result;
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
                        const SizedBox(height: 12.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: industrySpecificFields.map((field) {
                            return Chip(
                              label: Text(field,
                                  style: kTextStyle.copyWith(color: kNeutralColor)),
                              backgroundColor: kPrimaryColor.withOpacity(0.1),
                              deleteIcon: Icon(FeatherIcons.x, size: 16, color: kPrimaryColor),
                              onDeleted: () {
                                setState(() {
                                  industrySpecificFields.remove(field);
                                });
                              },
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24.0),
                        Row(
                          children: [
                            Text(
                              'Features',
                              style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
                            const SizedBox(width: 5.0),
                            GestureDetector(
                              onTap: () async {
                                final result =
                                    await showFeaturesPopUp(selectedFeatures: features);
                                if (result != null) {
                                  setState(() {
                                    features = result;
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
                        const SizedBox(height: 12.0),
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 8.0,
                          children: features.map((feature) {
                            return Chip(
                              label: Text(feature,
                                  style: kTextStyle.copyWith(color: kNeutralColor)),
                              backgroundColor: kPrimaryColor.withOpacity(0.1),
                              deleteIcon: Icon(FeatherIcons.x, size: 16, color: kPrimaryColor),
                              onDeleted: () {
                                setState(() {
                                  features.remove(feature);
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ).visible(currentIndexPage == 1),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Buyer/Seller Information',
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        const Divider(color: kBorderColorTextField),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _buyerSellerType,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Type',
                            prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: buyerSellerTypes
                              .map((type) => DropdownMenuItem(
                                    value: type,
                                    child: Text(type),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _buyerSellerType = value),
                          validator: (value) =>
                              value == null ? 'Please select a type' : null,
                        ),
                        const SizedBox(height: 16.0),
                        DropdownButtonFormField<String>(
                          value: _buyerSellerStatus,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Status',
                            prefixIcon: Icon(Icons.info, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          items: buyerSellerStatuses
                              .map((status) => DropdownMenuItem(
                                    value: status,
                                    child: Text(status),
                                  ))
                              .toList(),
                          onChanged: (value) => setState(() => _buyerSellerStatus = value),
                          validator: (value) =>
                              value == null ? 'Please select a status' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _fullNameController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Full Name',
                            hintText: 'Enter full name',
                            prefixIcon: Icon(Icons.person, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter full name' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Mobile',
                            hintText: 'Enter mobile number',
                            prefixIcon: Icon(Icons.phone, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter mobile number';
                            }
                            if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                              return 'Please enter a valid 10-digit mobile number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Email',
                            hintText: 'Enter email',
                            prefixIcon: Icon(Icons.email, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter an email';
                            }
                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _addressController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Address',
                            hintText: 'Enter address',
                            prefixIcon: Icon(Icons.location_city, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter an address' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _panTanController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'PAN/TAN',
                            hintText: 'Enter PAN/TAN number',
                            prefixIcon: Icon(Icons.badge, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter PAN/TAN' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _gstnController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'GSTN',
                            hintText: 'Enter GSTN number',
                            prefixIcon: Icon(Icons.business, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter GSTN' : null,
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          controller: _establishmentYearController,
                          keyboardType: TextInputType.number,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Establishment Year',
                            hintText: 'Enter establishment year',
                            prefixIcon: Icon(Icons.calendar_today, color: kPrimaryColor),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter establishment year' : null,
                        ),
                        const SizedBox(height: 24.0),
                        const Divider(color: kBorderColorTextField),
                        const SizedBox(height: 16.0),
                        Row(
                          children: [
                            Text(
                              'Bank Accounts',
                              style: kTextStyle.copyWith(
                                color: kNeutralColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Spacer(),
                            Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
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
                        const SizedBox(height: 12.0),
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
                                          '${bank['bank_name']} ${bank['account_number']} ${bank['ifsc']} ${bank['upi'] ?? ''}',
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
                              const SizedBox(height: 12.0),
                            ],
                          );
                        }),
                        const SizedBox(height: 24.0),
                        Text(
                          'Review Your Post',
                          style: kTextStyle.copyWith(
                            color: kNeutralColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12.0),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ScaleTransition(
          scale: _buttonAnimation,
          child: ButtonGlobalWithoutIcon(
            buttontext: currentIndexPage < 2 ? 'Continue' : 'Save Post',
            buttonDecoration: kButtonDecoration.copyWith(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(30.0),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            onPressed: () async {
              await _animationController.forward();
              await _animationController.reverse();
              if (currentIndexPage < 2) {
                if (currentIndexPage == 0 && !_formKey.currentState!.validate()) {
                  return;
                }
                pageController.nextPage(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOut,
                );
              } else {
                submitPost();
              }
            },
            buttonTextColor: kWhite,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _landmarkController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    _totalQuantityController.dispose();
    _unitController.dispose();
    _lotSizeController.dispose();
    _reservePriceController.dispose();
    _incrementValueController.dispose();
    _emdAmountController.dispose();
    _feeController.dispose();
    _inspectionOpenController.dispose();
    _inspectionCloseController.dispose();
    _emdLastDateController.dispose();
    _startController.dispose();
    _endController.dispose();
    _securityDepositDaysController.dispose();
    _paymentDepositDaysController.dispose();
    _loadCompleteDaysController.dispose();
    _fullNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _panTanController.dispose();
    _gstnController.dispose();
    _establishmentYearController.dispose();
    pageController.dispose();
    super.dispose();
  }
}

// Placeholder for InfoShowCase widget
class InfoShowCase extends StatelessWidget {
  final String title;
  final String subTitle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const InfoShowCase({
    super.key,
    required this.title,
    required this.subTitle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4.0),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: kNeutralColor.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(title,
            style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.w600)),
        subtitle: Text(subTitle, style: kTextStyle.copyWith(color: kSubTitleColor)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(FeatherIcons.edit, color: kPrimaryColor, size: 20),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(FeatherIcons.trash, color: kPrimaryColor, size: 20),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}