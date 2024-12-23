import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zithara_excersize/resources/app_colors.dart';

AppColors appClrs = AppColors();

class UiHelper {
  // Vertically Space Provider
  static const Widget verticalSpaceTiny = SizedBox(height: 4.0);
  static const Widget verticalSpaceSmall = SizedBox(height: 10.0);
  static const Widget verticalSpaceMedium = SizedBox(height: 20.0);
  static const Widget verticalSpaceLarge = SizedBox(height: 60.0);

// Horizontal Space provider
  static const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
  static const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
  static const Widget horizontalSpaceMedium = SizedBox(width: 20.0);

// Light Theme Provider
  static ThemeData lightThemeref() {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        color: Colors.blue,
      ),
    );
  }

  // Light Theme Provider
  static ThemeData darkThemeref() {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.deepPurple,
      scaffoldBackgroundColor: Colors.black,
      appBarTheme: const AppBarTheme(
        color: Colors.deepPurple,
      ),
    );
  }

  static BoxDecoration roundedBorderWithColor(double radius, Color backgroundColor, {Color borderColor = Colors.transparent, double borderWidth = 0, bool isShadow = false, Color shadowcolor = Colors.black45}) {
    return BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(width: borderWidth, color: borderColor),
        color: backgroundColor,
        boxShadow: isShadow
            ? [
                BoxShadow(
                  color: shadowcolor,
                  offset: const Offset(2, 2),
                  blurRadius: 3.0,
                )
              ]
            : []);
  }

  static BoxDecoration roundedBorderWithimage(double radius, String imageurl, {Color borderColor = Colors.transparent, double borderWidth = 0, double imgopacity = 1}) {
    return BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      border: Border.all(width: borderWidth, color: borderColor),
      image: DecorationImage(image: AssetImage(imageurl), fit: BoxFit.cover, opacity: imgopacity),
    );
  }

  static BoxDecoration circleBorderBox(Color backgroundColor, {Color borderColor = Colors.transparent, double borderWidth = 0}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      color: backgroundColor,
      border: Border.all(width: borderWidth, color: borderColor),
    );
  }

  // Input Box Style Provider
  static OutlineInputBorder getInputBorder(double width, {double radius = 10, Color borderColor = Colors.transparent}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(radius)),
      borderSide: BorderSide(color: borderColor, width: width),
    );
  }

  Future commonsnack(String title, String message) async {
    return Get.snackbar(
      title,
      message,
      backgroundColor: appClrs.secondaryclr,
      colorText: appClrs.whiteclr,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(10),
    );
  }
}
