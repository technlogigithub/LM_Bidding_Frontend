import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:libdding/widget/form_widgets/location_picker.dart';
import 'package:geocoding/geocoding.dart';
import '../../controller/home/home_controller.dart';
import '../../controller/cart/cart_controller.dart';
import '../../core/app_textstyle.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../custom_tapbar.dart';
import 'app_button.dart';
import 'app_checkbox.dart';
import 'app_dropdown.dart';
import 'app_radiobutton.dart';
import 'app_textfield.dart';
import 'custom_textarea.dart';
import 'custom_textfield_address.dart';
import 'custom_toggle.dart';
import 'custom_file_picker.dart';
import 'custom_multiple_file_picker.dart';
import 'custom_date_time.dart';
import '../custom_coupon_apply_field.dart';
import '../../core/app_color.dart';
import '../custom_horizontal_bullets.dart';
import '../custom_input_plus_minus.dart';
import '../custom_input_increase_decrease.dart';

class DynamicFormBuilder extends StatefulWidget {
  final List<RegisterInput> inputs;
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onFieldChanged;
  final Map<String, String> errors;
  final VoidCallback? onAutoForward;
  // Called when user presses "Next/Done" on the last enter-enabled field
  final VoidCallback? onStepNext;

  const DynamicFormBuilder({
    super.key,
    required this.inputs,
    required this.formData,
    required this.onFieldChanged,
    required this.errors,
    this.onAutoForward,
    this.onStepNext,
  });

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {
  // Track if form has been interacted with (to prevent showing initial selection)
  final Set<String> _userInteractedFields = {};

  // Helpers for Enter/Next navigation based on enterEnable flag from API
  bool _isEnterNavigableField(RegisterInput input, String fieldType) {
    if (input.enterEnable != true) return false;
    if ((input.name ?? '').toLowerCase() == 'step_type') return false;
    if (fieldType == 'group') return false;
    // Limit to single-line text-like inputs where keyboard next makes sense
    return fieldType == 'text' ||
        fieldType == 'email' ||
        fieldType == 'password' ||
        fieldType == 'number';
  }

  bool _isLastEnterEnabledField(RegisterInput input, String fieldType) {
    if (!_isEnterNavigableField(input, fieldType)) return false;

    final currentIndex = widget.inputs.indexOf(input);
    if (currentIndex == -1) return false;

    // If there is ANY later visible input in this step (of any type),
    // then this is NOT the last field. Only when this is the last
    // actual widget in the step should "Done" move to the next step.
    for (int i = currentIndex + 1; i < widget.inputs.length; i++) {
      final other = widget.inputs[i];
      final otherName = (other.name ?? '').toLowerCase();
      final otherType = (other.inputType ?? '').toLowerCase();

      // Ignore purely technical fields which don't render UI
      if (otherName == 'step_type' || otherType == 'group') {
        continue;
      }

      // There is a later real widget → not last
      return false;
    }
    return true;
  }

  // Check if all fields have autoForward: true and all have values
  bool _shouldAutoForward() {
    if (widget.onAutoForward == null) return false;

    // Check if all inputs have autoForward: true
    final allAutoForward = widget.inputs.every((input) {
      // Skip step_type fields
      if ((input.name ?? '').toLowerCase() == 'step_type') return true;
      // Skip group fields
      if ((input.inputType ?? '').toLowerCase() == 'group') return true;
      // Skip hidden fields (they don't have UI, so don't count in auto-forward logic)
      if ((input.inputType ?? '').toLowerCase() == 'hidden') return true;
      return input.autoForward == true;
    });

    if (!allAutoForward) return false;

    // Check if all required fields have values
    for (final input in widget.inputs) {
      final fieldName = input.name ?? '';
      final inputTypeLower = (input.inputType ?? '').toLowerCase();
      // Skip step_type, group, and hidden fields
      if (fieldName.toLowerCase() == 'step_type' ||
          inputTypeLower == 'group' ||
          inputTypeLower == 'hidden') {
        continue;
      }

      final value = widget.formData[fieldName];
      final isRequired = input.required ?? false;

      // If field is required and has no value, don't auto-forward
      if (isRequired && (value == null || value.toString().isEmpty)) {
        return false;
      }
    }

    return true;
  }

  // Wrapper for onFieldChanged that checks auto-forward
  void _handleFieldChanged(
    String fieldName,
    dynamic value, {
    bool isUserInteraction = false,
    RegisterInput? input, // Pass input directly to avoid searching
  }) {
    // Mark field as user-interacted
    if (isUserInteraction) {
      _userInteractedFields.add(fieldName);
    }

    widget.onFieldChanged(fieldName, value);

    // Force rebuild to show selected values in UI
    setState(() {});

    // Check auto-forward after a short delay to ensure formData is updated
    // Only check auto-forward if this was a user interaction
    if (isUserInteraction) {
      // Find the input field to check if it has autoForward: true (if not passed)
      final fieldInput = input ?? widget.inputs.firstWhere(
        (inp) => (inp.name ?? '') == fieldName,
        orElse: () => RegisterInput(),
      );
      
      // If this specific field has autoForward: true and value is not empty, trigger immediately
      final hasValue = value != null && 
          value.toString().trim().isNotEmpty && 
          value.toString().trim() != 'null';
      
      print('🔍 Auto-forward check for "$fieldName": autoForward=${fieldInput.autoForward}, hasValue=$hasValue, value=$value');
      
      if (fieldInput.autoForward == true && hasValue && widget.onAutoForward != null) {
        print('✅ Triggering auto-forward for field "$fieldName"');
        Future.delayed(const Duration(milliseconds: 100), () {
          if (widget.onAutoForward != null) {
            widget.onAutoForward!();
          }
        });
      } else {
        // Otherwise, check if all fields have autoForward: true
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_shouldAutoForward() && widget.onAutoForward != null) {
            widget.onAutoForward!();
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Wrap(
        spacing: 40,
        runSpacing: 0,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: widget.inputs.map((input) {
          final fieldType = (input.inputType ?? '').toLowerCase();
          final fieldName = (input.name ?? '').toLowerCase();

          // Determine if field should be full width on Web
          final bool isFullWidth = fieldType == 'textarea' ||
              fieldType == 'file' ||
              fieldType == 'files' ||
              fieldType == 'address' ||
              fieldName.contains('address') ||
              fieldName.contains('description') ||
              fieldName.contains('about');

          return SizedBox(
            width: isFullWidth ? double.infinity : 540, // Fits 2 columns in the 1200px constrained card
            child: _buildFormField(input),
          );
        }).toList(),
      );
    }

    return Column(
      children: widget.inputs.map((input) => _buildFormField(input)).toList(),
    );
  }

  Widget _buildFormField(RegisterInput input) {
    final fieldName = input.name ?? '';
    final fieldType = (input.inputType ?? '').toLowerCase();
    final label = input.label ?? '';
    final placeholder = input.placeholder ?? '';
    final isRequired = input.required ?? false;
    // Access formData value - GetX RxMap can be accessed like a regular Map
    final currentValue = widget.formData[fieldName];
    final error = widget.errors[fieldName];

    // Debug for files/photo fields
    if (fieldType == 'files' || fieldName == 'photo') {
      print('🎨 Building field "$fieldName" (type: $fieldType)');
      print('🎨 currentValue: $currentValue');
      print('🎨 currentValue type: ${currentValue?.runtimeType}');
      print('🎨 formData type: ${widget.formData.runtimeType}');
      print('🎨 formData keys: ${widget.formData.keys.toList()}');
      print(
        '🎨 formData contains "$fieldName": ${widget.formData.containsKey(fieldName)}',
      );
      if (currentValue != null) {
        print('🎨 currentValue is List: ${currentValue is List}');
        if (currentValue is List) {
          print('🎨 List length: ${currentValue.length}');
          if (currentValue.isNotEmpty) {
            print('🎨 First item: ${currentValue.first}');
            print('🎨 First item type: ${currentValue.first.runtimeType}');
          }
        }
      }
    }

    Widget fieldWidget;

    // Common config for Enter/Next behavior driven by enterEnable flag
    final isEnterEnabled = _isEnterNavigableField(input, fieldType);
    final isLastEnterField = _isLastEnterEnabledField(input, fieldType);

    TextInputAction _resolveTextInputAction() {
      if (!isEnterEnabled) {
        // When enterEnable is false, do not show "Next" behavior
        return TextInputAction.done;
      }
      return isLastEnterField ? TextInputAction.done : TextInputAction.next;
    }

    Function(String)? _resolveOnSubmitted() {
      if (isEnterEnabled && isLastEnterField && widget.onStepNext != null) {
        // On last enter-enabled field, pressing keyboard action moves to next step
        return (_) => widget.onStepNext!();
      }
      return null;
    }

    switch (fieldType) {
      case 'text':
        fieldWidget = _TextField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
          textInputAction: _resolveTextInputAction(),
          onSubmitted: _resolveOnSubmitted(),
          keyboardType: _getKeyboardType(input),
          maxLength: _getMaxLength(input),
          textCapitalization: _getTextCapitalization(fieldName, label),
        );
        break;

      case 'email':
        fieldWidget = _TextField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
          textInputAction: _resolveTextInputAction(),
          onSubmitted: _resolveOnSubmitted(),
          keyboardType: TextInputType.emailAddress,
        );
        break;

      case 'password':
        fieldWidget = _PasswordField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
          textInputAction: _resolveTextInputAction(),
          onSubmitted: _resolveOnSubmitted(),
        );
        break;

      case 'textarea':
        fieldWidget = _TextareaField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          isRequired: isRequired,
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
        );
        break;

