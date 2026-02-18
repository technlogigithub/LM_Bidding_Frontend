import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../widget/web_card_container_layout.dart';
import 'package:libdding/core/app_color.dart';
import 'package:libdding/core/app_string.dart';
import 'package:libdding/core/app_textstyle.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../controller/auth/auth_controller.dart';
import '../../core/utils.dart';
import '../../core/input_formatters.dart';
import '../../widget/app_image_handle.dart';
import '../../widget/form_widgets/app_button.dart';
import '../../widget/app_social_icons.dart';
import '../../widget/form_widgets/app_textfield.dart';
import '../../widget/form_widgets/custom_mobile_number_textfield.dart';
import '../../widget/form_widgets/custom_textarea.dart';
import '../../widget/form_widgets/custom_toggle.dart';
import '../../widget/form_widgets/custom_radio_group.dart';
import '../../widget/form_widgets/custom_checkbox_group.dart';
import '../../widget/form_widgets/custom_file_picker.dart';
import '../../widget/form_widgets/custom_dropdown.dart';
import '../../widget/form_widgets/custom_date_time.dart';
import '../../widget/form_widgets/location_picker.dart';
import '../../controller/home/home_controller.dart';
import 'login_with_mobile_number_screen.dart';

class CreateAccountScreen extends StatefulWidget {
  CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final controller = Get.put(AuthController());
  static final controllerApp = Get.put(AppSettingsController());

  // Persist values for dynamic fields
  final Map<String, TextEditingController> _textControllers = {};
  final Map<String, bool> _toggleValues = {};
  final Map<String, String?> _radioValues = {};
  final Map<String, Set<String>> _checkValues = {};
  final Map<String, String?> _dropdownValues = {};
  final Map<String, DateTime?> _dateTimeValues = {};
  final Map<String, DateTimeRange?> _dateRangeValues = {};
  final Map<String, bool> _passwordObscure = {};

  @override
  void dispose() {
    for (final c in _textControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return _buildWebUI(context);
    }
    return _buildMobileUI(context);
  }

