import 'package:flutter/foundation.dart';
import '../../widget/form_widgets/web_file_drop_zone_stub.dart'
    if (dart.library.html) '../../widget/form_widgets/web_file_drop_zone_web.dart' as web_drop;
import 'dart:io';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../../core/utils.dart';
import '../../view/Bottom_navigation_screen/Botom_navigation_screen.dart';
import '../../view/Home_screen/home_screen.dart';
import '../../view/profile_screens/My Posts/my_post_screen.dart';
import '../../view/profile_screens/my_profile_screen.dart';
import '../../view/profile_screens/setting_screen.dart';
import '../app_main/App_main_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Post/Post_Form_Genrate_Model.dart' as PostModel;
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
  final Postkey = ''.obs;

  // Loading State
  final isLoading = false.obs; // For step-wise API calls (next/previous)
  final isLoadingForm = false.obs; // For initial form loading (getPostForm)
  bool _formLoaded = false; // Track if form was loaded at least once
  bool _isUserInteracting =
      false; // Track if user is actively interacting (uploading files, etc.)

  // Public method to set interaction flag (used by file pickers)
  void setUserInteracting(bool value) {
    _isUserInteracting = value;
  }

  // Generic multi-entry storage per step (keyed by 0-based step index)
  final multiStepEntries = <int, List<Map<String, dynamic>>>{}.obs;

  // PageController for PageView navigation
  PageController? pageController;
  bool _isPageChanging = false; // Prevent multiple simultaneous API calls
  bool _isButtonNavigation =
      false; // Track if navigation is from button (no API call)

  // Session State
  String? _currentApiEndpoint; // Persist endpoint for refreshes
  bool _isExplicitEdit = false; // Track if we are in an explicit edit session

  // Reset session state (call this when leaving form flow)
  void resetSession() {
    print('🔄 Resetting Post Form Session');
    _currentApiEndpoint = null;
    _isExplicitEdit = false;
    formData.clear();
    formErrors.clear();
    multiStepEntries.clear();
    Postkey.value = '';
    currentStep.value = 0;
    _formLoaded = false;
  }

  @override
  void onInit() {
    super.onInit();
    // Initialize PageController
    pageController = PageController(initialPage: 0);
    // Load form - initial load uses defaults unless set prior
    getPostForm();
  }

  @override
  void onClose() {
    pageController?.dispose();
    super.onClose();
  }

  // Populate formData with existing values from API response
  void _populateFormDataFromApi() {
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;

    if (postForm == null || postForm.inputs == null) return;

    // Get all available steps
    List<int> availableSteps = postForm.inputs!.getAvailableSteps();

    for (int stepIndex in availableSteps) {
      List<PostModel.StepInput>? stepInputs = postForm.inputs!.getStepInputs(
        stepIndex,
      );

      if (stepInputs == null) continue;

      // Populate formData with values from API
      for (final stepInput in stepInputs) {
        final fieldName = stepInput.name ?? '';
        final fieldType = (stepInput.inputType ?? '').toLowerCase();
        final value = stepInput.value;

        // Skip special marker fields
        if (fieldName.toLowerCase() == 'step_type' ||
            fieldType == 'single' ||
            fieldType == 'multiple' ||
            fieldType == 'group') {
          continue;
        }

        // IMPORTANT: Preserve user-uploaded File objects - don't overwrite with API values
        // If formData already has a File or List<File> for this field, keep it
        if ((fieldType == 'file' || fieldType == 'files') &&
            formData.containsKey(fieldName)) {
          final existingValue = formData[fieldName];
          // If user has uploaded files (File or List<File>), preserve them
          if (existingValue is File ||
              (existingValue is List &&
                  existingValue.isNotEmpty &&
                  existingValue.first is File)) {
            print(
              '📸 Preserving user-uploaded files for "$fieldName", skipping API value',
            );
            continue; // Skip overwriting with API value
          }
        }

        // Only set value if it's not null and not empty
        if (value != null) {
          // Handle different value types based on input type
          if (fieldType == 'checkbox') {
            // Checkbox can be single boolean or multi-select list
            if (value is List) {
              // Already a list, store as-is
              if (value.isNotEmpty) {
                formData[fieldName] = value;
              }
            } else if (value is String) {
              final trimmedValue = value.trim();
              if (trimmedValue.isNotEmpty) {
                // Check if it's a string representation of a list like "[used, new]"
                if (trimmedValue.startsWith('[') &&
                    trimmedValue.endsWith(']')) {
                  try {
                    // Try to parse as JSON array
                    final parsed = jsonDecode(trimmedValue) as List;
                    formData[fieldName] = parsed
                        .map((e) => e.toString())
                        .toList();
                  } catch (e) {
                    // If JSON parsing fails, try manual parsing
                    final cleaned = trimmedValue
                        .replaceAll('[', '')
                        .replaceAll(']', '')
                        .replaceAll('"', '')
                        .replaceAll("'", '');
                    final items = cleaned
                        .split(',')
                        .map((e) => e.trim())
                        .where((e) => e.isNotEmpty)
                        .toList();
                    if (items.isNotEmpty) {
                      formData[fieldName] = items;
                    }
                  }
                } else {
                  // Single checkbox value (boolean string)
                  final boolValue =
                      trimmedValue.toLowerCase() == 'true' ||
                      trimmedValue == '1' ||
                      trimmedValue.toLowerCase() == 'yes';
                  formData[fieldName] = boolValue;
                }
              }
            } else if (value is bool) {
              formData[fieldName] = value;
            } else if (value is num) {
              formData[fieldName] = value != 0;
            }
          } else if (value is String) {
            final trimmedValue = value.trim();
            if (trimmedValue.isNotEmpty) {
              formData[fieldName] = trimmedValue;
            }
          } else if (value is bool) {
            formData[fieldName] = value;
          } else if (value is num) {
            formData[fieldName] = value.toString();
          } else if (value is List) {
            // For lists (e.g., files), store as-is
            if (value.isNotEmpty) {
              // Check if it's a list of file objects with url property
              if (fieldType == 'files' || fieldType == 'file') {
                // Convert to List<dynamic> to ensure proper type handling
                final listValue = List<dynamic>.from(value);
                print(
                  '📸 Storing files list for "$fieldName": ${listValue.length} items',
                );
                print('📸 First item type: ${listValue.first.runtimeType}');
                print('📸 First item: ${listValue.first}');
                if (listValue.first is Map) {
                  print(
                    '📸 First item keys: ${(listValue.first as Map).keys.toList()}',
                  );
                  print(
                    '📸 First item url: ${(listValue.first as Map)['url']}',
                  );
                }
                formData[fieldName] = listValue;
                print(
                  '📸 Stored in formData["$fieldName"]: ${formData[fieldName]}',
                );
                print(
                  '📸 Stored value type: ${formData[fieldName].runtimeType}',
                );
              } else {
                // For other list types, store as-is
                formData[fieldName] = value;
              }
            }
          } else if (value is Map) {
            // For complex objects, convert to JSON string
            try {
              formData[fieldName] = jsonEncode(value);
            } catch (e) {
              formData[fieldName] = value.toString();
            }
          } else {
            // For other types, convert to string
            final stringValue = value.toString();
            if (stringValue.isNotEmpty && stringValue != 'null') {
              formData[fieldName] = stringValue;
            }
          }
        }
      }
    }

    // Refresh formData to trigger UI update
    formData.refresh();

    print('FormData populated from API: ${formData.keys.toList()}');
    print(
      'FormData values: ${formData.entries.map((e) => '${e.key}: ${e.value}').join(', ')}',
    );
  }

  // Find first step with null value and set it as initial step
  void _setInitialStepFromApi() {
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;

    if (postForm == null || postForm.inputs == null) {
      currentStep.value = 0;
      return;
    }

    // Get all available steps (sorted)
    List<int> availableSteps = postForm.inputs!.getAvailableSteps();
    availableSteps.sort();

    // Find first step with at least one null value
    int? firstIncompleteStep;

    // Check explicit edit session first
    if (_isExplicitEdit) {
      print('✏️ Explicit Edit Session: Starting from Step 1');
      currentStep.value = 0;
      return;
    }

    // Only search for incomplete step if NOT in edit mode
    // In edit mode, we want to start from the beginning (Step 1)
    for (int stepIndex in availableSteps) {
      List<PostModel.StepInput>? stepInputs = postForm.inputs!.getStepInputs(
        stepIndex,
      );

      if (stepInputs == null || stepInputs.isEmpty) {
        // If step has no inputs, consider it incomplete
        firstIncompleteStep = stepIndex;
        break;
      }

      // Check if any input in this step has null value
      bool hasNullValue = false;
      bool hasVisibleField = false;

      for (final stepInput in stepInputs) {
        final fieldName = stepInput.name ?? '';
        final fieldType = (stepInput.inputType ?? '').toLowerCase();
        final value = stepInput.value;

        // Skip special marker fields
        if (fieldName.toLowerCase() == 'step_type' ||
            fieldType == 'single' ||
            fieldType == 'multiple' ||
            fieldType == 'group') {
          continue;
        }

        // Count visible fields (excluding hidden)
        if (fieldType != 'hidden') {
          hasVisibleField = true;
        }

        // Check if value is null or empty (only for visible REQUIRED fields)
        if (fieldType != 'hidden' && stepInput.required == true) {
          if (value == null ||
              (value is String && value.trim().isEmpty) ||
              (value is List && value.isEmpty)) {
            hasNullValue = true;
            break;
          }
        }
      }

      // If step has visible fields and at least one REQUIRED field is null, this is incomplete
      if (hasVisibleField && hasNullValue) {
        firstIncompleteStep = stepIndex;
        break;
      }
    }

    // Set initial step (default to 0 if all steps are complete)
    final initialStep = firstIncompleteStep ?? 0;
    currentStep.value = initialStep;

    // Update PageController after a frame to ensure it's built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (pageController != null && pageController!.hasClients) {
        try {
          final positions = pageController!.positions;
          if (positions.length == 1) {
            final currentPage = pageController!.page?.round() ?? 0;
            if (currentPage != initialStep) {
              pageController!.jumpToPage(initialStep);
            }
          }
        } catch (e) {
          print('Warning: Error updating PageController: $e');
        }
      }
    });

    print('Initial step set to: ${initialStep + 1} (0-based: $initialStep)');
  }

  void _initializeDefaultValues() {
    // Get form configuration from app settings
    final appController = Get.find<AppSettingsController>();

    // Use postFormFromApi if available, otherwise fallback to postFormPage
    final postForm = appController.postFormFromApi.value;
    final fallbackForm = appController.postFormPage.value;

    if (postForm != null && postForm.inputs != null) {
      // Initialize defaults for all available steps dynamically
      List<int> availableSteps = postForm.inputs!.getAvailableSteps();
      for (int stepIndex in availableSteps) {
        List<PostModel.StepInput>? stepInputs = postForm.inputs!.getStepInputs(
          stepIndex,
        );
        if (stepInputs != null) {
          // Convert StepInput to RegisterInput
          List<RegisterInput> registerInputs = stepInputs
              .map((si) => convertStepInputToRegisterInput(si))
              .toList();
          _setDefaultsForStep(registerInputs);
        }
      }
    } else if (fallbackForm != null && fallbackForm.inputs != null) {
      // Fallback to postFormPage if postFormFromApi is not available
      List<int> availableSteps = fallbackForm.inputs!.getAvailableSteps();
      for (int stepIndex in availableSteps) {
        List<RegisterInput>? stepInputs = fallbackForm.inputs!.getStepInputs(
          stepIndex,
        );
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
      // Only set if field doesn't exist or has empty/null value
      if (!formData.containsKey(fieldName) ||
          formData[fieldName] == null ||
          formData[fieldName].toString().isEmpty) {
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
    // Use postFormFromApi if available, otherwise fallback to postFormPage
    final postForm = appController.postFormFromApi.value;
    final fallbackForm = appController.postFormPage.value;
    final buttons = postForm?.buttons ?? fallbackForm?.buttons;

    final totalSteps = postForm?.totalSteps ?? fallbackForm?.totalSteps ?? 26;

    if (buttons == null) {
      // Default behavior if no button configuration
      showPreviousButton.value = currentStep.value > 0;
      showNextButton.value = currentStep.value < totalSteps - 1;
      showSubmitButton.value = currentStep.value == totalSteps - 1;
      return;
    }

    // Reset all buttons
    showPreviousButton.value = false;
    showNextButton.value = false;
    showSubmitButton.value = false;

    // Check each button configuration
    for (final button in buttons) {
      // Handle both Buttons (from PostForm) and ProfileFormButton (from ProfileFormPage)
      String? action;
      int? visibleFromStep;
      int? visibleUntilStep;
      int? visibleOnStep;

      if (button is PostModel.Buttons) {
        action = button.action?.toLowerCase();
        visibleFromStep = button.visibleFromStep;
        visibleUntilStep = button.visibleUntilStep;
        visibleOnStep = button.visibleOnStep;
      } else if (button is ProfileFormButton) {
        action = button.action?.toLowerCase();
        visibleFromStep = button.visibleFromStep;
        visibleUntilStep = button.visibleUntilStep;
        visibleOnStep = button.visibleOnStep;
      }

      final currentStepValue = currentStep.value + 1;

      switch (action) {
        case 'prev_step':
          if (visibleFromStep != null && currentStepValue >= visibleFromStep) {
            showPreviousButton.value = true;
          }
          break;
        case 'next_step':
          if (visibleUntilStep != null &&
              currentStepValue <= visibleUntilStep) {
            showNextButton.value = true;
          }
          break;
        case 'submit_form':
          if (visibleOnStep != null && currentStepValue == visibleOnStep) {
            showSubmitButton.value = true;
          }
          break;
      }
    }
  }

  // Dynamic Form Methods
  void updateFormData(String fieldName, dynamic value) {
    // Mark as user interacting when updating form data (especially file uploads)
    if (value is File ||
        (value is List && value.isNotEmpty && value.first is File)) {
      _isUserInteracting = true;
      // Reset interaction flag after delay to allow refresh on navigation back
      Future.delayed(const Duration(seconds: 3), () {
        _isUserInteracting = false;
      });
    }

    formData[fieldName] = value;
    // Clear error for this field when user starts typing
    if (formErrors.containsKey(fieldName)) {
      formErrors.remove(fieldName);
      formErrors.refresh();
    }
    // Don't trigger update here to avoid PageView rebuild issues
    // The form will update automatically through reactive variables
  }

  Future<void> nextStep1() async {
    print('Next step called. Current step: ${currentStep.value}');

    // Always validate and show errors immediately
    final isValid = _validateCurrentStep();
    print('Validation result: $isValid');

    if (!isValid) {
      // Force UI update to show errors immediately
      formErrors.refresh();
      // Don't trigger update to avoid PageView rebuild issues
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
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Error',
          message: 'Failed to save step data: $e',
        );
        return;
      }
      isLoading.value = false;
    }

    // Get total steps from API configuration
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;
    final fallbackForm = appController.postFormPage.value;
    final totalSteps = postForm?.totalSteps ?? fallbackForm?.totalSteps ?? 26;
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
    print('Next step (button) called. Current step: ${currentStep.value}');

    // 1) Validate current step before moving ahead
    final isValid = _validateCurrentStep();
    print('Validation result (button next): $isValid');

    if (!isValid) {
      // Force UI update to show errors immediately
      formErrors.refresh();
      // Don't trigger update to avoid PageView rebuild issues
      return;
    }

    // 2) Call step-wise API for this step (same as swipe/nextStep1)

    final apiEndpoint = _getStepApiEndpoint(currentStep.value);
    if (apiEndpoint != null) {
      print(
        'Calling API (button next) for step ${currentStep.value + 1}: $apiEndpoint',
      );

      isLoading.value = true;
      try {
        final success = await _callStepApi(apiEndpoint, currentStep.value);
        if (!success) {
          isLoading.value = false;
          return; // Don't proceed if API call failed
        }
      } catch (e) {
        isLoading.value = false;
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Error',
          message: 'Failed to save step data: $e',
        );
        return;
      }
      isLoading.value = false;
    }

    // 3) After successful API call, actually move to next step using PageView
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;
    final fallbackForm = appController.postFormPage.value;
    final totalSteps = postForm?.totalSteps ?? fallbackForm?.totalSteps ?? 26;
    print('Total steps (button next): $totalSteps');

    if (currentStep.value < totalSteps - 1 && pageController != null) {
      // Mark as button navigation so onPageChanged me dobara API na लगे
      _isButtonNavigation = true;
      pageController!.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousStep() {
    if (currentStep.value > 0 && pageController != null) {
      // Mark as button navigation (no API call)
      _isButtonNavigation = true;
      // Use PageController to navigate
      pageController!.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  // Handle page change from PageView (swipe gesture or button)
  Future<void> onPageChanged(int newPage, int? previousPage) async {
    if (_isPageChanging) return; // Prevent multiple simultaneous calls

    final isSwipeNavigation =
        !_isButtonNavigation; // API call only on swipe, not button

    // If going forward (swiping right/next) and it's a swipe gesture
    if (previousPage != null && newPage > previousPage && isSwipeNavigation) {
      // Validate previous step before moving forward
      final isValid = _validateCurrentStep();
      if (!isValid) {
        // Revert to previous page if validation fails
        if (pageController != null && pageController!.hasClients) {
          pageController!.jumpToPage(previousPage);
        }
        formErrors.refresh();
        // Don't trigger update to avoid PageView rebuild issues
        return;
      }

      // Call API for the previous step (the one we're leaving)
      _isPageChanging = true;
      final apiEndpoint = _getStepApiEndpoint(previousPage);
      if (apiEndpoint != null) {
        print(
          'Calling API for step ${previousPage + 1} (swipe forward): $apiEndpoint',
        );
        isLoading.value = true;
        try {
          final success = await _callStepApi(apiEndpoint, previousPage);
          if (!success) {
            isLoading.value = false;
            _isPageChanging = false;
            // Revert to previous page if API call failed
            if (pageController != null && pageController!.hasClients) {
              pageController!.jumpToPage(previousPage);
            }
            _isButtonNavigation = false; // Reset flag
            return;
          }
        } catch (e) {
          isLoading.value = false;
          _isPageChanging = false;
          Utils.showSnackbar(
            isSuccess: false,
            title: 'Error',
            message: 'Failed to save step data: $e',
          );
          // Revert to previous page if API call failed
          if (pageController != null && pageController!.hasClients) {
            pageController!.jumpToPage(previousPage);
          }
          _isButtonNavigation = false; // Reset flag
          return;
        }
        isLoading.value = false;
      }
      _isPageChanging = false;
    }
    // If going backward (swiping left/previous) or button navigation, no API call needed

    // Reset button navigation flag
    _isButtonNavigation = false;

    // Update current step
    currentStep.value = newPage;
    _updateButtonVisibility();
    // Don't trigger update to avoid PageView rebuild issues
  }

  // Step-wise API endpoints
  String? _getStepApiEndpoint(int step) {
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;
    final fallbackForm = appController.postFormPage.value;

    // Try postFormFromApi first, then fallback to postFormPage
    if (postForm?.apiEndpoints != null) {
      String? endpoint = postForm!.apiEndpoints!.getStepEndpoint(step);
      if (endpoint != null && !endpoint.startsWith('http')) {
        endpoint = '${AppConstants.baseUrl}$endpoint';
      }
      return endpoint;
    }

    if (fallbackForm?.apiEndpoints == null) return null;

    // Use the dynamic method from the model
    String? endpoint = fallbackForm!.apiEndpoints!.getStepEndpoint(step);

    // If endpoint is just a path (like "post/store"), add base URL
    if (endpoint != null && !endpoint.startsWith('http')) {
      // Use the proper base URL from AppConstants
      endpoint = '${AppConstants.baseUrl}$endpoint';
    }

    return endpoint;
  }

  // Helper method to map inputType to API field type
  String _mapInputTypeToApiType(RegisterInput input) {
    final inputType = (input.inputType ?? '').toLowerCase();
    final fieldName = (input.name ?? '').toLowerCase();
    final label = (input.label ?? '').toLowerCase();

    // Check for video-specific fields
    if (inputType == 'files' || inputType == 'file') {
      if (fieldName.contains('video') || label.contains('video')) {
        return 'video';
      }
    }

    // Map input types to API types
    switch (inputType) {
      case 'number':
        return 'number';
      case 'date':
      case 'datetime':
      case 'daterange':
      case 'datetimerange':
        return 'date';
      case 'files':
        return 'files';
      case 'file':
        return 'file';
      case 'text':
      case 'email':
      case 'password':
      case 'textarea':
      case 'address':
      case 'select':
      case 'dropdown':
      case 'radio':
      case 'toggle':
      case 'checkbox':
      default:
        return 'string';
    }
  }

  // Build fields JSON from step inputs
  Map<String, dynamic> _buildFieldsJson(List<RegisterInput>? inputs) {
    final fields = <String, dynamic>{};

    if (inputs == null) return fields;

    for (final input in inputs) {
      final fieldName = input.name ?? '';
      final inputTypeLower = (input.inputType ?? '').toLowerCase();
      final lowerName = fieldName.toLowerCase();

      // Skip special marker fields
      if (lowerName == 'step_type' ||
          inputTypeLower == 'single' ||
          inputTypeLower == 'multiple' ||
          inputTypeLower == 'group' ||
          inputTypeLower == 'hidden') {
        continue;
      }

      // Map input type to API type
      final apiType = _mapInputTypeToApiType(input);
      fields[fieldName] = {'type': apiType};
    }

    return fields;
  }

  // Get first input name for title field
  String? _getFirstInputName(List<RegisterInput>? inputs) {
    if (inputs == null || inputs.isEmpty) return null;

    for (final input in inputs) {
      final fieldName = input.name ?? '';
      final inputTypeLower = (input.inputType ?? '').toLowerCase();
      final lowerName = fieldName.toLowerCase();

      // Skip special marker fields
      if (lowerName == 'step_type' ||
          inputTypeLower == 'single' ||
          inputTypeLower == 'multiple' ||
          inputTypeLower == 'group' ||
          inputTypeLower == 'hidden') {
        continue;
      }

      return fieldName;
    }

    return null;
  }

  // Call step-wise API
  Future<bool> _callStepApi(String endpoint, int step) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userKey = prefs.getString('ukey');

      if (token == null) {
        // Utils.showSnackbar(
        //   isSuccess: false,
        //   title: 'Error',
        //   message: 'Authentication token not found',
        // );

        return false;
      }

      if (userKey == null) {
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Error',
          message: 'User key not found',
        );

        return false;
      }

      // Get current step inputs
      final currentStepInputs = getCurrentStepInputs(step);

      // Check if step has multiple input_type
      final hasMultipleInput =
          currentStepInputs?.any(
            (e) => (e.inputType ?? '').toLowerCase() == 'multiple',
          ) ??
          false;

      // Prepare step-specific data
      final stepData = _prepareStepData(step);

      // Handle file uploads for this step
      final filesToUpload = <String, File>{};
      final multipleFilesToUpload = <String, List<File>>{};
      for (final entry in stepData.entries) {
        if (entry.value is File) {
          filesToUpload[entry.key] = entry.value as File;
        } else if (entry.value is List<File>) {
          multipleFilesToUpload[entry.key] = entry.value as List<File>;
        }
      }
      final appController = Get.find<AppSettingsController>();

      final postForm = appController.postFormPage.value;
      final postGenerate = appController.postFormFromApi.value;
      final postFormName = postGenerate?.pageName;
      final totalStep = postGenerate?.totalSteps;
      // final postKey = postGenerate?.postKey;

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(endpoint));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add static form fields as per new API format
      request.fields['form_name'] = postFormName ?? " ";
      request.fields['user_key'] = userKey;
      request.fields['post_key'] = Postkey.value;
      request.fields['total_steps'] = totalStep.toString();
      // request.fields['step_no'] =totalStep.toString();
      // request.fields['app_page_id'] = '10';

      // Build fields JSON from step inputs
      final fieldsJson = _buildFieldsJson(currentStepInputs);
      request.fields['fields'] = jsonEncode(fieldsJson);

      // Get first input name for title field
      final firstInputName = _getFirstInputName(currentStepInputs);
      if (firstInputName != null) {
        request.fields['title'] = firstInputName;
      }

      // Add dynamic step number (1-based)
      request.fields['step_no'] = (step + 1).toString();

      // If input_type is multiple, format data as arrays
      if (hasMultipleInput) {
        // Get the list of entries
        List<Map<String, dynamic>> entriesList =
            List<Map<String, dynamic>>.from(multiStepEntries[step] ?? []);

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

          // Add all field values with array notation (excluding File objects)
          for (final fieldName in fieldNames) {
            final value = entry[fieldName];
            if (value != null && value is! File && value is! List<File>) {
              request.fields['$fieldName[$index]'] = value.toString();
            }
          }
        }
      } else {
        // For non-multiple steps, add form fields normally (excluding File objects)
        for (final entry in stepData.entries) {
          if (entry.value is! File && entry.value is! List<File>) {
            request.fields[entry.key] = entry.value.toString();
          }
        }
      }

      // Debug: Print request details
      try {
        print('Step ${step + 1} API Request URL: $endpoint');
        print(
          'Step ${step + 1} API Request Fields: ${jsonEncode(request.fields)}',
        );
        if (filesToUpload.isNotEmpty) {
          print(
            'Step ${step + 1} API Single Files: ${filesToUpload.keys.toList()}',
          );
        }
        if (multipleFilesToUpload.isNotEmpty) {
          print(
            'Step ${step + 1} API Multiple Files: ${multipleFilesToUpload.keys.toList()}',
          );
        }
      } catch (_) {}

      // Add single files
      for (final entry in filesToUpload.entries) {
        if (kIsWeb) {
          final bytes = web_drop.getWebFileBytes(entry.value.path);
          if (bytes != null) {
            request.files.add(
              http.MultipartFile.fromBytes(
                entry.key,
                bytes,
                filename: entry.value.path.split('/').last.replaceFirst('web://', ''),
              ),
            );
          }
        } else {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value.path),
          );
        }
      }

      // Add multiple files (for files input type)
      for (final entry in multipleFilesToUpload.entries) {
        for (int i = 0; i < entry.value.length; i++) {
          final file = entry.value[i];
          if (kIsWeb) {
            final bytes = web_drop.getWebFileBytes(file.path);
            if (bytes != null) {
              request.files.add(
                http.MultipartFile.fromBytes(
                  '${entry.key}[$i]',
                  bytes,
                  filename: file.path.split('/').last.replaceFirst('web://', ''),
                ),
              );
            }
          } else {
            request.files.add(
              await http.MultipartFile.fromPath(
                '${entry.key}[$i]',
                file.path,
              ),
            );
          }
        }
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      print('Step ${step + 1} API Status: ${response.statusCode}');
      print('Step ${step + 1} API Response: $decodedResponse');

      if (response.statusCode == 200 && decodedResponse['success'] == true) {
        // ✅ Correct path: result -> post_key
        Postkey.value = decodedResponse['result']['post_key'].toString();

        print('Saved PostKey: ${Postkey.value}');

        Utils.showSnackbar(
          isSuccess: true,
          title: 'Success',
          message:
              decodedResponse['message'] ??
              'Step ${step + 1} data saved successfully',
        );

        return true;
      } else {
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Error',
          message: decodedResponse['message'] ?? 'Failed to save step data',
        );
        return false;
      }
    } catch (e) {
      print('Step API Error: $e');
      Utils.showSnackbar(
        isSuccess: false,
        title: 'Error',
        message: 'Failed to save step data: $e',
      );

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
      final lowerName = fieldName.toLowerCase();
      final inputTypeLower = (input.inputType ?? '').toLowerCase();

      // Skip special marker fields
      if (lowerName == 'step_type' ||
          inputTypeLower == 'single' ||
          inputTypeLower == 'multiple') {
        continue;
      }

      // Special handling: current_lat / current_long => always user ki current location
      if ((lowerName == 'current_lat' || lowerName == 'current_long') &&
          Get.isRegistered<ClientHomeController>()) {
        final home = ClientHomeController.to;
        final latLng = home.currentLatLng.value;
        if (lowerName == 'current_lat') {
          stepData[fieldName] = latLng.latitude.toString();
        } else {
          stepData[fieldName] = latLng.longitude.toString();
        }
        continue;
      }

      // Default: use formData value if present
      if (formData.containsKey(fieldName)) {
        stepData[fieldName] = formData[fieldName];
      }
    }

    return stepData;
  }

  List<RegisterInput>? getCurrentStepInputs(int stepIndex) {
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;
    final fallbackForm = appController.postFormPage.value;

    // Use postFormFromApi if available
    if (postForm != null && postForm.inputs != null) {
      List<PostModel.StepInput>? stepInputs = postForm.inputs!.getStepInputs(
        stepIndex,
      );
      if (stepInputs != null) {
        // Convert StepInput to RegisterInput
        return stepInputs
            .map((si) => convertStepInputToRegisterInput(si))
            .toList();
      }
    }

    // Fallback to postFormPage
    if (fallbackForm != null) {
      return _getStepInputs(fallbackForm, stepIndex);
    }

    return null;
  }

  bool _validateCurrentStep() {
    print('Validating step: ${currentStep.value}');
    // Clear previous errors
    formErrors.clear();

    // Get current step inputs from app settings
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;
    final fallbackForm = appController.postFormPage.value;

    List<RegisterInput>? currentStepInputs;

    // Use postFormFromApi if available
    if (postForm != null && postForm.inputs != null) {
      List<PostModel.StepInput>? stepInputs = postForm.inputs!.getStepInputs(
        currentStep.value,
      );
      if (stepInputs != null) {
        currentStepInputs = stepInputs
            .map((si) => convertStepInputToRegisterInput(si))
            .toList();
      }
    }

    if (currentStepInputs == null && fallbackForm != null) {
      // Fallback to postFormPage
      currentStepInputs = _getStepInputs(fallbackForm, currentStep.value);
    }

    if (currentStepInputs == null) return true;
    if (currentStepInputs.isEmpty) return true;

    // Filter out special marker fields from validation
    final inputsForValidation = currentStepInputs.where((input) {
      final fieldName = (input.name ?? '').toLowerCase();
      final t = (input.inputType ?? '').toLowerCase();
      return fieldName != 'step_type' && t != 'single' && t != 'multiple';
    }).toList();

    // If step is marked as multiple, ensure at least one entry is added
    final hasMultipleMarker = currentStepInputs.any(
      (e) => (e.inputType ?? '').toLowerCase() == 'multiple',
    );
    if (hasMultipleMarker) {
      final list = multiStepEntries[currentStep.value] ?? const [];
      if (list.isEmpty) {
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Validation Error',
          message: 'Please add at least one item before proceeding',
        );

        return false;
      }
      return true;
    }
    // Validate and update errors
    final newErrors = DynamicFormValidator.validateForm(
      inputsForValidation,
      formData,
    );
    formErrors.value = newErrors;
    // Force refresh of the reactive variable
    formErrors.refresh();

    return formErrors.isEmpty;
  }

  // Helper method to get inputs for any step dynamically
  List<RegisterInput>? _getStepInputs(ProfileFormPage postForm, int stepIndex) {
    if (postForm.inputs == null) return null;

    // Use the dynamic method from the model
    return postForm.inputs!.getStepInputs(stepIndex);
  }

  // Helper method to convert StepInput to RegisterInput (public for view access)
  RegisterInput convertStepInputToRegisterInput(PostModel.StepInput stepInput) {
    // Convert StepValidation to InputValidation
    List<InputValidation>? validations;
    if (stepInput.validations != null) {
      validations = stepInput.validations!.map((sv) {
        return InputValidation(
          type: sv.type,
          value: sv.value is int ? sv.value : null,
          stringValue: sv.stringValue ?? (sv.value?.toString()),
          pattern: sv.pattern,
          field: sv.field,
          errorMessage: sv.errorMessage,
          minLength: sv.minLength,
          maxLength: sv.maxLength,
          minLengthError: sv.minLengthError,
          maxLengthError: sv.maxLengthError,
          patternErrorMessage: sv.patternErrorMessage,
        );
      }).toList();
    }

    // Convert OptionItem to OptionItem (same structure, but ensure compatibility)
    List<OptionItem>? optionItems;
    if (stepInput.options != null) {
      optionItems = stepInput.options!.map((opt) {
        return OptionItem(label: opt.label, value: opt.value);
      }).toList();
    }

    return RegisterInput(
      inputType: stepInput.inputType,
      label: stepInput.label,
      placeholder: stepInput.placeholder,
      name: stepInput.name,
      required: stepInput.required,
      autoForward: stepInput.autoForward,
      enterEnable: stepInput.enterEnable,
      validations: validations,
      optionItems: optionItems,
      stepSetting: stepInput.stepSetting,
      value: stepInput.value,
    );
  }

  RxString apiMessage = ''.obs;

  Future<void> submitForm(BuildContext context) async {
    final appController = Get.find<AppSettingsController>();

    final postForm = appController.postFormPage.value;

    if (!_validateCurrentStep()) {
      formErrors.refresh();

      Utils.showSnackbar(
        isSuccess: false,
        title: 'Validation Error',
        message: 'Please fix the errors before submitting',
      );
      return;
    }

    isLoading.value = true;

    try {
      final appController = Get.find<AppSettingsController>();
      final fallbackForm = appController.postFormPage.value;

      final submitUrl =
          fallbackForm?.apiEndpoints?.submitForm ??
          '${AppConstants.baseUrl}post/store';

      final success = await _callStepApi(submitUrl, currentStep.value);

      if (success) {
        if (postForm != null && postForm.postKey != null) {
          postForm.postKey = '';
        }
        
        // Reset session state (preserve _isExplicitEdit for a moment to decide nav)
        bool wasEdit = _isExplicitEdit;
        resetSession();

        Utils.showSnackbar(
          isSuccess: true,
          title: 'Success',
          message: apiMessage.value.isNotEmpty
              ? apiMessage.value
              : 'Post saved successfully',
        );

        if (wasEdit) {
           // If editing, just go back to the previous screen (Post Details)
           Get.back(); // Close PostNewScreen
           // Ideally, previous screen should refresh. PostDetailScreen has onRefresh logic.
        } else {
           // If creating new, navigate to My Profiles
           Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MyPostScreen()),
          );
        }
      } else {
        // ✅ API Failed Message
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Failed',
          message: apiMessage.value.isNotEmpty
              ? apiMessage.value
              : 'Something went wrong',
        );
      }
    } catch (e) {
      Utils.showSnackbar(
        isSuccess: false,
        title: 'Error',
        message: apiMessage.value.isNotEmpty
            ? apiMessage.value
            : 'An error occurred: $e',
      );
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

  // Refresh form data when screen is revisited
  Future<void> refreshFormData({String? endpoint}) async {
    // Don't refresh if user is actively interacting (uploading files, etc.)
    if (_isUserInteracting) {
      print('🔄 Skipping refresh - user is actively interacting with form');
      return;
    }

    if (!_formLoaded) {
      // If form was never loaded, do full load
      await getPostForm(endpoint: endpoint);
      return;
    }

    // If form was already loaded, just refresh the data
    print('🔄 Refreshing form data...');

    // Reload form from API to get latest data
    await getPostForm(endpoint: endpoint);
  }

  // Fetch post form from API
  Future<void> getPostForm({String? endpoint, bool? isEditMode}) async {
    try {
      isLoadingForm.value = true; // Use separate loading state for form loading

      // Update Session State
      if (endpoint != null) {
        _currentApiEndpoint = endpoint;
      }
      if (isEditMode != null) {
        _isExplicitEdit = isEditMode;
      }

      final appController = Get.find<AppSettingsController>();
      final postForm = appController.postFormPage.value;

      final prefs = await SharedPreferences.getInstance();
      
      // ... (Rest of existing variable setup)
      final token = prefs.getString('auth_token');
      final userKey = prefs.getString('ukey');
      
      // Use stored key or API key
      if (postForm != null && postForm.postKey != null) {
        Postkey.value = postForm.postKey.toString();
      }
      
      final appPageKey = postForm?.pageName;
      final languageKey =
          prefs.getString('selected_language_key') ??
          appController.selectedLanguageKey.value;
          
      print('Post Key: ${Postkey.value}');
      // ... (Logging)

      if (token == null) {
        // Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Authentication token not found');
        isLoadingForm.value = false;
        return;
      }

      if (userKey == null) {
        Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'User key not found');
        isLoadingForm.value = false;
        return;
      }

      // Build API endpoint using persisted value or default
      final String apiEndpoint;
      final String targetEndpoint = _currentApiEndpoint ?? '${AppConstants.baseUrl}';
      
      if (targetEndpoint.startsWith('http')) {
         apiEndpoint = targetEndpoint;
      } else {
         apiEndpoint = '${AppConstants.baseUrl}$targetEndpoint';
      }

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse(apiEndpoint));

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add form fields
      request.fields['language_code'] = languageKey;
      request.fields['user_key'] = userKey;
      request.fields['app_page_key'] = appPageKey ?? "";
      
      // Important: Add edit_mode flag if explicitly editing
      // if (_isExplicitEdit) {
      //   request.fields['explicit_edit'] = 'true'; // If API supports it
      // }
      // The API seems to rely on the URL structure (containing the key) for edit mode.

      print('Get Post Form API Request URL: $apiEndpoint');
      print('Get Post Form API Request Fields: ${jsonEncode(request.fields)}');

      // Send request
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final decodedResponse = jsonDecode(responseBody);

      print('Get Post Form API Status: ${response.statusCode}');
      print('Get Post Form API Response: $decodedResponse');

      if (response.statusCode == 200) {
        // Parse response
        final postFormResponse =
            PostModel.PostFormGenrateResponseModel.fromJson(decodedResponse);

        if (postFormResponse.success == true &&
            postFormResponse.result?.postForm != null) {
          
          // Clear previous form data before populating new data
          formData.clear();
          formErrors.clear();
          multiStepEntries.clear();
          currentStep.value = 0;

          // Store in AppSettingsController
          final appController = Get.find<AppSettingsController>();
          appController.postFormFromApi.value =
              postFormResponse.result?.postForm;

          // Populate formData with existing values and find first incomplete step
          _populateFormDataFromApi();
          _setInitialStepFromApi();

          // Initialize form data and button visibility after form loads
          _initializeDefaultValues();
          _updateButtonVisibility();

          final postformGeneratePostKey = postFormResponse.result?.postForm;
          print(
            'Post Key for generate time : ${postformGeneratePostKey?.postKey}',
          );
          Postkey.value = postformGeneratePostKey!.postKey.toString();

          // Mark form as loaded
          _formLoaded = true;

          // Utils.showSnackbar(
          //   isSuccess: true,
          //   title: 'Success',
          //   message:
          //       postFormResponse.message ?? 'Post form loaded successfully',
          // );
        } else {
          Utils.showSnackbar(
            isSuccess: false,
            title: 'Error',
            message: postFormResponse.message ?? 'Failed to load post form',
          );

        }
      } else {
        Utils.showSnackbar(
          isSuccess: false,
          title: 'Error',
          message: decodedResponse['message'] ?? 'Failed to load post form',
        );
      }
    } catch (e) {
      print('Get Post Form API Error: $e');
      Utils.showSnackbar(
        isSuccess: false,
        title: 'Error',
        message: 'Failed to load post form: $e',
      );

    } finally {
      isLoadingForm.value = false;
    }
  }

}