      case 'address':
        final bool isAddressField =
            fieldName.toLowerCase().contains('address') ||
            label.toLowerCase().contains('address');

        if (isAddressField) {
          fieldWidget = _AddressField(
            label: label + (isRequired ? ' *' : ''),
            hintText: placeholder,
            initialValue: currentValue?.toString() ?? '',
            fieldName: fieldName,
            formData: widget.formData,
            onFieldChanged: (name, value, {bool isUserInteraction = false}) =>
                _handleFieldChanged(
                  name,
                  value,
                  isUserInteraction: isUserInteraction,
                ),
            keyboardType: _getKeyboardType(input),
            maxLength: _getMaxLength(input),
            textCapitalization: _getTextCapitalization(fieldName, label),
          );
        } else {
          fieldWidget = _TextField(
            label: label + (isRequired ? ' *' : ''),
            hintText: placeholder,
            initialValue: currentValue?.toString() ?? '',
            onChanged: (value) =>
                _handleFieldChanged(fieldName, value, isUserInteraction: true),
            textInputAction: _resolveTextInputAction(),
            onSubmitted: _resolveOnSubmitted(),
            keyboardType: _getKeyboardType(input),
            maxLength: _getMaxLength(input),
            textCapitalization: _getTextCapitalization(fieldName, label),
          );
        }

        break;

      case 'select':
        debugPrint("👉 API Raw value for '${input.name}' = ${input.value}");

        List<String> optionLabels = [];
        List<String> optionValues = [];

        /// Build options safely
        if (input.optionItems != null && input.optionItems!.isNotEmpty) {
          optionLabels = input.optionItems!
              .map((e) => e.label ?? '')
              .where((l) => l.trim().isNotEmpty)
              .toList();

          optionValues = input.optionItems!
              .map(
                (e) => (e.value != null && e.value!.trim().isNotEmpty)
                    ? e.value!.trim()
                    : (e.label ?? '').trim(),
              )
              .where((v) => v.isNotEmpty)
              .toList();

          if (optionLabels.length != optionValues.length) {
            optionValues = List<String>.from(optionLabels);
          }
        } else if (input.options != null && input.options!.isNotEmpty) {
          optionLabels = _extractOptionLabels(input.options!);
          optionValues = _extractOptionValues(input.options!);

          if (optionValues.isEmpty || optionValues.every((v) => v.isEmpty)) {
            optionValues = List<String>.from(optionLabels);
          }
        }

        /// SAFE INITIAL INDEX
        /// Priority: 1) User interaction (formData) > 2) API value (input.value) > 3) null
        int? safeInitialIndex;

        // Check if user has interacted with this field
        final hasUserInteracted = _userInteractedFields.contains(fieldName);

        // Determine which value to use for initial selection
        dynamic valueToUse;

        if (hasUserInteracted) {
          // User has interacted → use formData value (persist user selection)
          valueToUse = currentValue;
        } else {
          // No user interaction → use API value (input.value)
          // If API value is null, don't preselect anything
          valueToUse = input.value;
        }

        // Only set initialIndex if we have a valid value
        if (valueToUse != null &&
            valueToUse.toString().trim().isNotEmpty &&
            optionValues.isNotEmpty) {
          final valueStr = valueToUse.toString().trim();

          int idx = optionValues.indexOf(valueStr);

          if (idx == -1) {
            idx = optionValues.indexWhere(
              (v) => v.toLowerCase() == valueStr.toLowerCase(),
            );
          }

          if (idx == -1) {
            idx = optionLabels.indexWhere(
              (l) =>
                  l.toLowerCase() == valueStr.toLowerCase() ||
                  l.trim() == valueStr.trim(),
            );
          }

          safeInitialIndex = (idx != -1) ? idx : null;
        } else {
          // API value is null and user hasn't interacted → no selection
          safeInitialIndex = null;
        }

