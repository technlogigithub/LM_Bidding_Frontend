import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'package:shimmer/shimmer.dart';
import '../../controller/post/post_form_controller.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../core/app_string.dart';
import '../../widget/form_widgets/dynamic_form_builder.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../../models/Post/Post_Form_Genrate_Model.dart' as PostModel;
import '../../widget/web_form_container.dart';

class PostNewScreen extends StatefulWidget {
  final String? apiEndpoint;
  const PostNewScreen({super.key, this.apiEndpoint});

  @override
  State<PostNewScreen> createState() => _PostNewScreenState();
}

class _PostNewScreenState extends State<PostNewScreen> with WidgetsBindingObserver {
  late PostFormController controller;
  bool _hasInitialized = false;
  DateTime? _lastRefreshTime;
  bool _isUserInteracting = false; // Track if user is actively interacting with form

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    // Register controller if not already registered
    if (!Get.isRegistered<PostFormController>()) {
      Get.put(PostFormController());
    }
    controller = Get.find<PostFormController>();

    // Load form data when screen is first built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasInitialized) {
        _hasInitialized = true;
        controller.refreshFormData(endpoint: widget.apiEndpoint);
        _lastRefreshTime = DateTime.now();
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Reset form session when leaving screen
    if (Get.isRegistered<PostFormController>()) {
      controller.resetSession();
    }
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Refresh form data when screen is revisited (navigation back)
    // BUT: Don't refresh if user is actively interacting with the form (uploading images, etc.)
    // Only refresh if it's been more than 1 second since last refresh to avoid excessive calls
    if (mounted && _hasInitialized && !_isUserInteracting) {
      final now = DateTime.now();
      if (_lastRefreshTime == null ||
          now.difference(_lastRefreshTime!).inSeconds > 1) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_isUserInteracting) {
            controller.refreshFormData(endpoint: widget.apiEndpoint);
            _lastRefreshTime = DateTime.now();
          }
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    // When app comes back to foreground, refresh form data
    if (state == AppLifecycleState.resumed && mounted && _hasInitialized) {
      controller.refreshFormData(endpoint: widget.apiEndpoint);
      _lastRefreshTime = DateTime.now();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebUI(context);
    }
    return _buildMobileUI(context);
  }

  Widget _buildMobileUI(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final appController = Get.find<AppSettingsController>();
    final postForm = appController.postFormFromApi.value;

    return Container(
      decoration: BoxDecoration(gradient: AppColors.appPagecolor),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          iconTheme: IconThemeData(color: AppColors.appTextColor),
          toolbarHeight: 80,
          centerTitle: true,
          backgroundColor: Colors.transparent,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: AppColors.appbarColor,
            ),
          ),
          title: Text(
            postForm?.pageTitle ?? '',
            style: AppTextStyle.title(
              color: AppColors.appTextColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Obx(() {
          final postForm = appController.postFormFromApi.value;
          final isLoadingForm = controller.isLoadingForm.value;

          if (isLoadingForm || postForm == null) {
            if (isLoadingForm) {
              return _buildShimmerLoading(screenHeight);
            } else {
              return _buildEmptyState();
            }
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFormHeader(postForm),
                _buildFormContentWithPageView(postForm, screenHeight),
                const SizedBox(height: 160),
              ],
            ),
          );
        }),
        bottomNavigationBar: Obx(() {
          final postForm = appController.postFormFromApi.value;
          final isLoadingForm = controller.isLoadingForm.value;
          if (isLoadingForm || postForm == null) return const SizedBox.shrink();

          return Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.transparent,
            child: SafeArea(child: _buildActionButtons(postForm, screenHeight, context)),
          );
        }),
      ),
    );
  }

  Widget _buildWebUI(BuildContext context) {
    final appController = Get.find<AppSettingsController>();
    final screenHeight = MediaQuery.of(context).size.height;

    return Obx(() {
      final postForm = appController.postFormFromApi.value;
      final isLoadingForm = controller.isLoadingForm.value;

      if (isLoadingForm || postForm == null) {
        return Scaffold(
          body: isLoadingForm
              ? _buildShimmerLoading(screenHeight)
              : _buildEmptyState(),
        );
      }

      return Container(
        decoration: BoxDecoration(gradient: AppColors.appPagecolor),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                // Header outside the card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    children: [
                      Text(
                        postForm.pageTitle ?? '',
                        style: AppTextStyle.title(
                          color: AppColors.appTitleColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildFormHeader(postForm),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Card containing ONLY the steps and actions
                Expanded(
                  child: WebFormContainer(
                    widthFactor: 0.9,
                    heightFactor: 1.0, 
                    htmlContent: """
                      <div style="font-family: Arial, sans-serif; color: #333; line-height: 1.6;">
                        <h4 style="color: #1A73E8;">Bidding Guidelines</h4>
                        <p>Welcome to the Post Form. Please follow these steps to ensure your post is approved quickly:</p>
                        <ul style="padding-left: 20px;">
                          <li><b>Accuracy:</b> Enter precise details for your item or service.</li>
                          <li><b>Media:</b> Upload clear photos. Posts with images get 3x more visibility.</li>
                          <li><b>Bidding Mode:</b> Choose the mode that best fits your requirements.</li>
                        </ul>
                        <div style="background: #F8F9FA; padding: 10px; border-left: 4px solid #1A73E8; margin-top: 20px;">
                          <b>Need Help?</b><br>
                          Contact our 24/7 support team if you encounter any issues while filling the form.
                        </div>
                      </div>
                    """,
                    footer: _buildActionButtons(postForm, screenHeight, context),
                    child: _buildFormContentWithPageView(postForm, screenHeight),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildFormHeader(PostModel.PostForm postForm) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (postForm.pageDescription?.isNotEmpty == true) ...[
          Text(
            postForm.pageDescription!,
            style: AppTextStyle.description(
              color: AppColors.appDescriptionColor,
            ),
          ),
          const SizedBox(height: 20),
        ],
        if (postForm.progressBar == true) ...[
          _buildProgressBar(postForm),
          const SizedBox(height: 20),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              FeatherIcons.alertCircle,
              size: 48,
              color: AppColors.appDescriptionColor,
            ),
            const SizedBox(height: 16),
            Text(
              'Post form configuration not available',
              style: AppTextStyle.description(
                color: AppColors.appDescriptionColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------- PROGRESS BAR -------------------------

  Widget _buildProgressBar(PostModel.PostForm postForm) {
    final currentStep = controller.currentStep.value;
    final totalSteps = postForm.totalSteps ?? 26;

    return Column(
      children: [
        StepProgressIndicator(
          totalSteps: totalSteps,
          currentStep: currentStep + 1,
          selectedColor: AppColors.appColor,
          unselectedColor: AppColors.appMutedColor,
          size: 8,
          roundedEdges: const Radius.circular(4),
        ),
        const SizedBox(height: 12),

        if (postForm.stepTitles != null &&
            currentStep < postForm.stepTitles!.length) ...[
          Text(
            postForm.stepTitles![currentStep],
            style: AppTextStyle.title(
              color: AppColors.appTitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  // ------------------------- FORM CONTENT WITH PAGEVIEW -------------------------

  Widget _buildFormContentWithPageView(
      PostModel.PostForm postForm,
      double screenHeight,
      ) {
    final totalSteps = postForm.totalSteps ?? 26;

    // Ensure PageController is initialized (should be done in onInit, but check here)
    if (controller.pageController == null) {
      controller.pageController = PageController(
        initialPage: controller.currentStep.value,
      );
    }

    // Sync PageController with current step if they're out of sync
    // Only do this if controller has clients (PageView is attached) and exactly one PageView
    if (controller.pageController!.hasClients) {
      // Check that only one PageView is attached to avoid the error
      try {
        final positions = controller.pageController!.positions;
        if (positions.length == 1) {
          final currentPage = controller.pageController!.page?.round();
          if (currentPage != null &&
              currentPage != controller.currentStep.value) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (controller.pageController != null &&
                  controller.pageController!.hasClients) {
                final positions = controller.pageController!.positions;
                // Only jump if there's exactly one position (one PageView attached)
                if (positions.length == 1) {
                  controller.pageController!.jumpToPage(
                    controller.currentStep.value,
                  );
                }
              }
            });
          }
        }
      } catch (e) {
        // If there are multiple PageViews attached, ignore the sync
        print('Warning: Multiple PageViews detected, skipping sync: $e');
      }
    }

    return Builder(
      builder: (context) {
        // Get keyboard height dynamically
        final mediaQuery = MediaQuery.of(context);
        final keyboardHeight = mediaQuery.viewInsets.bottom;
        final screenSize = mediaQuery.size;
        final padding = mediaQuery.padding;

        // Calculate available height dynamically
        final viewportHeight = kIsWeb
            ? (screenSize.height * 0.5) // Adaptive height for web content area
            : (screenSize.height - padding.top - padding.bottom - (80.0 + 60.0 + 40.0 + 80.0 + 32.0) - keyboardHeight);

        // Ensure minimum height for proper rendering
        final height = (viewportHeight > 300 ? viewportHeight : 300.0);

        return SizedBox(
          height: height,
          child: PageView.builder(
            key: ValueKey(
              'post_form_pageview_${controller.hashCode}',
            ), // Unique key to prevent multiple instances
            controller: controller.pageController,
            physics: const ClampingScrollPhysics(), // Enable swipe gestures
            onPageChanged: (int page) {
              final previousPage = controller.currentStep.value;
              controller.onPageChanged(page, previousPage);
            },
            itemCount: totalSteps,
            itemBuilder: (context, index) {
              // Get keyboard height in itemBuilder to ensure it's always current
              final currentKeyboardHeight = MediaQuery.of(
                context,
              ).viewInsets.bottom;
              return SingleChildScrollView(
                physics:
                const AlwaysScrollableScrollPhysics(), // Ensure scrollable even when content fits
                padding: EdgeInsets.only(
                  top: 8.0,
                  bottom: currentKeyboardHeight > 0
                      ? 20.0
                      : 8.0, // Extra bottom padding when keyboard is visible
                ),
                child: _buildFormContentForStep(postForm, index, screenHeight,context),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFormContentForStep(
      PostModel.PostForm postForm,
      int stepIndex,
      double screenHeight,
      BuildContext context
      ) {
    List<RegisterInput>? currentStepInputs;

    final totalSteps = postForm.totalSteps ?? 26;
    final bool isLastStep = stepIndex >= totalSteps - 1;
    if (stepIndex >= 0 && stepIndex < totalSteps) {
      currentStepInputs = _getStepInputs(postForm, stepIndex);
    }

    if (currentStepInputs == null || currentStepInputs.isEmpty) {
      return Center(
        child: Text(
          'No form fields available for this step',
          style: AppTextStyle.title(color: AppColors.appDescriptionColor),
        ),
      );
    }

    final currentStepTitle = _getCurrentStepTitle(postForm, stepIndex);

    final hasMultipleMarker = currentStepInputs.any(
          (e) => (e.inputType ?? '').toLowerCase() == 'multiple',
    );

    final filteredInputs = currentStepInputs
        .where((e) => (e.name ?? '').toLowerCase() != 'step_type')
        .toList();

    // Check if all visible inputs have autoForward: true
    final allAutoForward = filteredInputs.every((input) {
      final type = (input.inputType ?? '').toLowerCase();
      // Skip non-UI / technical fields
      if (type == 'group' || type == 'hidden') return true;
      return input.autoForward == true;
    });

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 20.0,
      ), // Extra padding to prevent label cutoff
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasMultipleMarker)
            _buildGenericMultipleStep(
              stepIndex,
              filteredInputs,
              title: currentStepTitle,
            )
          else
            DynamicFormBuilder(
              key: ValueKey('form_${controller.currentStep.value}_${controller.formData.length}'),
              inputs: filteredInputs,
              formData: controller.formData,
              onFieldChanged: (fieldName, value) {
                // Mark as user interacting when field changes (especially file uploads)
                _isUserInteracting = true;
                controller.updateFormData(fieldName, value);
                // Reset interaction flag after a delay to allow refresh on navigation back
                Future.delayed(const Duration(seconds: 3), () {
                  if (mounted) {
                    _isUserInteracting = false;
                  }
                });
              },
              errors: controller.formErrors,
              onAutoForward: () {
                // Auto-advance to next step when auto-forward is triggered
                // This can be triggered by individual field autoForward or all fields autoForward
                Future.delayed(const Duration(milliseconds: 300), () {
                  if (isLastStep) {
                    controller.submitForm(context);
                  } else {
                    controller.nextStep();
                  }
                });
              },
              // Keyboard Enter/Next navigation for enterEnable = true inputs
              onStepNext: () {
                if (isLastStep) {
                  controller.submitForm(context);
                } else {
                  controller.nextStep();
                }
              },
            ),
        ],
      ),
    );
  }

  List<RegisterInput>? _getStepInputs(
      PostModel.PostForm postForm,
      int stepIndex,
      ) {
    if (postForm.inputs == null) return null;

    // Get StepInput from PostForm and convert to RegisterInput
    List<PostModel.StepInput>? stepInputs = postForm.inputs!.getStepInputs(
      stepIndex,
    );
    if (stepInputs == null) return null;

    // Convert StepInput to RegisterInput using controller's converter
    return stepInputs
        .map((si) => controller.convertStepInputToRegisterInput(si))
        .toList();
  }

  String? _getCurrentStepTitle(PostModel.PostForm postForm, int stepIndex) {
    if (postForm.stepTitles == null ||
        stepIndex >= postForm.stepTitles!.length) {
      return null;
    }
    return postForm.stepTitles![stepIndex];
  }

  // ------------------------- MULTI ENTRY STEP -------------------------

  Widget _buildGenericMultipleStep(
      int stepIndex,
      List<RegisterInput>? inputs, {
        String? title,
      }) {
    return Obx(() {
      final list = controller.getEntriesForStep(stepIndex);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title ?? 'Items', style: AppTextStyle.title()),
          const SizedBox(height: 20),

          if (list.isEmpty)
            Text('No items added', style: AppTextStyle.description())
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
                              style: AppTextStyle.description(),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () => _showGenericEntryDialog(
                              stepIndex,
                              inputs,
                              existingData: data,
                              index: index,
                            ),
                            child: const Icon(
                              FeatherIcons.edit,
                              color: Colors.blue,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () =>
                                controller.removeEntryForStep(stepIndex, index),
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

  void _showGenericEntryDialog(
      int stepIndex,
      List<RegisterInput>? inputs, {
        Map<String, dynamic>? existingData,
        int? index,
      }) {
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

  Widget _buildActionButtons(PostModel.PostForm postForm, double screenHeight,BuildContext context) {
    return Obx(() {
      final currentStep = controller.currentStep.value;

      String? labelForAction(String action) {
        final buttons = postForm.buttons ?? [];
        final currentStepOneBased = currentStep + 1;
        for (final b in buttons) {
          // Handle both PostModel.Buttons and ProfileFormButton types
          String? buttonAction;
          int? visibleFromStep;
          int? visibleUntilStep;
          int? visibleOnStep;
          String? label;

          // PostForm uses PostModel.Buttons
          buttonAction = b.action?.toLowerCase();
          visibleFromStep = b.visibleFromStep;
          visibleUntilStep = b.visibleUntilStep;
          visibleOnStep = b.visibleOnStep;
          label = b.label;

          if (buttonAction != action) continue;

          if (action == 'prev_step' &&
              (visibleFromStep == null ||
                  currentStepOneBased >= visibleFromStep)) {
            return label;
          }
          if (action == 'next_step' &&
              (visibleUntilStep == null ||
                  currentStepOneBased <= visibleUntilStep)) {
            return label;
          }
          if (action == 'submit_form' &&
              (visibleOnStep != null && currentStepOneBased == visibleOnStep)) {
            return label;
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
                    ? controller.submitForm(context)
                    : controller.nextStep(),
                isLoading: controller.isLoading.value,
              ),
            ),
        ],
      );
    });
  }

  // ------------------------- SHIMMER LOADING -------------------------

  Widget _buildShimmerLoading(double screenHeight) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page Description Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: Container(
              height: 20,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Progress Bar Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Step Title Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: Container(
              height: 24,
              width: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Form Fields Shimmer (5 fields)
          ...List.generate(
            5,
                (index) => Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Label Shimmer
                  Shimmer.fromColors(
                    baseColor: AppColors.appMutedColor,
                    highlightColor: AppColors.appMutedTextColor,
                    child: Container(
                      height: 16,
                      width: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Input Field Shimmer
                  Shimmer.fromColors(
                    baseColor: AppColors.appMutedColor,
                    highlightColor: AppColors.appMutedTextColor,
                    child: Container(
                      height: 50,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Button Shimmer
          Shimmer.fromColors(
            baseColor: AppColors.appMutedColor,
            highlightColor: AppColors.appMutedTextColor,
            child: Container(
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
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
              color: AppColors.appMutedColor,
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
                        style: AppTextStyle.title(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1D1D1D),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: const Icon(FeatherIcons.x, size: 24),
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
                        child: CustomButton(text: 'Save', onTap: _save),
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
