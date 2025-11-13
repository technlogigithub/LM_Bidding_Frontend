import 'dart:io';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../app_main/App_main_controller.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../core/app_constant.dart';
import '../../widget/form_widgets/dynamic_form_builder.dart';

class PostFormController extends GetxController {
  static PostFormController get to => Get.find();

  // Dynamic Form State
  final currentStep = 0.obs;
  final formData = <String, dynamic>{}.obs;
  final formErrors = <String, String>{}.obs;

  // Button visibility states
  final showPreviousButton = true.obs;
  final showNextButton = true.obs;
  final showSubmitButton = false.obs;

  // Loading State
  final isLoading = false.obs;

  // Generic multi-entry storage per step (keyed by 0-based step index)
  final multiStepEntries = <int, List<Map<String, dynamic>>>{}.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeDefaultValues();
    _updateButtonVisibility(); // Initialize button visibility
  }

  void _initializeDefaultValues() {
    // Get form configuration from app settings
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormPage.value;
    
    if (postForm != null && postForm.inputs != null) {
      // Initialize defaults for all available steps dynamically
      List<int> availableSteps = postForm.inputs!.getAvailableSteps();
      for (int stepIndex in availableSteps) {
        List<RegisterInput>? stepInputs = postForm.inputs!.getStepInputs(stepIndex);
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
            if (input.optionItems != null && input.optionItems!.isNotEmpty) {
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
          case 'number':
          case 'datetime':
          default:
            formData[fieldName] = '';
            break;
        }
      }
    }
  }

  // Update button visibility based on API response
  void _updateButtonVisibility() {
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormPage.value;
    final buttons = postForm?.buttons;
    
    if (buttons == null) {
      // Default behavior if no button configuration
      showPreviousButton.value = currentStep.value > 0;
      showNextButton.value = currentStep.value < (postForm?.totalSteps ?? 26) - 1;
      showSubmitButton.value = currentStep.value == (postForm?.totalSteps ?? 26) - 1;
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

  Future<void> nextStep1() async {
    print('Next step called. Current step: ${currentStep.value}');
    
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
      
      isLoading.value = true;
      try {
        final success = await _callStepApi(apiEndpoint, currentStep.value);
        if (!success) {
          isLoading.value = false;
          return; // Don't proceed if API call failed
        }
      } catch (e) {
        isLoading.value = false;
        Get.snackbar('Error', 'Failed to save step data: $e');
        return;
      }
      isLoading.value = false;
    }
    
    // Get total steps from API configuration
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormPage.value;
    final totalSteps = postForm?.totalSteps ?? 26;
    print('Total steps: $totalSteps');
    
    if (currentStep.value < totalSteps - 1) {
      currentStep.value++;
      print('Moved to step: ${currentStep.value}');
      
      // Update button visibility after step change
      _updateButtonVisibility();
    }
  }

  /// Below Is Static Next Button API Not Calling
  Future<void> nextStep() async {
    print('Next step called. Current step: ${currentStep.value}');
    // Get total steps from API configuration
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormPage.value;
    final totalSteps = postForm?.totalSteps ?? 26;
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

  // Step-wise API endpoints
  String? _getStepApiEndpoint(int step) {
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormPage.value;
    
    if (postForm?.apiEndpoints == null) return null;
    
    // Use the dynamic method from the model
    String? endpoint = postForm!.apiEndpoints!.getStepEndpoint(step);
    
    // If endpoint is just a path (like "post/store"), add base URL
    if (endpoint != null && !endpoint.startsWith('http')) {
      // Use the proper base URL from AppConstants
      endpoint = '${AppConstants.baseUrl}$endpoint';
    }
    
    return endpoint;
  }




  // Call step-wise API
  Future<bool> _callStepApi(String endpoint, int step) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        Get.snackbar('Error', 'Authentication token not found');
        return false;
      }

      // Get current step inputs
      final currentStepInputs = getCurrentStepInputs(step);
      
      // Check if step has multiple input_type
      final hasMultipleInput = currentStepInputs?.any((e) => 
        (e.inputType ?? '').toLowerCase() == 'multiple') ?? false;

      // Prepare step-specific data
      final stepData = _prepareStepData(step);
      
      // Handle file uploads for this step
      final filesToUpload = <String, File>{};
      for (final entry in stepData.entries) {
        if (entry.value is File) {
          filesToUpload[entry.key] = entry.value as File;
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
        // Get the list of entries
        List<Map<String, dynamic>> entriesList = List<Map<String, dynamic>>.from(multiStepEntries[step] ?? []);

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
              fieldNames.add(fieldName);
            }
          }
        }

        // Format each entry as array fields: fieldName[0], fieldName[1], etc.
        for (int index = 0; index < entriesList.length; index++) {
          final entry = entriesList[index];
          
          // Add all field values with array notation
          for (final fieldName in fieldNames) {
            final value = entry[fieldName];
            if (value != null) {
              request.fields['$fieldName[$index]'] = value.toString();
            }
          }
        }
      } else {
        // For non-multiple steps, add form fields normally
        request.fields.addAll(stepData.map((key, value) => MapEntry(key, value.toString())));
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

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      print('Step ${step + 1} API Status: ${response.statusCode}');
      print('Step ${step + 1} API Response: $decodedResponse');

      if (response.statusCode == 200 && decodedResponse['success'] == true) {
        Get.snackbar('Success', 'Step ${step + 1} data saved successfully');
        return true;
      } else {
        Get.snackbar('Error', decodedResponse['message'] ?? 'Failed to save step data');
        return false;
      }
    } catch (e) {
      print('Step API Error: $e');
      Get.snackbar('Error', 'Failed to save step data: $e');
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
        stepData[fieldName] = formData[fieldName];
      }
    }

    return stepData;
  }

  List<RegisterInput>? getCurrentStepInputs(int stepIndex) {
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormPage.value;
    
    if (postForm == null) return null;

    return _getStepInputs(postForm, stepIndex);
  }

  bool _validateCurrentStep() {
    print('Validating step: ${currentStep.value}');
    // Clear previous errors
    formErrors.clear();
    
    // Get current step inputs from app settings
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormPage.value;
    
    if (postForm == null) return true;

    // Get current step inputs dynamically
    List<RegisterInput>? currentStepInputs = _getStepInputs(postForm, currentStep.value);

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
          Get.snackbar('Validation Error', 'Please add at least one item before proceeding');
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
  List<RegisterInput>? _getStepInputs(ProfileFormPage postForm, int stepIndex) {
    if (postForm.inputs == null) return null;
    
    // Use the dynamic method from the model
    return postForm.inputs!.getStepInputs(stepIndex);
  }

  Future<void> submitForm() async {
    if (!_validateCurrentStep()) {
      // Force UI update to show errors immediately
      formErrors.refresh();
      update(['form_content']);
      Get.snackbar('Validation Error', 'Please fix the errors before submitting');
      return;
    }

    isLoading.value = true;
    
    try {
      // Get API endpoint from app settings
      final appController = Get.find<AppSettingsController>();
      final postForm = appController.postFormPage.value;
      final submitUrl = postForm?.apiEndpoints?.submitForm ?? '${AppConstants.baseUrl}post/store';
      // Submit only current step data with step_no formatting like nextStep
      final success = await _callStepApi(submitUrl, currentStep.value);
      if (success) {
        Get.snackbar('Success', 'Post created successfully');
        Get.back();
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    } finally {
      isLoading.value = false;
    }
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
}

