import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:libdding/controller/profile/profile_controller.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/utils.dart';
import '../../view/Bottom_navigation_screen/Botom_navigation_screen.dart';
import '../app_main/App_main_controller.dart';
import '../../widget/form_widgets/dynamic_form_builder.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../core/app_constant.dart';

class SetupProfileController extends GetxController {
  static SetupProfileController get to => Get.find();

  // Page Control
  final pageController = PageController(initialPage: 0).obs;
  final currentIndexPage = 0.obs;
  final percent = 25.0.obs;

  // User Type
  final isSelected = [true, false].obs;
  final userType = "Individual".obs;

  // Form Controllers
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final aadharController = TextEditingController();
  final panController = TextEditingController();
  final gstnController = TextEditingController();
  final regNoController = TextEditingController();
  final addressSearchController = TextEditingController();

  // File Observables
  final dpImage = Rx<File?>(null);
  final bannerImage = Rx<File?>(null);
  final bankDocument = Rx<File?>(null);
  final aadharFrontImage = Rx<File?>(null);
  final aadharBackImage = Rx<File?>(null);
  final panCardFiles = <File>[].obs;
  final gstCertificateFiles = <File>[].obs;
  final regCertificateFiles = <File>[].obs;

  // Image URLs from API
  final dpImageUrl = RxString('');
  final bannerImageUrl = RxString('');
  final bankDocumentUrl = RxString('');
  final aadharFrontUrl = RxString('');
  final aadharBackUrl = RxString('');
  final panCardUrl = RxString('');
  final gstCertificateUrl = RxString('');
  final regCertificateUrl = RxString('');

  // Verification Status
  final aadharVerified = false.obs;
  final panVerified = false.obs;
  final gstnVerified = false.obs;
  final regNoVerified = false.obs;

  // Dynamic Lists
  final addresses = <Map<String, dynamic>>[].obs;
  final bankAccounts = <Map<String, String?>>[].obs;
  // Generic multi-entry storage per step (keyed by 0-based step index)
  final multiStepEntries = <int, List<Map<String, dynamic>>>{}.obs;

  // Primary indices
  final primaryBankIndex = (-1).obs;
  final defaultAddressIndex = (-1).obs;

  // Button visibility states
  final showPreviousButton = true.obs;
  final showNextButton = true.obs;
  final showSubmitButton = false.obs;


  // Loading State
  final isLoading = false.obs;
  final profilecontroller = Get.put(ProfileController());

  // Step-wise API endpoints
  String? _getStepApiEndpoint(int step) {
    final appController = Get.find<AppSettingsController>();

    final profileForm = appController.profileFormPage.value;
    
    if (profileForm?.apiEndpoints == null) return null;
    
    // Use the dynamic method from the model
    String? endpoint = profileForm!.apiEndpoints!.getStepEndpoint(step);
    
    // If endpoint is just a path (like "profile_update/1"), add base URL
    if (endpoint != null && !endpoint.startsWith('http')) {
      // Use the proper base URL from AppConstants
      endpoint = '${AppConstants.baseUrl}$endpoint';
    }
    
    return endpoint;
  }

  // Update button visibility based on API response
  void _updateButtonVisibility() {
    final appController = Get.find<AppSettingsController>();
    final profileForm = appController.profileFormPage.value;
    final buttons = profileForm?.buttons;
    
    if (buttons == null) {
      // Default behavior if no button configuration
      showPreviousButton.value = currentStep.value > 0;
      showNextButton.value = currentStep.value < (profileForm?.totalSteps ?? 3) - 1;
      showSubmitButton.value = currentStep.value == (profileForm?.totalSteps ?? 3) - 1;
      return;
    }

    // Reset all buttons
    showPreviousButton.value = false;
    showNextButton.value = false;
    showSubmitButton.value = false;

    // Check each button configuration
    for (final button in buttons) {
      final action = button.action?.toLowerCase();
      final currentStepValue = currentStep.value + 1;

      switch (action) {
        case 'prev_step':
          if (button.visibleFromStep != null && currentStepValue >= button.visibleFromStep!) {
            showPreviousButton.value = true;
          }
          break;
        case 'next_step':
          if (button.visibleUntilStep != null && currentStepValue <= button.visibleUntilStep!) {
            showNextButton.value = true;
          }
          break;
        case 'submit_form':
          if (button.visibleOnStep != null && currentStepValue == button.visibleOnStep!) {
            showSubmitButton.value = true;
          }
          break;
      }
    }
  }

  // Dynamic Form State
  final currentStep = 0.obs;
  final formData = <String, dynamic>{}.obs;
  final formErrors = <String, String>{}.obs;
  bool _hasPrefilled = false; // Flag to prevent multiple prefilling

