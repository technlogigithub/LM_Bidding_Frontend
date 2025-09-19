// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter_feather_icons/flutter_feather_icons.dart';
// import 'package:flutter_iconly/flutter_iconly.dart';
// import 'package:freelancer/screen/app_config/app_config.dart';
// import 'package:freelancer/screen/widgets/button_global.dart';
// import 'package:freelancer/screen/widgets/constant.dart';
// import 'package:freelancer/screen/widgets/data.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:http/http.dart' as http;
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:google_api_headers/google_api_headers.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';

// class SetupClientProfile extends StatefulWidget {
//   const SetupClientProfile({super.key});

//   @override
//   State<SetupClientProfile> createState() => _SetupClientProfileState();
// }

// class _SetupClientProfileState extends State<SetupClientProfile> {
//   PageController pageController = PageController(initialPage: 0);
//   int currentIndexPage = 0;
//   double percent = 25.0;

//   List<bool> isSelected = [true, false]; // default: Individual
//   String userType = "Individual";
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _userNameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _mobileController = TextEditingController();
//   final TextEditingController _aadharController = TextEditingController();
//   final TextEditingController _panController = TextEditingController();
//   final TextEditingController _gstnController = TextEditingController();
//   final TextEditingController _regNoController = TextEditingController();
//   final TextEditingController _addressSearchController =
//       TextEditingController();

//   // File variables
//   File? _dpImage;
//   File? _bannerImage;
//   File? _bankDocument;
//   File? _aadharFrontImage;
//   File? _aadharBackImage;
//   List<File> _panCardFiles = [];
//   List<File> _gstCertificateFiles = [];
//   List<File> _regCertificateFiles = [];

//   // Image URLs from API
//   String? _dpImageUrl;
//   String? _bannerImageUrl;
//   String? _bankDocumentUrl;
//   String? _aadharFrontUrl;
//   String? _aadharBackUrl;
//   String? _panCardUrl;
//   String? _gstCertificateUrl;
//   String? _regCertificateUrl;

//   // Dynamic lists
//   List<Map<String, dynamic>> addresses = [];
//   List<Map<String, String>> bankAccounts = [];

//   // Primary bank and default address indices
//   int primaryBankIndex = -1;
//   int defaultAddressIndex = -1;

//   // API endpoint
//   final String apiUrl =
//       'https://phplaravel-1517766-5835172.cloudwaysapps.com/api/profile/update';

//   // Image picker
//   final ImagePicker _picker = ImagePicker();

//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchProfileData();
//   }

//   // Fetch profile data from API
//   Future<void> _fetchProfileData() async {
//     setState(() => _isLoading = true);
//     try {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content:
//                   Text('No internet connection. Unable to fetch profile.')),
//         );
//         return;
//       }

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content:
//                   Text('Authentication token not found. Please log in again.')),
//         );
//         return;
//       }

//       final response = await http.post(
//         Uri.parse(apiUrl),
//         headers: {
//           'Accept': 'application/json',
//           'Authorization': 'Bearer $token',
//         },
//       ).timeout(const Duration(seconds: 30));

//       if (response.statusCode == 200) {
//         final decodedResponse = jsonDecode(response.body);
//         if (decodedResponse['response_code'] == 200 &&
//             decodedResponse['success'] == true) {
//           final result = decodedResponse['result'];
//           setState(() {
//             // Basic Info
//             _nameController.text = result['name'] ?? '';
//             _userNameController.text = result['username'] ?? '';
//             _emailController.text = result['email'] ?? '';
//             _mobileController.text = result['mobile'] ?? '';
//             _dpImageUrl = result['dp_image_url'];
//             _bannerImageUrl = result['banner_image_url'];

//             // Addresses
//             addresses = List<Map<String, dynamic>>.from(
//                 result['addresses'].map((addr) => {
//                       'address_key': addr['address_key'] ?? '',
//                       'address_type': addr['address_type'] ?? '',
//                       'address': addr['full_address'] ?? '',
//                       'landmark': '',
//                       'latitude': addr['latitude']?.toString() ?? '',
//                       'longitude': addr['longitude']?.toString() ?? '',
//                       'default_address': addr['is_default'] == 1 ? '1' : '0',
//                       'place_id': '',
//                     }));
//             defaultAddressIndex = addresses
//                 .asMap()
//                 .entries
//                 .firstWhere(
//                   (entry) => entry.value['default_address'] == '1',
//                   orElse: () => MapEntry(-1, {}),
//                 )
//                 .key;

//             // Bank Accounts
//             bankAccounts = List<Map<String, String>>.from(
//                 result['bank_accounts'].map((bank) => {
//                       'account_key': bank['account_key'] ?? '',
//                       'beneficiary_name': bank['beneficiary_name'] ?? '',
//                       'account_number': bank['account_number'] ?? '',
//                       'ifsc_code': bank['ifsc_code'] ?? '',
//                       'upi_address': bank['upi_address'] ?? '',
//                       'primary_bank': bank['is_primary'] == 1 ? '1' : '0',
//                     }));
//             primaryBankIndex = bankAccounts
//                 .asMap()
//                 .entries
//                 .firstWhere(
//                   (entry) => entry.value['primary_bank'] == '1',
//                   orElse: () => MapEntry(-1, {}),
//                 )
//                 .key;
//             _bankDocumentUrl = result['bank_accounts'][0]['bank_document_url'];

