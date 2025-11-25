import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import '../../controller/post/post_form_controller.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../core/app_string.dart';
import '../../widget/form_widgets/dynamic_form_builder.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../models/App_moduls/AppResponseModel.dart';

class PostNewScreen extends GetView<PostFormController> {
  const PostNewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Register controller if not already registered
    if (!Get.isRegistered<PostFormController>()) {
      Get.put(PostFormController());
    }

    final screenHeight = MediaQuery.of(context).size.height;
    final appController = Get.find<AppSettingsController>();

    return Container(
      // FULL PAGE GRADIENT — FIXES WHITE SPACE ISSUE
      decoration: BoxDecoration(
        gradient: AppColors.appPagecolor,
      ),
      child: Scaffold(
        backgroundColor: Colors
            .transparent, // Important so scaffold doesn't hide gradient under body
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          toolbarHeight: 80,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,   // ← APPLY GRADIENT HERE
            ),
          ),
          title: Obx(() {
            final postForm = appController.postFormPage.value;
            return Text(
              postForm?.pageTitle ?? 'Create Post',
              style: TextStyle(
                color: AppColors.appTextColor,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            );
          }),
        ),


        // BODY
        body: Obx(() {
          final postForm = appController.postFormPage.value;

          if (postForm == null) {
            return const Center(
              child: Text('Post form configuration not available'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Page Description
                if (postForm.pageDescription?.isNotEmpty == true) ...[
                  Text(
                    postForm.pageDescription!,
                    style: AppTextStyle.kTextStyle.copyWith(
                      color: AppColors.appDescriptionColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Progress Bar
                if (postForm.progressBar == true) ...[
                  _buildProgressBar(postForm),
                  const SizedBox(height: 20),
                ],

                // Form Content
                GetBuilder<PostFormController>(
                  id: 'form_content',
                  builder: (controller) =>
                      _buildFormContent(postForm, screenHeight),
                ),

                const SizedBox(height: 160), // For bottom nav spacing
              ],
            ),
          );
        }),

        // BOTTOM BAR
        bottomNavigationBar: Obx(() {
          final postForm = appController.postFormPage.value;
          if (postForm == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors
                .transparent, // FIX: do not apply gradient again → no white gap
            child: SafeArea(
              child: _buildActionButtons(postForm, screenHeight),
            ),
          );
        }),
      ),
    );
  }

  // ------------------------- PROGRESS BAR -------------------------