        debugPrint(
          "Select field '$fieldName' → initialIndex: $safeInitialIndex, API value: ${input.value}, formData value: $currentValue, userInteracted: $hasUserInteracted",
        );

        /// UI Rendering
        if (optionLabels.isEmpty) {
          fieldWidget = Text(
            '${label + (isRequired ? ' *' : '')}\nNo options available',
            style: AppTextStyle.description(color: Colors.red),
          );
        } else {
          fieldWidget = Column(
            key: ValueKey(fieldName),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label + (isRequired ? ' *' : ''),
                style: AppTextStyle.description(
                  fontWeight: FontWeight.w600,
                  color: AppColors.appBodyTextColor,
                ),
              ),
              CustomTabBar(
                tabs: optionLabels,
                textStyle: AppTextStyle.description(),
                initialIndex: safeInitialIndex, // NO DEFAULT if API null
                onTap: (index) {
                  _handleFieldChanged(
                    fieldName,
                    optionValues[index],
                    isUserInteraction: true,
                  );
                },
              ),
            ],
          );
        }

        break;

      case 'toggle':
        // Convert currentValue to bool, handling String, bool, and null cases
        bool boolValue = false;
        if (currentValue != null) {
          if (currentValue is bool) {
            boolValue = currentValue;
          } else if (currentValue is String) {
            final lowerValue = currentValue.toLowerCase().trim();
            boolValue =
                lowerValue == 'true' ||
                lowerValue == '1' ||
                lowerValue == 'yes';
          } else if (currentValue is int) {
            boolValue = currentValue != 0;
          }
        }
        fieldWidget = CustomToggle(
          label: label + (isRequired ? ' *' : ''),
          value: boolValue,
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
          isRequired: isRequired,
        );
        break;

      case 'file':
        // Determine allowed extensions and category
        final allowedExt = _getAllowedExtensions(input);
        final category = _getFileCategory(allowedExt);
        // Get image URL if saved (for non-File values that might be URLs)
        String? imageUrl;
        if (currentValue is String &&
            currentValue.toString().startsWith('http')) {
          imageUrl = currentValue.toString();
        } else if (currentValue is Map) {
          // Object with url property: {id: 2, type: null, url: "https://..."}
          final url = currentValue['url'];
          if (url != null && url.toString().startsWith('http')) {
            imageUrl = url.toString();
          }
        } else if (currentValue is List && currentValue.isNotEmpty) {
          // If it's a list, take the first item
          final firstItem = currentValue.first;
          if (firstItem is Map) {
            final url = firstItem['url'];
            if (url != null && url.toString().startsWith('http')) {
              imageUrl = url.toString();
            }
          } else if (firstItem is String &&
              firstItem.toString().startsWith('http')) {
            imageUrl = firstItem.toString();
          }
        }

        fieldWidget = CustomFilePicker(
          label: label + (isRequired ? ' *' : ''),
          fieldName: fieldName,
          value: currentValue is File ? currentValue : null,
          imageUrl: imageUrl,
          isImageFile: category == 'image',
          allowedExtensions: allowedExt,
          category: category,
          onPicked: (file) =>
              _handleFieldChanged(fieldName, file, isUserInteraction: true),
        );
        break;

      case 'files':
        // Multiple files picker
        final allowedExt = _getAllowedExtensions(input);
        final category = _getFileCategory(allowedExt);

        // DEBUG: Print all detection info
        print('🔍 ====== FILES INPUT DETECTION ======');
        print('📝 Field Name: $fieldName');
        print('🏷️  Label: $label');
        print('📋 Allowed Extensions: $allowedExt');
        print('📁 Detected Category: $category');
        print('🎬 Is Video? ${category == 'video'}');
        print('🖼️  Is Image? ${category == 'image'}');
        print('📄 Input Type: ${input.inputType}');

        // Additional check: If label contains "video" or fieldName contains "video", force video category
        final lowerLabel = label.toLowerCase();
        final lowerFieldName = fieldName.toLowerCase();
        final hasVideoInLabel =
            lowerLabel.contains('video') || lowerFieldName.contains('video');
        final hasImageInLabel =
            lowerLabel.contains('image') ||
            lowerLabel.contains('photo') ||
            lowerLabel.contains('picture');

        // Override category if label suggests video/image
        String finalCategory = category;
        if (hasVideoInLabel && !hasImageInLabel) {
          finalCategory = 'video';
          print('✅ OVERRIDE: Label suggests VIDEO, forcing category to VIDEO');
        } else if (hasImageInLabel && !hasVideoInLabel) {
          finalCategory = 'image';
          print('✅ OVERRIDE: Label suggests IMAGE, forcing category to IMAGE');
        }

        print('🎯 FINAL Category: $finalCategory');
        print('🔍 ====================================');

        // Get image URLs if saved (for non-File values that might be URLs)
        List<String>? imageUrls;

        print(
          '🔍 Files field "$fieldName" currentValue type: ${currentValue.runtimeType}',
        );
        print('🔍 Files field "$fieldName" currentValue: $currentValue');

        if (currentValue is List) {
          final tempUrls = <String>[];
          print('🔍 Processing List with ${currentValue.length} items');
          for (int i = 0; i < currentValue.length; i++) {
            final item = currentValue[i];
            print('🔍 Item $i type: ${item.runtimeType}, value: $item');

            if (item is String && item.startsWith('http')) {
              // Direct URL string
              print('✅ Found direct URL string: $item');
              tempUrls.add(item);
            } else if (item is Map) {
              // Object with url property: {id: 2, type: null, url: "https://..."}
              // Handle both Map<dynamic, dynamic> and Map<String, dynamic>
              print('✅ Found Map object, keys: ${item.keys.toList()}');
              dynamic url;
              if (item.containsKey('url')) {
                url = item['url'];
              } else if (item.containsKey('URL')) {
                url = item['URL'];
              }
              print('🔍 Extracted URL: $url (type: ${url.runtimeType})');
              if (url != null) {
                final urlStr = url.toString().trim();
                if (urlStr.startsWith('http')) {
                  print('✅ Adding URL: $urlStr');
                  tempUrls.add(urlStr);
                } else {
                  print('⚠️ URL does not start with http: $urlStr');
                }
              } else {
                print('⚠️ URL is null');
              }
            } else if (item != null) {
              final itemStr = item.toString().trim();
              if (itemStr.startsWith('http')) {
                print('✅ Found URL from toString: $itemStr');
                tempUrls.add(itemStr);
              }
            }
          }
          if (tempUrls.isNotEmpty) {
            imageUrls = tempUrls;
            print('✅ Final imageUrls: $imageUrls');
          } else {
            print('⚠️ No URLs extracted from list');
          }
        } else if (currentValue is String &&
            currentValue.toString().startsWith('http')) {
          imageUrls = [currentValue.toString()];
          print('✅ Found single URL string: $imageUrls');
        } else if (currentValue is Map) {
          // Single object with url property
          print(
            '✅ Found single Map object, keys: ${currentValue.keys.toList()}',
          );
          final url = currentValue['url'];
          if (url != null && url.toString().startsWith('http')) {
            imageUrls = [url.toString()];
            print('✅ Extracted single URL: $imageUrls');
          }
        } else {
          print(
            '⚠️ currentValue is not List, String, or Map. Type: ${currentValue.runtimeType}',
          );
        }

        print('🎯 Final imageUrls for "$fieldName": $imageUrls');

        fieldWidget = CustomMultipleFilePicker(
          label: label + (isRequired ? ' *' : ''),
          fieldName: fieldName,
          value: currentValue is List<File> ? currentValue : null,
          imageUrls: imageUrls,
          isImageFile: finalCategory == 'image',
          allowedExtensions: allowedExt,
          category: finalCategory, // Use finalCategory instead of category
          onPicked: (files) =>
              _handleFieldChanged(fieldName, files, isUserInteraction: true),
        );
        break;

      case 'datetime':
        DateTime? dateTimeValue;
        if (currentValue is DateTime) {
          dateTimeValue = currentValue;
        } else if (currentValue is String && currentValue.isNotEmpty) {
          try {
            dateTimeValue = DateTime.parse(currentValue);
          } catch (e) {
            dateTimeValue = null;
          }
        }
        fieldWidget = CustomDateTimePicker(
          label: label + (isRequired ? ' *' : ''),
          value: dateTimeValue,
          onChanged: (value) {
            if (value != null) {
              _handleFieldChanged(
                fieldName,
                value.toIso8601String(),
                isUserInteraction: true,
              );
            } else {
              _handleFieldChanged(fieldName, '', isUserInteraction: true);
            }
          },
        );
        break;

      case 'number':
        fieldWidget = _TextField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
          textInputAction: _resolveTextInputAction(),
          onSubmitted: _resolveOnSubmitted(),
          keyboardType: TextInputType.number,
        );
        break;

      case 'custom_input_increase_decrease':
        fieldWidget = CustomInputIncreaseDecrease(
          label: label,
          // label: label + (isRequired ? ' *' : ''),
          name: fieldName,
          value: currentValue,
          validations: input.validations ?? [],
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
          required: isRequired,
        );
        break;
      case 'button':
        fieldWidget = CustomButton(
          text: label,
          onTap: () =>
              _handleFieldChanged(fieldName, true, isUserInteraction: true),
          backgroundColor: AppColors.appButtonColor,
        );
        break;
      case 'checkbox':
        // Support both single checkbox and multi-select checkbox (with options)
        final hasOptions =
            (input.optionItems != null && input.optionItems!.isNotEmpty) ||
            (input.options != null && input.options!.isNotEmpty);

        if (!hasOptions) {
          // Original single boolean checkbox behavior
          bool boolValue = false;

          if (currentValue is bool) {
            boolValue = currentValue;
          } else if (currentValue is String) {
            boolValue =
                currentValue.toLowerCase() == "true" || currentValue == "1";
          }

          fieldWidget = CustomCheckbox(
            value: boolValue,
            title: label + (isRequired ? " *" : ""),
            onChanged: (val) =>
                _handleFieldChanged(fieldName, val, isUserInteraction: true),
          );
        } else {
          // Multi-select checkbox list using same UI (CustomCheckbox) for each option
          // Normalize options to (label, value)
          final List<String> optionLabels = [];
          final List<String> optionValues = [];

          if (input.optionItems != null && input.optionItems!.isNotEmpty) {
            for (final item in input.optionItems!) {
              final optLabel = (item.label ?? '').trim();
              final optValue = (item.value ?? item.label ?? '')
                  .toString()
                  .trim();
              if (optLabel.isNotEmpty && optValue.isNotEmpty) {
                optionLabels.add(optLabel);
                optionValues.add(optValue);
              }
            }
          } else if (input.options != null && input.options!.isNotEmpty) {
            // Legacy options list which may be plain strings or "label:value"
            final labels = _extractOptionLabels(input.options!);
            final values = _extractOptionValues(input.options!);

            for (int i = 0; i < labels.length; i++) {
              final l = labels[i].trim();
              final v = (i < values.length ? values[i] : '').trim();
              if (l.isEmpty) continue;
              optionLabels.add(l);
              optionValues.add(v.isNotEmpty ? v : l);
            }
          }

          // Prepare selected values set (always work with List<String> in formData)
          final Set<String> selected = {};
          if (currentValue is List) {
            for (final v in currentValue) {
              if (v != null) selected.add(v.toString());
            }
          } else if (currentValue is String && currentValue.isNotEmpty) {
            final valueStr = currentValue.trim();
            // Check if it's a string representation of a list like "[used, new]"
            if (valueStr.startsWith('[') && valueStr.endsWith(']')) {
              try {
                // Try to parse as JSON array
                final parsed = jsonDecode(valueStr) as List;
                for (final v in parsed) {
                  if (v != null) selected.add(v.toString());
                }
              } catch (e) {
                // If JSON parsing fails, try manual parsing
                final cleaned = valueStr
                    .replaceAll('[', '')
                    .replaceAll(']', '')
                    .replaceAll('"', '')
                    .replaceAll("'", '');
                final parts = cleaned
                    .split(',')
                    .map((e) => e.trim())
                    .where((e) => e.isNotEmpty);
                selected.addAll(parts);
              }
            } else {
              // Support comma-separated string from API / backend
              final parts = valueStr
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty);
              selected.addAll(parts);
            }
          }

          fieldWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label + (isRequired ? " *" : ""),
                style: AppTextStyle.description(
                  color: AppColors.appBodyTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...List.generate(optionLabels.length, (index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: CustomCheckbox(
                    value: selected.contains(optionValues[index]),
                    title: optionLabels[index],
                    onChanged: (val) {
                      if (val == true) {
                        selected.add(optionValues[index]);
                      } else {
                        selected.remove(optionValues[index]);
                      }
                      _handleFieldChanged(
                        fieldName,
                        selected.toList(),
                        isUserInteraction: true,
                      );
                    },
                  ),
                );
              }),
            ],
          );
        }
        break;

      case 'custom_horizontal_bullets':
        List<String> bulletItems = [];
        if (input.optionItems != null && input.optionItems!.isNotEmpty) {
          bulletItems = input.optionItems!.map((e) => e.label ?? '').toList();
        } else if (input.options != null && input.options!.isNotEmpty) {
          bulletItems = input.options!;
        }

        fieldWidget = CustomHorizontalBullets(
          items: bulletItems,
          textStyle: AppTextStyle.description(),
        );
        break;

      case 'custom_input_plus_minus':
        fieldWidget = CustomInputPlusMinus(
          label: label,
          name: fieldName,
          value: currentValue,
          validations: input.validations ?? [],
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
          required: isRequired,
        );
        break;

      case 'radio':
        List<String> labels = [];
        List<String> values = [];

        if (input.optionItems != null && input.optionItems!.isNotEmpty) {
          labels = input.optionItems!
              .map((e) => e.label ?? "")
              .where((l) => l.isNotEmpty)
              .toList();
          values = input.optionItems!
              .map((e) => e.value ?? e.label ?? "")
              .where((v) => v.isNotEmpty)
              .toList();

          // Ensure both lists have same length
          if (labels.length != values.length) {
            // If mismatch, use labels as values
            values = List<String>.from(labels);
          }
        }

        // Handle empty options case
        if (labels.isEmpty || values.isEmpty) {
          fieldWidget = Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '${label + (isRequired ? " *" : "")}\nNo options available',
              style: AppTextStyle.description(color: Colors.red),
            ),
          );
        } else {
          // Get current value as string, defaulting to empty string if null
          final currentValueStr = currentValue?.toString() ?? '';

          fieldWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label + (isRequired ? " *" : ""),
                style: AppTextStyle.description(
                  color: AppColors.appBodyTextColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              for (int i = 0; i < labels.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: CustomRadioButton<String>(
                    value: values[i],
                    groupValue: currentValueStr,
                    title: labels[i],
                    onChanged: (val) => _handleFieldChanged(
                      fieldName,
                      val,
                      isUserInteraction: true,
                    ),
                  ),
                ),
            ],
          );
        }
        break;
      case 'dropdown':
        List<String> labels = [];
        List<String> values = [];

        if (input.optionItems != null) {
          labels = input.optionItems!.map((e) => e.label ?? "").toList();
          values = input.optionItems!
              .map((e) => e.value ?? e.label ?? "")
              .toList();
        }

        // Convert currentValue into correct dropdown value
        String? selectedValue;
        if (currentValue != null) {
          if (values.contains(currentValue.toString())) {
            selectedValue = currentValue.toString();
          } else {
            int index = labels.indexOf(currentValue.toString());
            if (index != -1) {
              selectedValue = values[index];
            }
          }
        }

        fieldWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label + (isRequired ? " *" : ""),
              style: AppTextStyle.description(
                color: AppColors.appBodyTextColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),

            CustomDropdown<String>(
              value: selectedValue,
              items: values,
              hintText: placeholder.isNotEmpty ? placeholder : "Select",
              itemToString: (v) {
                final index = values.indexOf(v);
                return labels[index];
              },
              onChanged: (val) {
                // Only trigger if value is not null (user actually selected something)
                if (val != null) {
                  print('📋 Dropdown "$fieldName" changed to: $val, autoForward: ${input.autoForward}');
                  _handleFieldChanged(fieldName, val, isUserInteraction: true, input: input);
                } else {
                  print('⚠️ Dropdown "$fieldName" changed to null, skipping auto-forward');
                }
              },
            ),
          ],
        );
        break;

      case 'date': // date picker
        DateTime? dateValue;
        if (currentValue is DateTime) {
          dateValue = currentValue;
        } else if (currentValue is String && currentValue.isNotEmpty) {
          try {
            dateValue = DateTime.parse(currentValue);
          } catch (e) {
            dateValue = null;
          }
        }

        fieldWidget = CustomDatePicker(
          label: label + (isRequired ? ' *' : ''),
          value: dateValue,
          onChanged: (pickedDate) {
            if (pickedDate != null) {
              _handleFieldChanged(
                fieldName,
                pickedDate.toIso8601String(),
                isUserInteraction: true,
              );
            } else {
              _handleFieldChanged(fieldName, "", isUserInteraction: true);
            }
          },
        );
      //   break;

      case 'daterange':
        DateTime? start;
        DateTime? end;

        if (currentValue is String && currentValue.contains('|')) {
          final parts = currentValue.split('|');
          try {
            start = DateTime.parse(parts[0]);
            end = DateTime.parse(parts[1]);
          } catch (e) {
            start = null;
            end = null;
          }
        }

        fieldWidget = CustomDateRangePicker(
          label: label + (isRequired ? ' *' : ''),
          value: (start != null && end != null)
              ? DateTimeRange(start: start, end: end)
              : null,
          onChanged: (range) {
            if (range != null) {
              _handleFieldChanged(
                fieldName,
                "${range.start.toIso8601String()}|${range.end.toIso8601String()}",
                isUserInteraction: true,
              );
            } else {
              _handleFieldChanged(fieldName, "", isUserInteraction: true);
            }
          },
        );
        break;

      case 'datetimerange':
        DateTimeRangeResult? dateTimeRangeValue;

        if (currentValue is String && currentValue.contains('|')) {
          final parts = currentValue.split('|');
          try {
            final start = DateTime.parse(parts[0]);
            final end = DateTime.parse(parts[1]);
            dateTimeRangeValue = DateTimeRangeResult(start: start, end: end);
          } catch (e) {
            dateTimeRangeValue = null;
          }
        }

        fieldWidget = CustomDateTimeRangePicker(
          label: label + (isRequired ? ' *' : ''),
          value: dateTimeRangeValue,
          onChanged: (range) {
            if (range != null) {
              _handleFieldChanged(
                fieldName,
                "${range.start.toIso8601String()}|${range.end.toIso8601String()}",
                isUserInteraction: true,
              );
            } else {
              _handleFieldChanged(fieldName, "", isUserInteraction: true);
            }
          },
        );
        break;

      case 'group':
        // Group inputs should not create any UI element
        return const SizedBox.shrink();

      case 'hidden':
        // Group inputs should not create any UI element
        return const SizedBox.shrink();

      case 'custom_coupon_apply_field':
        Widget nestedForm = const SizedBox.shrink();

        if (input.design != null && input.design!['inputs'] != null) {
          final inputsMap = input.design!['inputs'];
          final nestedInputs = <RegisterInput>[];

          if (inputsMap is Map) {
            inputsMap.forEach((key, value) {
              if (value is Map<String, dynamic>) {
                // Fix typo from backend if present
                if (value['input_type'] == 'botton') {
                  value['input_type'] = 'button';
                }
                nestedInputs.add(RegisterInput.fromJson(value));
              }
            });
          }

        if (nestedInputs.isNotEmpty) {
            nestedForm = DynamicFormBuilder(
              inputs: nestedInputs,
              formData: widget.formData,
              onFieldChanged: widget.onFieldChanged,
              errors: widget.errors,
            );
          }
        }

        fieldWidget = Obx(() {
            bool isApplied = false;
             if (Get.isRegistered<CartController>()) {
              isApplied = Get.find<CartController>().isCouponApplied.value;
            }
            return Column(
              children: [
                _CouponApplyField(
                  label: label,
                  hintText: placeholder,
                  initialValue: currentValue?.toString() ?? '',
                  isApplied: isApplied,
                  onChanged: (value) => _handleFieldChanged(fieldName, value,
                      isUserInteraction: true),
                  onApply: () {
                    debugPrint("🟢 Apply button clicked");

                    final value = widget.formData[fieldName];
                    debugPrint("📌 Field Name: $fieldName");
                    debugPrint("📌 Field Value: $value");

                    _handleFieldChanged(
                      fieldName,
                      value,
                      isUserInteraction: true,
                      input: input,
                    );

                    // Check for API endpoint in design
                    if (input.design != null && input.design!['api_endpoint'] != null) {
                      debugPrint("✅ API endpoint found in design");

                      try {
                        if (Get.isRegistered<CartController>()) {
                          debugPrint("✅ CartController is registered");

                          final controller = Get.find<CartController>();
                          final code = value?.toString() ?? '';

                          debugPrint("🎟 Coupon Code: '$code'");
                          debugPrint("🌐 API Endpoint: ${input.design!['api_endpoint']}");

                          if (code.isNotEmpty) {
                            debugPrint("🚀 Calling applyCoupon API");

                            controller.applyCoupon(
                              endpoint: input.design!['api_endpoint'],
                              couponCode: code,
                            );
                          } else {
                            debugPrint("⚠️ Coupon code is empty");
                          }
                        } else {
                          debugPrint("❌ CartController NOT found");
                        }
                      } catch (e, stack) {
                        debugPrint("❌ Error triggering coupon API: $e");
                        debugPrint("📛 StackTrace: $stack");
                      }
                    } else {
                      debugPrint("⚠️ No api_endpoint found in input.design");
                    }
                  },

                ),
                SizedBox(height: 10.h,),
                nestedForm,
              ],
            );
        });
        break;

      default:
        fieldWidget = _TextField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) =>
              _handleFieldChanged(fieldName, value, isUserInteraction: true),
        );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          fieldWidget,
          if (error != null) ...[
            const SizedBox(height: 4),
            Text(error, style: AppTextStyle.body(color: Colors.red)),
          ],
        ],
      ),
    );
  }

  TextInputType _getKeyboardType(RegisterInput input) {
    final validations = input.validations ?? [];
    for (final validation in validations) {
      if (validation.type?.toLowerCase() == 'numeric') {
        return TextInputType.number;
      }
    }
    return TextInputType.text;
  }

  int? _getMaxLength(RegisterInput input) {
    final validations = input.validations ?? [];
    for (final validation in validations) {
      if (validation.type?.toLowerCase() == 'exact_length' &&
          validation.value != null) {
        return validation.value;
      }
    }
    return null;
  }

  TextCapitalization _getTextCapitalization(String fieldName, String label) {
    final lowerFieldName = fieldName.toLowerCase();
    final lowerLabel = label.toLowerCase();

    // Check for PAN card fields
    if (lowerFieldName.contains('pan') || lowerLabel.contains('pan')) {
      return TextCapitalization.characters;
    }

    // Check for GSTN fields
    if (lowerFieldName.contains('gst') || lowerLabel.contains('gst')) {
      return TextCapitalization.characters;
    }

    // Default to none for other fields
    return TextCapitalization.none;
  }

  List<String> _extractOptionLabels(List<String> options) {
    // Options may be plain labels or JSON-like 'label:value'. Keep simple.
    return options.map((e) {
      if (e.contains(':')) {
        return e.split(':').first.trim();
      }
      return e;
    }).toList();
  }

  List<String> _extractOptionValues(List<String> options) {
    return options.map((e) {
      if (e.contains(':')) {
        final parts = e.split(':');
        return parts.length > 1 ? parts[1].trim() : '';
      }
      return '';
    }).toList();
  }

  // Extract allowed extensions from validations
  List<String> _getAllowedExtensions(RegisterInput input) {
    final validations = input.validations ?? [];
    final List<String> exts = [];

    print('🔍 Extracting extensions from validations...');
    print('📋 Total validations: ${validations.length}');

    // Known extension lists for validation
    final allVideoExts = {
      'mp4',
      'mov',
      'mkv',
      'avi',
      'webm',
      '3gp',
      'hevc',
      'h265',
      'h.265',
    };
    final allImageExts = {
      'jpg',
      'jpeg',
      'png',
      'webp',
      'gif',
      'bmp',
      'heif',
      'heic',
      'avif',
      'svg',
    };
    final allDocExts = {
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
      'rtf',
      'epub',
      'csv',
    };
    final allKnownExts = {...allVideoExts, ...allImageExts, ...allDocExts};

    for (final v in validations) {
      print('  📝 Validation type: ${v.type}');
      print('  📝 Validation value: ${v.value}');
      print('  📝 Validation value String: ${v.stringValue}');

      // ONLY extract from validation.value, NOT from error messages
      if (v.type == 'file' && v.stringValue != null) {
        print(
          '  ✅ Processing file validation value: ${v.stringValue.toString().trim()}',
        );
        final valueStr = v.stringValue?.trim();
        print('  ✅ Processing file validation value: $valueStr');

        // Split by comma, space, or pipe
        final parts = valueStr
            ?.split(RegExp(r'[\s,|/]+'))
            .where((e) => e.isNotEmpty)
            .toList();

        for (final p in parts!) {
          final cleanExt = p.toLowerCase().trim();
          // Remove any leading dots or special chars
          final ext = cleanExt.replaceAll(RegExp(r'^[.\s]+|[.\s]+$'), '');

          // Only add if it's a known extension (2-5 chars, alphanumeric)
          if (ext.length >= 2 &&
              ext.length <= 5 &&
              RegExp(r'^[a-z0-9.]+$').hasMatch(ext)) {
            // Check if it's a valid known extension
            if (allKnownExts.contains(ext)) {
              print('  ✅ Valid extension found: $ext');
              exts.add(ext);
            } else {
              print('  ⚠️  Skipping unknown extension: $ext');
            }
          }
        }
      }
    }

    // Deduplicate
    final finalExts = exts.toSet().toList();
    print('📋 Final extracted extensions: $finalExts');
    return finalExts;
  }

  // Determine category from extensions
  String _getFileCategory(List<String> exts) {
    print('🔍 Determining category from extensions: $exts');

    final imageSet = {
      'jpg',
      'jpeg',
      'png',
      'webp',
      'heif',
      'heic',
      'gif',
      'bmp',
      'avif',
      'svg',
    };
    final videoSet = {
      'mp4',
      'mov',
      'mkv',
      'avi',
      'webm',
      '3gp',
      'hevc',
      'h265',
      'h.265',
    };
    final docSet = {
      'pdf',
      'doc',
      'docx',
      'xls',
      'xlsx',
      'ppt',
      'pptx',
      'txt',
      'rtf',
      'epub',
      'csv',
    };

    final hasImage = exts.any((e) => imageSet.contains(e));
    final hasVideo = exts.any((e) => videoSet.contains(e));
    final hasDoc = exts.any((e) => docSet.contains(e));

    print('  🖼️  Has Image Ext: $hasImage');
    print('  🎬 Has Video Ext: $hasVideo');
    print('  📄 Has Doc Ext: $hasDoc');

    if (hasImage) {
      print('  ✅ Category: IMAGE');
      return 'image';
    }
    if (hasVideo) {
      print('  ✅ Category: VIDEO');
      return 'video';
    }
    if (hasDoc) {
      print('  ✅ Category: DOCUMENT');
      return 'document';
    }
    print('  ✅ Category: ANY (default)');
    return 'any';
  }
}