//             // Documents
//             for (var doc in result['documents']) {
//               switch (doc['document_key']) {
//                 case 'aadhar':
//                   _aadharController.text = doc['document_value'] ?? '';
//                   break;
//                 case 'pan':
//                   _panController.text = doc['document_value'] ?? '';
//                   _panCardUrl = doc['document_url'];
//                   break;
//                 case 'gstn':
//                   _gstnController.text = doc['document_value'] ?? '';
//                   _gstCertificateUrl = doc['document_url'];
//                   break;
//                 case 'reg_no':
//                   _regNoController.text = doc['document_value'] ?? '';
//                   _regCertificateUrl = doc['document_url'];
//                   break;
//                 case 'aadhar_front':
//                   _aadharFrontUrl = doc['document_url_full'];
//                   break;
//                 case 'aadhar_back':
//                   _aadharBackUrl = doc['document_url_full'];
//                   break;
//               }
//             }
//           });
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(
//                     decodedResponse['message'] ?? 'Failed to fetch profile')),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Failed to fetch profile: ${response.statusCode} ${response.reasonPhrase}')),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error fetching profile: $e')),
//       );
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // Request permissions
//   Future<bool> requestStoragePermission({bool isCamera = false}) async {
//     if (Platform.isAndroid) {
//       if (isCamera) {
//         final cameraStatus = await Permission.camera.status;
//         if (!cameraStatus.isGranted) {
//           final status = await Permission.camera.request();
//           if (!status.isGranted) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(
//                   content:
//                       Text('Camera permission is required for taking photos')),
//             );
//             return false;
//           }
//         }
//       }

//       final photoStatus = await Permission.photos.status;
//       if (photoStatus.isGranted) return true;
//       final photoResult = await Permission.photos.request();
//       if (photoResult.isGranted) return true;

//       final storageStatus = await Permission.storage.status;
//       if (storageStatus.isGranted) return true;
//       final storageResult = await Permission.storage.request();
//       if (storageResult.isGranted) return true;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text(
//                 'Storage or media permissions are required to pick images')),
//       );
//       return false;
//     }
//     return true;
//   }

//   // Fetch lat/lng from Google Place ID
//   Future<Map<String, String>?> getLatLngFromPlaceId(String placeId) async {
//     if (placeId.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please select a valid address')),
//       );
//       return null;
//     }

//     final String apiKey = AppInfo.googleAddressKey;
//     if (apiKey.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Google API key is missing. Contact support.')),
//       );
//       return null;
//     }

//     final url = Uri.parse(
//       'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&fields=formatted_address,geometry&key=$apiKey',
//     );

//     try {
//       final headers = await GoogleApiHeaders().getHeaders();
//       final response = await http
//           .get(url, headers: headers)
//           .timeout(const Duration(seconds: 10));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['status'] == 'OK' && data['result'] != null) {
//           final location = data['result']['geometry']['location'];
//           return {
//             'address': data['result']['formatted_address'],
//             'latitude': location['lat'].toString(),
//             'longitude': location['lng'].toString(),
//           };
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(
//                     'Geocoding failed: ${data['error_message'] ?? 'No results found'}')),
//           );
//           return null;
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content:
//                   Text('Geocoding request failed: ${response.statusCode}')),
//         );
//         return null;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Error fetching coordinates. Please try again.')),
//       );
//       return null;
//     }
//   }

//   // Address popup
//   Future<Map<String, dynamic>?> showAddressPopUp(
//       {Map<String, dynamic>? existingAddress, int? index}) async {
//     final addressTypeController =
//         TextEditingController(text: existingAddress?['address_type'] ?? '');
//     final addressLine1Controller =
//         TextEditingController(text: existingAddress?['address'] ?? '');
//     final landmarkController =
//         TextEditingController(text: existingAddress?['landmark'] ?? '');
//     final latitudeController =
//         TextEditingController(text: existingAddress?['latitude'] ?? '');
//     final longitudeController =
//         TextEditingController(text: existingAddress?['longitude'] ?? '');
//     bool isDefault = index == defaultAddressIndex;
//     bool isLoadingCoordinates = false;
//     bool useAutocomplete = true;
//     String? placeId = existingAddress?['place_id'];
//     String? errorMessage;

//     final connectivityResult = await Connectivity().checkConnectivity();
//     bool hasInternet = connectivityResult != ConnectivityResult.none;
//     if (!hasInternet || AppInfo.googleAddressKey.isEmpty) {
//       useAutocomplete = false;
//       errorMessage = !hasInternet
//           ? 'No internet connection. Manual entry only.'
//           : 'Google API key missing. Manual entry only.';
//     }

//     if (existingAddress == null &&
//         hasInternet &&
//         AppInfo.googleAddressKey.isNotEmpty) {
//       try {
//         bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//         if (!serviceEnabled) {
//           errorMessage = 'Location services are disabled. Using manual entry.';
//           useAutocomplete = false;
//         } else {
//           LocationPermission permission = await Geolocator.checkPermission();
//           if (permission == LocationPermission.denied) {
//             permission = await Geolocator.requestPermission();
//             if (permission == LocationPermission.denied) {
//               errorMessage = 'Location permission denied. Using manual entry.';
//               useAutocomplete = false;
//             }
//           }

//           if (permission == LocationPermission.whileInUse ||
//               permission == LocationPermission.always) {
//             isLoadingCoordinates = true;
//             Position position = await Geolocator.getCurrentPosition(
//                 desiredAccuracy: LocationAccuracy.high);
//             final url = Uri.parse(
//               'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${AppInfo.googleAddressKey}',
//             );
//             final response = await http.get(url);
//             if (response.statusCode == 200) {
//               final data = jsonDecode(response.body);
//               if (data['status'] == 'OK' && data['results'].isNotEmpty) {
//                 final address = data['results'][0]['formatted_address'];
//                 placeId = data['results'][0]['place_id'];
//                 addressLine1Controller.text = address;
//                 _addressSearchController.text = address;
//                 latitudeController.text = position.latitude.toString();
//                 longitudeController.text = position.longitude.toString();
//               } else {
//                 errorMessage =
//                     'Failed to fetch current address: ${data['error_message'] ?? 'No results'}';
//               }
//             } else {
//               errorMessage =
//                   'Failed to fetch current address: ${response.statusCode}';
//             }
//           }
//         }
//       } catch (e) {
//         errorMessage = 'Error fetching current location. Using manual entry.';
//         useAutocomplete = false;
//       } finally {
//         isLoadingCoordinates = false;
//       }
//     }

//     _addressSearchController.clear();
//     if (existingAddress == null && addressLine1Controller.text.isNotEmpty) {
//       _addressSearchController.text = addressLine1Controller.text;
//     }

//     final result = await showDialog<Map<String, dynamic>>(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.0)),
//               child: SizedBox(
//                 height: MediaQuery.of(context).size.height * 0.8,
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: SingleChildScrollView(
//                     child: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         Text(
//                           existingAddress == null
//                               ? 'Add Address'
//                               : 'Edit Address',
//                           style: kTextStyle.copyWith(
//                               color: kNeutralColor,
//                               fontWeight: FontWeight.bold),
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: addressTypeController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Address Type',
//                             hintText: 'e.g., Office, Home',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) => value == null || value.isEmpty
//                               ? 'Please enter address type'
//                               : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         CheckboxListTile(
//                           title: Text('Use Google Autocomplete',
//                               style: kTextStyle.copyWith(color: kNeutralColor)),
//                           value: useAutocomplete,
//                           onChanged:
//                               hasInternet && AppInfo.googleAddressKey.isNotEmpty
//                                   ? (value) {
//                                       setState(() {
//                                         useAutocomplete = value!;
//                                         if (!useAutocomplete) {
//                                           _addressSearchController.clear();
//                                           addressLine1Controller.clear();
//                                           latitudeController.clear();
//                                           longitudeController.clear();
//                                           errorMessage = null;
//                                         }
//                                       });
//                                     }
//                                   : null,
//                           subtitle: errorMessage != null
//                               ? Text(errorMessage!,
//                                   style: const TextStyle(color: Colors.red))
//                               : null,
//                         ),
//                         const SizedBox(height: 20.0),
//                         useAutocomplete
//                             ? GooglePlaceAutoCompleteTextField(
//                                 textEditingController: _addressSearchController,
//                                 googleAPIKey: AppInfo.googleAddressKey,
//                                 inputDecoration: kInputDecoration.copyWith(
//                                   labelText: 'Search Address',
//                                   hintText:
//                                       'Enter address (e.g., Delhi, India)',
//                                   border: const OutlineInputBorder(),
//                                   suffixIcon: isLoadingCoordinates
//                                       ? const Padding(
//                                           padding: EdgeInsets.all(12.0),
//                                           child: CircularProgressIndicator(
//                                               strokeWidth: 2.0),
//                                         )
//                                       : const Icon(IconlyBold.location,
//                                           color: kPrimaryColor),
//                                   errorText: errorMessage,
//                                 ),
//                                 isLatLngRequired: true,
//                                 debounceTime: 300,
//                                 getPlaceDetailWithLatLng:
//                                     (Prediction prediction) async {
//                                   if (prediction.placeId == null) {
//                                     setState(() {
//                                       errorMessage = 'Invalid place selected';
//                                       isLoadingCoordinates = false;
//                                     });
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content:
//                                               Text('Invalid place selected')),
//                                     );
//                                     return;
//                                   }
//                                   setState(() => isLoadingCoordinates = true);
//                                   final coords = await getLatLngFromPlaceId(
//                                       prediction.placeId!);
//                                   if (coords != null) {
//                                     setState(() {
//                                       addressLine1Controller.text =
//                                           coords['address']!;
//                                       latitudeController.text =
//                                           coords['latitude']!;
//                                       longitudeController.text =
//                                           coords['longitude']!;
//                                       _addressSearchController.text =
//                                           coords['address']!;
//                                       placeId = prediction.placeId;
//                                       errorMessage = null;
//                                       isLoadingCoordinates = false;
//                                     });
//                                   } else {
//                                     setState(() {
//                                       errorMessage =
//                                           'Failed to fetch address details';
//                                       isLoadingCoordinates = false;
//                                     });
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content: Text(
//                                               'Failed to fetch address details')),
//                                     );
//                                   }
//                                 },
//                                 itemClick: (Prediction prediction) {
//                                   _addressSearchController.text =
//                                       prediction.description ?? '';
//                                   _addressSearchController.selection =
//                                       TextSelection.fromPosition(
//                                     TextPosition(
//                                         offset: _addressSearchController
//                                             .text.length),
//                                   );
//                                 },
//                                 textStyle:
//                                     kTextStyle.copyWith(color: kNeutralColor),
//                               )
//                             : TextFormField(
//                                 controller: addressLine1Controller,
//                                 decoration: kInputDecoration.copyWith(
//                                   labelText: 'Address',
//                                   hintText:
//                                       'Enter address manually (e.g., 123 MG Road)',
//                                   border: const OutlineInputBorder(),
//                                 ),
//                                 validator: (value) =>
//                                     value == null || value.isEmpty
//                                         ? 'Please enter address'
//                                         : null,
//                               ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: landmarkController,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Landmark',
//                             hintText: 'e.g., Near Metro Station',
//                             border: const OutlineInputBorder(),
//                           ),
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: latitudeController,
//                           keyboardType: TextInputType.number,
//                           readOnly: useAutocomplete,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Latitude',
//                             hintText: useAutocomplete
//                                 ? 'Auto-filled'
//                                 : 'Enter latitude (e.g., 28.7041)',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (!useAutocomplete &&
//                                 (value == null || value.isEmpty)) {
//                               return 'Please enter latitude';
//                             }
//                             if (value != null && value.isNotEmpty) {
//                               final numValue = double.tryParse(value);
//                               if (numValue == null ||
//                                   numValue < -90 ||
//                                   numValue > 90) {
//                                 return 'Invalid latitude (-90 to 90)';
//                               }
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         TextFormField(
//                           controller: longitudeController,
//                           keyboardType: TextInputType.number,
//                           readOnly: useAutocomplete,
//                           decoration: kInputDecoration.copyWith(
//                             labelText: 'Longitude',
//                             hintText: useAutocomplete
//                                 ? 'Auto-filled'
//                                 : 'Enter longitude (e.g., 77.1025)',
//                             border: const OutlineInputBorder(),
//                           ),
//                           validator: (value) {
//                             if (!useAutocomplete &&
//                                 (value == null || value.isEmpty)) {
//                               return 'Please enter longitude';
//                             }
//                             if (value != null && value.isNotEmpty) {
//                               final numValue = double.tryParse(value);
//                               if (numValue == null ||
//                                   numValue < -180 ||
//                                   numValue > 180) {
//                                 return 'Invalid longitude (-180 to 180)';
//                               }
//                             }
//                             return null;
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         CheckboxListTile(
//                           title: Text('Set as Default',
//                               style: kTextStyle.copyWith(color: kNeutralColor)),
//                           value: isDefault,
//                           onChanged: (value) {
//                             setState(() {
//                               isDefault = value!;
//                               if (isDefault) {
//                                 this.setState(() => defaultAddressIndex =
//                                     index ?? addresses.length);
//                               } else if (index == defaultAddressIndex) {
//                                 this.setState(() => defaultAddressIndex = -1);
//                               }
//                             });
//                           },
//                         ),
//                         const SizedBox(height: 20.0),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             TextButton(
//                               onPressed: () => Navigator.pop(context),
//                               child: Text('Cancel',
//                                   style: kTextStyle.copyWith(
//                                       color: kSubTitleColor)),
//                             ),
//                             TextButton(
//                               onPressed: () {
//                                 if (addressTypeController.text.isNotEmpty &&
//                                     addressLine1Controller.text.isNotEmpty &&
//                                     (!useAutocomplete ||
//                                         (latitudeController.text.isNotEmpty &&
//                                             longitudeController
//                                                 .text.isNotEmpty))) {
//                                   final address = {
//                                     'address_key':
//                                         existingAddress?['address_key'] ?? '',
//                                     'address_type': addressTypeController.text,
//                                     'address': addressLine1Controller.text,
//                                     'landmark': landmarkController.text,
//                                     'latitude': latitudeController.text,
//                                     'longitude': longitudeController.text,
//                                     'default_address': isDefault ? '1' : '0',
//                                     'place_id': placeId ?? '',
//                                   };
//                                   Navigator.pop(context, address);
//                                 } else {
//                                   ScaffoldMessenger.of(context).showSnackBar(
//                                     const SnackBar(
//                                         content: Text(
//                                             'Please fill all required fields')),
//                                   );
//                                 }
//                               },
//                               child: Text(
//                                 existingAddress == null ? 'Add' : 'Update',
//                                 style:
//                                     kTextStyle.copyWith(color: kPrimaryColor),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );

//     return result;
//   }

//   // Bank account popup
//   Future<Map<String, String>?> showBankAccountPopUp(
//       {Map<String, String>? existingBankAccount, int? index}) async {
//     final beneficiaryController = TextEditingController(
//         text: existingBankAccount?['beneficiary_name'] ?? '');
//     final accountNumberController = TextEditingController(
//         text: existingBankAccount?['account_number'] ?? '');
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
//                   borderRadius: BorderRadius.circular(20.0)),
//               child: Padding(
//                 padding: const EdgeInsets.all(20.0),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       existingBankAccount == null
//                           ? 'Add Bank Account'
//                           : 'Edit Bank Account',
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
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'Please enter beneficiary name'
//                           : null,
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
//                       validator: (value) => value == null || value.isEmpty
//                           ? 'Please enter account number'
//                           : null,
//                     ),
//                     const SizedBox(height: 20.0),
//                     TextFormField(
//                       controller: ifscCodeController,
//                       decoration: kInputDecoration.copyWith(
//                         labelText: 'IFSC Code',
//                         hintText: 'Enter IFSC code (e.g., HDFC0005678)',
//                         border: const OutlineInputBorder(),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty)
//                           return 'Please enter IFSC code';
//                         if (!RegExp(r'^[A-Z]{4}0[A-Z0-9]{6}$')
//                             .hasMatch(value)) {
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
//                         hintText:
//                             'Enter UPI address (e.g., jane123@okhdfcbank)',
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
//                             this.setState(() => primaryBankIndex =
//                                 index ?? bankAccounts.length);
//                           } else if (index == primaryBankIndex) {
//                             this.setState(() => primaryBankIndex = -1);
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
//                               style:
//                                   kTextStyle.copyWith(color: kSubTitleColor)),
//                         ),
//                         TextButton(
//                           onPressed: () {
//                             if (beneficiaryController.text.isNotEmpty &&
//                                 accountNumberController.text.isNotEmpty &&
//                                 ifscCodeController.text.isNotEmpty) {
//                               final bankAccount = {
//                                 'beneficiary_name': beneficiaryController.text,
//                                 'account_number': accountNumberController.text,
//                                 'ifsc_code': ifscCodeController.text,
//                                 'upi_address': upiAddressController.text,
//                                 'primary_bank': isPrimary ? '1' : '0',
//                               };
//                               Navigator.pop(context, bankAccount);
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 const SnackBar(
//                                     content: Text(
//                                         'Please fill all required fields')),
//                               );
//                             }
//                           },
//                           child: Text(
//                             existingBankAccount == null ? 'Add' : 'Update',
//                             style: kTextStyle.copyWith(color: kPrimaryColor),
//                           ),
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

//   // Image upload popup
//   Future<File?> showImageUploadPopUp(String title,
//       {bool isAadhar = false, bool isFront = true}) async {
//     if (!await requestStoragePermission(isCamera: true)) return null;

//     return await showDialog<File?>(
//       barrierDismissible: true,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   'Select Image Source for $title',
//                   style: kTextStyle.copyWith(
//                       color: kNeutralColor, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 20.0),
//                 ListTile(
//                   title: const Text('Gallery'),
//                   leading: const Icon(IconlyBold.image),
//                   onTap: () async {
//                     try {
//                       final XFile? file =
//                           await _picker.pickImage(source: ImageSource.gallery);
//                       Navigator.pop(
//                           context, file != null ? File(file.path) : null);
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content:
//                                 Text('Error picking image from gallery: $e')),
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
//                       final XFile? file =
//                           await _picker.pickImage(source: ImageSource.camera);
//                       Navigator.pop(
//                           context, file != null ? File(file.path) : null);
//                     } catch (e) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content:
//                                 Text('Error picking image from camera: $e')),
//                       );
//                       Navigator.pop(context, null);
//                     }
//                   },
//                 ),
//                 TextButton(
//                   onPressed: () => Navigator.pop(context, null),
//                   child: Text('Cancel',
//                       style: kTextStyle.copyWith(color: kSubTitleColor)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   // Profile picture popup
//   Future<void> showImportProfilePopUp() async {
//     await showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('Pick Profile Image'),
//                 onTap: () async {
//                   final file = await showImageUploadPopUp('Profile Image');
//                   if (file != null) setState(() => _dpImage = file);
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 title: const Text('Pick Banner Image'),
//                 onTap: () async {
//                   final file = await showImageUploadPopUp('Banner Image');
//                   if (file != null) setState(() => _bannerImage = file);
//                   Navigator.pop(context);
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   // Save profile success popup
//   void saveProfilePopUp(String message) {
//     showDialog(
//       barrierDismissible: false,
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape:
//               RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
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

//   // Verify document (Mock API)
//   Future<bool> verifyDocument(String type, String value) async {
//     try {
//       await Future.delayed(const Duration(seconds: 1));
//       return true;
//     } catch (e) {
//       return false;
//     }
//   }

//   // Submit profile to API
//   Future<bool> submitProfile({bool isPartial = false}) async {
//     setState(() => _isLoading = true);

//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please fill all required fields correctly')),
//       );
//       setState(() => _isLoading = false);
//       return false;
//     }

//     if (currentIndexPage == 0 &&
//         (_dpImage == null && _dpImageUrl == null ||
//             _bannerImage == null && _bannerImageUrl == null)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//             content: Text('Please upload both profile and banner images')),
//       );
//       setState(() => _isLoading = false);
//       return false;
//     }

//     if (currentIndexPage >= 1 && addresses.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add at least one address')),
//       );
//       setState(() => _isLoading = false);
//       return false;
//     }

//     if (currentIndexPage >= 2 && bankAccounts.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please add at least one bank account')),
//       );
//       setState(() => _isLoading = false);
//       return false;
//     }

//     if (currentIndexPage >= 2 &&
//         _bankDocument == null &&
//         _bankDocumentUrl == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please upload bank document')),
//       );
//       setState(() => _isLoading = false);
//       return false;
//     }

//     if (currentIndexPage == 3) {
//       if (_aadharFrontImage == null && _aadharFrontUrl == null ||
//           _aadharBackImage == null && _aadharBackUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Please upload both Aadhar front and back images')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }
//       if (_panCardFiles.isEmpty && _panCardUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please upload PAN card image')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }
//       if (_gstCertificateFiles.isEmpty && _gstCertificateUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please upload GST certificate')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }
//       if (_regCertificateFiles.isEmpty && _regCertificateUrl == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('Please upload registration certificate')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }
//       if (!await verifyDocument('aadhar', _aadharController.text)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Aadhar verification failed')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }
//       if (!await verifyDocument('pan', _panController.text)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('PAN verification failed')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }
//       if (!await verifyDocument('gstn', _gstnController.text)) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('GSTN verification failed')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }
//     }

//     try {
//       final connectivityResult = await Connectivity().checkConnectivity();
//       if (connectivityResult == ConnectivityResult.none) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content: Text('No internet connection. Please try again.')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString('auth_token');
//       if (token == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//               content:
//                   Text('Authentication token not found. Please log in again.')),
//         );
//         setState(() => _isLoading = false);
//         return false;
//       }

//       const maxFileSize = 5 * 1024 * 1024; // 5MB
//       for (var file in [
//         _dpImage,
//         _bannerImage,
//         _bankDocument,
//         _aadharFrontImage,
//         _aadharBackImage,
//         ..._panCardFiles,
//         ..._gstCertificateFiles,
//         ..._regCertificateFiles
//       ]) {
//         if (file != null) {
//           final fileSize = await file.length();
//           if (fileSize > maxFileSize) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               SnackBar(
//                   content: Text(
//                       'File ${file.path.split('/').last} is too large. Max size is 5MB.')),
//             );
//             setState(() => _isLoading = false);
//             return false;
//           }
//         }
//       }

//       final Map<String, String> headers = {
//         'Accept': 'application/json',
//         'Authorization': 'Bearer $token',
//       };

//       var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
//       request.headers.addAll(headers);

//       // Basic Info
//       if (currentIndexPage >= 0) {
//         request.fields.addAll({
//           'step_no': '0',
//           'name': _nameController.text,
//           'username': _userNameController.text,
//           'email': _emailController.text,
//           'mobile': _mobileController.text,
//           'user_type': userType,
//         });
//       }

//       // Addresses
//       if (currentIndexPage >= 1) {
        
//         addresses.asMap().forEach((index, address) {
//           request.fields['addresses[$index][address_key]'] =
//               address['address_key'] ?? '';
//           request.fields['addresses[$index][address_type]'] =
//               address['address_type']!;
//           request.fields['addresses[$index][address_line1]'] =
//               address['address']!;
//           request.fields['addresses[$index][landmark]'] =
//               address['landmark'] ?? '';
//           request.fields['addresses[$index][latitude]'] =
//               address['latitude'] ?? '';
//           request.fields['addresses[$index][longitude]'] =
//               address['longitude'] ?? '';
//           request.fields['addresses[$index][default_address]'] =  
//               address['default_address'] ?? '0';
//         });
//         request.fields['default_address_index'] =
//             defaultAddressIndex.toString();
//              request.fields['step_no'] =
//             "1";
//       }

//       // Bank Accounts
//       if (currentIndexPage >= 2) {
//         bankAccounts.asMap().forEach((index, bank) {
//           request.fields['bank_accounts[$index][account_key]'] =
//               bank['account_key'] ?? '';
//           request.fields['bank_accounts[$index][beneficiary_name]'] =
//               bank['beneficiary_name']!;
//           request.fields['bank_accounts[$index][account_number]'] =
//               bank['account_number']!;
//           request.fields['bank_accounts[$index][ifsc_code]'] =
//               bank['ifsc_code']!;
//           request.fields['bank_accounts[$index][upi_address]'] =
//               bank['upi_address'] ?? '';
//           request.fields['bank_accounts[$index][primary_bank]'] =
//               bank['primary_bank'] ?? '0';
//         });
//         request.fields['primary_bank'] = primaryBankIndex.toString();
//          request.fields['step_no'] =
//             "2";
//       }

//       // Documents
//       if (currentIndexPage == 3) {
//          request.fields['step_no'] =
//             "3";
//         request.fields['aadhar'] = _aadharController.text;
//         request.fields['pan'] = _panController.text;
//         request.fields['gstn'] = _gstnController.text;
//         request.fields['reg_no'] = _regNoController.text;
//       }

//       // Files
//       if (currentIndexPage >= 0 && _dpImage != null) {
//         request.files
//             .add(await http.MultipartFile.fromPath('dp_image', _dpImage!.path));
//       }
//       if (currentIndexPage >= 0 && _bannerImage != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//             'banner_image', _bannerImage!.path));
//       }
//       if (currentIndexPage >= 2 && _bankDocument != null) {
//         request.files.add(await http.MultipartFile.fromPath(
//             'bank_document', _bankDocument!.path));
//       }
//       if (currentIndexPage == 3) {
//         if (_aadharFrontImage != null) {
//           request.files.add(await http.MultipartFile.fromPath(
//               'aadhar_card[]', _aadharFrontImage!.path));
//         }
//         if (_aadharBackImage != null) {
//           request.files.add(await http.MultipartFile.fromPath(
//               'aadhar_card[]', _aadharBackImage!.path));
//         }
//         for (var file in _panCardFiles) {
//           request.files
//               .add(await http.MultipartFile.fromPath('pan_card[]', file.path));
//         }
//         for (var file in _gstCertificateFiles) {
//           request.files.add(await http.MultipartFile.fromPath(
//               'gst_certificate[]', file.path));
//         }
//         for (var file in _regCertificateFiles) {
//           request.files.add(await http.MultipartFile.fromPath(
//               'reg_certificate[]', file.path));
//         }
//       }

//       final response =
//           await request.send().timeout(const Duration(seconds: 30));
//       final responseBody = await response.stream.bytesToString();

//       if (response.statusCode == 200) {
//         final decodedResponse = jsonDecode(responseBody);
//         if (decodedResponse['response_code'] == 200 &&
//             decodedResponse['success'] == true) {
//           saveProfilePopUp(
//               decodedResponse['message'] ?? 'Profile updated successfully');
//           setState(() {
//             _nameController.text =
//                 decodedResponse['result']['name'] ?? _nameController.text;
//             _emailController.text =
//                 decodedResponse['result']['email'] ?? _emailController.text;
//             _mobileController.text =
//                 decodedResponse['result']['mobile'] ?? _mobileController.text;
//             _dpImageUrl =
//                 decodedResponse['result']['dp_image_url'] ?? _dpImageUrl;
//             _bannerImageUrl = decodedResponse['result']['banner_image_url'] ??
//                 _bannerImageUrl;
//             // Update other URLs if provided in the response
//             for (var doc in decodedResponse['result']['documents']) {
//               switch (doc['document_key']) {
//                 case 'aadhar_front':
//                   _aadharFrontUrl = doc['document_url_full'] ?? _aadharFrontUrl;
//                   break;
//                 case 'aadhar_back':
//                   _aadharBackUrl = doc['document_url_full'] ?? _aadharBackUrl;
//                   break;
//                 case 'pan':
//                   _panCardUrl = doc['document_url'] ?? _panCardUrl;
//                   break;
//                 case 'gstn':
//                   _gstCertificateUrl =
//                       doc['document_url'] ?? _gstCertificateUrl;
//                   break;
//                 case 'reg_no':
//                   _regCertificateUrl =
//                       doc['document_url'] ?? _regCertificateUrl;
//                   break;
//               }
//             }
//           });
//           return true;
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(
//                     decodedResponse['message'] ?? 'Failed to save profile')),
//           );
//           return false;
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Failed to save profile: ${response.statusCode} ${response.reasonPhrase}')),
//         );
//         return false;
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error: $e')),
//       );
//       return false;
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   // Image preview widget
//   Widget buildImagePreview(
//       {File? image,
//       String? imageUrl,
//       required String label,
//       required VoidCallback onTap,
//       required VoidCallback onDelete}) {
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
//                             child: const Icon(IconlyBold.delete,
//                                 color: Colors.white, size: 16),
//                           ),
//                         ),
//                       ),
//                     ],
//                   )
//                 : imageUrl != null
//                     ? Stack(
//                         fit: StackFit.expand,
//                         children: [
//                           ClipRRect(
//                             borderRadius: BorderRadius.circular(8.0),
//                             child: CachedNetworkImage(
//                               imageUrl: imageUrl,
//                               fit: BoxFit.cover,
//                               placeholder: (context, url) =>
//                                   const CircularProgressIndicator(),
//                               errorWidget: (context, url, error) =>
//                                   const Icon(Icons.error),
//                             ),
//                           ),
//                           Positioned(
//                             top: 0,
//                             right: 0,
//                             child: GestureDetector(
//                               onTap: onDelete,
//                               child: Container(
//                                 padding: const EdgeInsets.all(2.0),
//                                 color: Colors.red.withOpacity(0.7),
//                                 child: const Icon(IconlyBold.delete,
//                                     color: Colors.white, size: 16),
//                               ),
//                             ),
//                           ),
//                         ],
//                       )
//                     : const Icon(IconlyBold.image,
//                         color: kBorderColorTextField, size: 50),
//           ),
//         ),
//         const SizedBox(height: 8.0),
//         Text(label, style: kTextStyle.copyWith(color: kSubTitleColor)),
//       ],
//     );
//   }

//   // Aadhar preview widget
//   Widget buildAadharPreview() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text('Aadhar Card', style: kTextStyle.copyWith(color: kNeutralColor)),
//         const SizedBox(height: 8.0),
//         Row(
//           children: [
//             buildImagePreview(
//               image: _aadharFrontImage,
//               imageUrl: _aadharFrontUrl,
//               label: 'Front',
//               onTap: () async {
//                 final file = await showImageUploadPopUp('Aadhar Card Front',
//                     isAadhar: true, isFront: true);
//                 if (file != null) setState(() => _aadharFrontImage = file);
//               },
//               onDelete: () => setState(() {
//                 _aadharFrontImage = null;
//                 _aadharFrontUrl = null;
//               }),
//             ),
//             const SizedBox(width: 16.0),
//             buildImagePreview(
//               image: _aadharBackImage,
//               imageUrl: _aadharBackUrl,
//               label: 'Back',
//               onTap: () async {
//                 final file = await showImageUploadPopUp('Aadhar Card Back',
//                     isAadhar: true, isFront: false);
//                 if (file != null) setState(() => _aadharBackImage = file);
//               },
//               onDelete: () => setState(() {
//                 _aadharBackImage = null;
//                 _aadharBackUrl = null;
//               }),
//             ),
//           ],
//         ),
//         const SizedBox(height: 8.0),
//         // Text(
//         //   (_aadharFrontImage != null || _aadharFrontUrl != null) && (_aadharBackImage != null || _aadharBackUrl != null)
//         //       ? 'Aadhar Front & Back Uploaded'
//         //       : (_aadharFrontImage != null || _aadharFrontUrl != null)
//         //           ? 'Aadhar Back Missing'
//         //           : (_aadharBackImage != null || _aadharBackUrl != null)
//         //               ? 'Aadhar Front Missing'
//         //               : 'Upload Aadhar Front & Back',
//         //   style: kTextStyle.copyWith(color: kSubTitleColor),
//         // ),
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
//           style: kTextStyle.copyWith(
//               color: kNeutralColor, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Form(
//               key: _formKey,
//               child: PageView.builder(
//                 itemCount: 4,
//                 physics: const PageScrollPhysics(),
//                 controller: pageController,
//                 onPageChanged: (int index) => setState(() {
//                   currentIndexPage = index;
//                   percent = 25.0 * (index + 1);
//                 }),
//                 itemBuilder: (_, i) {
//                   return Padding(
//                     padding: const EdgeInsets.all(20.0),
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Text(
//                                 'Step ${currentIndexPage + 1} of 4',
//                                 style:
//                                     kTextStyle.copyWith(color: kNeutralColor),
//                               ),
//                               const SizedBox(width: 10.0),
//                               Expanded(
//                                 child: StepProgressIndicator(
//                                   totalSteps: 4,
//                                   currentStep: currentIndexPage + 1,
//                                   size: 8,
//                                   padding: 0,
//                                   selectedColor: kPrimaryColor,
//                                   unselectedColor:
//                                       kPrimaryColor.withOpacity(0.2),
//                                   roundedEdges: const Radius.circular(10),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20.0),
//                           if (currentIndexPage == 0)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Basic Information',
//                                   style: kTextStyle.copyWith(
//                                       color: kNeutralColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 10.0),
//                                 Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     buildImagePreview(
//                                       image: _dpImage,
//                                       imageUrl: _dpImageUrl,
//                                       label: 'Display Picture',
//                                       onTap: () => showImportProfilePopUp(),
//                                       onDelete: () => setState(() {
//                                         _dpImage = null;
//                                         _dpImageUrl = null;
//                                       }),
//                                     ),
//                                     buildImagePreview(
//                                       image: _bannerImage,
//                                       imageUrl: _bannerImageUrl,
//                                       label: 'Banner Image',
//                                       onTap: () => showImportProfilePopUp(),
//                                       onDelete: () => setState(() {
//                                         _bannerImage = null;
//                                         _bannerImageUrl = null;
//                                       }),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 ToggleButtons(
//                                   borderRadius: BorderRadius.circular(8),
//                                   borderColor: kPrimaryColor,
//                                   selectedBorderColor: kPrimaryColor,
//                                   fillColor: kPrimaryColor.withOpacity(0.1),
//                                   selectedColor: kPrimaryColor,
//                                   color: Colors.black,
//                                   constraints: const BoxConstraints(
//                                       minHeight: 40, minWidth: 120),
//                                   isSelected: isSelected,
//                                   onPressed: (index) {
//                                     setState(() {
//                                       for (int i = 0;
//                                           i < isSelected.length;
//                                           i++) {
//                                         isSelected[i] = i == index;
//                                       }
//                                       userType = index == 0
//                                           ? "Individual"
//                                           : "Organisation";
//                                     });
//                                   },
//                                   children: const [
//                                     Text("Individual"),
//                                     Text("Organisation"),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _nameController,
//                                   keyboardType: TextInputType.name,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Name',
//                                     hintText: 'Enter your name',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) =>
//                                       value == null || value.isEmpty
//                                           ? 'Please enter your name'
//                                           : null,
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _userNameController,
//                                   keyboardType: TextInputType.name,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Username',
//                                     hintText: 'Enter your username',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) =>
//                                       value == null || value.isEmpty
//                                           ? 'Please enter your username'
//                                           : null,
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _mobileController,
//                                   keyboardType: TextInputType.phone,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Mobile Number',
//                                     hintText: 'Enter mobile number',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty)
//                                       return 'Please enter your mobile number';
//                                     if (!RegExp(r'^\d{10}$').hasMatch(value)) {
//                                       return 'Please enter a valid 10-digit mobile number';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _emailController,
//                                   keyboardType: TextInputType.emailAddress,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Email',
//                                     hintText: 'Enter email',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty)
//                                       return 'Please enter your email';
//                                     if (!RegExp(
//                                             r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
//                                         .hasMatch(value)) {
//                                       return 'Please enter a valid email';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                               ],
//                             ),
//                           if (currentIndexPage == 1)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Addresses',
//                                   style: kTextStyle.copyWith(
//                                       color: kNeutralColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 Row(
//                                   children: [
//                                     const Spacer(),
//                                     const Icon(FeatherIcons.plusCircle,
//                                         color: kSubTitleColor, size: 18.0),
//                                     const SizedBox(width: 5.0),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         final result = await showAddressPopUp();
//                                         if (result != null)
//                                           setState(() => addresses.add(result));
//                                       },
//                                       child: Text('Add New',
//                                           style: kTextStyle.copyWith(
//                                               color: kSubTitleColor)),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 ...addresses.asMap().entries.map((entry) {
//                                   int index = entry.key;
//                                   Map<String, dynamic> address = entry.value;
//                                   return Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: InfoShowCase(
//                                               title: address['address_type']!,
//                                               subTitle:
//                                                   '${address['address']}, ${address['landmark']}',
//                                               onEdit: () async {
//                                                 final result =
//                                                     await showAddressPopUp(
//                                                         existingAddress:
//                                                             address,
//                                                         index: index);
//                                                 if (result != null) {
//                                                   setState(() {
//                                                     addresses[index] = result;
//                                                     if (result['default_address'] !=
//                                                             '1' &&
//                                                         index ==
//                                                             defaultAddressIndex) {
//                                                       defaultAddressIndex = -1;
//                                                     }
//                                                   });
//                                                 }
//                                               },
//                                               onDelete: () {
//                                                 setState(() {
//                                                   if (index ==
//                                                       defaultAddressIndex) {
//                                                     defaultAddressIndex = -1;
//                                                   } else if (index <
//                                                       defaultAddressIndex) {
//                                                     defaultAddressIndex--;
//                                                   }
//                                                   addresses.removeAt(index);
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       CheckboxListTile(
//                                         title: Text('Set as Default',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor)),
//                                         value: index == defaultAddressIndex,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             if (value == true) {
//                                               defaultAddressIndex = index;
//                                               addresses[index]
//                                                   ['default_address'] = '1';
//                                               for (int i = 0;
//                                                   i < addresses.length;
//                                                   i++) {
//                                                 if (i != index)
//                                                   addresses[i]
//                                                       ['default_address'] = '0';
//                                               }
//                                             } else {
//                                               defaultAddressIndex = -1;
//                                               addresses[index]
//                                                   ['default_address'] = '0';
//                                             }
//                                           });
//                                         },
//                                       ),
//                                       const SizedBox(height: 20.0),
//                                     ],
//                                   );
//                                 }),
//                               ],
//                             ),
//                           if (currentIndexPage == 2)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Bank Accounts',
//                                   style: kTextStyle.copyWith(
//                                       color: kNeutralColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 Row(
//                                   children: [
//                                     const Spacer(),
//                                     const Icon(FeatherIcons.plusCircle,
//                                         color: kSubTitleColor, size: 18.0),
//                                     const SizedBox(width: 5.0),
//                                     GestureDetector(
//                                       onTap: () async {
//                                         final result =
//                                             await showBankAccountPopUp();
//                                         if (result != null)
//                                           setState(
//                                               () => bankAccounts.add(result));
//                                       },
//                                       child: Text('Add New',
//                                           style: kTextStyle.copyWith(
//                                               color: kSubTitleColor)),
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 ...bankAccounts.asMap().entries.map((entry) {
//                                   int index = entry.key;
//                                   Map<String, String> bank = entry.value;
//                                   return Column(
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Expanded(
//                                             child: InfoShowCase(
//                                               title: bank['beneficiary_name']!,
//                                               subTitle:
//                                                   '${bank['account_number']} ${bank['ifsc_code']} ${bank['upi_address'] ?? ''}',
//                                               onEdit: () async {
//                                                 final result =
//                                                     await showBankAccountPopUp(
//                                                         existingBankAccount:
//                                                             bank,
//                                                         index: index);
//                                                 if (result != null) {
//                                                   setState(() {
//                                                     bankAccounts[index] =
//                                                         result;
//                                                     if (result['primary_bank'] !=
//                                                             '1' &&
//                                                         index ==
//                                                             primaryBankIndex) {
//                                                       primaryBankIndex = -1;
//                                                     }
//                                                   });
//                                                 }
//                                               },
//                                               onDelete: () {
//                                                 setState(() {
//                                                   if (index ==
//                                                       primaryBankIndex) {
//                                                     primaryBankIndex = -1;
//                                                   } else if (index <
//                                                       primaryBankIndex) {
//                                                     primaryBankIndex--;
//                                                   }
//                                                   bankAccounts.removeAt(index);
//                                                 });
//                                               },
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       CheckboxListTile(
//                                         title: Text('Set as Primary',
//                                             style: kTextStyle.copyWith(
//                                                 color: kNeutralColor)),
//                                         value: index == primaryBankIndex,
//                                         onChanged: (value) {
//                                           setState(() {
//                                             if (value == true) {
//                                               primaryBankIndex = index;
//                                               bankAccounts[index]
//                                                   ['primary_bank'] = '1';
//                                               for (int i = 0;
//                                                   i < bankAccounts.length;
//                                                   i++) {
//                                                 if (i != index)
//                                                   bankAccounts[i]
//                                                       ['primary_bank'] = '0';
//                                               }
//                                             } else {
//                                               primaryBankIndex = -1;
//                                               bankAccounts[index]
//                                                   ['primary_bank'] = '0';
//                                             }
//                                           });
//                                         },
//                                       ),
//                                       const SizedBox(height: 20.0),
//                                     ],
//                                   );
//                                 }),
//                                 const SizedBox(height: 20.0),
//                                 buildImagePreview(
//                                   image: _bankDocument,
//                                   imageUrl: _bankDocumentUrl,
//                                   label: 'Bank Document',
//                                   onTap: () async {
//                                     final file = await showImageUploadPopUp(
//                                         'Bank Document');
//                                     if (file != null)
//                                       setState(() => _bankDocument = file);
//                                   },
//                                   onDelete: () => setState(() {
//                                     _bankDocument = null;
//                                     _bankDocumentUrl = null;
//                                   }),
//                                 ),
//                               ],
//                             ),
//                           if (currentIndexPage == 3)
//                             Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   'Documents & Other Information',
//                                   style: kTextStyle.copyWith(
//                                       color: kNeutralColor,
//                                       fontWeight: FontWeight.bold),
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _aadharController,
//                                   keyboardType: TextInputType.number,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Aadhar Number',
//                                     hintText: 'Enter 12-digit Aadhar number',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty)
//                                       return 'Please enter Aadhar number';
//                                     if (!RegExp(r'^\d{12}$').hasMatch(value)) {
//                                       return 'Please enter a valid 12-digit Aadhar number';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 buildAadharPreview(),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _panController,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'PAN Number',
//                                     hintText:
//                                         'Enter PAN number (e.g., ABCDE1234F)',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty)
//                                       return 'Please enter PAN number';
//                                     if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$')
//                                         .hasMatch(value)) {
//                                       return 'Please enter a valid PAN number';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 buildImagePreview(
//                                   image: _panCardFiles.isNotEmpty
//                                       ? _panCardFiles[0]
//                                       : null,
//                                   imageUrl: _panCardUrl,
//                                   label: 'PAN Card',
//                                   onTap: () async {
//                                     final file =
//                                         await showImageUploadPopUp('PAN Card');
//                                     if (file != null)
//                                       setState(() => _panCardFiles = [file]);
//                                   },
//                                   onDelete: () => setState(() {
//                                     _panCardFiles = [];
//                                     _panCardUrl = null;
//                                   }),
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _gstnController,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'GST Number',
//                                     hintText:
//                                         'Enter GST number (e.g., 22AAAAA0000A1Z5)',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) {
//                                     if (value == null || value.isEmpty)
//                                       return 'Please enter GST number';
//                                     if (!RegExp(
//                                             r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9A-Z]{3}$')
//                                         .hasMatch(value)) {
//                                       return 'Please enter a valid GST number';
//                                     }
//                                     return null;
//                                   },
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 buildImagePreview(
//                                   image: _gstCertificateFiles.isNotEmpty
//                                       ? _gstCertificateFiles[0]
//                                       : null,
//                                   imageUrl: _gstCertificateUrl,
//                                   label: 'GST Certificate',
//                                   onTap: () async {
//                                     final file = await showImageUploadPopUp(
//                                         'GST Certificate');
//                                     if (file != null)
//                                       setState(
//                                           () => _gstCertificateFiles = [file]);
//                                   },
//                                   onDelete: () => setState(() {
//                                     _gstCertificateFiles = [];
//                                     _gstCertificateUrl = null;
//                                   }),
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 TextFormField(
//                                   controller: _regNoController,
//                                   decoration: kInputDecoration.copyWith(
//                                     labelText: 'Registration Number',
//                                     hintText: 'Enter registration number',
//                                     border: const OutlineInputBorder(),
//                                   ),
//                                   validator: (value) =>
//                                       value == null || value.isEmpty
//                                           ? 'Please enter registration number'
//                                           : null,
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 buildImagePreview(
//                                   image: _regCertificateFiles.isNotEmpty
//                                       ? _regCertificateFiles[0]
//                                       : null,
//                                   imageUrl: _regCertificateUrl,
//                                   label: 'Registration Certificate',
//                                   onTap: () async {
//                                     final file = await showImageUploadPopUp(
//                                         'Registration Certificate');
//                                     if (file != null)
//                                       setState(
//                                           () => _regCertificateFiles = [file]);
//                                   },
//                                   onDelete: () => setState(() {
//                                     _regCertificateFiles = [];
//                                     _regCertificateUrl = null;
//                                   }),
//                                 ),
//                                 const SizedBox(height: 20.0),
//                                 // Text(
//                                 //   'Review Your Profile',
//                                 //   style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
//                                 // ),
//                                 // const SizedBox(height: 15.0),
//                                 // Text('Basic Info:', style: kTextStyle.copyWith(color: kNeutralColor)),
//                                 // Text('Name: ${_nameController.text}'),
//                                 // Text('Username: ${_userNameController.text}'),
//                                 // Text('Email: ${_emailController.text}'),
//                                 // Text('Mobile No: ${_mobileController.text}'),
//                                 // Text('User Type: Organisation'),
//                                 // const SizedBox(height: 10.0),
//                                 // Text('Addresses:', style: kTextStyle.copyWith(color: kNeutralColor)),
//                                 // ...addresses.asMap().entries.map((entry) {
//                                 //   int index = entry.key;
//                                 //   Map<String, dynamic> address = entry.value;
//                                 //   return Text(
//                                 //       '${address['address_type']}: ${address['address']}, ${address['landmark']} ${index == defaultAddressIndex ? '(Default)' : ''}');
//                                 // }),
//                                 // const SizedBox(height: 10.0),
//                                 // Text('Bank Accounts:', style: kTextStyle.copyWith(color: kNeutralColor)),
//                                 // ...bankAccounts.asMap().entries.map((entry) {
//                                 //   int index = entry.key;
//                                 //   Map<String, String> bank = entry.value;
//                                 //   return Text('${bank['beneficiary_name']} - ${bank['account_number']} ${index == primaryBankIndex ? '(Primary)' : ''}');
//                                 // }),
//                                 // Text('Bank Document: ${_bankDocument != null || _bankDocumentUrl != null ? 'Uploaded' : 'Not Uploaded'}'),
//                                 // const SizedBox(height: 10.0),
//                                 // Text('Documents & Other:', style: kTextStyle.copyWith(color: kNeutralColor)),
//                                 // Text('Aadhar Number: ${_aadharController.text}'),
//                                 // Text('Aadhar Card: ${_aadharFrontImage != null || _aadharFrontUrl != null && _aadharBackImage != null || _aadharBackUrl != null ? 'Front & Back Uploaded' : 'Not Uploaded'}'),
//                                 // Text('PAN Number: ${_panController.text}'),
//                                 // Text('PAN Card: ${_panCardFiles.isNotEmpty || _panCardUrl != null ? 'Uploaded' : 'Not Uploaded'}'),
//                                 // Text('GST Number: ${_gstnController.text}'),
//                                 // Text('GST Certificate: ${_gstCertificateFiles.isNotEmpty || _gstCertificateUrl != null ? 'Uploaded' : 'Not Uploaded'}'),
//                                 // Text('Registration Number: ${_regNoController.text}'),
//                                 // Text('Registration Certificate: ${_regCertificateFiles.isNotEmpty || _regCertificateUrl != null ? 'Uploaded' : 'Not Uploaded'}'),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//       bottomNavigationBar: ButtonGlobalWithoutIcon(
//         buttontext: currentIndexPage < 3 ? 'Continue' : 'Save Profile',
//         buttonDecoration: kButtonDecoration.copyWith(
//           color: kPrimaryColor,
//           borderRadius: BorderRadius.circular(30.0),
//         ),
//         onPressed: _isLoading
//             ? null
//             : () async {
//                 if (currentIndexPage < 3) {
//                   if (currentIndexPage == 0 &&
//                       !_formKey.currentState!.validate()) {
//                     return;
//                   }
//                   if (currentIndexPage == 0 &&
//                       (_dpImage == null && _dpImageUrl == null ||
//                           _bannerImage == null && _bannerImageUrl == null)) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text(
//                               'Please upload both profile and banner images')),
//                     );
//                     return;
//                   }
//                   if (currentIndexPage == 1 && addresses.isEmpty) {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                           content: Text('Please add at least one address')),
//                     );
//                     return;
//                   }
//                   if (currentIndexPage == 2) {
//                     if (bankAccounts.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content:
//                                 Text('Please add at least one bank account')),
//                       );
//                       return;
//                     }
//                     if (_bankDocument == null && _bankDocumentUrl == null) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         const SnackBar(
//                             content: Text('Please upload bank document')),
//                       );
//                       return;
//                     }
//                   }
//                   bool success = await submitProfile(isPartial: true);
//                   if (success) {
//                     pageController.nextPage(
//                       duration: const Duration(milliseconds: 300),
//                       curve: Curves.bounceInOut,
//                     );
//                   }
//                 } else {
//                   await submitProfile();
//                 }
//               },
//         buttonTextColor: kWhite,
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _nameController.dispose();
//     _userNameController.dispose();
//     _emailController.dispose();
//     _mobileController.dispose();
//     _aadharController.dispose();
//     _panController.dispose();
//     _gstnController.dispose();
//     _regNoController.dispose();
//     _addressSearchController.dispose();
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
import 'package:freelancer/screen/widgets/constant.dart';
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
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:logger/logger.dart';

class SetupClientProfile extends StatefulWidget {
  const SetupClientProfile({super.key});

  @override
  State<SetupClientProfile> createState() => _SetupClientProfileState();
}

class _SetupClientProfileState extends State<SetupClientProfile> {
  final _logger = Logger();
  PageController pageController = PageController(initialPage: 0);
  int currentIndexPage = 0;
  double percent = 25.0;

  List<bool> isSelected = [true, false]; // default: Individual
  String userType = "Individual";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _gstnController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
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

  // Image URLs from API
  String? _dpImageUrl;
  String? _bannerImageUrl;
  String? _bankDocumentUrl;
  String? _aadharFrontUrl;
  String? _aadharBackUrl;
  String? _panCardUrl;
  String? _gstCertificateUrl;
  String? _regCertificateUrl;

  // Verification statuses
  bool _aadharVerified = false;
  bool _panVerified = false;
  bool _gstnVerified = false;
  bool _regNoVerified = false;

  // Dynamic lists
  List<Map<String, dynamic>> addresses = [];
  List<Map<String, String?>> bankAccounts = [];

  // Primary bank and default address indices
  int primaryBankIndex = -1;
  int defaultAddressIndex = -1;

  // API endpoint
  final String apiUrl = 'https://phplaravel-1517766-5835172.cloudwaysapps.com/api/profile/update';

  // Image picker
  final ImagePicker _picker = ImagePicker();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  // Fix URL to handle double /storage issue
  String? fixUrl(String? url) {
    if (url == null) return null;
    return url.replaceAll('/storage//storage', '/storage');
  }

  // Fetch profile data from API
  Future<void> _fetchProfileData() async {
    setState(() => _isLoading = true);
    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection. Unable to fetch profile.')),
        );
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token not found. Please log in again.')),
        );
        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      final responseBody = response.body;
      _logger.i('API Response: $responseBody');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(responseBody);
        if (decodedResponse['response_code'] == 200 && decodedResponse['success'] == true) {
          final result = decodedResponse['result'] ?? {};
          setState(() {
            // Basic Info
            _nameController.text = result['name']?.toString() ?? '';
            _userNameController.text = result['username']?.toString() ?? '';
            _emailController.text = result['email']?.toString() ?? '';
            _mobileController.text = result['mobile']?.toString() ?? '';
            _dpImageUrl = fixUrl(result['dp_image_url']?.toString());
            _bannerImageUrl = fixUrl(result['banner_image_url']?.toString());
            userType = result['user_type']?.toString() ?? 'Individual';
            isSelected = userType == 'Individual' ? [true, false] : [false, true];

            // Preserve old addresses map for merging
            Map<String, Map<String, dynamic>> oldAddressesMap = {};
            for (var addr in addresses) {
              oldAddressesMap[addr['address_key']] = Map<String, dynamic>.from(addr);
            }

            // Addresses
            addresses = List<Map<String, dynamic>>.from(
              (result['addresses'] ?? []).map((addr) {
                var newAddr = {
                  'address_key': addr['address_key']?.toString() ?? '',
                  'address_type': addr['address_type']?.toString() ?? '',
                  'address': addr['full_address']?.toString() ?? '',
                  'landmark': addr['landmark']?.toString() ?? '',
                  'latitude': addr['latitude']?.toString() ?? '',
                  'longitude': addr['longitude']?.toString() ?? '',
                  'default_address': addr['is_default'] == 1 ? '1' : '0',
                  'place_id': addr['place_id']?.toString() ?? '',
                };
                var oldAddr = oldAddressesMap[newAddr['address_key']];
                if (oldAddr != null) {
                  newAddr['landmark'] = oldAddr['landmark'] ?? '';
                }
                return newAddr;
              }),
            );
            defaultAddressIndex = addresses
                .asMap()
                .entries
                .firstWhere(
                  (entry) => entry.value['default_address'] == '1',
                  orElse: () => MapEntry(-1, {}),
                )
                .key;

            // Bank Accounts
            bankAccounts = List<Map<String, String?>>.from(
              (result['bank_accounts'] ?? []).map((bank) => {
                'account_key': bank['account_key']?.toString() ?? '',
                'beneficiary_name': bank['beneficiary_name']?.toString() ?? '',
                'account_number': bank['account_number']?.toString() ?? '',
                'ifsc_code': bank['ifsc_code']?.toString() ?? '',
                'upi_address': bank['upi_address']?.toString() ?? '',
                'primary_bank': bank['is_primary']?.toString() ?? '0',
                'bank_document_url': fixUrl(bank['bank_document_url']?.toString()),
              }),
            );
            _logger.i('Parsed bankAccounts: $bankAccounts');
            primaryBankIndex = bankAccounts
                .asMap()
                .entries
                .firstWhere(
                  (entry) => entry.value['primary_bank'] == '1',
                  orElse: () => MapEntry(-1, {}),
                )
                .key;
            _bankDocumentUrl = primaryBankIndex >= 0 ? bankAccounts[primaryBankIndex]['bank_document_url'] : null;

            // Documents
            _aadharFrontUrl = null;
            _aadharBackUrl = null;
            _panCardUrl = null;
            _gstCertificateUrl = null;
            _regCertificateUrl = null;
            _aadharVerified = false;
            _panVerified = false;
            _gstnVerified = false;
            _regNoVerified = false;

            for (var doc in result['documents'] ?? []) {
              _logger.i('Processing document: ${doc['document_key']}');
              final docUrl = fixUrl(doc['document_url_full']?.toString() ?? doc['document_url']?.toString());
              switch (doc['document_key']) {
                case 'aadhar_front':
                  _aadharFrontUrl = docUrl;
                  _aadharVerified = doc['is_verified'] == 1;
                  break;
                case 'aadhar_back':
                  _aadharBackUrl = docUrl;
                  _aadharVerified = doc['is_verified'] == 1 && _aadharVerified;
                  break;
                case 'pan':
                  _panController.text = doc['document_value']?.toString() ?? '';
                  _panCardUrl = docUrl;
                  _panVerified = doc['is_verified'] == 1;
                  break;
                case 'gstn':
                  _gstnController.text = doc['document_value']?.toString() ?? '';
                  _gstCertificateUrl = docUrl;
                  _gstnVerified = doc['is_verified'] == 1;
                  break;
                case 'reg_no':
                  _regNoController.text = doc['document_value']?.toString() ?? '';
                  _regCertificateUrl = docUrl;
                  _regNoVerified = doc['is_verified'] == 1;
                  break;
              }
            }
            _logger.i('Document URLs: Aadhar Front: $_aadharFrontUrl, Aadhar Back: $_aadharBackUrl, PAN: $_panCardUrl, GST: $_gstCertificateUrl, Reg: $_regCertificateUrl');
          });
          await _updateAddressesWithGeocode();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['message'] ?? 'Failed to fetch profile')),
          );
        }
      } else {
        _logger.w('HTTP Error: ${response.statusCode} ${response.reasonPhrase}, Body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to fetch profile: ${response.statusCode} ${response.reasonPhrase}')),
        );
      }
    } catch (e, stackTrace) {
      // _logger.e('Error fetching profile: $e, Response: ${response.reasonPhrase}', stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching profile: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Update addresses with geocoding if full_address is null
  Future<void> _updateAddressesWithGeocode() async {
    for (int i = 0; i < addresses.length; i++) {
      final addr = addresses[i];
      if (addr['address']?.isEmpty != false &&
          addr['latitude']?.isNotEmpty == true &&
          addr['longitude']?.isNotEmpty == true) {
        final coords = await getLatLngFromPlaceId(addr['place_id'] ?? '');
        if (coords != null) {
          setState(() {
            addresses[i]['address'] = coords['address']!;
            addresses[i]['place_id'] = coords['place_id'] ?? '';
          });
          _logger.i('Updated address $i with geocoding: ${coords['address']}');
        }
      }
    }
  }

  // Request permissions
  Future<bool> requestStoragePermission({bool isCamera = false}) async {
    if (Platform.isAndroid) {
      if (isCamera) {
        final cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted) {
          final status = await Permission.camera.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera permission is required for taking photos')),
            );
            return false;
          }
        }
      }

      final photoStatus = await Permission.photos.status;
      if (photoStatus.isGranted) return true;
      final photoResult = await Permission.photos.request();
      if (photoResult.isGranted) return true;

      final storageStatus = await Permission.storage.status;
      if (storageStatus.isGranted) return true;
      final storageResult = await Permission.storage.request();
      if (storageResult.isGranted) return true;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Storage or media permissions are required to pick images')),
      );
      return false;
    }
    return true;
  }

  // Fetch lat/lng from Google Place ID
  Future<Map<String, String>?> getLatLngFromPlaceId(String placeId) async {
    if (placeId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a valid address')),
      );
      return null;
    }

    final String apiKey = AppInfo.googleAddressKey;
    if (apiKey.isEmpty) {
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
      final response = await http.get(url, headers: headers).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'OK' && data['result'] != null) {
          final location = data['result']['geometry']['location'];
          return {
            'address': data['result']['formatted_address'],
            'latitude': location['lat'].toString(),
            'longitude': location['lng'].toString(),
            'place_id': placeId,
          };
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Geocoding failed: ${data['error_message'] ?? 'No results found'}')),
          );
          return null;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Geocoding request failed: ${response.statusCode}')),
        );
        return null;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching coordinates. Please try again.')),
      );
      return null;
    }
  }

  // Address popup
  Future<Map<String, dynamic>?> showAddressPopUp({Map<String, dynamic>? existingAddress, int? index}) async {
    final addressTypeController = TextEditingController(text: existingAddress?['address_type'] ?? '');
    final addressLine1Controller = TextEditingController(text: existingAddress?['address'] ?? '');
    final landmarkController = TextEditingController(text: existingAddress?['landmark'] ?? '');
    final latitudeController = TextEditingController(text: existingAddress?['latitude'] ?? '');
    final longitudeController = TextEditingController(text: existingAddress?['longitude'] ?? '');
    bool isDefault = index == defaultAddressIndex;
    bool isLoadingCoordinates = false;
    bool useAutocomplete = true;
    String? placeId = existingAddress?['place_id'];
    String? errorMessage;

    final connectivityResult = await Connectivity().checkConnectivity();
    bool hasInternet = connectivityResult != ConnectivityResult.none;
    if (!hasInternet || AppInfo.googleAddressKey.isEmpty) {
      useAutocomplete = false;
      errorMessage = !hasInternet ? 'No internet connection. Manual entry only.' : 'Google API key missing. Manual entry only.';
    }

    if (existingAddress == null && hasInternet && AppInfo.googleAddressKey.isNotEmpty) {
      try {
        bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          errorMessage = 'Location services are disabled. Using manual entry.';
          useAutocomplete = false;
        } else {
          LocationPermission permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              errorMessage = 'Location permission denied. Using manual entry.';
              useAutocomplete = false;
            }
          }

          if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
            isLoadingCoordinates = true;
            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            final url = Uri.parse(
              'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${AppInfo.googleAddressKey}',
            );
            final response = await http.get(url);
            if (response.statusCode == 200) {
              final data = jsonDecode(response.body);
              if (data['status'] == 'OK' && data['results'].isNotEmpty) {
                final address = data['results'][0]['formatted_address'];
                placeId = data['results'][0]['place_id'];
                addressLine1Controller.text = address;
                _addressSearchController.text = address;
                latitudeController.text = position.latitude.toString();
                longitudeController.text = position.longitude.toString();
              } else {
                errorMessage = 'Failed to fetch current address: ${data['error_message'] ?? 'No results'}';
              }
            } else {
              errorMessage = 'Failed to fetch current address: ${response.statusCode}';
            }
          }
        }
      } catch (e) {
        errorMessage = 'Error fetching current location. Using manual entry.';
        useAutocomplete = false;
      } finally {
        isLoadingCoordinates = false;
      }
    }

    _addressSearchController.clear();
    if (existingAddress == null && addressLine1Controller.text.isNotEmpty) {
      _addressSearchController.text = addressLine1Controller.text;
    }

    final result = await showDialog<Map<String, dynamic>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          existingAddress == null ? 'Add Address' : 'Edit Address',
                          style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: addressTypeController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Address Type',
                            hintText: 'e.g., Office, Home',
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) => value == null || value.isEmpty ? 'Please enter address type' : null,
                        ),
                        const SizedBox(height: 20.0),
                        CheckboxListTile(
                          title: Text('Use Google Autocomplete', style: kTextStyle.copyWith(color: kNeutralColor)),
                          value: useAutocomplete,
                          onChanged: hasInternet && AppInfo.googleAddressKey.isNotEmpty
                              ? (value) {
                                  setState(() {
                                    useAutocomplete = value!;
                                    if (!useAutocomplete) {
                                      _addressSearchController.clear();
                                      addressLine1Controller.clear();
                                      latitudeController.clear();
                                      longitudeController.clear();
                                      errorMessage = null;
                                    }
                                  });
                                }
                              : null,
                          subtitle: errorMessage != null ? Text(errorMessage!, style: const TextStyle(color: Colors.red)) : null,
                        ),
                        const SizedBox(height: 20.0),
                        useAutocomplete
                            ? GooglePlaceAutoCompleteTextField(
                                textEditingController: _addressSearchController,
                                googleAPIKey: AppInfo.googleAddressKey,
                                inputDecoration: kInputDecoration.copyWith(
                                  labelText: 'Search Address',
                                  hintText: 'Enter address (e.g., Delhi, India)',
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
                                debounceTime: 300,
                                getPlaceDetailWithLatLng: (Prediction prediction) async {
                                  if (prediction.placeId == null) {
                                    setState(() {
                                      errorMessage = 'Invalid place selected';
                                      isLoadingCoordinates = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Invalid place selected')),
                                    );
                                    return;
                                  }
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
                                  } else {
                                    setState(() {
                                      errorMessage = 'Failed to fetch address details';
                                      isLoadingCoordinates = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Failed to fetch address details')),
                                    );
                                  }
                                },
                                itemClick: (Prediction prediction) {
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
                                validator: (value) => value == null || value.isEmpty ? 'Please enter address' : null,
                              ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          controller: landmarkController,
                          decoration: kInputDecoration.copyWith(
                            labelText: 'Landmark',
                            hintText: 'e.g., Near Metro Station',
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
                            hintText: useAutocomplete ? 'Auto-filled' : 'Enter latitude (e.g., 28.7041)',
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
                            hintText: useAutocomplete ? 'Auto-filled' : 'Enter longitude (e.g., 77.1025)',
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
                          title: Text('Set as Default', style: kTextStyle.copyWith(color: kNeutralColor)),
                          value: isDefault,
                          onChanged: (value) {
                            setState(() {
                              isDefault = value!;
                              if (isDefault) {
                                this.setState(() => defaultAddressIndex = index ?? addresses.length);
                              } else if (index == defaultAddressIndex) {
                                this.setState(() => defaultAddressIndex = -1);
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
                              child: Text('Cancel', style: kTextStyle.copyWith(color: kSubTitleColor)),
                            ),
                            TextButton(
                              onPressed: () {
                                if (addressTypeController.text.isNotEmpty &&
                                    addressLine1Controller.text.isNotEmpty &&
                                    (!useAutocomplete || (latitudeController.text.isNotEmpty && longitudeController.text.isNotEmpty))) {
                                  final address = {
                                    'address_key': existingAddress?['address_key'] ?? '',
                                    'address_type': addressTypeController.text,
                                    'address': addressLine1Controller.text,
                                    'landmark': landmarkController.text,
                                    'latitude': latitudeController.text,
                                    'longitude': longitudeController.text,
                                    'default_address': isDefault ? '1' : '0',
                                    'place_id': placeId ?? '',
                                  };
                                  Navigator.pop(context, address);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please fill all required fields')),
                                  );
                                }
                              },
                              child: Text(
                                existingAddress == null ? 'Add' : 'Update',
                                style: kTextStyle.copyWith(color: kPrimaryColor),
                              ),
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

    return result;
  }

  // Bank account popup
  Future<Map<String, String?>?> showBankAccountPopUp({Map<String, String?>? existingBankAccount, int? index}) async {
    final beneficiaryController = TextEditingController(text: existingBankAccount?['beneficiary_name'] ?? '');
    final accountNumberController = TextEditingController(text: existingBankAccount?['account_number'] ?? '');
    final ifscCodeController = TextEditingController(text: existingBankAccount?['ifsc_code'] ?? '');
    final upiAddressController = TextEditingController(text: existingBankAccount?['upi_address'] ?? '');
    bool isPrimary = index == primaryBankIndex;

    return await showDialog<Map<String, String?>>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      existingBankAccount == null ? 'Add Bank Account' : 'Edit Bank Account',
                      style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: beneficiaryController,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Beneficiary Name',
                        hintText: 'Enter beneficiary name',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter beneficiary name' : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: accountNumberController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'Account Number',
                        hintText: 'Enter account number',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) => value == null || value.isEmpty ? 'Please enter account number' : null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: ifscCodeController,
                      decoration: kInputDecoration.copyWith(
                        labelText: 'IFSC Code',
                        hintText: 'Enter IFSC code (e.g., HDFC0005678)',
                        border: const OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Please enter IFSC code';
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
                        hintText: 'Enter UPI address (e.g., jane123@okhdfcbank)',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    CheckboxListTile(
                      title: Text('Set as Primary', style: kTextStyle.copyWith(color: kNeutralColor)),
                      value: isPrimary,
                      onChanged: (value) {
                        setState(() {
                          isPrimary = value!;
                          if (isPrimary) {
                            this.setState(() {
                              primaryBankIndex = index ?? bankAccounts.length;
                              for (int i = 0; i < bankAccounts.length; i++) {
                                if (i != primaryBankIndex) bankAccounts[i]['primary_bank'] = '0';
                              }
                            });
                          } else if (index == primaryBankIndex) {
                            this.setState(() => primaryBankIndex = -1);
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
                          child: Text('Cancel', style: kTextStyle.copyWith(color: kSubTitleColor)),
                        ),
                        TextButton(
                          onPressed: () {
                            if (beneficiaryController.text.isNotEmpty &&
                                accountNumberController.text.isNotEmpty &&
                                ifscCodeController.text.isNotEmpty) {
                              final bankAccount = {
                                'account_key': existingBankAccount?['account_key'] ?? '',
                                'beneficiary_name': beneficiaryController.text,
                                'account_number': accountNumberController.text,
                                'ifsc_code': ifscCodeController.text,
                                'upi_address': upiAddressController.text,
                                'primary_bank': isPrimary ? '1' : '0',
                                'bank_document_url': existingBankAccount?['bank_document_url'],
                              };
                              Navigator.pop(context, bankAccount);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please fill all required fields')),
                              );
                            }
                          },
                          child: Text(
                            existingBankAccount == null ? 'Add' : 'Update',
                            style: kTextStyle.copyWith(color: kPrimaryColor),
                          ),
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

  // Image upload popup
  Future<File?> showImageUploadPopUp(String title, {bool isAadhar = false, bool isFront = true}) async {
    if (!await requestStoragePermission(isCamera: true)) return null;

    return await showDialog<File?>(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
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
                      Navigator.pop(context, file != null ? File(file.path) : null);
                    } catch (e) {
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
                      Navigator.pop(context, file != null ? File(file.path) : null);
                    } catch (e) {
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

  // Profile picture popup
  Future<void> showImportProfilePopUp() async {
    await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Pick Profile Image'),
                onTap: () async {
                  final file = await showImageUploadPopUp('Profile Image');
                  if (file != null) setState(() => _dpImage = file);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Pick Banner Image'),
                onTap: () async {
                  final file = await showImageUploadPopUp('Banner Image');
                  if (file != null) setState(() => _bannerImage = file);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // Save profile success popup
  void saveProfilePopUp(String message) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20.0),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (currentIndexPage == 3) {
                      Navigator.pop(context); // Exit profile setup on final step
                    }
                  },
                  child: Text('OK', style: kTextStyle.copyWith(color: kPrimaryColor)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Verify document (Mock API)
  Future<bool> verifyDocument(String type, String value) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      return false;
    }
  }

  // Submit profile to API
  Future<bool> submitProfile({bool isPartial = false}) async {
    setState(() => _isLoading = true);

    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields correctly')),
      );
      setState(() => _isLoading = false);
      return false;
    }

    // Validation for Step 0 (Basic Information)
    if (currentIndexPage == 0 &&
        (_dpImage == null && _dpImageUrl == null || _bannerImage == null && _bannerImageUrl == null)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload both profile and banner images')),
      );
      setState(() => _isLoading = false);
      return false;
    }

    // Validation for Step 1 (Addresses)
    if (currentIndexPage == 1 && addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one address')),
      );
      setState(() => _isLoading = false);
      return false;
    }

    // Validation for Step 2 (Bank Accounts)
    if (currentIndexPage == 2 && bankAccounts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one bank account')),
      );
      setState(() => _isLoading = false);
      return false;
    }
    if (currentIndexPage == 2 && _bankDocument == null && _bankDocumentUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload bank document')),
      );
      setState(() => _isLoading = false);
      return false;
    }

    // Validation for Step 3 (Documents)
    if (currentIndexPage == 3) {
      if (_aadharFrontImage == null && _aadharFrontUrl == null || _aadharBackImage == null && _aadharBackUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload both Aadhar front and back images')),
        );
        setState(() => _isLoading = false);
        return false;
      }
      if (_panCardFiles.isEmpty && _panCardUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload PAN card image')),
        );
        setState(() => _isLoading = false);
        return false;
      }
      if (_gstCertificateFiles.isEmpty && _gstCertificateUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload GST certificate')),
        );
        setState(() => _isLoading = false);
        return false;
      }
      if (_regCertificateFiles.isEmpty && _regCertificateUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload registration certificate')),
        );
        setState(() => _isLoading = false);
        return false;
      }
      if (!await verifyDocument('aadhar', _aadharController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Aadhar verification failed')),
        );
        setState(() => _isLoading = false);
        return false;
      }
      if (!await verifyDocument('pan', _panController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PAN verification failed')),
        );
        setState(() => _isLoading = false);
        return false;
      }
      if (!await verifyDocument('gstn', _gstnController.text)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('GSTN verification failed')),
        );
        setState(() => _isLoading = false);
        return false;
      }
    }

    try {
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No internet connection. Please try again.')),
        );
        setState(() => _isLoading = false);
        return false;
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Authentication token not found. Please log in again.')),
        );
        setState(() => _isLoading = false);
        return false;
      }

      const maxFileSize = 5 * 1024 * 1024; // 5MB
      for (var file in [
        _dpImage,
        _bannerImage,
        _bankDocument,
        _aadharFrontImage,
        _aadharBackImage,
        ..._panCardFiles,
        ..._gstCertificateFiles,
        ..._regCertificateFiles
      ]) {
        if (file != null) {
          final fileSize = await file.length();
          if (fileSize > maxFileSize) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('File ${file.path.split('/').last} is too large. Max size is 5MB.')),
            );
            setState(() => _isLoading = false);
            return false;
          }
        }
      }

      final Map<String, String> headers = {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      request.headers.addAll(headers);

      // Step-specific data submission
      if (currentIndexPage == 0) {
        request.fields['step_no'] = '0';
        request.fields.addAll({
          'name': _nameController.text,
          'username': _userNameController.text,
          'email': _emailController.text,
          'mobile': _mobileController.text,
          'user_type': userType,
        });
        if (_dpImage != null) {
          request.files.add(await http.MultipartFile.fromPath('dp_image', _dpImage!.path));
        }
        if (_bannerImage != null) {
          request.files.add(await http.MultipartFile.fromPath('banner_image', _bannerImage!.path));
        }
      } else if (currentIndexPage == 1) {
        request.fields['step_no'] = '1';
        addresses.asMap().forEach((index, address) {
          request.fields['addresses[$index][address_key]'] = address['address_key'] ?? '';
          request.fields['addresses[$index][address_type]'] = address['address_type'] ?? '';
          request.fields['addresses[$index][address_line1]'] = address['address'] ?? '';
          request.fields['addresses[$index][landmark]'] = address['landmark'] ?? '';
          request.fields['addresses[$index][latitude]'] = address['latitude'] ?? '';
          request.fields['addresses[$index][longitude]'] = address['longitude'] ?? '';
          request.fields['addresses[$index][default_address]'] = address['default_address'] ?? '0';
          request.fields['addresses[$index][place_id]'] = address['place_id'] ?? '';
        });
        request.fields['default_address_index'] = defaultAddressIndex.toString();
      } else if (currentIndexPage == 2) {
        request.fields['step_no'] = '2';
        bankAccounts.asMap().forEach((index, bank) {
          request.fields['bank_accounts[$index][account_key]'] = bank['account_key'] ?? '';
          request.fields['bank_accounts[$index][beneficiary_name]'] = bank['beneficiary_name'] ?? '';
          request.fields['bank_accounts[$index][account_number]'] = bank['account_number'] ?? '';
          request.fields['bank_accounts[$index][ifsc_code]'] = bank['ifsc_code'] ?? '';
          request.fields['bank_accounts[$index][upi_address]'] = bank['upi_address'] ?? '';
          request.fields['bank_accounts[$index][primary_bank]'] = bank['primary_bank'] ?? '0';
          if (bank['bank_document_url'] != null) {
            request.fields['bank_accounts[$index][bank_document_url]'] = bank['bank_document_url']!;
          }
        });
        request.fields['primary_bank'] = primaryBankIndex.toString();
        if (_bankDocument != null && primaryBankIndex >= 0) {
          request.files.add(
              await http.MultipartFile.fromPath('bank_accounts[$primaryBankIndex][bank_document]', _bankDocument!.path));
        }
      } else if (currentIndexPage == 3) {
        request.fields['step_no'] = '3';
        if (_aadharController.text.isNotEmpty) {
          request.fields['documents[0][document_key]'] = 'aadhar';
          request.fields['documents[0][document_value]'] = _aadharController.text;
        }
        if (_aadharFrontImage != null) {
          request.files.add(await http.MultipartFile.fromPath('documents[0][file]', _aadharFrontImage!.path));
        }
        if (_aadharBackImage != null) {
          request.files.add(await http.MultipartFile.fromPath('documents[1][file]', _aadharBackImage!.path));
        }
        request.fields['documents[2][document_key]'] = 'pan';
        request.fields['documents[2][document_value]'] = _panController.text;
        if (_panCardFiles.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath('documents[2][file]', _panCardFiles[0].path));
        }
        request.fields['documents[3][document_key]'] = 'gstn';
        request.fields['documents[3][document_value]'] = _gstnController.text;
        if (_gstCertificateFiles.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath('documents[3][file]', _gstCertificateFiles[0].path));
        }
        request.fields['documents[4][document_key]'] = 'reg_no';
        request.fields['documents[4][document_value]'] = _regNoController.text;
        if (_regCertificateFiles.isNotEmpty) {
          request.files.add(await http.MultipartFile.fromPath('documents[4][file]', _regCertificateFiles[0].path));
        }
      }

      final response = await request.send().timeout(const Duration(seconds: 30));
      final responseBody = await response.stream.bytesToString();
      _logger.i('Submit Response: $responseBody');

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(responseBody);
        if (decodedResponse['response_code'] == 200 && decodedResponse['success'] == true) {
          saveProfilePopUp(decodedResponse['message'] ?? 'Profile updated successfully');
          setState(() {
            final result = decodedResponse['result'] ?? {};
            _nameController.text = result['name']?.toString() ?? _nameController.text;
            _userNameController.text = result['username']?.toString() ?? _userNameController.text;
            _emailController.text = result['email']?.toString() ?? _emailController.text;
            _mobileController.text = result['mobile']?.toString() ?? _mobileController.text;
            _dpImageUrl = fixUrl(result['dp_image_url']?.toString()) ?? _dpImageUrl;
            _bannerImageUrl = fixUrl(result['banner_image_url']?.toString()) ?? _bannerImageUrl;
            userType = result['user_type']?.toString() ?? userType;
            isSelected = userType == 'Individual' ? [true, false] : [false, true];

            // Update addresses
            Map<String, Map<String, dynamic>> oldAddressesMap = {};
            for (var addr in addresses) {
              oldAddressesMap[addr['address_key']] = Map<String, dynamic>.from(addr);
            }
            addresses = List<Map<String, dynamic>>.from(
              (result['addresses'] ?? []).map((addr) {
                var newAddr = {
                  'address_key': addr['address_key']?.toString() ?? '',
                  'address_type': addr['address_type']?.toString() ?? '',
                  'address': addr['full_address']?.toString() ?? '',
                  'landmark': addr['landmark']?.toString() ?? '',
                  'latitude': addr['latitude']?.toString() ?? '',
                  'longitude': addr['longitude']?.toString() ?? '',
                  'default_address': addr['is_default'] == 1 ? '1' : '0',
                  'place_id': addr['place_id']?.toString() ?? '',
                };
                var oldAddr = oldAddressesMap[newAddr['address_key']];
                if (oldAddr != null) {
                  newAddr['landmark'] = oldAddr['landmark'] ?? '';
                }
                return newAddr;
              }),
            );
            defaultAddressIndex = addresses
                .asMap()
                .entries
                .firstWhere(
                  (entry) => entry.value['default_address'] == '1',
                  orElse: () => MapEntry(-1, {}),
                )
                .key;

            // Update bank accounts
            bankAccounts = List<Map<String, String?>>.from(
              (result['bank_accounts'] ?? []).map((bank) => {
                'account_key': bank['account_key']?.toString() ?? '',
                'beneficiary_name': bank['beneficiary_name']?.toString() ?? '',
                'account_number': bank['account_number']?.toString() ?? '',
                'ifsc_code': bank['ifsc_code']?.toString() ?? '',
                'upi_address': bank['upi_address']?.toString() ?? '',
                'primary_bank': bank['is_primary']?.toString() ?? '0',
                'bank_document_url': fixUrl(bank['bank_document_url']?.toString()),
              }),
            );
            _logger.i('Updated bankAccounts: $bankAccounts');
            primaryBankIndex = bankAccounts
                .asMap()
                .entries
                .firstWhere(
                  (entry) => entry.value['primary_bank'] == '1',
                  orElse: () => MapEntry(-1, {}),
                )
                .key;
            _bankDocumentUrl = primaryBankIndex >= 0 ? bankAccounts[primaryBankIndex]['bank_document_url'] : null;

            // Update documents
            _aadharFrontUrl = null;
            _aadharBackUrl = null;
            _panCardUrl = null;
            _gstCertificateUrl = null;
            _regCertificateUrl = null;
            _aadharVerified = false;
            _panVerified = false;
            _gstnVerified = false;
            _regNoVerified = false;

            for (var doc in result['documents'] ?? []) {
              _logger.i('Updating document: ${doc['document_key']}');
              final docUrl = fixUrl(doc['document_url_full']?.toString() ?? doc['document_url']?.toString());
              switch (doc['document_key']) {
                case 'aadhar_front':
                  _aadharFrontUrl = docUrl;
                  _aadharVerified = doc['is_verified'] == 1;
                  break;
                case 'aadhar_back':
                  _aadharBackUrl = docUrl;
                  _aadharVerified = doc['is_verified'] == 1 && _aadharVerified;
                  break;
                case 'pan':
                  _panController.text = doc['document_value']?.toString() ?? _panController.text;
                  _panCardUrl = docUrl;
                  _panVerified = doc['is_verified'] == 1;
                  break;
                case 'gstn':
                  _gstnController.text = doc['document_value']?.toString() ?? _gstnController.text;
                  _gstCertificateUrl = docUrl;
                  _gstnVerified = doc['is_verified'] == 1;
                  break;
                case 'reg_no':
                  _regNoController.text = doc['document_value']?.toString() ?? _regNoController.text;
                  _regCertificateUrl = docUrl;
                  _regNoVerified = doc['is_verified'] == 1;
                  break;
              }
            }
            _logger.i('Updated Document URLs: Aadhar Front: $_aadharFrontUrl, Aadhar Back: $_aadharBackUrl, PAN: $_panCardUrl, GST: $_gstCertificateUrl, Reg: $_regCertificateUrl');
          });
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(decodedResponse['message'] ?? 'Failed to save profile')),
          );
          return false;
        }
      } else {
        _logger.w('HTTP Error: ${response.statusCode} ${response.reasonPhrase}, Body: $responseBody');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save profile: ${response.statusCode} ${response.reasonPhrase}')),
        );
        return false;
      }
    } catch (e, stackTrace) {
      // _logger.e('Error submitting profile: $e, Response: $responseBody', stackTrace: stackTrace);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Image preview widget
  Widget buildImagePreview({
    File? image,
    String? imageUrl,
    required String label,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
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
                            child: const Icon(IconlyBold.delete, color: Colors.white, size: 16),
                          ),
                        ),
                      ),
                    ],
                  )
                : imageUrl != null && imageUrl.isNotEmpty
                    ? Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(strokeWidth: 2.0),
                              ),
                              errorWidget: (context, url, error) {
                                _logger.e('Failed to load image: $url, Error: $error');
                                return const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, color: Colors.red, size: 30),
                                    SizedBox(height: 4),
                                    Text('Image Load Failed', style: TextStyle(color: kSubTitleColor, fontSize: 12)),
                                  ],
                                );
                              },
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: onDelete,
                              child: Container(
                                padding: const EdgeInsets.all(2.0),
                                color: Colors.red.withOpacity(0.7),
                                child: const Icon(IconlyBold.delete, color: Colors.white, size: 16),
                              ),
                            ),
                          ),
                        ],
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(IconlyBold.image, color: kBorderColorTextField, size: 50),
                          SizedBox(height: 4),
                          Text('No Image', style: TextStyle(color: kSubTitleColor, fontSize: 12)),
                        ],
                      ),
          ),
        ),
        const SizedBox(height: 8.0),
        Text(label, style: kTextStyle.copyWith(color: kSubTitleColor)),
      ],
    );
  }

  // Aadhar preview widget
  Widget buildAadharPreview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Aadhar Card', style: kTextStyle.copyWith(color: kNeutralColor)),
        const SizedBox(height: 8.0),
        Row(
          children: [
            buildImagePreview(
              image: _aadharFrontImage,
              imageUrl: _aadharFrontUrl,
              label: 'Front',
              onTap: () async {
                final file = await showImageUploadPopUp('Aadhar Card Front', isAadhar: true, isFront: true);
                if (file != null) setState(() => _aadharFrontImage = file);
              },
              onDelete: () => setState(() {
                _aadharFrontImage = null;
                _aadharFrontUrl = null;
                _aadharVerified = false;
              }),
            ),
            const SizedBox(width: 16.0),
            buildImagePreview(
              image: _aadharBackImage,
              imageUrl: _aadharBackUrl,
              label: 'Back',
              onTap: () async {
                final file = await showImageUploadPopUp('Aadhar Card Back', isAadhar: true, isFront: false);
                if (file != null) setState(() => _aadharBackImage = file);
              },
              onDelete: () => setState(() {
                _aadharBackImage = null;
                _aadharBackUrl = null;
                _aadharVerified = false;
              }),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Text(
          'Verification Status: ${_aadharVerified ? 'Verified' : (_aadharFrontUrl != null && _aadharBackUrl != null ? 'Pending' : 'Not Uploaded')}',
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: PageView.builder(
                itemCount: 4,
                physics: const PageScrollPhysics(),
                controller: pageController,
                onPageChanged: (int index) => setState(() {
                  currentIndexPage = index;
                  percent = 25.0 * (index + 1);
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
                                'Step ${currentIndexPage + 1} of 4',
                                style: kTextStyle.copyWith(color: kNeutralColor),
                              ),
                              const SizedBox(width: 10.0),
                              Expanded(
                                child: StepProgressIndicator(
                                  totalSteps: 4,
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
                          if (currentIndexPage == 0) // Step 0: Basic Information
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Basic Information',
                                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildImagePreview(
                                      image: _dpImage,
                                      imageUrl: _dpImageUrl,
                                      label: 'Display Picture',
                                      onTap: () => showImportProfilePopUp(),
                                      onDelete: () => setState(() {
                                        _dpImage = null;
                                        _dpImageUrl = null;
                                      }),
                                    ),
                                    buildImagePreview(
                                      image: _bannerImage,
                                      imageUrl: _bannerImageUrl,
                                      label: 'Banner Image',
                                      onTap: () => showImportProfilePopUp(),
                                      onDelete: () => setState(() {
                                        _bannerImage = null;
                                        _bannerImageUrl = null;
                                      }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                ToggleButtons(
                                  borderRadius: BorderRadius.circular(8),
                                  borderColor: kPrimaryColor,
                                  selectedBorderColor: kPrimaryColor,
                                  fillColor: kPrimaryColor.withOpacity(0.1),
                                  selectedColor: kPrimaryColor,
                                  color: Colors.black,
                                  constraints: const BoxConstraints(minHeight: 40, minWidth: 120),
                                  isSelected: isSelected,
                                  onPressed: (index) {
                                    setState(() {
                                      for (int i = 0; i < isSelected.length; i++) {
                                        isSelected[i] = i == index;
                                      }
                                      userType = index == 0 ? "Individual" : "Organisation";
                                    });
                                  },
                                  children: const [
                                    Text("Individual"),
                                    Text("Organisation"),
                                  ],
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
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter your name' : null,
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _userNameController,
                                  keyboardType: TextInputType.name,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: 'Username',
                                    hintText: 'Enter your username',
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter your username' : null,
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
                                    if (value == null || value.isEmpty) return 'Please enter your mobile number';
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
                                    if (value == null || value.isEmpty) return 'Please enter your email';
                                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                      return 'Please enter a valid email';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          if (currentIndexPage == 1) // Step 1: Addresses
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Addresses',
                                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    const Spacer(),
                                    const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
                                    const SizedBox(width: 5.0),
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await showAddressPopUp();
                                        if (result != null) setState(() => addresses.add(result));
                                      },
                                      child: Text('Add New', style: kTextStyle.copyWith(color: kSubTitleColor)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                if (addresses.isEmpty)
                                  Text(
                                    'No addresses added',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                ...addresses.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, dynamic> address = entry.value;
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoShowCase(
                                              title: address['address_type'] ?? 'Unknown',
                                              subTitle: address['address']?.isNotEmpty == true
                                                  ? '${address['address']}${address['landmark']?.isNotEmpty == true ? ', ${address['landmark']}' : ''}'
                                                  : 'Latitude: ${address['latitude'] ?? 'N/A'}, Longitude: ${address['longitude'] ?? 'N/A'}',
                                              onEdit: () async {
                                                final result = await showAddressPopUp(existingAddress: address, index: index);
                                                if (result != null) {
                                                  setState(() {
                                                    addresses[index] = result;
                                                    if (result['default_address'] != '1' && index == defaultAddressIndex) {
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
                                        title: Text('Set as Default', style: kTextStyle.copyWith(color: kNeutralColor)),
                                        value: index == defaultAddressIndex,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              defaultAddressIndex = index;
                                              addresses[index]['default_address'] = '1';
                                              for (int i = 0; i < addresses.length; i++) {
                                                if (i != index) addresses[i]['default_address'] = '0';
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
                              ],
                            ),
                          if (currentIndexPage == 2) // Step 2: Bank Accounts
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Bank Accounts',
                                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20.0),
                                Row(
                                  children: [
                                    const Spacer(),
                                    const Icon(FeatherIcons.plusCircle, color: kSubTitleColor, size: 18.0),
                                    const SizedBox(width: 5.0),
                                    GestureDetector(
                                      onTap: () async {
                                        final result = await showBankAccountPopUp();
                                        if (result != null) {
                                          setState(() {
                                            bankAccounts.add(result);
                                            _logger.i('Added bank account: $result');
                                          });
                                        }
                                      },
                                      child: Text('Add New', style: kTextStyle.copyWith(color: kSubTitleColor)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20.0),
                                if (bankAccounts.isEmpty)
                                  Text(
                                    'No bank accounts added',
                                    style: kTextStyle.copyWith(color: kSubTitleColor),
                                  ),
                                ...bankAccounts.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  Map<String, String?> bank = entry.value;
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: InfoShowCase(
                                              title: bank['beneficiary_name'] ?? 'Unknown',
                                              subTitle: [
                                                bank['account_number']?.replaceAll(RegExp(r'\d'), '*') ?? '',
                                                bank['ifsc_code'] ?? '',
                                                bank['upi_address']?.isNotEmpty == true ? bank['upi_address']! : ''
                                              ].where((e) => e.isNotEmpty).join(' | '),
                                              onEdit: () async {
                                                final result = await showBankAccountPopUp(existingBankAccount: bank, index: index);
                                                if (result != null) {
                                                  setState(() {
                                                    bankAccounts[index] = result;
                                                    _logger.i('Updated bank account at index $index: $result');
                                                    if (result['primary_bank'] != '1' && index == primaryBankIndex) {
                                                      primaryBankIndex = -1;
                                                    }
                                                  });
                                                }
                                              },
                                              onDelete: () {
                                                setState(() {
                                                  _logger.i('Deleting bank account at index $index');
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
                                        title: Text('Set as Primary', style: kTextStyle.copyWith(color: kNeutralColor)),
                                        value: index == primaryBankIndex,
                                        onChanged: (value) {
                                          setState(() {
                                            if (value == true) {
                                              primaryBankIndex = index;
                                              bankAccounts[index]['primary_bank'] = '1';
                                              for (int i = 0; i < bankAccounts.length; i++) {
                                                if (i != index) bankAccounts[i]['primary_bank'] = '0';
                                              }
                                              _logger.i('Set primary bank to index $index');
                                            } else {
                                              primaryBankIndex = -1;
                                              bankAccounts[index]['primary_bank'] = '0';
                                              _logger.i('Removed primary bank status from index $index');
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
                                  'Bank Document',
                                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 10.0),
                                buildImagePreview(
                                  image: _bankDocument,
                                  imageUrl: _bankDocumentUrl,
                                  label: 'Bank Document',
                                  onTap: () async {
                                    final file = await showImageUploadPopUp('Bank Document');
                                    if (file != null) setState(() => _bankDocument = file);
                                  },
                                  onDelete: () => setState(() {
                                    _bankDocument = null;
                                    _bankDocumentUrl = null;
                                  }),
                                ),
                              ],
                            ),
                          if (currentIndexPage == 3) // Step 3: Documents
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Documents & Other Information',
                                  style: kTextStyle.copyWith(color: kNeutralColor, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _aadharController,
                                  keyboardType: TextInputType.number,
                                  obscureText: true,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: 'Aadhar Number',
                                    hintText: 'Enter 12-digit Aadhar number',
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Please enter Aadhar number';
                                    if (!RegExp(r'^\d{12}$').hasMatch(value)) {
                                      return 'Please enter a valid 12-digit Aadhar number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Verification Status: ${_aadharVerified ? 'Verified' : (_aadharFrontUrl != null && _aadharBackUrl != null ? 'Pending' : 'Not Uploaded')}',
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                                const SizedBox(height: 20.0),
                                buildAadharPreview(),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _panController,
                                  obscureText: true,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: 'PAN Number',
                                    hintText: 'Enter PAN number (e.g., ABCDE1234F)',
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Please enter PAN number';
                                    if (!RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(value)) {
                                      return 'Please enter a valid PAN number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Verification Status: ${_panVerified ? 'Verified' : (_panCardUrl != null ? 'Pending' : 'Not Uploaded')}',
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                                const SizedBox(height: 20.0),
                                buildImagePreview(
                                  image: _panCardFiles.isNotEmpty ? _panCardFiles[0] : null,
                                  imageUrl: _panCardUrl,
                                  label: 'PAN Card',
                                  onTap: () async {
                                    final file = await showImageUploadPopUp('PAN Card');
                                    if (file != null) setState(() => _panCardFiles = [file]);
                                  },
                                  onDelete: () => setState(() {
                                    _panCardFiles = [];
                                    _panCardUrl = null;
                                    _panVerified = false;
                                  }),
                                ),
                                const SizedBox(height: 20.0),
                                TextFormField(
                                  controller: _gstnController,
                                  obscureText: true,
                                  decoration: kInputDecoration.copyWith(
                                    labelText: 'GST Number',
                                    hintText: 'Enter GST number (e.g., 22AAAAA0000A1Z5)',
                                    border: const OutlineInputBorder(),
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) return 'Please enter GST number';
                                    if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[0-9A-Z]{3}$').hasMatch(value)) {
                                      return 'Please enter a valid GST number';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'Verification Status: ${_gstnVerified ? 'Verified' : (_gstCertificateUrl != null ? 'Pending' : 'Not Uploaded')}',
                                  style: kTextStyle.copyWith(color: kSubTitleColor),
                                ),
                                const SizedBox(height: 20.0),
                                buildImagePreview(
                                  image: _gstCertificateFiles.isNotEmpty ? _gstCertificateFiles[0] : null,
                                  imageUrl: _gstCertificateUrl,
                                  label: 'GST Certificate',
                                  onTap: () async {
                                    final file = await showImageUploadPopUp('GST Certificate');
                                    if (file != null) setState(() => _gstCertificateFiles = [file]);
                                  },
                                  onDelete: () => setState(() {
                                    _gstCertificateFiles = [];
                                    _gstCertificateUrl = null;
                                    _gstnVerified = false;
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
                                  validator: (value) => value == null || value.isEmpty ? 'Please enter registration number' : null,
                                ),
                                const SizedBox(height: 20.0),
                                buildImagePreview(
                                  image: _regCertificateFiles.isNotEmpty ? _regCertificateFiles[0] : null,
                                  imageUrl: _regCertificateUrl,
                                  label: 'Registration Certificate',
                                  onTap: () async {
                                    final file = await showImageUploadPopUp('Registration Certificate');
                                    if (file != null) setState(() => _regCertificateFiles = [file]);
                                  },
                                  onDelete: () => setState(() {
                                    _regCertificateFiles = [];
                                    _regCertificateUrl = null;
                                  }),
                                ),
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
        buttontext: currentIndexPage < 3 ? 'Continue' : 'Save Profile',
        buttonDecoration: kButtonDecoration.copyWith(
          color: kPrimaryColor,
          borderRadius: BorderRadius.circular(30.0),
        ),
        onPressed: _isLoading
            ? null
            : () async {
                if (currentIndexPage < 3) {
                  if (currentIndexPage == 0 && !_formKey.currentState!.validate()) {
                    return;
                  }
                  if (currentIndexPage == 0 &&
                      (_dpImage == null && _dpImageUrl == null || _bannerImage == null && _bannerImageUrl == null)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please upload both profile and banner images')),
                    );
                    return;
                  }
                  if (currentIndexPage == 1 && addresses.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please add at least one address')),
                    );
                    return;
                  }
                  if (currentIndexPage == 2) {
                    if (bankAccounts.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please add at least one bank account')),
                      );
                      return;
                    }
                    if (_bankDocument == null && _bankDocumentUrl == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please upload bank document')),
                      );
                      return;
                    }
                  }
                  bool success = await submitProfile(isPartial: true);
                  if (success) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.bounceInOut,
                    );
                  }
                } else {
                  await submitProfile();
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
    _addressSearchController.dispose();
    pageController.dispose();
    super.dispose();
  }
}