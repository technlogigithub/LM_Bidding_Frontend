import 'package:flutter/services.dart';

class PhoneNumberFormatter extends TextInputFormatter {
  final List<String>? availableCountryCodes;
  final Function(String)? onCountryCodeDetected;

  PhoneNumberFormatter({this.availableCountryCodes, this.onCountryCodeDetected});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String text = newValue.text;

    // Check for country code if we have available codes and a callback
    if (availableCountryCodes != null &&
        availableCountryCodes!.isNotEmpty &&
        onCountryCodeDetected != null) {
      // Remove all non-digit characters for easier matching
      String cleanText = text.replaceAll(RegExp(r'\D'), '');

      for (var code in availableCountryCodes!) {
        // Remove '+' from code for comparison with cleanText
        String cleanCode = code.replaceAll('+', '');

        if (cleanCode.isNotEmpty && cleanText.startsWith(cleanCode)) {
          // If it matches exactly a code followed by 10 digits, it's a strong match
          String rest = cleanText.substring(cleanCode.length);
          if (rest.length == 10) {
            // Delay the callback to avoid calling setState during build/format
            Future.microtask(() => onCountryCodeDetected!(code));
            
            return TextEditingValue(
              text: rest,
              selection: TextSelection.collapsed(offset: rest.length),
            );
          }
        }
      }
    }

    // Default behavior: Remove all non-digit characters
    String digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    // If the resulting number is more than 10 digits, we assume the user 
    // (or autofill) included a country code (of any length). 
    // We strictly take the LAST 10 digits as the phone number.
    if (digits.length > 10) {
      digits = digits.substring(digits.length - 10);
    }

    // Only update if the text actually changed (either characters were removed
    // or the length was truncated)
    if (digits != newValue.text) {
      return TextEditingValue(
        text: digits,
        selection: TextSelection.collapsed(offset: digits.length),
      );
    }

    return newValue;
  }
}

