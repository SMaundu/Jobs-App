import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  const AppTheme._();

  static Color backgroundColor = const Color(0xffF5F8FA);
  static Color blueColor = const Color(0xff1DA1F2);
  static Color blackColor = const Color(0xff14171A);
  static Color darkGrayColor = const Color(0xff657786);
  static Color lightGrayColor = const Color(0xffAAB8C2);
  static Color errorColor = const Color(0xffFB4747);
  static Color whiteColor = const Color(0xffffffff);

  static final lightTheme = Get.theme.copyWith(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    brightness: Brightness.light,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: blueColor,
    hintColor: lightGrayColor,
    cardColor: whiteColor,
    // errorColor: errorColor, // Removed because ThemeData does not support this parameter directly
    textTheme: _lightTextTheme,
    colorScheme: _lightColorScheme,
    elevatedButtonTheme: _lightElevatedButtonTheme,
    inputDecorationTheme: _inputDecorationTheme,
  );

  static final _lightTextTheme = Get.textTheme.copyWith(
    labelLarge: GoogleFonts.poppins(
      fontSize: 14.sp,
      fontWeight: FontWeight.w700,
    ),
    bodySmall: GoogleFonts.poppins(
      fontSize: 13.sp,
      fontWeight: FontWeight.w400,
      color: lightGrayColor,
    ),
  );

  static final _lightColorScheme = ColorScheme.fromSwatch().copyWith(
    surface: backgroundColor,
    onSurface: blackColor,
    primary: blueColor,
    onPrimary: backgroundColor,
    secondary: darkGrayColor,
    tertiary: lightGrayColor,
    error: errorColor,
  );

  static final _lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: blueColor,
      elevation: 10,
      textStyle: _lightTextTheme.labelLarge,
      shadowColor: blueColor.withOpacity(0.25),
      foregroundColor: backgroundColor,
      padding: EdgeInsets.all(16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
      ),
      disabledBackgroundColor: blueColor,
      disabledForegroundColor: backgroundColor,
    ),
  );

  static final _inputDecorationTheme = InputDecorationTheme(
    contentPadding: EdgeInsets.all(16.w),
    hintStyle: _lightTextTheme.bodySmall,
    errorStyle: _lightTextTheme.bodySmall?.copyWith(
      color: errorColor,
      fontSize: 10.sp,
    ),
    fillColor: whiteColor,
    filled: true,
    errorMaxLines: 3,
    counterStyle: _lightTextTheme.bodySmall?.copyWith(fontSize: 10.sp),
    suffixIconColor: darkGrayColor,
    prefixIconColor: lightGrayColor,
    enabledBorder: _outlineInputBorder,
    border: _outlineInputBorder,
    focusedBorder: _outlineInputBorder,
    errorBorder: _outlineInputBorder.copyWith(
      borderSide: BorderSide(color: errorColor),
    ),
  );

  static final _outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(14.r),
    borderSide: BorderSide(
      color: blackColor.withOpacity(0.1),
      width: 1.0,
    ),
  );
}
