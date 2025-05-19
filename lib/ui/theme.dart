import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishClr = Color(0xFF4e5ae8);
const Color darkGreyClr = Color(0xFF121212);
const Color darkHeaderClr = Color(0xFF424242);
const Color orangeClr = Color(0xCFFF8746);
const Color pinkClr = Color(0xFFff4667);
const primaryClr = bluishClr;
const Color white = Colors.white;

TextStyle get body2Style => GoogleFonts.lato(
  textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.grey[200] : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
);

TextStyle get bodyStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 14,
    fontWeight: FontWeight.w400,
  ),
);
TextStyle get headingStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 24,
    fontWeight: FontWeight.bold,
  ),
);
TextStyle get subHeadingStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),
);
TextStyle get subTitleStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ),
);
TextStyle get titleStyle => GoogleFonts.lato(
  textStyle: TextStyle(
    color: Get.isDarkMode ? Colors.white : Colors.black,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
);

class Themes {
  static final light = ThemeData(
    primaryColor: primaryClr,
    brightness: Brightness.light,
    scaffoldBackgroundColor: white, // Added for better background control
    appBarTheme: const AppBarTheme(
      // Added for consistent AppBar styling
      backgroundColor: primaryClr,
      elevation: 0,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: primaryClr,
      onPrimary: white,
      secondary: pinkClr,
      onSecondary: white,
      error: Colors.red,
      onError: white, // Adjusted for better text visibility
      surface: white,
      onSurface: darkGreyClr, // Adjusted for better text visibility
    ),
  );
  static final dark = ThemeData(
    primaryColor: darkGreyClr,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkGreyClr, // Added for better background control
    appBarTheme: const AppBarTheme(
      // Added for consistent AppBar styling
      backgroundColor:
          darkHeaderClr, // Using darkHeaderClr for dark theme AppBar
      elevation: 0,
      iconTheme: IconThemeData(color: white),
      titleTextStyle: TextStyle(
        color: white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary:
          primaryClr, // Kept bluishClr as primary for consistency, can be changed
      onPrimary: white,
      secondary: pinkClr,
      onSecondary: white,
      error: Colors.redAccent,
      onError: Colors.black,
      surface:
          darkGreyClr, // Surface is the main background for cards, dialogs etc.
      onSurface: white, // Text on surface elements
    ),
  );
}