class _TextField extends StatefulWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final Function(String) onChanged;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;
  final TextInputType keyboardType;
  final int? maxLength;
  final TextCapitalization textCapitalization;

  const _TextField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<_TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<_TextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_TextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if the initial value changed AND user hasn't modified the text
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text == oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      label: widget.label,
      hintText: widget.hintText,
      controller: _controller,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      onChanged: widget.onChanged,
    );
  }
}

class _PasswordField extends StatefulWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final Function(String) onChanged;
  final TextInputAction textInputAction;
  final Function(String)? onSubmitted;

  const _PasswordField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onChanged,
    this.textInputAction = TextInputAction.next,
    this.onSubmitted,
  });

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  late TextEditingController _controller;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_PasswordField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update if the initial value changed AND user hasn't modified the text
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text == oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextfield(
      label: widget.label,
      hintText: widget.hintText,
      controller: _controller,
      obscureText: _obscureText,
      textInputAction: widget.textInputAction,
      onSubmitted: widget.onSubmitted,
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.appIconColor,
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

class _TextareaField extends StatefulWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final bool isRequired;
  final Function(String) onChanged;

  const _TextareaField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.isRequired,
    required this.onChanged,
  });

  @override
  State<_TextareaField> createState() => _TextareaFieldState();
}

class _TextareaFieldState extends State<_TextareaField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(_propagateChange);
  }

  @override
  void didUpdateWidget(_TextareaField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update only if parent value truly changed and user hasn't typed over it
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text == oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  void _propagateChange() {
    widget.onChanged(_controller.text);
  }

  @override
  void dispose() {
    _controller.removeListener(_propagateChange);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextarea(
      label: widget.label,
      hintText: widget.hintText,
      controller: _controller,
      isRequired: widget.isRequired,
    );
  }
}