  // Toggle States
  final isOn = false.obs;
  final isOnForSetDefault = false.obs;
  final isOnForSetDefaultForAddress = false.obs;
  final isOnForSetDefaultForBank = false.obs;

  // Address Types
  final addressTypes = ['Office', 'Shop', 'Godown', 'Home', 'Other'];
  final isSelectedForAddress = [false, false, false, false, false].obs;
  final selectedAddressType = RxString('');

  final ImagePicker _picker = ImagePicker();
  final String apiUrl = 'https://phplaravel-1517766-5835172.cloudwaysapps.com/api/profile/update';



  final appController = Get.find<AppSettingsController>();


  @override
  void onInit() {
    super.onInit();

    _initializeDefaultValues();
    _fetchProfileData();
    _updateButtonVisibility();

    final appController = Get.find<AppSettingsController>();

    /// Prefill when API arrives
    ever(appController.profileFormPage, (form) {
      if (form != null && !_hasPrefilled) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // _prefillStep1(form);          // <-- WILL RUN
          _prefillFormFromBackend();    // <-- WILL RUN

          _hasPrefilled = true;         // <-- MOVED INSIDE
        });
      }
    });

    /// If already available
    if (appController.profileFormPage.value != null && !_hasPrefilled) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        // _prefillStep1(appController.profileFormPage.value!);
        _prefillFormFromBackend();

        _hasPrefilled = true;          // <-- HERE TOO
      });
    }
  }




  // void _prefillStep1(ProfileFormPage profileForm) {
  //   final step1 = profileForm.inputs?.getStepInputs(0);
  //
  //   if (step1 == null) return;
  //
  //   print("===== PREFILLING STEP-1 VALUES =====");
  //   for (var input in step1) {
  //     print("${input.name} : ${input.value}");
  //   }
  //   print("====================================");
  //
  //   for (var input in step1) {
  //     switch (input.name) {
  //       case "user_type":
  //         userType.value = input.value?.toString() ?? "";
  //         break;
  //
  //       case "name":
  //         nameController.text = input.value?.toString() ?? "";
  //         break;
  //
  //       case "username":
  //         userNameController.text = input.value?.toString() ?? "";
  //         break;
  //
  //       case "email":
  //         emailController.text = input.value?.toString() ?? "";
  //         break;
  //
  //       case "mobile":
  //         mobileController.text = input.value?.toString() ?? "";
  //         break;
  //     }
  //   }
  // }




  void _initializeDefaultValues() {
    // Set default values for all steps
    formData['user_type'] = 'individual';
    formData['address_type'] = 'home';
    formData['default_address'] = false;
    
    // Get form configuration from app settings
    final appController = Get.find<AppSettingsController>();
    final profileForm = appController.profileFormPage.value;
    
    if (profileForm != null && profileForm.inputs != null) {
      // Initialize defaults for all available steps dynamically
      List<int> availableSteps = profileForm.inputs!.getAvailableSteps();
      for (int stepIndex in availableSteps) {
        List<RegisterInput>? stepInputs = profileForm.inputs!.getStepInputs(stepIndex);
        _setDefaultsForStep(stepInputs);
      }
    }
  }

  void _setDefaultsForStep(List<RegisterInput>? inputs) {
    if (inputs == null) return;
    
    for (final input in inputs) {
      final fieldName = input.name ?? '';
      final fieldType = (input.inputType ?? 'text').toLowerCase();
      
      // Set default values based on field type and name
      if (!formData.containsKey(fieldName)) {
        switch (fieldType) {
          case 'select':
            if (fieldName.toLowerCase() == 'user_type') {
              formData[fieldName] = 'individual';
            } else if (fieldName.toLowerCase() == 'address_type') {
              formData[fieldName] = 'home';
            } else if (input.optionItems != null && input.optionItems!.isNotEmpty) {
              formData[fieldName] = input.optionItems!.first.value ?? '';
            }
            break;
          case 'checkbox':
            formData[fieldName] = false;
            break;
          case 'text':
          case 'email':
          case 'password':
          case 'textarea':
          default:
            formData[fieldName] = '';
            break;
        }
      }
    }
  }

  // Prefill form fields from backend response
  void _prefillFormFromBackend() {
    if (_hasPrefilled) {
      return; // Already prefilled
    }

    try {
      final appController = Get.find<AppSettingsController>();
      final profileForm = appController.profileFormPage.value;

      if (profileForm == null || profileForm.inputs == null) {
        print('Profile form not available for prefilling');
        return;
      }

      // ================================================================
      // 🔥 PRINT RAW BACKEND DATA
      // ================================================================
      print("==================================================");
      print("🔥 RAW BACKEND PROFILE FORM (FULL DATA BELOW)");
      print("==================================================");

      try {
        print(profileForm.toJson());
      } catch (_) {
        print(profileForm);
      }

      print("==================================================\n\n");

      // Get all available steps
      List<int> availableSteps = profileForm.inputs!.getAvailableSteps();

      print("AVAILABLE STEPS => $availableSteps");

      for (int stepIndex in availableSteps) {
        List<RegisterInput>? stepInputs = profileForm.inputs!.getStepInputs(stepIndex);
        if (stepInputs == null) continue;

        print("\n--------------------------------------------------");
        print(" STEP $stepIndex INPUTS FROM BACKEND");
        print("--------------------------------------------------");

        // Step title
        final currentStepTitle = _getCurrentStepTitle(profileForm, stepIndex);
        final isAddressStep = _isAddressStep(currentStepTitle);

        for (final input in stepInputs) {
          final fieldName = input.name ?? '';
          final fieldType = (input.inputType ?? '').toLowerCase();
          final value = input.value;

          // PRINT EACH FIELD
          print("FIELD: $fieldName");
          print("TYPE : $fieldType");
          print("VALUE: $value\n");

          // Skip marker fields
          if (fieldName.toLowerCase() == 'step_type' ||
              fieldType == 'single' ||
              fieldType == 'multiple') {
            continue;
          }

          if (value == null) continue;

          switch (fieldType) {

          // ------------------------------------------------------------
            case 'group':
              if (value is List) {
                print("🔥 GROUP FIELD DETECTED: $fieldName");

                if (isAddressStep && fieldName.toLowerCase() == 'addresses') {
                  final addressList = <Map<String, dynamic>>[];

                  for (var item in value) {
                    if (item is Map<String, dynamic>) {
                      print("➡️ Address Item: $item");

                      final addressMap = <String, dynamic>{};
                      addressMap['address_key'] = item['address_key']?.toString();
                      addressMap['address_type'] = item['address_type']?.toString() ?? 'home';
                      addressMap['address'] = item['address']?.toString() ?? '';
                      addressMap['landmark'] = item['landmark']?.toString();
                      addressMap['latitude'] = item['latitude']?.toString();
                      addressMap['longitude'] = item['longitude']?.toString();

                      final isDefault = item['default_address'] == true ||
                          item['default_address'] == 1 ||
                          item['default_address'] == '1';

                      addressMap['default_address'] = isDefault;

                      addressList.add(addressMap);

                      if (isDefault && defaultAddressIndex.value == -1) {
                        defaultAddressIndex.value = addressList.length - 1;
                      }
                    }
                  }

                  print("🏠 FINAL ADDRESS LIST => $addressList");
                  if (addressList.isNotEmpty) {
                    addresses.assignAll(addressList);
                  }

                } else {
                  // OTHER GROUP ITEMS (documents, etc.)
                  final entryList = <Map<String, dynamic>>[];

                  for (var item in value) {
                    if (item is Map<String, dynamic>) {
                      print("📄 Group Entry: $item");
                      entryList.add(Map<String, dynamic>.from(item));
                    }
                  }

                  print("📂 FINAL GROUP LIST (Step $stepIndex) => $entryList");

                  if (entryList.isNotEmpty) {
                    multiStepEntries[stepIndex] = entryList;
                  }
                }
              }
              break;

          // ------------------------------------------------------------
            case 'file':
              if (value is String && value.isNotEmpty) {
                formData[fieldName] = value;
                print("📁 FILE FIELD → $fieldName = $value");
              }
              break;

          // ------------------------------------------------------------
            case 'files':
              if (value is List) {
                formData[fieldName] = value;
              } else if (value is String) {
                formData[fieldName] = [value];
              }
              print("📁 FILES FIELD → $fieldName = ${formData[fieldName]}");
              break;

          // ------------------------------------------------------------
            case 'checkbox':
            case 'toggle':
              bool parsed = false;

              if (value is bool) parsed = value;
              else if (value is int) parsed = value == 1;
              else if (value is String) parsed = value.toLowerCase() == 'true' || value == '1';

              formData[fieldName] = parsed;
              print("✔️ CHECKBOX → $fieldName = $parsed");
              break;

          // ------------------------------------------------------------
            case 'select':
              if (value is String &&
                  input.optionItems != null &&
                  input.optionItems!.isNotEmpty) {
                final valueLower = value.toLowerCase();

                final matching = input.optionItems!.firstWhere(
                      (o) => (o.value ?? '').toLowerCase() == valueLower ||
                      (o.label ?? '').toLowerCase() == valueLower,
                  orElse: () => input.optionItems!.first,
                );

                formData[fieldName] = matching.value ?? value;
              } else {
                formData[fieldName] = value.toString();
              }

              print("🔽 SELECT → $fieldName = ${formData[fieldName]}");
              break;

          // ------------------------------------------------------------
            case 'number':
              if (value is num) {
                formData[fieldName] = value;
              } else if (value is String) {
                final numValue = num.tryParse(value);
                if (numValue != null) {
                  formData[fieldName] = numValue;
                }
              }
              print("🔢 NUMBER → $fieldName = ${formData[fieldName]}");
              break;

          // ------------------------------------------------------------
            default:
              formData[fieldName] = value.toString();
              print("📝 TEXT → $fieldName = ${formData[fieldName]}");
          }
        }
      }

      // ================================================================
      // PRINT FINAL MAPPED DATA
      // ================================================================
      print("\n==================================================");
      print("🔥 FINAL MAPPED formData");
      print("==================================================");
      formData.forEach((k, v) => print("$k : $v"));

      print("\n🔥 FINAL ADDRESSES => $addresses");
      print("🔥 FINAL MULTI-STEP ENTRIES => $multiStepEntries");
      print("==================================================");

      formData.refresh();
      update(['form_content']);

    } catch (e) {
      print('Error prefilling form from backend: $e');
    }
  }


  @override
  void onClose() {
    nameController.dispose();
    userNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    aadharController.dispose();
    panController.dispose();
    gstnController.dispose();
    regNoController.dispose();
    addressSearchController.dispose();
    pageController.value.dispose();
    super.onClose();
  }

  // Update page index and percentage
  void updatePageIndex(int index) {
    currentIndexPage.value = index;
    percent.value = 25.0 * (index + 1);
  }

  // Dynamic Form Methods
  void updateFormData(String fieldName, dynamic value) {
    formData[fieldName] = value;
    // Clear error for this field when user starts typing
    if (formErrors.containsKey(fieldName)) {
      formErrors.remove(fieldName);
      formErrors.refresh();
    }
    // Trigger update to refresh UI immediately
    update(['form_content']);
  }

  Future<void> nextStep() async {
    print('Next step called. Current step: ${currentStep.value}');
    print('Addresses count: ${addresses.length}');

    // Always validate and show errors immediately
    final isValid = _validateCurrentStep();
    print('Validation result: $isValid');

    if (!isValid) {
      // Force UI update to show errors immediately
      formErrors.refresh();
      // Trigger a rebuild of the form to show errors
      update(['form_content']);
      return;
    }

    // Call step-wise API before moving to next step
    final apiEndpoint = _getStepApiEndpoint(currentStep.value);
    if (apiEndpoint != null) {
      print('Calling API for step ${currentStep.value + 1}: $apiEndpoint');
      print('Full API URL: $apiEndpoint');

      isLoading.value = true;
      try {
        final success = await _callStepApi(apiEndpoint, currentStep.value);
        if (!success) {
          isLoading.value = false;
          return; // Don't proceed if API call failed
        }
      } catch (e) {
        isLoading.value = false;
        Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to save step data: $e');

        return;
      }
      isLoading.value = false;
    }

    // Get total steps from API configuration
    final appController = Get.find<AppSettingsController>();
    final profileForm = appController.profileFormPage.value;
    final totalSteps = profileForm?.totalSteps ?? 3;
    print('Total steps: $totalSteps');

    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      print('Moved to step: ${currentStep.value}');

      // Update button visibility after step change
      _updateButtonVisibility();
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
      // Update button visibility after step change
      _updateButtonVisibility();
    }
  }

  // Call step-wise API
  Future<bool> _callStepApi(String endpoint, int step) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Authentication token not found');
        return false;
      }

      // Get app controller and profile form
      final appController = Get.find<AppSettingsController>();
      final profileForm = appController.profileFormPage.value;

      // Get current step inputs and title
      final currentStepInputs = getCurrentStepInputs(step);
      final currentStepTitle = profileForm != null ? _getCurrentStepTitle(profileForm, step) : null;

      // Check if step has multiple input_type
      final hasMultipleInput = currentStepInputs?.any((e) =>
        (e.inputType ?? '').toLowerCase() == 'multiple') ?? false;

      // Check if step title is "Address Details"
      final isAddressDetailsStep = currentStepTitle != null &&
        currentStepTitle.toLowerCase() == 'address details';

      // Prepare step-specific data
      final stepData = _prepareStepData(step);

      // Handle file uploads for this step
      final filesToUpload = <String, File>{};
      for (final entry in stepData.entries) {
        if (entry.value is File) {
          final file = entry.value as File;

          // Only upload if path does NOT contain HTTP (local files only)
          if (!file.path.toLowerCase().contains('http')) {
            filesToUpload[entry.key] = file;
          }
        }

      }

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add dynamic step number (1-based)
      request.fields['step_no'] = (step + 1).toString();

      // If input_type is multiple, format data as arrays
      if (hasMultipleInput) {
        // Get the list of entries - use addresses for address step, otherwise multiStepEntries
        List<Map<String, dynamic>> entriesList;
        if (_isAddressStep(currentStepTitle)) {
          entriesList = List<Map<String, dynamic>>.from(addresses);
        } else {
          entriesList = List<Map<String, dynamic>>.from(multiStepEntries[step] ?? []);
        }

        // Get field names from inputs (excluding special markers)
        final fieldNames = <String>[];
        if (currentStepInputs != null) {
          for (final input in currentStepInputs) {
            final fieldName = input.name ?? '';
            final inputTypeLower = (input.inputType ?? '').toLowerCase();
            // Skip special marker fields
            if (fieldName.toLowerCase() != 'step_type' &&
                inputTypeLower != 'single' &&
                inputTypeLower != 'multiple') {
              // For Address Details step, skip default_address as we handle it separately
              if (!isAddressDetailsStep || fieldName.toLowerCase() != 'default_address') {
                fieldNames.add(fieldName);
              }
            }
          }
        }

        // Format each entry as array fields: fieldName[0], fieldName[1], etc.
        for (int index = 0; index < entriesList.length; index++) {
          final entry = entriesList[index];

          // First, add key fields if they exist (e.g., address_key, document_key)
          // These are used to identify existing entries for updates
          for (final key in entry.keys) {
            if (key.toLowerCase().endsWith('_key') || key.toLowerCase() == 'key') {
              final keyValue = entry[key];
              if (keyValue != null && keyValue.toString().isNotEmpty) {
                request.fields['$key[$index]'] = keyValue.toString();
                print('Added key field: $key[$index] = ${keyValue.toString()}');
              }
            }
          }

          // Add all field values with array notation
          for (final fieldName in fieldNames) {
            final value = entry[fieldName];
            if (value != null) {
              // Check if this is a file field
              final input = currentStepInputs?.firstWhere(
                (inp) => inp.name?.toLowerCase() == fieldName.toLowerCase(),
                orElse: () => RegisterInput(),
              );
              final isFileField = (input?.inputType ?? '').toLowerCase() == 'file' || 
                                 (input?.inputType ?? '').toLowerCase() == 'files';
              
              final valueStr = value.toString();
              // Skip file fields that contain HTTP (remote URLs)
              // Non-file fields (like URLs) should still be included
              if (!isFileField || !valueStr.toLowerCase().contains('http')) {
                request.fields['$fieldName[$index]'] = valueStr;
              }
            }
          }

          // For Address Details step, handle default_address and location
          if (isAddressDetailsStep) {
            // Set default_address based on defaultAddressIndex
            final isDefault = (defaultAddressIndex.value == index);
            request.fields['default_address[$index]'] = isDefault ? '1' : '0';

            // Add latitude and longitude
            final latitude = entry['latitude'];
            final longitude = entry['longitude'];
            if (latitude != null) {
              request.fields['latitude[$index]'] = latitude.toString();
            }
            if (longitude != null) {
              request.fields['longitude[$index]'] = longitude.toString();
            }
          } else {
            // For non-address multiple steps, check if default_address field exists
            final defaultAddressValue = entry['default_address'];
            if (defaultAddressValue != null) {
              // Convert boolean to '1' or '0', or keep string value
              final defaultStr = defaultAddressValue is bool
                ? (defaultAddressValue ? '1' : '0')
                : defaultAddressValue.toString();
              request.fields['default_address[$index]'] = defaultStr;
            }
          }
        }
      } else {
        // For non-multiple steps, add form fields normally
        // File objects are handled separately in filesToUpload, so skip them here
        for (final entry in stepData.entries) {
          // Skip File objects (they're handled as multipart files)
          if (entry.value is File) {
            continue;
          }
          
          final valueStr = entry.value.toString();
          // Skip string values that contain HTTP and are file fields
          // (non-file fields like URLs should still be included)
          final input = currentStepInputs?.firstWhere(
            (inp) => inp.name?.toLowerCase() == entry.key.toLowerCase(),
            orElse: () => RegisterInput(),
          );
          final isFileField = (input?.inputType ?? '').toLowerCase() == 'file' || 
                             (input?.inputType ?? '').toLowerCase() == 'files';
          
          if (!isFileField || !valueStr.toLowerCase().contains('http')) {
            request.fields[entry.key] = valueStr;
          }
        }
      }

      // Debug: Print request details
      try {
        print('Step ${step + 1} API Request URL: $endpoint');
        print('Step ${step + 1} API Request Fields: ${jsonEncode(request.fields)}');
        if (filesToUpload.isNotEmpty) {
          print('Step ${step + 1} API Files: ${filesToUpload.keys.toList()}');
        }
      } catch (_) {}

      // Add files
      for (final entry in filesToUpload.entries) {
        request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value.path));
      }

      // Debug: Final fields just before send (after addresses/files fields have been set)
      try {
        print('Step ${step + 1} FINAL Request Fields: ${jsonEncode(request.fields)}');
      } catch (_) {}

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      print('Step ${step + 1} API Status: ${response.statusCode}');
      print('Step ${step + 1} API Response: $decodedResponse');

      if (response.statusCode == 200 && decodedResponse['success'] == true) {
        Utils.showSnackbar(isSuccess: true, title: 'Success', message: 'Step ${step + 1} data saved successfully');
        //
        // if (profileForm?.autoForward == true) {
        //   showNextButtonFromAuto.value = true; // ✅ correct Rx update
        //   print('Auto-forward is enabled — proceeding to next step automatically...');
        //
        //   // Auto move to next step if possible
        //   Future.delayed(const Duration(milliseconds: 500), () async {
        //     final totalSteps = profileForm?.totalSteps ?? 3;
        //     if (currentStep.value < totalSteps - 1) {
        //       await nextStep(); // 🚀 Automatically call nextStep()
        //     } else {
        //       print('Auto-forward: Last step reached, not moving further.');
        //     }
        //   });
        // }


        return true;
      } else {
        Utils.showSnackbar(isSuccess: false, title: 'Error', message: decodedResponse['message'] ?? 'Failed to save step data');
        return false;
      }
    } catch (e) {
      print('Step API Error: $e');
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to save step data: $e');
      return false;
    }
  }

  // Prepare step-specific data
  Map<String, dynamic> _prepareStepData(int step) {
    final stepData = <String, dynamic>{};
    
    // Get current step inputs
    final currentStepInputs = getCurrentStepInputs(step);
    if (currentStepInputs == null) return stepData;

    // Add form data for current step fields
    for (final input in currentStepInputs) {
      final fieldName = input.name ?? '';
      final inputTypeLower = (input.inputType ?? '').toLowerCase();
      // Skip special marker fields
      if (fieldName.toLowerCase() == 'step_type' || inputTypeLower == 'single' || inputTypeLower == 'multiple') {
        continue;
      }
      if (formData.containsKey(fieldName)) {
        final value = formData[fieldName];
        
        // Skip file fields that contain HTTP (remote URLs)
        if (value is File) {
          // Only include local files (not HTTP URLs)
          if (!value.path.toLowerCase().contains('http')) {
            stepData[fieldName] = value;
          }
        } else if (value is String) {
          // Check if it's a file field by input type
          if (inputTypeLower == 'file' || inputTypeLower == 'files') {
            // Skip if the string contains HTTP (remote URL)
            if (!value.toLowerCase().contains('http')) {
              stepData[fieldName] = value;
            }
          } else {
            // For non-file fields, include the value
            stepData[fieldName] = value;
          }
        } else {
          // For other types, include the value
          stepData[fieldName] = value;
        }
      }
    }

    return stepData;
  }

  List<RegisterInput>? getCurrentStepInputs(int stepIndex) {
    final appController = Get.find<AppSettingsController>();
    final profileForm = appController.profileFormPage.value;
    
    if (profileForm == null) return null;

    return _getStepInputs(profileForm, stepIndex);
  }

  bool _validateCurrentStep() {
    print('Validating step: ${currentStep.value}');
    // Clear previous errors
    formErrors.clear();
    
    // Get current step inputs from app settings
    final appController = Get.find<AppSettingsController>();
    final profileForm = appController.profileFormPage.value;
    
    if (profileForm == null) return true;

    // Get current step title for conditional validation
    final currentStepTitle = _getCurrentStepTitle(profileForm, currentStep.value);
    
    // Special handling for address step based on step_titles
    if (_isAddressStep(currentStepTitle)) {
      print('Address step validation - addresses count: ${addresses.length}');
      // For address step, we only validate that at least one address is added
      if (addresses.isEmpty) {
        Utils.showSnackbar(isSuccess: false, title: 'Validation Error', message: 'Please add at least one address before proceeding');
        return false;
      }
      return true;
    }
    
    // Get current step inputs dynamically
    List<RegisterInput>? currentStepInputs = _getStepInputs(profileForm, currentStep.value);

    if (currentStepInputs != null) {
      // Filter out special marker fields from validation
      final inputsForValidation = currentStepInputs.where((input) {
        final fieldName = (input.name ?? '').toLowerCase();
        final t = (input.inputType ?? '').toLowerCase();
        return fieldName != 'step_type' && t != 'single' && t != 'multiple';
      }).toList();

      // If step is marked as multiple, ensure at least one entry is added
      final hasMultipleMarker = currentStepInputs.any((e) => (e.inputType ?? '').toLowerCase() == 'multiple');
      if (hasMultipleMarker) {
        final list = multiStepEntries[currentStep.value] ?? const [];
        if (list.isEmpty) {
          Utils.showSnackbar(isSuccess: false, title: 'Validation Error', message: 'Please add at least one item before proceeding');
          return false;
        }
        return true;
      }
      // Validate and update errors
      final newErrors = DynamicFormValidator.validateForm(inputsForValidation, formData);
      formErrors.value = newErrors;
      // Force refresh of the reactive variable
      formErrors.refresh();
    }

    return formErrors.isEmpty;
  }

  // Helper method to get inputs for any step dynamically
  List<RegisterInput>? _getStepInputs(ProfileFormPage profileForm, int stepIndex) {
    if (profileForm.inputs == null) return null;
    
    // Use the dynamic method from the model
    return profileForm.inputs!.getStepInputs(stepIndex);
  }

  // Helper method to get current step title
  String? _getCurrentStepTitle(ProfileFormPage profileForm, int stepIndex) {
    if (profileForm.stepTitles == null || stepIndex >= profileForm.stepTitles!.length) {
      return null;
    }
    return profileForm.stepTitles![stepIndex];
  }

  // Helper method to check if current step is address step based on step_titles
  bool _isAddressStep(String? stepTitle) {
    if (stepTitle == null) return false;
    return stepTitle.toLowerCase().contains('address');
  }

  Future<void> submitForm(BuildContext context) async {
    if (!_validateCurrentStep()) {
      // Force UI update to show errors immediately
      formErrors.refresh();
      update(['form_content']);
      Utils.showSnackbar(isSuccess: false, title: 'Validation Error', message: "Please fix the errors before submitting");

      return;
    }

    isLoading.value = true;
    
    try {
      // Get API endpoint from app settings
      final appController = Get.find<AppSettingsController>();
      final profileForm = appController.profileFormPage.value;
      final submitUrl = profileForm?.apiEndpoints?.submitForm ?? apiUrl;
      // Submit only current step data with step_no formatting like nextStep
      final success = await _callStepApi(submitUrl, currentStep.value);
      if (success) {
        Utils.showSnackbar(isSuccess: true, title: 'Success', message: 'Profile updated successfully');

        profilecontroller.fetchProfileDetails();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationScreen(),));

      }
    } catch (e) {
      Utils.showSnackbar(isSuccess: false, title: 'Error', message:'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> _submitFormData(
    String url,
    Map<String, dynamic> data,
    Map<String, File> files,
  ) async {
    final request = http.MultipartRequest('POST', Uri.parse(url));

    // Auth header
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token != null && token.isNotEmpty) {
        request.headers.addAll({
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        });
      } else {
        print('Submit API: auth token not found in SharedPreferences');
      }
    } catch (e) {
      print('Submit API: error reading token: $e');
    }

    // Add form fields
    request.fields.addAll(data.map((key, value) => MapEntry(key, value.toString())));

    // Debug: Print submit request body
    try {
      print('Submit API Request URL: $url');
      print('Submit API Request Fields: ${jsonEncode(request.fields)}');
      if (files.isNotEmpty) {
        print('Submit API Files: ${files.keys.toList()}');
      }
    } catch (_) {}

    // Add files
    for (final entry in files.entries) {
      request.files.add(await http.MultipartFile.fromPath(entry.key, entry.value.path));
    }

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    try {
      print('Submit API Status: ${response.statusCode}');
      print('Submit API Response: $responseBody');
    } catch (_) {}

    return json.decode(responseBody);
  }

  // Toggle user type
  void toggleUserType(int index) {
    for (int i = 0; i < isSelected.length; i++) {
      isSelected[i] = i == index;
    }
    userType.value = index == 0 ? "Individual" : "Organisation";
  }

  // Image picking methods
  Future<bool> requestStoragePermission({bool isCamera = false}) async {
    if (Platform.isAndroid) {
      if (isCamera) {
        final cameraStatus = await Permission.camera.status;
        if (!cameraStatus.isGranted) {
          final status = await Permission.camera.request();
          if (!status.isGranted) {
            Utils.showSnackbar(isSuccess: false, title: 'Permission Required', message: 'Camera permission is required for taking photos');

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
      Utils.showSnackbar(isSuccess: false, title: 'Permission Required', message: 'Storage or media permissions are required to pick images');
      return false;
    }
    return true;
  }

  Future<void> pickImage(ImageSource source, Rx<File?> imageField) async {
    try {
      if (!await requestStoragePermission(isCamera: source == ImageSource.camera)) return;

      final XFile? file = await _picker.pickImage(source: source);
      if (file != null) {
        imageField.value = File(file.path);
      }
    } catch (e) {
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Error picking image: $e');

    }
  }

  // Address management
  void addAddress(Map<String, dynamic> address) {
    addresses.add(address);
  }

  void updateAddress(int index, Map<String, dynamic> address) {
    addresses[index] = address;
  }

  void removeAddress(int index) {
    if (index == defaultAddressIndex.value) {
      defaultAddressIndex.value = -1;
    } else if (index < defaultAddressIndex.value) {
      defaultAddressIndex.value--;
    }
    addresses.removeAt(index);
  }

  // Bank account management
  void addBankAccount(Map<String, String?> bankAccount) {
    bankAccounts.add(bankAccount);
  }

  void updateBankAccount(int index, Map<String, String?> bankAccount) {
    bankAccounts[index] = bankAccount;
  }

  void removeBankAccount(int index) {
    if (index == primaryBankIndex.value) {
      primaryBankIndex.value = -1;
    } else if (index < primaryBankIndex.value) {
      primaryBankIndex.value--;
    }
    bankAccounts.removeAt(index);
  }

  // Generic multi-entry management
  List<Map<String, dynamic>> getEntriesForStep(int stepIndex) {
    return multiStepEntries[stepIndex] ?? <Map<String, dynamic>>[];
  }

  void addEntryForStep(int stepIndex, Map<String, dynamic> data) {
    final list = List<Map<String, dynamic>>.from(getEntriesForStep(stepIndex));
    list.add(data);
    multiStepEntries[stepIndex] = list;
    multiStepEntries.refresh();
  }

  void updateEntryForStep(int stepIndex, int index, Map<String, dynamic> data) {
    final list = List<Map<String, dynamic>>.from(getEntriesForStep(stepIndex));
    if (index >= 0 && index < list.length) {
      list[index] = data;
      multiStepEntries[stepIndex] = list;
      multiStepEntries.refresh();
    }
  }

  void removeEntryForStep(int stepIndex, int index) {
    final list = List<Map<String, dynamic>>.from(getEntriesForStep(stepIndex));
    if (index >= 0 && index < list.length) {
      list.removeAt(index);
      multiStepEntries[stepIndex] = list;
      multiStepEntries.refresh();
    }
  }

  // API Methods
  Future<void> _fetchProfileData() async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Authentication token not found');

        return;
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);
        if (decodedResponse['response_code'] == 200 && decodedResponse['success'] == true) {
          _updateProfileFromResponse(decodedResponse['result'] ?? {});
        }
      }
    } catch (e) {
      Utils.showSnackbar(isSuccess: false, title: 'Error', message:'Failed to fetch profile: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateProfileFromResponse(Map<String, dynamic> result) {
    // Update basic info
    nameController.text = result['name']?.toString() ?? '';
    userNameController.text = result['username']?.toString() ?? '';
    emailController.text = result['email']?.toString() ?? '';
    mobileController.text = result['mobile']?.toString() ?? '';

    // Update user type
    final type = result['user_type']?.toString() ?? 'Individual';
    userType.value = type;
    toggleUserType(type == "Individual" ? 0 : 1);

    // Update addresses
    addresses.assignAll(List<Map<String, dynamic>>.from(
        (result['addresses'] ?? []).map((addr) => {
          'address_key': addr['address_key']?.toString() ?? '',
          'address_type': addr['address_type']?.toString() ?? '',
          'address': addr['full_address']?.toString() ?? '',
          'landmark': addr['landmark']?.toString() ?? '',
          'latitude': addr['latitude']?.toString() ?? '',
          'longitude': addr['longitude']?.toString() ?? '',
          'default_address': addr['is_default'] == 1 ? '1' : '0',
          'place_id': addr['place_id']?.toString() ?? '',
        })
    ));

    // Update bank accounts
    bankAccounts.assignAll(List<Map<String, String?>>.from(
        (result['bank_accounts'] ?? []).map((bank) => {
          'account_key': bank['account_key']?.toString() ?? '',
          'beneficiary_name': bank['beneficiary_name']?.toString() ?? '',
          'account_number': bank['account_number']?.toString() ?? '',
          'ifsc_code': bank['ifsc_code']?.toString() ?? '',
          'upi_address': bank['upi_address']?.toString() ?? '',
          'primary_bank': bank['is_primary']?.toString() ?? '0',
        })
    ));
  }

  Future<bool> submitProfile({bool isPartial = false}) async {
    isLoading.value = true;

    try {
      // Your existing submit logic here
      // Convert to use GetX observables

      await Future.delayed(const Duration(seconds: 2)); // Mock API call
      Utils.showSnackbar(isSuccess: true, title: "Success", message: 'Profile updated successfully');

      return true;
    } catch (e) {
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to submit profile: $e');

      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation
  void nextPage() {
    if (currentIndexPage.value < 3) {
      pageController.value.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentIndexPage.value > 0) {
      pageController.value.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }




}