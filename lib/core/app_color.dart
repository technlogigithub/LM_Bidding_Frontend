import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/app_main/App_main_controller.dart';

class AppColors {
  static final controller = Get.put(AppSettingsController());

  static LinearGradient get appbarColor => parseLinearGradient(controller.bgColorLtr.value);
  static LinearGradient get appPagecolor => parseLinearGradient(controller.bgColorTtb.value);

  static Color get appColor => parseColor(controller.primaryColor.value);
  static Color get appTextColor => parseColor(controller.primaryTextColor.value);
  static Color get appButtonColor => parseColor(controller.secondaryColor.value);
  static Color get appButtonTextColor => parseColor(controller.secondaryTextColor.value);
  static Color get appgreyColor => parseColor(controller.mutedColor.value);
  static Color get appgreyTextColor => parseColor(controller.mutedTextColor.value);

  static Color appWhite = Colors.white;
  static Color appBlack = Colors.black;
  static Color neutralColor = Color(0xFF121F3E);
  static Color darkWhite = Color(0xFFF6F6F6);
  static Color subTitleColor = Color(0xFF4F5350);
  static Color textgrey = Color(0xFF8E8E8E);
  static Color ratingBarColor = Color(0xFFFFB33E);
  static Color simmerColor =  Colors.grey.shade300;

  static Color appSuccesses = Colors.green;
  static Color appFail = Colors.red;
  static Color kBorderColorTextField = Color(0xFFE3E3E3);
}

Color parseColor(String? hexColor, {Color fallback = Colors.black}) {
  if (hexColor == null || hexColor.isEmpty) return fallback;

  try {
    String hex = hexColor.replaceAll('#', '').trim().toUpperCase();
    if (hex.length == 6) hex = 'FF$hex'; // Add full opacity if missing
    else if (hex.length != 8) return fallback; // Handle invalid length
    return Color(int.parse(hex, radix: 16));
  } catch (e) {
    debugPrint("Invalid color: $hexColor, error: $e");
    return fallback;
  }
}




LinearGradient parseLinearGradient(String? gradientStr) {
  if (gradientStr == null || gradientStr.isEmpty) {
    return LinearGradient(colors: [Colors.yellow, Colors.yellow]); // fallback
  }

  // Remove "linear-gradient(" and ")"
  String cleanStr = gradientStr
      .replaceAll('linear-gradient(', '')
      .replaceAll(')', '');

  // Split by comma
  List<String> parts = cleanStr.split(',');

  Alignment begin = Alignment.centerLeft;
  Alignment end = Alignment.centerRight;

  List<Color> colors = [];

  // Check if first part is "to right", "to left", etc.
  String firstPart = parts[0].trim().toLowerCase();
  if (firstPart.startsWith('to ')) {
    switch (firstPart) {
      case 'to right':
        begin = Alignment.centerLeft;
        end = Alignment.centerRight;
        break;
      case 'to left':
        begin = Alignment.centerRight;
        end = Alignment.centerLeft;
        break;
      case 'to bottom':
        begin = Alignment.topCenter;
        end = Alignment.bottomCenter;
        break;
      case 'to top':
        begin = Alignment.bottomCenter;
        end = Alignment.topCenter;
        break;
    }
    parts = parts.sublist(1); // remove direction from color list
  }

  // Parse colors
  for (var part in parts) {
    colors.add(parseColor(part.trim()));
  }

  return LinearGradient(
    begin: begin,
    end: end,
    colors: colors,
  );
}

Color parseRgba(String? rgba) {
  if (rgba == null || rgba.isEmpty) return Colors.yellow;

  // Example input: "rgba(236, 239, 241, 1)"
  rgba = rgba.replaceAll('rgba(', '').replaceAll(')', '');
  List<String> parts = rgba.split(',');

  int r = int.parse(parts[0].trim());
  int g = int.parse(parts[1].trim());
  int b = int.parse(parts[2].trim());
  double a = double.parse(parts[3].trim());

  return Color.fromRGBO(r, g, b, a);
}



