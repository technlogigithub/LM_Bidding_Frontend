import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libdding/core/app_color.dart';
import 'package:pinput/pinput.dart';

import '../controller/app_main/App_main_controller.dart';
import 'app_font_family.dart';

class AppTextStyle {

  // Default text style
  static final kTextStyle = GoogleFonts.inter(
    color: AppColors.neutralColor,
  );

  // PIN Theme
  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
      fontSize: 20,
      color: AppColors.neutralColor,
      fontWeight: FontWeight.w600,
    ),
  );

  // Font sizes
  static const double size12 = 12;
  static const double size14 = 14;
  static const double size16 = 16;
  static const double size18 = 18;
  static const double size20 = 20;

  // Font weights
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;

  static final AppSettingsController settings =
  Get.find<AppSettingsController>();

  // ===========================
  // DYNAMIC STYLES (UPDATED)
  // ===========================

  static TextStyle title({
    Color? color,
    FontWeight fontWeight = FontWeight.bold,
  }) {
    return dynamicFont(
      fontSize: settings.fontTitleSize.value,
      fontWeight: fontWeight,
      color: color ?? AppColors.appTitleColor,
    );
  }

  static TextStyle description({
    Color? color,
    FontWeight fontWeight = regular,
  }) {
    return dynamicFont(
      fontSize: settings.fontDescriptionSize.value,
      fontWeight: fontWeight,
      color: color ?? AppColors.appDescriptionColor,
    );
  }

  static TextStyle body({
    Color? color,
    FontWeight fontWeight = regular,
  }) {
    return dynamicFont(
      fontSize: settings.fontBodySize.value,
      fontWeight: fontWeight,
      color: color ?? AppColors.appBodyTextColor,
    );
  }

  // Input decoration
  final InputDecoration kInputDecoration = InputDecoration(
    hintStyle: TextStyle(color: AppColors.appTextColor),
    filled: true,
    fillColor: Colors.white70,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      borderSide: BorderSide(
          color: AppColors.appTextColor.withOpacity(0.5), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(6.0)),
      borderSide: BorderSide(color: AppColors.appTextColor, width: 2),
    ),
  );
}