  Widget _buildProgressBar(ProfileFormPage postForm) {
    final currentStep = controller.currentStep.value;
    final totalSteps = postForm.totalSteps ?? 26;

    return Column(
      children: [
        StepProgressIndicator(
          totalSteps: totalSteps,
          currentStep: currentStep + 1,
          selectedColor: AppColors.appColor,
          unselectedColor: AppColors.appGreyColor,
          size: 8,
          roundedEdges: const Radius.circular(4),
        ),
        const SizedBox(height: 12),

        if (postForm.stepTitles != null &&
            currentStep < postForm.stepTitles!.length) ...[
          Text(
            postForm.stepTitles![currentStep],
            style: AppTextStyle.kTextStyle.copyWith(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ],
    );
  }

  // ------------------------- FORM CONTENT -------------------------

  Widget _buildFormContent(ProfileFormPage postForm, double screenHeight) {
    final currentStep = controller.currentStep.value;
    List<RegisterInput>? currentStepInputs;

    final totalSteps = postForm.totalSteps ?? 26;
    if (currentStep >= 0 && currentStep < totalSteps) {
      currentStepInputs = _getStepInputs(postForm, currentStep);
    }

    if (currentStepInputs == null || currentStepInputs.isEmpty) {
      return const Center(
        child: Text('No form fields available for this step'),
      );
    }

    final currentStepTitle = _getCurrentStepTitle(postForm, currentStep);

    final hasMultipleMarker = currentStepInputs
        .any((e) => (e.inputType ?? '').toLowerCase() == 'multiple');

    final filteredInputs = currentStepInputs
        .where((e) => (e.name ?? '').toLowerCase() != 'step_type')
        .toList();

    return Column(
      children: [
        if (hasMultipleMarker)
          _buildGenericMultipleStep(
            currentStep,
            filteredInputs,
            title: currentStepTitle,
          )
        else
          DynamicFormBuilder(
            inputs: filteredInputs,
            formData: controller.formData,
            onFieldChanged: controller.updateFormData,
            errors: controller.formErrors,
          ),
      ],
    );
  }

  List<RegisterInput>? _getStepInputs(ProfileFormPage postForm, int stepIndex) {
    if (postForm.inputs == null) return null;
    return postForm.inputs!.getStepInputs(stepIndex);
  }

  String? _getCurrentStepTitle(ProfileFormPage postForm, int stepIndex) {
    if (postForm.stepTitles == null ||
        stepIndex >= postForm.stepTitles!.length) {
      return null;
    }
    return postForm.stepTitles![stepIndex];
  }

  // ------------------------- MULTI ENTRY STEP -------------------------

  Widget _buildGenericMultipleStep(
      int stepIndex, List<RegisterInput>? inputs,
      {String? title}) {
    return Obx(() {
      final list = controller.getEntriesForStep(stepIndex);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title ?? 'Items',
            style: const TextStyle(
              color: Color(0xFF1D1D1D),
              fontWeight: FontWeight.bold,
              fontSize: 18,
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

                String subtitle = data.entries
                    .take(3)
                    .map((e) => '${e.key}: ${e.value}')
                    .join(' • ');

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.values.first?.toString() ??
                                  'Item ${index + 1}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.appTextColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              subtitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF757575),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showGenericEntryDialog(
                                stepIndex, inputs,
                                existingData: data, index: index),
                            child: const Icon(
                              FeatherIcons.edit,
                              color: Colors.blue,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => controller.removeEntryForStep(
                                stepIndex, index),
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

  void _showGenericEntryDialog(int stepIndex, List<RegisterInput>? inputs,
      {Map<String, dynamic>? existingData, int? index}) {
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

  // ------------------------- ACTION BUTTONS -------------------------

  Widget _buildActionButtons(ProfileFormPage postForm, double screenHeight) {
    return Obx(() {
      final currentStep = controller.currentStep.value;

      String? labelForAction(String action) {
        final buttons = postForm.buttons ?? [];
        final currentStepOneBased = currentStep + 1;
        for (final b in buttons) {
          final a = (b.action ?? '').toLowerCase();
          if (a != action) continue;
          if (action == 'prev_step' &&
              (b.visibleFromStep == null ||
                  currentStepOneBased >= b.visibleFromStep!)) {
            return b.label;
          }
          if (action == 'next_step' &&
              (b.visibleUntilStep == null ||
                  currentStepOneBased <= b.visibleUntilStep!)) {
            return b.label;
          }
          if (action == 'submit_form' &&
              (b.visibleOnStep != null &&
                  currentStepOneBased == b.visibleOnStep!)) {
            return b.label;
          }
        }
        return null;
      }

      final prevLabel = labelForAction('prev_step') ?? AppStrings.previous;
      final nextLabel = labelForAction('next_step') ?? AppStrings.next;
      final submitLabel = labelForAction('submit_form') ?? AppStrings.submit;

      return Row(
        children: [
          if (controller.showPreviousButton.value) ...[
            Expanded(
              child: CustomButton(
                text: prevLabel,
                onTap: controller.isLoading.value
                    ? null
                    : controller.previousStep,
              ),
            ),
            const SizedBox(width: 16),
          ],

          if (controller.showNextButton.value ||
              controller.showSubmitButton.value)
            Expanded(
              child: CustomButton(
                text: controller.showSubmitButton.value
                    ? submitLabel
                    : nextLabel,
                onTap: controller.isLoading.value
                    ? null
                    : () => controller.showSubmitButton.value
                    ? controller.submitForm()
                    : controller.nextStep(),
                isLoading: controller.isLoading.value,
              ),
            ),
        ],
      );
    });
  }
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
  State<GenericMultiEntryDialog> createState() =>
      _GenericMultiEntryDialogState();
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
      final name = input.name ?? '';
      if (name.toLowerCase() == 'step_type') continue;
      if (input.required == true &&
          (_data[name] == null || _data[name].toString().isEmpty)) {
        _errors[name] = '${input.label ?? 'Field'} is required';
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
