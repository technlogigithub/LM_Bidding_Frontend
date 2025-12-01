import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/profile/edit_profile_controller.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/home/home_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../core/app_string.dart';
import '../../core/utils.dart';
import '../../widget/form_widgets/dynamic_form_builder.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/form_widgets/reusable_location_picker.dart';
import '../../widget/form_widgets/custom_toggle.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import 'package:url_launcher/url_launcher.dart';

class DynamicProfileFormScreen extends GetView<SetupProfileController> {
  const DynamicProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appController = Get.find<AppSettingsController>();
    final profileForm = appController.profileFormPage.value;

    // final step1Inputs = profileForm?.inputs?.getStepInputs(0);
    //
    // step1Inputs?.forEach((input) {
    //   print("${input.name} : ${input.value}");
    // });







    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.appPagecolor,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            automaticallyImplyLeading: true,
            iconTheme:  IconThemeData(color: AppColors.appTextColor),
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: AppColors.appbarColor,
                // borderRadius: const BorderRadius.only(
                //   bottomLeft: Radius.circular(50.0),
                //   bottomRight: Radius.circular(50.0),
                // ),
              ),
            ),
            toolbarHeight: 80,
            centerTitle: true,
            title: Obx(() {
              final profileForm = appController.profileFormPage.value;
              return Text(
                profileForm?.pageTitle ?? 'Setup Profile',
                style:  AppTextStyle.title(
                  color: AppColors.appTextColor,
                  fontWeight: FontWeight.bold,

                ),
              );
            }),
          ),
          body: Obx(() {
        // final profileForm = appController.profileFormPage.value;

        if (profileForm == null) {
          return const Center(
            child: Text('Profile form configuration not available'),
          );
        }

        // Show shimmer when loading/prefilling data
        if (controller.isLoading.value) {
          return _buildShimmerLoading(screenHeight);
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Description
              if (profileForm.pageDescription?.isNotEmpty == true) ...[
                Text(
                  profileForm.pageDescription!,
                  style: AppTextStyle.description(
                    color: AppColors.appDescriptionColor,

                  ),
                ),
                const SizedBox(height: 20),
              ],

              // Progress Bar
              if (profileForm.progressBar == true) ...[
                _buildProgressBar(profileForm),
                const SizedBox(height: 20),
              ],

              // Form Content
              GetBuilder<SetupProfileController>(
                id: 'form_content',
                builder: (controller) => _buildFormContent(profileForm, screenHeight,context),
              ),
            ],
          ),
        );
      }),
        ),
      ),
    );
  }

  Widget _buildProgressBar(ProfileFormPage profileForm) {
    final currentStep = controller.currentStep.value;
    final totalSteps = profileForm.totalSteps ?? 3;

    return Column(
      children: [
        // Step Progress Indicator
        StepProgressIndicator(
          totalSteps: totalSteps,
          currentStep: currentStep + 1,
          selectedColor: AppColors.appColor,
          unselectedColor: AppColors.appMutedColor,
          size: 8,
          roundedEdges: const Radius.circular(4),
        ),
        const SizedBox(height: 12),

        // Step Title
        if (profileForm.stepTitles != null &&
            currentStep < profileForm.stepTitles!.length) ...[
          Text(
            profileForm.stepTitles![currentStep],
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.bold,

            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFormContent(ProfileFormPage profileForm, double screenHeight,BuildContext context) {
    final currentStep = controller.currentStep.value;
    List<RegisterInput>? currentStepInputs;

    // Dynamic step handling based on total_steps from backend
    final totalSteps = profileForm.totalSteps ?? 3;
    if (currentStep >= 0 && currentStep < totalSteps) {
      currentStepInputs = _getStepInputs(profileForm, currentStep);
    }

    if (currentStepInputs == null || currentStepInputs.isEmpty) {
      return const Center(
        child: Text('No form fields available for this step'),
      );
    }

    // Get current step title for conditional rendering
    final currentStepTitle = _getCurrentStepTitle(profileForm, currentStep);

    // Determine if step is marked as multiple/single by input marker
    final hasMultipleMarker = currentStepInputs.any((e) => (e.inputType ?? '').toLowerCase() == 'multiple');
    final filteredInputs = currentStepInputs.where((e) => (e.name ?? '').toLowerCase() != 'step_type').toList();

    return Column(
      children: [
        // If address step, keep legacy UI
          if(_isAddressStep(currentStepTitle))
          _buildAddressStep(filteredInputs, title: currentStepTitle)

        // Generic multiple step renderer for non-address, non-document steps
        else if (hasMultipleMarker)
          _buildGenericMultipleStep(currentStep, filteredInputs, title: currentStepTitle)

        // If generic single step, show dynamic form
        else
          DynamicFormBuilder(
            inputs: filteredInputs,
            formData: controller.formData,
            onFieldChanged: controller.updateFormData,
            errors: controller.formErrors,
          ),

        const SizedBox(height: 30),

        // Action Buttons
        _buildActionButtons(profileForm, screenHeight,context),
      ],
    );
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
    return stepTitle.toLowerCase().contains('address') || stepTitle.toLowerCase().contains("पता विवरण");
  }

  // Helper method to check if current step is document step based on step_titles
  bool _isDocumentStep(String? stepTitle) {
    if (stepTitle == null) return false;
    return stepTitle.toLowerCase().contains('document') ||
           stepTitle.toLowerCase().contains('verification');
  }

  // Filter out special marker inputs like step_type/single/multiple
  List<RegisterInput>? _filterMarkerInputs(List<RegisterInput>? inputs) {
    if (inputs == null) return null;
    return inputs.where((e) {
      final name = (e.name ?? '').toLowerCase();
      final t = (e.inputType ?? '').toLowerCase();
      return name != 'step_type' && t != 'single' && t != 'multiple';
    }).toList();
  }

  Widget _buildAddressStep(List<RegisterInput>? addressInputs, {String? title}) {
    final appController = Get.find<AppSettingsController>();
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title ?? '',
                    style: AppTextStyle.title(
                      color: AppColors.appBodyTextColor,
                      fontWeight: FontWeight.bold,
                            ),
                          ),
                  Obx(() {
                    final currentStep = controller.currentStep.value;
                    final profileForm = appController.profileFormPage.value;

                    if (profileForm != null) {
                      final inputs = controller.getCurrentStepInputs(currentStep) ?? [];

                      // ✔ Correct Condition: If any inputType == 'address'
                      final isAddress = inputs.any(
                            (e) => (e.inputType ?? '').toLowerCase() == 'address',
                      );

                      // ✔ Detect multi-entry step
                      final isMultiple = inputs.any(
                            (e) => (e.inputType ?? '').toLowerCase() == 'multiple',
                      );

                      if (isMultiple) {
                        return SizedBox(
                          height: 40.h,
                          child: FloatingActionButton.extended(
                            backgroundColor: AppColors.appButtonColor,
                            onPressed: () => isAddress
                                ? _showAddressDialog(_filterMarkerInputs(inputs))
                                : _showGenericEntryDialog(currentStep, inputs),
                            icon: Icon(
                              FeatherIcons.plusCircle,
                              color: AppColors.appButtonTextColor,
                              size: 20.0,
                            ),
                            label: Text(
                              (() {
                                final buttons = profileForm.buttons ?? [];
                                for (final b in buttons) {
                                  if ((b.visibleOnStep ?? -1) == 0) {
                                    return b.label ?? AppStrings.addNew;
                                  }
                                }
                                return AppStrings.addNew;
                              })(),
                              style: AppTextStyle.description(
                                color: AppColors.appButtonTextColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }
                    }

                    return const SizedBox.shrink();
                  })

                ],
              ),
        const SizedBox(height: 20),

        // Address List
        Obx(() => controller.addresses.isEmpty
            ? Text(
                AppStrings.noAddressesAdded,
                style: TextStyle(
                  color: Color(0xFF757575),
                  fontSize: 16,
                ),
              )
            : Column(
                children: controller.addresses.asMap().entries.map((entry) {
                  int index = entry.key;
                  Map<String, dynamic> address = entry.value;
                  return _buildAddressCard(address, index);
                }).toList(),
              ),
        ),
      ],
    );
  }

  Widget _buildGenericMultipleStep(int stepIndex, List<RegisterInput>? inputs, {String? title}) {
    return Obx(() {
      final list = controller.getEntriesForStep(stepIndex);
      return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? 'Items',
          style: AppTextStyle.title(
          ),
        ),
        const SizedBox(height: 20),
        if (list.isEmpty)
          const Text(
            'No items added',
            style: TextStyle(
              color: Color(0xFF757575),
              fontSize: 16,
            ),
          )
        else
          Column(
            children: list.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              // pick a couple of fields to preview
              String subtitle = data.entries.take(3).map((e) => '${e.key}: ${e.value}').join(' • ');
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            data.values.first?.toString() ?? 'Item ${index + 1}',
                            style: AppTextStyle.title(
                              fontWeight: FontWeight.bold,
                              color: AppColors.appTextColor,

                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:  AppTextStyle.description(
                              color: Color(0xFF757575),

                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _showGenericEntryDialog(stepIndex, inputs, existingData: data, index: index),
                          child: const Icon(
                            FeatherIcons.edit,
                            color: Colors.blue,
                            size: 18,
                          ),
                        ),
                        const SizedBox(width: 12),
                        GestureDetector(
                          onTap: () => controller.removeEntryForStep(stepIndex, index),
                          child: const Icon(
                            FeatherIcons.trash2,
                            color: Colors.red,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
      ],
    );
    });
  }

  Widget _buildAddressCard(Map<String, dynamic> address, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
        boxShadow: [
          BoxShadow(
            color: AppColors.appMutedColor,
            blurRadius: 5,
            spreadRadius: 1,
            offset: Offset(0, 10),
            // blurRadius: 1,
            // spreadRadius: 1,
            // offset: Offset(0, 6),
          ),
        ],

        // border: Border.all(color: AppColors.appBodyTextColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      address['address_type'] ?? '',
                      style: AppTextStyle.title(
                        fontWeight: FontWeight.bold,
                        color: AppColors.appTitleColor,

                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         GestureDetector(
                           onTap: () {
                             final lat = double.tryParse((address['latitude'] ?? '').toString());
                             final lng = double.tryParse((address['longitude'] ?? '').toString());
                             final fullAddress = address['address']?.toString();
                             _openInGoogleMaps(lat: lat, lng: lng, queryAddress: fullAddress);
                           },
                             child: Icon(Icons.place_outlined, color: AppColors.appIconColor, size: 20)),
                        SizedBox(width: 10.w),
                        SizedBox(
                          width: Get.width * 0.6,
                          child: Text(
                            address['address']?.isNotEmpty == true
                                ? '${address['address']}${address['landmark']?.isNotEmpty == true ? ', ${address['landmark']}' : ''}'
                                : 'Latitude: ${address['latitude'] ?? 'N/A'}, Longitude: ${address['longitude'] ?? 'N/A'}',
                            style:  AppTextStyle.description(
                              color:AppColors.appDescriptionColor ,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => controller.removeAddress(index),
                    child: const Icon(
                      FeatherIcons.trash2,
                      color: Colors.red,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => _showAddressDialog(
                        _filterMarkerInputs(controller.getCurrentStepInputs(1)),
                        existingAddress: address,
                        index: index
                    ),
                    child:  Icon(
                      FeatherIcons.edit,
                      color: AppColors.appColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Expanded(
                child: CustomToggle(
                  label: AppStrings.setAsDefault,
                  value: index == controller.defaultAddressIndex.value,
                  onChanged: (value) {
                    if (value) {
                      controller.defaultAddressIndex.value = index;
                    } else if (index == controller.defaultAddressIndex.value) {
                      controller.defaultAddressIndex.value = -1;
                    }
                  },
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(List<RegisterInput>? addressInputs, {Map<String, dynamic>? existingAddress, int? index}) {
    Get.bottomSheet(
      AddressDialog(
        addressInputs: addressInputs,
        existingAddress: existingAddress,
        index: index,
        onSave: (addressData) {
          if (index != null) {
            controller.updateAddress(index, addressData);
          } else {
            controller.addAddress(addressData);
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _showGenericEntryDialog(int stepIndex, List<RegisterInput>? inputs, {Map<String, dynamic>? existingData, int? index}) {
    Get.bottomSheet(
      GenericMultiEntryDialog(
        inputs: inputs,
        existingData: existingData,
        index: index,
        onSave: (data) {
          if (index != null) {
            controller.updateEntryForStep(stepIndex, index, data);
          } else {
            controller.addEntryForStep(stepIndex, data);
          }
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildActionButtons(ProfileFormPage profileForm, double screenHeight,BuildContext context) {
    return Obx(() {
      final currentStep = controller.currentStep.value;
      final addresses = controller.addresses;

      // For address step, only show buttons if addresses are not empty
      final currentStepTitle = _getCurrentStepTitle(profileForm, currentStep);
      if (_isAddressStep(currentStepTitle) && addresses.isEmpty) {
        return const SizedBox.shrink();
      }

      String? labelForAction(String action) {
        final buttons = profileForm.buttons ?? [];
        final currentStepOneBased = currentStep + 1;
        for (final b in buttons) {
          final a = (b.action ?? '').toLowerCase();
          if (a != action) continue;
          if (action == 'prev_step' && (b.visibleFromStep == null || currentStepOneBased >= b.visibleFromStep!)) return b.label;
          if (action == 'next_step' && (b.visibleUntilStep == null || currentStepOneBased <= b.visibleUntilStep!)) return b.label;
          if (action == 'submit_form' && (b.visibleOnStep != null && currentStepOneBased == b.visibleOnStep!)) return b.label;
        }
        return null;
      }

      final prevLabel = labelForAction('prev_step') ?? AppStrings.previous;
      final nextLabel = labelForAction('next_step') ?? AppStrings.next;
      final submitLabel = labelForAction('submit_form') ?? AppStrings.submit;

      return Row(
        children: [
          // Previous Button - Show based on API response
          if (controller.showPreviousButton.value) ...[
            Expanded(
              child: CustomButton(
                text: prevLabel,
                onTap: controller.isLoading.value ? null : controller.previousStep,
                isLoading: false, // Previous button doesn't trigger API, so no loading state
              ),
            ),
            const SizedBox(width: 16),
          ],

          // Next/Submit Button - Show based on API response
          if (controller.showNextButton.value || controller.showSubmitButton.value)
            Expanded(
              child: CustomButton(
                text: controller.showSubmitButton.value ? submitLabel : nextLabel,
                onTap: controller.isLoading.value
                    ? null
                    : () => controller.showSubmitButton.value
                        ? controller.submitForm(context)
                        : controller.nextStep(),

                // onTap: controller.isLoading.value
                //     ? null
                //     : () async {
                //   if (controller.showSubmitButton.value) {
                //     await controller.submitForm();
                //   } else {
                //     // 🚀 Start auto flow when user presses Next once
                //     controller.autoFlowActive.value = true;
                //     await controller.nextStep();
                //   }
                // },
                isLoading: controller.isLoading.value,
              ),
            ),
        ],
      );
    });
  }

  Widget _buildShimmerLoading(double screenHeight) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Description Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.simmerColor,
            highlightColor: AppColors.appWhite,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Progress Bar Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.simmerColor,
            highlightColor: AppColors.appWhite,
            child: Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Step Title Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.simmerColor,
            highlightColor: AppColors.appWhite,
            child: Container(
              height: 24,
              width: 200,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Form Fields Shimmer
          ...List.generate(5, (index) => Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Label Shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.simmerColor,
                  highlightColor: AppColors.appWhite,
                  child: Container(
                    height: 16,
                    width: 120,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // Input Field Shimmer
                Shimmer.fromColors(
                  baseColor: AppColors.simmerColor,
                  highlightColor: AppColors.appWhite,
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.appWhite,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          )),
          const SizedBox(height: 30),
          // Button Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.simmerColor,
            highlightColor: AppColors.appWhite,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.appWhite,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

}

Future<void> _openInGoogleMaps({double? lat, double? lng, String? queryAddress}) async {
  try {
    Uri? uri;
    if (lat != null && lng != null) {
      // Use coordinates if available
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    } else
      if (queryAddress != null && queryAddress.trim().isNotEmpty) {
      // Fallback to address text search
      final q = Uri.encodeComponent(queryAddress);
      uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$q');
    }

    if (uri == null) return;

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  } catch (_) {}
}

class AddressDialog extends StatefulWidget {
  final List<RegisterInput>? addressInputs;
  final Map<String, dynamic>? existingAddress;
  final int? index;
  final Function(Map<String, dynamic>) onSave;

  const AddressDialog({
    super.key,
    this.addressInputs,
    this.existingAddress,
    this.index,
    required this.onSave,
  });

  @override
  State<AddressDialog> createState() => _AddressDialogState();
}

class GenericMultiEntryDialog extends StatefulWidget {
  final List<RegisterInput>? inputs;
  final Map<String, dynamic>? existingData;
  final int? index;
  final Function(Map<String, dynamic>) onSave;

  const GenericMultiEntryDialog({
    super.key,
    this.inputs,
    this.existingData,
    this.index,
    required this.onSave,
  });

  @override
  State<GenericMultiEntryDialog> createState() => _GenericMultiEntryDialogState();
}

class _GenericMultiEntryDialogState extends State<GenericMultiEntryDialog> {
  final Map<String, dynamic> _data = {};
  final Map<String, String> _errors = {};

  @override
  void initState() {
    super.initState();
    if (widget.existingData != null) {
      _data.addAll(widget.existingData!);
    }
  }

  void _updateField(String fieldName, dynamic value) {
    setState(() {
      _data[fieldName] = value;
      _errors.remove(fieldName);
    });
  }

  bool _validate() {
    _errors.clear();
    bool ok = true;
    for (final input in widget.inputs ?? const []) {
      final fieldName = input.name ?? '';
      if (fieldName.toLowerCase() == 'step_type') continue;
      final isRequired = input.required ?? false;
      final value = _data[fieldName];
      if (isRequired && (value == null || value.toString().isEmpty)) {
        _errors[fieldName] = '${input.label ?? 'This field'} is required';
        ok = false;
      }
    }
    setState(() {});
    return ok;
  }

  void _save() {
    if (_validate()) {
      widget.onSave(_data);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = (widget.inputs ?? const [])
        .where((e) => (e.name ?? '').toLowerCase() != 'step_type')
        .toList();
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.index != null ? 'Edit Item' : 'Add New Item',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(
                          FeatherIcons.x,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (filtered.isNotEmpty)
                    DynamicFormBuilder(
                      inputs: filtered,
                      formData: _data,
                      onFieldChanged: _updateField,
                      errors: _errors,
                    ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          onTap: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Save',
                          onTap: _save,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AddressDialogState extends State<AddressDialog> {
  final Map<String, dynamic> _addressData = {};
  final Map<String, String> _errors = {};
  final controller = Get.find<SetupProfileController>();
  bool _useGoogleAutoComplete = false;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  void _initializeData() {
    if (widget.existingAddress != null) {
      _addressData.addAll(widget.existingAddress!);
    } else {
      // Initialize with default values
      _addressData['address_type'] = 'home';
      _addressData['default_address'] = false;
    }
  }

  void _updateField(String fieldName, dynamic value) {
    if (!mounted) return;
    // Defer state update to avoid setState during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _addressData[fieldName] = value;
        if (_errors.containsKey(fieldName)) {
          _errors.remove(fieldName);
        }
      });
    });
  }

  bool _validateForm() {
    _errors.clear();
    bool isValid = true;

    if (widget.addressInputs != null) {
      for (final input in widget.addressInputs!) {
        final fieldName = input.name ?? '';
        final isRequired = input.required ?? false;
        final value = _addressData[fieldName];

        if (isRequired && (value == null || value.toString().isEmpty)) {
          _errors[fieldName] = '${input.label ?? 'This field'} is required';
          isValid = false;
        }
      }
    }

    setState(() {});
    return isValid;
  }

  void _saveAddress() {
    if (_validateForm()) {
      widget.onSave(_addressData);
      Get.back();
    }
  }

  Future<void> _openLocationPicker() async {
    // Get current location or use default
    final homeController = Get.find<ClientHomeController>();
    final currentLat = homeController.currentLatLng.value.latitude;
    final currentLng = homeController.currentLatLng.value.longitude;

    await Get.to(() => ReusableLocationPickerScreen(
      initialLat: currentLat,
      initialLng: currentLng,
      onLocationSelected: (latLng, address, landmark) {
        setState(() {
          _addressData['latitude'] = latLng.latitude.toString();
          _addressData['longitude'] = latLng.longitude.toString();
          _addressData['address'] = address;
          _addressData['landmark'] = landmark;
        });
      },
    ));
  }

  Future<void> _getCurrentLocation() async {
    try {
      final homeController = Get.find<ClientHomeController>();
      // Get current location using the public method
      await homeController.getCurrentLocation();

      // Extract landmark from current location
      String landmark = '';
      final currentAddress = homeController.currentLocation.value;
      if (currentAddress.isNotEmpty) {
        // Try to extract landmark from the address string
        final parts = currentAddress.split(',');
        if (parts.length > 1) {
          landmark = parts[1].trim(); // Usually the second part is landmark/area
        }
      }

      setState(() {
        _addressData['latitude'] = homeController.currentLatLng.value.latitude.toString();
        _addressData['longitude'] = homeController.currentLatLng.value.longitude.toString();
        _addressData['address'] = homeController.currentLocation.value;
        _addressData['landmark'] = landmark;
      });
    } catch (e) {
      Utils.showSnackbar(isSuccess: false, title: 'Error', message: 'Failed to get current location: $e');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration:  BoxDecoration(
        gradient: AppColors.appPagecolor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.index != null ? 'Edit Address' : 'Add New Address',
                        style: AppTextStyle.title(

                          fontWeight: FontWeight.bold,
                          color: AppColors.appTitleColor
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child:  Icon(
                          FeatherIcons.x,
                          size: 24,
                          color: AppColors.appIconColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Google AutoComplete Toggle
                  Row(
                    children: [
                      Expanded(
                        child: CustomToggle(
                          label: 'Current Address',
                          value: _useGoogleAutoComplete,
                          onChanged: (value) {
                            setState(() {
                              _useGoogleAutoComplete = value;
                            });
                            if (_useGoogleAutoComplete) {
                              _getCurrentLocation();
                            }
                          },
                        ),
                      ),
                      // Location Picker Button (only show when toggle is enabled)
                      if (_useGoogleAutoComplete) ...[
                        const SizedBox(width: 16),
                        GestureDetector(
                          onTap: _openLocationPicker,
                          child: Icon(Icons.place_outlined, color: AppColors.appIconColor, size: 20),
                        ),
                      ],
                    ],
                  ),



                  const SizedBox(height: 20),

                  // Dynamic Form Fields
                  if (widget.addressInputs != null)
                    DynamicFormBuilder(
                      inputs: widget.addressInputs!,
                      formData: _addressData,
                      onFieldChanged: _updateField,
                      errors: _errors,
                    ),

                  const SizedBox(height: 20),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Cancel',
                          onTap: () => Get.back(),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: CustomButton(
                          text: 'Save',
                          onTap: _saveAddress,
                        ),
                      ),
                    ],
                  ),

                  // Bottom padding for safe area
                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