class _AddressField extends StatefulWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final String fieldName;
  final Map<String, dynamic> formData;
  final Function(String, dynamic, {bool isUserInteraction}) onFieldChanged;
  final TextInputType keyboardType;
  final int? maxLength;
  final TextCapitalization textCapitalization;

  const _AddressField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.fieldName,
    required this.formData,
    required this.onFieldChanged,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  State<_AddressField> createState() => _AddressFieldState();
}

class _AddressFieldState extends State<_AddressField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_AddressField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update controller when initial value changes from parent
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text == oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _openLocationPicker() async {
    final homeController = Get.find<ClientHomeController>();

    // Try to get existing lat/lng from formData (for editing existing address)
    double initialLat;
    double initialLng;

    // Check for latitude and longitude in formData
    final existingLat = widget.formData['latitude'];
    final existingLng = widget.formData['longitude'];

    if (existingLat != null && existingLng != null) {
      // Use existing address coordinates if available
      final lat = double.tryParse(existingLat.toString());
      final lng = double.tryParse(existingLng.toString());
      if (lat != null && lng != null) {
        initialLat = lat;
        initialLng = lng;
      } else {
        // Parsing failed → try geocoding from address string, else fallback
        final coords = await _tryGeocodeFromAddress(
          widget.formData[widget.fieldName] ?? widget.initialValue,
        );
        if (coords != null) {
          initialLat = coords.latitude;
          initialLng = coords.longitude;
        } else {
          initialLat = homeController.currentLatLng.value.latitude;
          initialLng = homeController.currentLatLng.value.longitude;
        }
      }
    } else {
      // No coords saved yet → try geocoding from current address text first
      final coords = await _tryGeocodeFromAddress(
        widget.formData[widget.fieldName] ?? widget.initialValue,
      );
      if (coords != null) {
        initialLat = coords.latitude;
        initialLng = coords.longitude;
      } else {
        // Fallback to current location if we can't geocode
        initialLat = homeController.currentLatLng.value.latitude;
        initialLng = homeController.currentLatLng.value.longitude;
      }
    }

    await Get.to(
      () => LocationPickerScreen(
        initialLat: initialLat,
        initialLng: initialLng,
        onLocationSelected: (latLng, address) {
          // Update the controller with selected address
          setState(() {
            _controller.text = address;
          });
          // Update the main address field (user-selected address)
          widget.onFieldChanged(
            widget.fieldName,
            address,
            isUserInteraction: true,
          );

          // Also update generic latitude and longitude if they exist in formData structure
          if (widget.formData.containsKey('latitude')) {
            widget.onFieldChanged(
              'latitude',
              latLng.latitude.toString(),
              isUserInteraction: false,
            );
          }
          if (widget.formData.containsKey('longitude')) {
            widget.onFieldChanged(
              'longitude',
              latLng.longitude.toString(),
              isUserInteraction: false,
            );
          }

          // Special hidden fields for selected address lat/long (for current step API)
          // In API config: input_type: "hidden", name: "address_lat" / "address_long"
          widget.onFieldChanged(
            'address_lat',
            latLng.latitude.toString(),
            isUserInteraction: false,
          );
          widget.onFieldChanged(
            'address_long',
            latLng.longitude.toString(),
            isUserInteraction: false,
          );
        },
      ),
    );
  }

  /// Try to convert a free-text address into coordinates using geocoding.
  /// Returns null if geocoding fails.
  Future<Location?> _tryGeocodeFromAddress(dynamic addressValue) async {
    try {
      final text = addressValue?.toString().trim();
      if (text == null || text.isEmpty) return null;
      final results = await locationFromAddress(text);
      if (results.isNotEmpty) return results.first;
    } catch (_) {
      // Ignore geocoding errors and let caller fallback
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextfieldForAddress(
      label: widget.label,
      hintText: widget.hintText,
      controller: _controller,
      readOnly: true, // User cannot type manually
      enabled: true, // Field is enabled for tapping
      onTap: _openLocationPicker, // Open location picker on tap
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      textCapitalization: widget.textCapitalization,
      suffixIcon: Icon(Icons.location_on, color: AppColors.appIconColor),
      onSuffixTap: _openLocationPicker, // Open location picker on suffix tap
    );
  }
}

