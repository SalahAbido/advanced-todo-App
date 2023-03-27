import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
// const Color white = Colors.white;
const primaryClr = bluishClr;
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);

class Themes {
  static final lightTheme = ThemeData(
      primaryColor: bluishClr,
      backgroundColor: Colors.white,
      brightness: Brightness.light);
  static final darkTheme = ThemeData(
      primaryColor: darkHeaderClr,
      backgroundColor: darkGreyClr,
      brightness: Brightness.dark);


}

TextStyle textStyle1 = const TextStyle(
  fontSize: 20.0,
  color: Colors.white,
);
TextStyle get headingStyle {
  return GoogleFonts.lato(
      fontSize: 25.0,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white: Colors.black );
}

TextStyle get subheadingStyle {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white: Colors.black );
}

TextStyle get tileStyle {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white: Colors.black );
}

TextStyle get subtileStyle {
  return TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.bold,
      color: Get.isDarkMode ? Colors.white: Colors.black );
}

TextStyle get bodytextStyle => TextStyle(
    fontSize: 15.0,
    fontWeight: FontWeight.bold,
    color: Get.isDarkMode ? Colors.white: Colors.black );
