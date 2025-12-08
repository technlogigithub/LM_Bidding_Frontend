import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';

import '../controller/app_main/App_main_controller.dart';

Future<void> loadNetworkFont(String url, String fontFamily) async {
  final ByteData fontData = await NetworkAssetBundle(Uri.parse(url)).load("");
  final fontLoader = FontLoader(fontFamily)..addFont(Future.value(fontData));
  await fontLoader.load();
}

TextStyle dynamicFont({
  required double fontSize,
  required FontWeight fontWeight,
  required Color color,
}) {
  final settings = Get.find<AppSettingsController>();
  final family = settings.fontFamily.value.trim();

  final lower = family.toLowerCase();

  // 1️⃣ Generic family mapping
  if (lower.contains("sans")) {
    return GoogleFonts.inter(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }
  if (lower.contains("serif")) {
    return GoogleFonts.lora(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }
  if (lower.contains("mono")) {
    return GoogleFonts.robotoMono(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }
  if (lower.contains("cursive")) {
    return GoogleFonts.dancingScript(fontSize: fontSize, fontWeight: fontWeight, color: color);
  }

  // 2️⃣ Try Google Fonts directly
  try {
    return GoogleFonts.getFont(
      family,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  } catch (_) {}

  // 3️⃣ If backend sends URL to .ttf → load dynamically
  if (family.startsWith("http")) {
    final fontName = "RemoteFont";
    loadNetworkFont(family, fontName);
    return TextStyle(
      fontFamily: fontName,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
    );
  }

  // 4️⃣ If custom font added in assets
  return TextStyle(
    fontFamily: family.isEmpty ? null : family,
    fontSize: fontSize,
    fontWeight: fontWeight,
    color: color,
  );
}
