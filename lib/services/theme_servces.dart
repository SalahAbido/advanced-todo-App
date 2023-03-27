import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class ThemeServices {
  GetStorage box = GetStorage();
  String key = 'isDark';

  bool get isDark => box.read(key) ?? false;

  ThemeMode get Theme => isDark ? ThemeMode.dark : ThemeMode.light;

  void ChangeTheme() {
    box.write(key, !isDark);
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
  }
}