class DynamicFormValidator {
  static Map<String, String> validateForm(
    List<RegisterInput> inputs,
    Map<String, dynamic> formData,
  ) {
    Map<String, String> errors = {};

    for (final input in inputs) {
      final fieldName = input.name ?? '';
      final fieldType = (input.inputType ?? 'text').toLowerCase();
      final isRequired = input.required ?? false;
      final value = formData[fieldName];

      // Skip validation for group inputs
      if (fieldType == 'group') {
        continue;
      }

      // Required validation
      if (isRequired && (value == null || value.toString().isEmpty)) {
        errors[fieldName] = '${input.label ?? 'This field'} is required';
        continue;
      }

      // Skip other validations if field is empty and not required
      if (value == null || value.toString().isEmpty) {
        continue;
      }

      final validations = input.validations ?? [];
      for (final validation in validations) {
        final validationType = validation.type?.toLowerCase() ?? '';
        final errorMessage = validation.errorMessage ?? 'Invalid input';

        switch (validationType) {
          case 'numeric':
            if (!RegExp(r'^\d+$').hasMatch(value.toString())) {
              errors[fieldName] = errorMessage;
            }
            break;

          case 'exact_length':
            if (validation.value != null &&
                value.toString().length != validation.value) {
              errors[fieldName] = errorMessage;
            }
            break;

          case 'min_length':
            if (validation.value != null &&
                value.toString().length < validation.value!) {
              errors[fieldName] = validation.minLengthError ?? errorMessage;
            }
            break;

          case 'max_length':
            if (validation.value != null &&
                value.toString().length > validation.value!) {
              errors[fieldName] = validation.maxLengthError ?? errorMessage;
            }
            break;

          case 'regex':
          case 'pattern':
            // Accept pattern from either pattern or value (string)
            final patt =
                validation.pattern ??
                (validation.value is String
                    ? validation.value as String
                    : null);
            if (patt != null && !RegExp(patt).hasMatch(value.toString())) {
              errors[fieldName] =
                  validation.patternErrorMessage ?? errorMessage;
            }
            break;

          case 'matches':
            if (validation.field != null &&
                formData[validation.field] != value) {
              errors[fieldName] = errorMessage;
            }
            break;
        }

        // Break if we found an error for this field
        if (errors.containsKey(fieldName)) {
          break;
        }
      }
    }

    return errors;
  }
}

