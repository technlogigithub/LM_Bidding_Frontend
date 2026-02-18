import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_color.dart';
import '../../core/app_textstyle.dart';
import '../../core/input_formatters.dart';
import 'package:get/get.dart';
import '../../controller/app_main/App_main_controller.dart';
import '../../models/App_moduls/AppResponseModel.dart';

class CustomMobileNumberTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller;
  final bool isRequired;
  final Function(String)? onChanged;
  final Function(String)? onCountryChanged;
  final String initialCountryCode;

  const CustomMobileNumberTextField({
    super.key,
    required this.label,
    required this.hintText,
    this.controller,
    this.isRequired = false,
    this.onChanged,
    this.onCountryChanged,
    this.initialCountryCode = '+91',
  });

  @override
  State<CustomMobileNumberTextField> createState() => _CustomMobileNumberTextFieldState();
}
class _CustomMobileNumberTextFieldState extends State<CustomMobileNumberTextField> {
  final AppSettingsController _settingsController = Get.find<AppSettingsController>();
  late String _selectedCountryCode;
  final TextEditingController _searchController = TextEditingController();
  final RxList<Country> _filteredCountries = <Country>[].obs;

  String _getFlagEmoji(String? flagCode) {
    if (flagCode == null || flagCode.isEmpty) return '🌍';
    if (flagCode.length != 2) return flagCode;
    
    try {
      final int firstLetter = flagCode.toUpperCase().codeUnitAt(0) - 0x41 + 0x1F1E6;
      final int secondLetter = flagCode.toUpperCase().codeUnitAt(1) - 0x41 + 0x1F1E6;
      return String.fromCharCode(firstLetter) + String.fromCharCode(secondLetter);
    } catch (e) {
      return '🌍';
    }
  }

  @override
  void initState() {
    super.initState();
    
    // Initialize with dynamic default from settings if available and no override provided
    if (widget.initialCountryCode == '+91' && _settingsController.country.value != null) {
      _selectedCountryCode = _settingsController.country.value!.code ?? '+91';
    } else {
      _selectedCountryCode = widget.initialCountryCode;
    }
    
    // Notify parent of initial selection
    if (widget.onCountryChanged != null) {
       widget.onCountryChanged!(_selectedCountryCode);
    }
  }

  void _filterCountries(String query) {
    if (query.isEmpty) {
      _filteredCountries.assignAll(_settingsController.availableCountries);
    } else {
      final lowercaseQuery = query.toLowerCase();
      final cleanQuery = query.replaceAll('+', '').toLowerCase();
      
      _filteredCountries.assignAll(
        _settingsController.availableCountries.where((country) {
          final name = country.name?.toLowerCase() ?? '';
          final code = country.code?.toLowerCase() ?? '';
          final cleanCode = code.replaceAll('+', '').toLowerCase();
          
          return name.contains(lowercaseQuery) || 
                 code.contains(lowercaseQuery) ||
                 (cleanQuery.isNotEmpty && cleanCode.contains(cleanQuery));
        }).toList(),
      );
    }
  }

  void _showCountryPicker() {
    _searchController.clear();
    _filteredCountries.assignAll(_settingsController.availableCountries);
    final countries = _settingsController.availableCountries;
    if (countries.isEmpty) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
            decoration: BoxDecoration(
              gradient: AppColors.appPagecolor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Select Country',
                    style: AppTextStyle.title(
                      fontWeight: FontWeight.bold,
                      color: AppColors.appTitleColor,
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _filterCountries,
                    style: AppTextStyle.body(color: AppColors.appTitleColor),
                    decoration: InputDecoration(
                      hintText: 'Search country...',
                      hintStyle: AppTextStyle.description(
                          color: AppColors.appDescriptionColor),
                      prefixIcon:
                          Icon(Icons.search, color: AppColors.appDescriptionColor),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.appBodyTextColor),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.appColor),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  child: Obx(() => ListView.builder(
                        shrinkWrap: true,
                        itemCount: _filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = _filteredCountries[index];
                          return ListTile(
                            leading: Text(
                              _getFlagEmoji(country.flag),
                              style: const TextStyle(fontSize: 24),
                            ),
                            title: Text(
                              country.name ?? '',
                              style:
                                  AppTextStyle.body(color: AppColors.appTitleColor),
                            ),
                            trailing: Text(
                              country.code ?? '',
                              style: AppTextStyle.body(
                                fontWeight: FontWeight.bold,
                                color: AppColors.appDescriptionColor,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                _selectedCountryCode = country.code ?? '';
                              });
                              if (widget.onCountryChanged != null) {
                                widget.onCountryChanged!(_selectedCountryCode);
                              }
                              Navigator.pop(context);
                            },
                          );
                        },
                      )),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Determine the flag for the selected code from dynamic list
      String flag = '🌍';
      try {
        final found = _settingsController.availableCountries.firstWhere(
          (c) => c.code == _selectedCountryCode,
        );
        flag = _getFlagEmoji(found.flag);
      } catch (_) {
        // Fallback or attempt to find by widget initial
      }

      return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: AppColors.appColor,
          selectionHandleColor: AppColors.appColor,
        ),
      ),
      child: TextField(
        controller: widget.controller,
        style: TextStyle(color: AppColors.appTitleColor),
        keyboardType: TextInputType.phone,
        cursorColor: AppColors.appColor,
        inputFormatters: [
          PhoneNumberFormatter(
            availableCountryCodes: _settingsController.availableCountries
                .map((e) => e.code ?? '')
                .where((code) => code.isNotEmpty)
                .toList(),
            onCountryCodeDetected: (code) {
              setState(() {
                _selectedCountryCode = code;
              });
              if (widget.onCountryChanged != null) {
                widget.onCountryChanged!(code);
              }
            },
          ), // Use the formatter we created
          LengthLimitingTextInputFormatter(10),
        ],
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          label: Text(
            widget.label,
            style: AppTextStyle.description(color: AppColors.appDescriptionColor),
          ),
          hintText: widget.hintText,
          hintStyle: AppTextStyle.description(color: AppColors.appDescriptionColor),
          // Country Picker Button
          prefixIcon: GestureDetector(
            onTap: _showCountryPicker,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              // Ensure background is transparent so hit test works
              color: Colors.transparent, 
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(flag, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 8),
                  Text(
                    _selectedCountryCode,
                    style: AppTextStyle.body(
                      color: AppColors.appTitleColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_drop_down, color: AppColors.appDescriptionColor),
                  const SizedBox(width: 8),
                  // Vertical divider to separate code from input
                  Container(
                    height: 24,
                    width: 1,
                    color: AppColors.appDescriptionColor.withOpacity(0.5),
                  ),
                ],
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appBodyTextColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.appDescriptionColor),
          ),
        ),
      ));
    });
  }
}
