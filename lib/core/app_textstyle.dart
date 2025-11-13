import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:libdding/core/app_color.dart';
import 'package:pinput/pinput.dart';

class AppTextStyle {
  static final  kTextStyle = GoogleFonts.inter(
    color: AppColors.neutralColor,
  );
  static final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: TextStyle(
        fontSize: 20, color: AppColors.neutralColor, fontWeight: FontWeight.w600),
  );


  InputDecoration kInputDecoration =  InputDecoration(
    hintStyle: TextStyle(color: AppColors.appTextColor),
    filled: true,
    fillColor: Colors.white70,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
      borderSide: BorderSide(color: AppColors.appTextColor.withOpacity(0.5), width: 2),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(6.0),
      ),
      borderSide: BorderSide(color: AppColors.appTextColor, width: 2),
    ),
  );
}