// Widget to wrap CustomTabBar for select fields with initial selection support
class _SelectTabBarWidget extends StatefulWidget {
  final String label;
  final List<String> optionLabels;
  final List<String> optionValues;
  final int initialIndex;
  final Function(String) onValueChanged;

  const _SelectTabBarWidget({
    required this.label,
    required this.optionLabels,
    required this.optionValues,
    required this.initialIndex,
    required this.onValueChanged,
  });

  @override
  State<_SelectTabBarWidget> createState() => _SelectTabBarWidgetState();
}

class _SelectTabBarWidgetState extends State<_SelectTabBarWidget> {
  late int selectedIndex;

  @override
  void initState() {
    super.initState();
    // Ensure initialIndex is within bounds
    selectedIndex =
        widget.initialIndex >= 0 &&
            widget.initialIndex < widget.optionLabels.length
        ? widget.initialIndex
        : 0;
  }

  @override
  void didUpdateWidget(_SelectTabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected index if initialIndex changed
    if (widget.initialIndex != oldWidget.initialIndex) {
      selectedIndex =
          widget.initialIndex >= 0 &&
              widget.initialIndex < widget.optionLabels.length
          ? widget.initialIndex
          : 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(widget.label, style: AppTextStyle.title()),
          ),
        Container(
          height: 50,
          alignment: Alignment.centerLeft,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: widget.optionLabels.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () {
                  setState(() => selectedIndex = index);
                  // Get the value for this index
                  final value =
                      index < widget.optionValues.length &&
                          widget.optionValues[index].isNotEmpty
                      ? widget.optionValues[index]
                      : widget.optionLabels[index];
                  widget.onValueChanged(value);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.appColor : Colors.white,
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppColors.appColor,
                              AppColors.appColor.withOpacity(0.7),
                            ],
                          )
                        : null,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.appColor.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : [],
                    border: Border.all(
                      color: isSelected
                          ? AppColors.appColor
                          : AppColors.appTextColor.withOpacity(0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    widget.optionLabels[index],
                    style: AppTextStyle.description(
                      color: isSelected ? Colors.white : AppColors.appTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CouponApplyField extends StatefulWidget {
  final String label;
  final String hintText;
  final String initialValue;
  final Function(String) onChanged;
  final VoidCallback onApply;
  final bool? isApplied;

  const _CouponApplyField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onChanged,
    required this.onApply,
    this.isApplied,
  });

  @override
  State<_CouponApplyField> createState() => _CouponApplyFieldState();
}

class _CouponApplyFieldState extends State<_CouponApplyField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
    _controller.addListener(() {
      widget.onChanged(_controller.text);
    });
  }

  @override
  void didUpdateWidget(_CouponApplyField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue &&
        _controller.text == oldWidget.initialValue) {
      _controller.text = widget.initialValue;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCouponApplyField(
      controller: _controller,
      label: widget.label,
      hintText: widget.hintText,
      onApply: widget.onApply,
      isApplied: widget.isApplied ?? false,
    );
  }
}
