import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsManager {
  static SharedPreferences? _prefs;

  /// Initialize SharedPreferences (call in main)
  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// ---------------- STORE DATA ----------------

  static Future setString(String key, String value) async =>
      await _prefs?.setString(key, value);

  static Future setInt(String key, int value) async =>
      await _prefs?.setInt(key, value);

  static Future setBool(String key, bool value) async =>
      await _prefs?.setBool(key, value);

  static Future setDouble(String key, double value) async =>
      await _prefs?.setDouble(key, value);

  static Future setStringList(String key, List<String> value) async =>
      await _prefs?.setStringList(key, value);

  /// ---------------- GET DATA ----------------

  static String? getString(String key) => _prefs?.getString(key);

  static int? getInt(String key) => _prefs?.getInt(key);

  static bool? getBool(String key) => _prefs?.getBool(key);

  static double? getDouble(String key) => _prefs?.getDouble(key);

  static List<String>? getStringList(String key) =>
      _prefs?.getStringList(key);

  /// ---------------- REMOVE / CLEAR ----------------

  static Future remove(String key) async => await _prefs?.remove(key);

  static Future clear() async => await _prefs?.clear();
}