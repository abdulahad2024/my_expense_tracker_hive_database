import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class ThemeController extends GetxController {
  final _box = Hive.box('settings');
  final _key = 'isDarkMode';
  ThemeMode get themeMode => _loadThemeFromBox() ? ThemeMode.dark : ThemeMode.light;

  bool _loadThemeFromBox() => _box.get(_key, defaultValue: false);

  void _saveThemeToBox(bool isDarkMode) => _box.put(_key, isDarkMode);

  void toggleTheme(bool isDarkMode) {
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToBox(isDarkMode);
    update();
  }
}