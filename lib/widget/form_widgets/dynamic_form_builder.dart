import 'dart:io';
import 'package:flutter/material.dart';
import '../../core/app_textstyle.dart';
import '../../models/App_moduls/AppResponseModel.dart';
import '../custom_tapbar.dart';
import 'app_button.dart';
import 'app_checkbox.dart';
import 'app_date_picker.dart';
import 'app_dropdown.dart';
import 'app_radiobutton.dart';
import 'app_textfield.dart';
import 'custom_textarea.dart';
import 'custom_toggle.dart';
import 'custom_file_picker.dart';
import 'custom_multiple_file_picker.dart';
import 'custom_date_time.dart';
import '../../core/app_color.dart';

class DynamicFormBuilder extends StatefulWidget {
  final List<RegisterInput> inputs;
  final Map<String, dynamic> formData;
  final Function(String, dynamic) onFieldChanged;
  final Map<String, String> errors;

  const DynamicFormBuilder({
    super.key,
    required this.inputs,
    required this.formData,
    required this.onFieldChanged,
    required this.errors,
  });

  @override
  State<DynamicFormBuilder> createState() => _DynamicFormBuilderState();
}

class _DynamicFormBuilderState extends State<DynamicFormBuilder> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: widget.inputs.map((input) => _buildFormField(input)).toList(),
    );
  }

  Widget _buildFormField(RegisterInput input) {
    final fieldName = input.name ?? '';
    final fieldType = (input.inputType ?? 'text').toLowerCase();
    final label = input.label ?? '';
    final placeholder = input.placeholder ?? '';
    final isRequired = input.required ?? false;
    final currentValue = widget.formData[fieldName];
    final error = widget.errors[fieldName];

    Widget fieldWidget;

    switch (fieldType) {
      case 'text':
        fieldWidget = _TextField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) => widget.onFieldChanged(fieldName, value),
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
          onChanged: (value) => widget.onFieldChanged(fieldName, value),
          keyboardType: TextInputType.emailAddress,
        );
        break;

      case 'password':
        fieldWidget = _PasswordField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) => widget.onFieldChanged(fieldName, value),
        );
        break;

      case 'textarea':
        fieldWidget = _TextareaField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          isRequired: isRequired,
          onChanged: (value) => widget.onFieldChanged(fieldName, value),
        );
        break;

      case 'select':
        // Use CustomTabBar for ALL select fields
        List<String> optionLabels = [];
        List<String> optionValues = [];
        
        if (input.optionItems != null && input.optionItems!.isNotEmpty) {
          // Extract labels and values from optionItems
          optionLabels = input.optionItems!.map((e) => e.label ?? '').where((l) => l.isNotEmpty).toList();
          optionValues = input.optionItems!.map((e) {
            // Prefer value over label, but use label if value is null/empty
            return (e.value != null && e.value!.isNotEmpty) ? e.value! : (e.label ?? '');
          }).where((v) => v.isNotEmpty).toList();
          
          // Ensure both lists have same length
          if (optionLabels.length != optionValues.length) {
            // If mismatch, use labels as values
            optionValues = List<String>.from(optionLabels);
          }
        } else if (input.options != null && input.options!.isNotEmpty) {
          // Use legacy options list
          optionLabels = _extractOptionLabels(input.options!);
          optionValues = _extractOptionValues(input.options!);
          
          // If optionValues are empty, use labels as values
          if (optionValues.isEmpty || optionValues.every((v) => v.isEmpty)) {
            optionValues = List<String>.from(optionLabels);
          }
        } else {
          // Fallback to empty lists (will show empty tab bar)
          optionLabels = [];
          optionValues = [];
        }

        // Find initial selected index based on current value
        String? currentValueStr = currentValue?.toString();
        int initialIndex = 0;
        if (currentValueStr != null && currentValueStr.isNotEmpty && optionValues.isNotEmpty) {
          // Try to find index by value first
          final valueIndex = optionValues.indexWhere((v) => v == currentValueStr);
          if (valueIndex != -1) {
            initialIndex = valueIndex;
          } else {
            // Try to find index by label
            final labelIndex = optionLabels.indexWhere((l) => l == currentValueStr);
            if (labelIndex != -1) {
              initialIndex = labelIndex;
            }
          }
        }

        // Ensure we have options before rendering
        if (optionLabels.isEmpty) {
          fieldWidget = Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '${label + (isRequired ? ' *' : '')}\nNo options available',
              style: AppTextStyle.description(
                color: Colors.red,
              ),
            ),
          );
        } else {
          fieldWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  label + (isRequired ? ' *' : ''),
                  style: AppTextStyle.description(
                    fontWeight: FontWeight.w600,
                    color: AppColors.appBodyTextColor
                  ),
                ),
              ),

              CustomTabBar(
                tabs: optionLabels,
                height: 55,
                textStyle: AppTextStyle.description(),
                // initialIndex: initialIndex,
                onTap: (index) {
                  widget.onFieldChanged(fieldName, optionValues[index]);
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
            boolValue = lowerValue == 'true' || lowerValue == '1' || lowerValue == 'yes';
          } else if (currentValue is int) {
            boolValue = currentValue != 0;
          }
        }
        fieldWidget = CustomToggle(
          label: label + (isRequired ? ' *' : ''),
          value: boolValue,
          onChanged: (value) => widget.onFieldChanged(fieldName, value),
          isRequired: isRequired,
        );
        break;

      case 'file':
        // Determine allowed extensions and category
        final allowedExt = _getAllowedExtensions(input);
        final category = _getFileCategory(allowedExt);
        // Get image URL if saved (for non-File values that might be URLs)
        final imageUrl = currentValue is String && currentValue.toString().startsWith('http')
            ? currentValue.toString()
            : null;

        fieldWidget = CustomFilePicker(
          label: label + (isRequired ? ' *' : ''),
          fieldName: fieldName,
          value: currentValue is File ? currentValue : null,
          imageUrl: imageUrl,
          isImageFile: category == 'image',
          allowedExtensions: allowedExt,
          category: category,
          onPicked: (file) => widget.onFieldChanged(fieldName, file),
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
        final lowerFieldName = fieldName?.toLowerCase() ?? '';
        final hasVideoInLabel = lowerLabel.contains('video') || lowerFieldName.contains('video');
        final hasImageInLabel = lowerLabel.contains('image') || lowerLabel.contains('photo') || lowerLabel.contains('picture');
        
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
        if (currentValue is List) {
          imageUrls = currentValue
              .where((item) => item is String && item.toString().startsWith('http'))
              .map((item) => item.toString())
              .toList();
        } else if (currentValue is String && currentValue.toString().startsWith('http')) {
          imageUrls = [currentValue.toString()];
        }

        fieldWidget = CustomMultipleFilePicker(
          label: label + (isRequired ? ' *' : ''),
          fieldName: fieldName,
          value: currentValue is List<File> ? currentValue : null,
          imageUrls: imageUrls,
          isImageFile: finalCategory == 'image',
          allowedExtensions: allowedExt,
          category: finalCategory, // Use finalCategory instead of category
          onPicked: (files) => widget.onFieldChanged(fieldName, files),
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
              widget.onFieldChanged(fieldName, value.toIso8601String());
            } else {
              widget.onFieldChanged(fieldName, '');
            }
          },
        );
        break;

      case 'number':
        fieldWidget = _TextField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) => widget.onFieldChanged(fieldName, value),
          keyboardType: TextInputType.number,
        );
        break;
      case 'button':
        fieldWidget = CustomButton(
          text: label,
          onTap: () => widget.onFieldChanged(fieldName, true),
          backgroundColor: AppColors.appButtonColor,
        );
        break;
      case 'checkbox':
        bool boolValue = false;

        if (currentValue is bool) {
          boolValue = currentValue;
        } else if (currentValue is String) {
          boolValue = currentValue.toLowerCase() == "true" || currentValue == "1";
        }

        fieldWidget = CustomCheckbox(
          value: boolValue,
          title: label + (isRequired ? " *" : ""),
          onChanged: (val) => widget.onFieldChanged(fieldName, val),
        );
        break;
      case 'radio':
        List<String> labels = [];
        List<String> values = [];

        if (input.optionItems != null && input.optionItems!.isNotEmpty) {
          labels = input.optionItems!.map((e) => e.label ?? "").where((l) => l.isNotEmpty).toList();
          values = input.optionItems!.map((e) => e.value ?? e.label ?? "").where((v) => v.isNotEmpty).toList();
          
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
              style: AppTextStyle.description(
                color: Colors.red,
              ),
            ),
          );
        } else {
          // Get current value as string, defaulting to empty string if null
          final currentValueStr = currentValue?.toString() ?? '';
          
          fieldWidget = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label + (isRequired ? " *" : ""),style:  AppTextStyle.description(color: AppColors.appBodyTextColor, fontWeight: FontWeight.w600,),),
              const SizedBox(height: 8),

              for (int i = 0; i < labels.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: CustomRadioButton<String>(
                    value: values[i],
                    groupValue: currentValueStr,
                    title: labels[i],
                    onChanged: (val) => widget.onFieldChanged(fieldName, val),
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
          values = input.optionItems!.map((e) => e.value ?? e.label ?? "").toList();
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
            Text(label + (isRequired ? " *" : ""),style:  AppTextStyle.description(color: AppColors.appBodyTextColor,fontWeight: FontWeight.w600,),),
            const SizedBox(height: 8),

            CustomDropdown<String>(
              value: selectedValue,
              items: values,
              hintText: placeholder ?? "Select",
              itemToString: (v) {
                final index = values.indexOf(v);
                return labels[index];
              },
              onChanged: (val) => widget.onFieldChanged(fieldName, val),
            ),
          ],
        );
        break;


      case 'date':    // date picker
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
              widget.onFieldChanged(fieldName, pickedDate.toIso8601String());
            } else {
              widget.onFieldChanged(fieldName, "");
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
              ? DateTimeRange(start: start!, end: end!)
              : null,
          onChanged: (range) {
            if (range != null) {
              widget.onFieldChanged(
                fieldName,
                "${range.start.toIso8601String()}|${range.end.toIso8601String()}",
              );
            } else {
              widget.onFieldChanged(fieldName, "");
            }
          },
        );
        break;



      case 'group':
        // Group inputs should not create any UI element
        return const SizedBox.shrink();

      default:
        fieldWidget = _TextField(
          label: label + (isRequired ? ' *' : ''),
          hintText: placeholder,
          initialValue: currentValue?.toString() ?? '',
          onChanged: (value) => widget.onFieldChanged(fieldName, value),
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
            Text(
              error,
              style:  AppTextStyle.body(
                color: Colors.red,

              ),
            ),
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
      if (validation.type?.toLowerCase() == 'exact_length' && validation.value != null) {
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

  // Check if file input accepts image files (jpg, jpeg, png)
  bool _isImageFileInput(RegisterInput input) {
    final validations = input.validations ?? [];
    for (final validation in validations) {
      // Check validation value (might be int or string)
      final valueStr = validation.value?.toString().toLowerCase() ?? '';
      // Check pattern field
      final pattern = (validation.pattern?.toString().toLowerCase() ?? '');
      // Check patternErrorMessage (sometimes extensions are stored here)
      final patternErrorMsg = (validation.patternErrorMessage?.toString().toLowerCase() ?? '');
      // Check errorMessage (sometimes extensions are stored here)
      final errorMsg = (validation.errorMessage?.toString().toLowerCase() ?? '');
      
      // Combined check across all possible fields
      final combinedText = '$valueStr $pattern $patternErrorMsg $errorMsg';
      
      // Check if any field contains image extensions
      if (combinedText.contains('jpg') || 
          combinedText.contains('jpeg') || 
          combinedText.contains('png') ||
          combinedText.contains('image')) {
        return true;
      }
    }
    return false;
  }

  // Extract allowed extensions from validations
  List<String> _getAllowedExtensions(RegisterInput input) {
    final validations = input.validations ?? [];
    final List<String> exts = [];
    
    print('🔍 Extracting extensions from validations...');
    print('📋 Total validations: ${validations.length}');
    
    // Known extension lists for validation
    final allVideoExts = {'mp4', 'mov', 'mkv', 'avi', 'webm', '3gp', 'hevc', 'h265', 'h.265'};
    final allImageExts = {'jpg', 'jpeg', 'png', 'webp', 'gif', 'bmp', 'heif', 'heic', 'avif', 'svg'};
    final allDocExts = {'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'txt', 'rtf', 'epub', 'csv'};
    final allKnownExts = {...allVideoExts, ...allImageExts, ...allDocExts};
    
    for (final v in validations) {
      print('  📝 Validation type: ${v.type}');
      print('  📝 Validation value: ${v.value}');
      print('  📝 Validation value String: ${v.stringValue}');

      // ONLY extract from validation.value, NOT from error messages
      if (v.type == 'file' && v.stringValue != null) {
        print('  ✅ Processing file validation value: ${v.stringValue.toString().trim()}');
        final valueStr = v.stringValue?.trim();
        print('  ✅ Processing file validation value: $valueStr');
        
        // Split by comma, space, or pipe
        final parts = valueStr?.split(RegExp(r'[\s,|/]+')).where((e) => e.isNotEmpty).toList();
        
        for (final p in parts!) {
          final cleanExt = p.toLowerCase().trim();
          // Remove any leading dots or special chars
          final ext = cleanExt.replaceAll(RegExp(r'^[.\s]+|[.\s]+$'), '');
          
          // Only add if it's a known extension (2-5 chars, alphanumeric)
          if (ext.length >= 2 && ext.length <= 5 && RegExp(r'^[a-z0-9.]+$').hasMatch(ext)) {
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
      'jpg','jpeg','png','webp','heif','heic','gif','bmp','avif','svg'
    };
    final videoSet = {
      'mp4','mov','mkv','avi','webm','3gp','hevc','h265','h.265'
    };
    final docSet = {
      'pdf','doc','docx','xls','xlsx','ppt','pptx','txt','rtf','epub','csv'
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
  final TextInputType keyboardType;
  final int? maxLength;
  final TextCapitalization textCapitalization;

  const _TextField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onChanged,
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

  const _PasswordField({
    required this.label,
    required this.hintText,
    required this.initialValue,
    required this.onChanged,
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
      keyboardType: TextInputType.visiblePassword,
      onChanged: widget.onChanged,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: AppColors.appIconColor
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
            if (validation.value != null && value.toString().length != validation.value) {
              errors[fieldName] = errorMessage;
            }
            break;

          case 'min_length':
            if (validation.value != null && value.toString().length < validation.value!) {
              errors[fieldName] = validation.minLengthError ?? errorMessage;
            }
            break;

          case 'max_length':
            if (validation.value != null && value.toString().length > validation.value!) {
              errors[fieldName] = validation.maxLengthError ?? errorMessage;
            }
            break;

          case 'regex':
          case 'pattern':
            // Accept pattern from either pattern or value (string)
            final patt = validation.pattern ?? (validation.value is String ? validation.value as String : null);
            if (patt != null && !RegExp(patt).hasMatch(value.toString())) {
              errors[fieldName] = validation.patternErrorMessage ?? errorMessage;
            }
            break;

          case 'matches':
            if (validation.field != null && formData[validation.field] != value) {
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
    selectedIndex = widget.initialIndex >= 0 && widget.initialIndex < widget.optionLabels.length
        ? widget.initialIndex
        : 0;
  }

  @override
  void didUpdateWidget(_SelectTabBarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update selected index if initialIndex changed
    if (widget.initialIndex != oldWidget.initialIndex) {
      selectedIndex = widget.initialIndex >= 0 && widget.initialIndex < widget.optionLabels.length
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
            child: Text(
              widget.label,
              style:  AppTextStyle.title(),
            ),
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
                  final value = index < widget.optionValues.length && widget.optionValues[index].isNotEmpty
                      ? widget.optionValues[index]
                      : widget.optionLabels[index];
                  widget.onValueChanged(value);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.appColor : Colors.white,
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [
                              AppColors.appColor,
                              AppColors.appColor.withOpacity(0.7)
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
                            )
                          ]
                        : [],
                    border: Border.all(
                      color: isSelected ? AppColors.appColor : AppColors.appTextColor.withOpacity(0.2),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    widget.optionLabels[index],
                    style:  AppTextStyle.description(
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