  Widget _buildMobileUI(BuildContext context) {
    // Initialize ScreenUtil with a reference design size (375x812 for mobile)
    ScreenUtil.init(context, designSize: const Size(375, 812), minTextAdapt: true);

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    // Define max width for web/large screens
    final maxContentWidth = screenWidth > 1200 ? 1200.0 : screenWidth;

    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: AppColors.appWhite,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          automaticallyImplyLeading: false,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50.r),
              bottomRight: Radius.circular(50.r),
            ),
          ),
          toolbarHeight: 180.h, // Scaled height
          flexibleSpace: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  spreadRadius: 2.r,
                  blurRadius: 6.r,
                  offset: const Offset(0, 3),
                ),
              ],
              gradient: AppColors.appbarColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Column(
                    children: [
                      Center(
                        child: UniversalImage(
                          url: controllerApp.logoNameWhite.toString(),
                          height: screenHeight * 0.1,
                          width: screenWidth * 0.7,
                          fit: BoxFit.contain,
                        ),
                      ),


                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContentWidth),
            child: Container(
              height: screenHeight,
              width: screenWidth,
              decoration: BoxDecoration(
                gradient: AppColors.appPagecolor,
              ),
              child: Padding(
                padding: EdgeInsets.all(10.w),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: _buildFormContent(context, isWeb: false),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWebUI(BuildContext context) {
    return WebCardContainerLayout(
      logoUrl: controllerApp.logoNameWhite.toString(),
      child: _buildFormContent(context, isWeb: true),
    );
  }

  Widget _buildFormContent(BuildContext context, {required bool isWeb}) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final reg = controllerApp.registerPage.value;
          return Center(
            child: Text(
              reg?.pageTitle ?? AppStrings.createNewAccount,
              style: AppTextStyle.title(
                color: AppColors.appTitleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }),
        SizedBox(height: isWeb ? 15 : 20.h),
        // Dynamic inputs
        Obx(() {
          final reg = controllerApp.registerPage.value;
          final inputs = reg?.inputs ?? [];
          List<Widget> widgets = [];
          if ((reg?.pageDescription ?? '').isNotEmpty) {
            widgets.add(Text(
              reg!.pageDescription!,
              style: AppTextStyle.description(color: AppColors.appDescriptionColor),
            ));
            widgets.add(SizedBox(height: isWeb ? 10 : 16.h));
          }
          for (final field in inputs) {
            final name = field.name ?? '';
            final label = field.label ?? '';
            final hint = field.placeholder ?? '';
            final type = (field.inputType ?? 'text').toLowerCase();
            switch (type) {
              case 'text':
              case 'password':
                // Choose controller: map dynamic fields to existing auth controllers when matching names
                TextEditingController selectedController;
                final lname = name.toLowerCase();
                if (lname == 'username' || lname.contains('mobile') || lname.contains('phone')) {
                  selectedController = controller.mobileController;
                } else if (lname == 'password') {
                  selectedController = controller.passwordController;
                } else if (lname == 'confirm_password' || lname.contains('confirm')) {
                  selectedController = controller.confirmPasswordController;
                } else {
                  _textControllers.putIfAbsent(name, () => TextEditingController());
                  selectedController = _textControllers[name]!;
                }

                if (type == 'password') {
                  _passwordObscure.putIfAbsent(name, () => true);
                }

                // Detect mobile and apply numeric+length restrictions (prefer validations exact_length)
                int? exactLen;
                final hasNumeric = (field.validations ?? []).any((v) => (v.type ?? '') == 'numeric');
                for (final v in (field.validations ?? [])) {
                  if ((v.type ?? '') == 'exact_length' && v.value != null) {
                    exactLen = v.value;
                  }
                }
                final isMobile = lname == 'username' || lname.contains('mobile') || lname.contains('phone');

                if (isMobile) {
                  widgets.add(CustomMobileNumberTextField(
                    label: label,
                    hintText: hint,
                    controller: selectedController,
                    isRequired: field.required ?? false,
                    onCountryChanged: (code) => controller.countryCode.value = code,
                  ));
                } else {
                  widgets.add(CustomTextfield(
                    label: label,
                    hintText: hint,
                    controller: selectedController,
                    obscureText: type == 'password' ? (_passwordObscure[name] ?? true) : false,
                    isRequired: field.required ?? false,
                    keyboardType: hasNumeric ? TextInputType.number : TextInputType.text,
                    maxLength: exactLen,
                    inputFormatters: hasNumeric
                        ? [FilteringTextInputFormatter.digitsOnly]
                        : null,
                    suffixIcon: type == 'password'
                        ? IconButton(
                            onPressed: () {
                              setState(() => _passwordObscure[name] = !(_passwordObscure[name] ?? true));
                            },
                            icon: Icon(
                              (_passwordObscure[name] ?? true) ? Icons.visibility_off : Icons.visibility,
                              color: AppColors.appIconColor,
                            ),
                          )
                        : null,
                  ));
                }
                widgets.add(SizedBox(height: isWeb ? 10 : 16.h));
                break;
              case 'textarea':
                _textControllers.putIfAbsent(name, () => TextEditingController());
                widgets.add(CustomTextarea(
                  label: label,
                  hintText: hint,
                  controller: _textControllers[name],
                  isRequired: field.required ?? false,
                ));
                widgets.add(SizedBox(height: isWeb ? 10 : 16.h));
                break;
              case 'toggle':
                _toggleValues.putIfAbsent(name, () => false);
                widgets.add(CustomToggle(
                  label: label,
                  value: _toggleValues[name]!,
                  onChanged: (v) => setState(() => _toggleValues[name] = v),
                  isRequired: field.required ?? false,
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'radio':
                _radioValues.putIfAbsent(name, () => null);
                widgets.add(CustomRadioGroup(
                  label: label,
                  options: field.options ?? [],
                  value: _radioValues[name],
                  onChanged: (v) => setState(() => _radioValues[name] = v),
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'check':
                _checkValues.putIfAbsent(name, () => <String>{});
                widgets.add(CustomCheckboxGroup(
                  label: label,
                  options: field.options ?? [],
                  values: _checkValues[name]!,
                  onChanged: (v) => setState(() => _checkValues[name] = v),
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'file':
                widgets.add(CustomFilePicker(
                  label: label,
                  value: null,
                  onPicked: (f) {},
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'dropdown':
                _dropdownValues.putIfAbsent(name, () => null);
                widgets.add(CustomDropdown(
                  label: label,
                  hintText: hint,
                  options: field.options ?? [],
                  value: _dropdownValues[name],
                  onChanged: (v) => setState(() => _dropdownValues[name] = v),
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'date_time':
                _dateTimeValues.putIfAbsent(name, () => null);
                widgets.add(CustomDateTimePicker(
                  label: label,
                  value: _dateTimeValues[name],
                  onChanged: (v) => setState(() => _dateTimeValues[name] = v),
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'date_picker':
                _dateTimeValues.putIfAbsent(name, () => null);
                widgets.add(CustomDatePicker(
                  label: label,
                  value: _dateTimeValues[name],
                  onChanged: (v) => setState(() => _dateTimeValues[name] = v),
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'date_range':
                _dateRangeValues.putIfAbsent(name, () => null);
                widgets.add(CustomDateRangePicker(
                  label: label,
                  value: _dateRangeValues[name],
                  onChanged: (v) => setState(() => _dateRangeValues[name] = v),
                ));
                widgets.add(const SizedBox(height: 8));
                break;
              case 'address':
                widgets.add(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(label, style: AppTextStyle.title(color: AppColors.appTextColor)),
                      SizedBox(height: isWeb ? 5 : 8.h),
                      CustomButton(
                        text: 'Pick Location',
                        onTap: () async {
                          await Utils.gotoNextPage(() => const LocationPickerScreen(initialLat: 20.5937, initialLng: 78.9629));
                          // Using home controller to fetch last selected address
                          final hc = Get.find<ClientHomeController>();
                          setState(() {
                            _textControllers.putIfAbsent(name, () => TextEditingController());
                            _textControllers[name]!.text = hc.currentLocation.value;
                          });
                        },
                      ),
                      SizedBox(height: isWeb ? 5 : 8.h),
                      CustomTextarea(
                        label: 'Selected Address',
                        hintText: hint,
                        controller: _textControllers.putIfAbsent(name, () => TextEditingController()),
                        isRequired: field.required ?? false,
                      ),
                    ],
                  ),
                );
                widgets.add(const SizedBox(height: 8));
                break;
              default:
                _textControllers.putIfAbsent(name, () => TextEditingController());
                widgets.add(CustomTextfield(
                  label: label,
                  hintText: hint,
                  controller: _textControllers[name],
                  isRequired: field.required ?? false,
                ));
                widgets.add(SizedBox(height: isWeb ? 10 : 16.h));
            }
          }
          widgets.add(SizedBox(height: isWeb ? 10 : 12.h));
          return Column(children: widgets);
        }),

        // Checkbox
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => GestureDetector(
                onTap: controller.toggleCheck,
                child: Container(
                  height: isWeb ? 20 : 20.h,
                  width: isWeb ? 20 : 20.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: controller.isCheck.value ? AppColors.appButtonColor :AppColors.appTitleColor,
                      width: 2,
                    ),
                    color: controller.isCheck.value
                        ? AppColors.appButtonColor
                        : Colors.transparent,
                  ),
                  child: controller.isCheck.value
                      ? const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  )
                      : null,
                ),
              ),
            ),
            SizedBox(width: isWeb ? 10 : 10.w),

            Flexible(
              child: RichText(
                text: TextSpan(
                  text: AppStrings.yesIunderstandandagreetothe,
                  style: AppTextStyle.body(
                    color: AppColors.appBodyTextColor,
                  ),
                  children: [
                    TextSpan(
                      text: AppStrings.termsofService,
                      style: AppTextStyle.body(
                        color: AppColors.appLinkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isWeb ? 15 : 20.h),
        // Sign Up Button
        Obx(() {
          final reg = controllerApp.registerPage.value;
          final label = reg?.submitButtonLabel ?? AppStrings.signUp;
          return CustomButton(
            text: label,
            onTap: () {
              // Terms check
              if (!controller.isCheck.value) {
                Utils.showSnackbar(isSuccess: false, title: AppStrings.alert, message: AppStrings.pleaseAcceptTerms);
                return;
              }

              // Dynamic field validations
              final inputs = controllerApp.registerPage.value?.inputs ?? [];
              String? firstError;

              String? getFieldValue(String name) {
                final lname = name.toLowerCase();
                if (lname == 'username' || lname.contains('mobile') || lname.contains('phone')) {
                  return controller.mobileController.text.trim();
                } else if (lname == 'password') {
                  return controller.passwordController.text.trim();
                } else if (lname == 'confirm_password' || lname.contains('confirm')) {
                  return controller.confirmPasswordController.text.trim();
                }
                return _textControllers[name]?.text.trim();
              }

              for (final field in inputs) {
                final name = field.name ?? '';
                final value = getFieldValue(name) ?? '';
                final type = (field.inputType ?? '').toLowerCase();

                // Required check
                if ((field.required ?? false)) {
                  final isEmpty = () {
                    switch (type) {
                      case 'toggle':
                        return !(_toggleValues[name] ?? false);
                      case 'radio':
                        return (_radioValues[name] == null);
                      case 'check':
                        return ((_checkValues[name] ?? <String>{}).isEmpty);
                      case 'dropdown':
                        return (_dropdownValues[name] == null || (_dropdownValues[name] ?? '').isEmpty);
                      case 'date_time':
                      case 'date_picker':
                        return _dateTimeValues[name] == null;
                      case 'date_range':
                        return _dateRangeValues[name] == null;
                      default:
                        return value.isEmpty;
                    }
                  }();
                  if (isEmpty) {
                    firstError ??= '${field.label ?? name} is required';
                    break;
                  }
                }

                // Validation rules
                for (final v in (field.validations ?? [])) {
                  final vtype = (v.type ?? '').toLowerCase();
                  if (vtype == 'numeric') {
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      firstError ??= v.errorMessage ?? '${field.label ?? name} must be numeric';
                      break;
                    }
                  } else if (vtype == 'exact_length') {
                    final len = v.value ?? 0;
                    if (value.length != len) {
                      firstError ??= v.errorMessage ?? '${field.label ?? name} must be exactly $len characters';
                      break;
                    }
                  } else if (vtype == 'min_length') {
                    final len = v.value ?? v.minLength ?? 0;
                    if (value.length < len) {
                      firstError ??= v.errorMessage ?? v.minLengthError ?? '${field.label ?? name} must be at least $len characters';
                      break;
                    }
                  } else if (vtype == 'max_length') {
                    final len = v.value ?? v.maxLength ?? 999999;
                    if (value.length > len) {
                      firstError ??= v.errorMessage ?? v.maxLengthError ?? '${field.label ?? name} must be at most $len characters';
                      break;
                    }
                  } else if (vtype == 'pattern') {
                    final pat = v.pattern;
                    if (pat != null && !RegExp(pat).hasMatch(value)) {
                      firstError ??= v.errorMessage ?? v.patternErrorMessage ?? '${field.label ?? name} format is invalid';
                      break;
                    }
                  } else if (vtype == 'matches') {
                    final other = getFieldValue(v.field ?? '') ?? '';
                    if (value != other) {
                      firstError ??= v.errorMessage ?? '${field.label ?? name} does not match';
                      break;
                    }
                  } else if (vtype == 'password') {
                    final min = v.minLength ?? 8;
                    if (value.length < min) {
                      firstError ??= v.minLengthError ?? 'Password must be at least $min characters';
                      break;
                    }
                    if (v.pattern != null && !RegExp(v.pattern!).hasMatch(value)) {
                      firstError ??= v.patternErrorMessage ?? 'Password does not meet complexity requirements';
                      break;
                    }
                  }
                }

                if (firstError != null) break;
              }

              if (firstError != null) {
                Utils.showSnackbar(isSuccess: false, title: AppStrings.alert, message: firstError!);
                return;
              }

              controller.CreateAccountApi(context);
            },
          );
        }),
        SizedBox(height: isWeb ? 15 : 20.h),
        Obx(() {
          return controllerApp.socialLoginRequired.value ? Column(
            children: [
              // Divider and "Or Sign up with" text
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: AppColors.appTextColor,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or Sign up with',
                      style: AppTextStyle.description(
                        color: AppColors.appMutedTextColor,
                      ),
                    ),
                  ),

                ],
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SocialIcon(
                      bgColor: AppColors.appTextColor,
                      iconColor: AppColors.appWhite,
                      icon: FontAwesomeIcons.facebookF,
                      borderColor: Colors.transparent,
                    ),
                    SocialIcon(
                      bgColor: AppColors.appWhite,
                      iconColor: AppColors.appTextColor,
                      icon: FontAwesomeIcons.google,
                      borderColor: AppColors.appColor,
                    ),
                    SocialIcon(
                      bgColor: AppColors.appWhite,
                      iconColor: const Color(0xFF76A9EA),
                      icon: FontAwesomeIcons.twitter,
                      borderColor: AppColors.appTextColor,
                    ),
                    SocialIcon(
                      bgColor: AppColors.appWhite,
                      iconColor: const Color(0xFFFF554A),
                      icon: FontAwesomeIcons.instagram,
                      borderColor: AppColors.appTextColor,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
            ],
          ) : const SizedBox.shrink();
        }),
        Obx(() {
          final reg = controllerApp.registerPage.value;
          final left = reg?.loginLabel ?? 'Already have an account? ';
          final right = reg?.loginLink ?? 'Log In';
          return GestureDetector(
            onTap: () => Utils.gotoNextPage(() => LoginWithMobileNoScreen()),
            child: Center(
              child: RichText(
                text: TextSpan(
                  text: left + ' ',
                  style: AppTextStyle.description(
                    color: AppColors.appBodyTextColor,
                  ),
                  children: [
                    TextSpan(
                      text: right,
                      style: AppTextStyle.description(
                        color: AppColors.appLinkColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}