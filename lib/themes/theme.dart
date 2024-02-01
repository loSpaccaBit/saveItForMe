import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  Color lightPrimaryColor = Colors.white;
  Color darkPrimaryColor = const Color.fromRGBO(17, 24, 39, 1);
  Color secondaryColor = Color.fromRGBO(89, 147, 255, 1);
  Color textLightColor = Colors.black;
  Color textDarkColor = Colors.white;

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: _themeClass.lightPrimaryColor,
    hoverColor: _themeClass.secondaryColor,
    colorScheme: const ColorScheme.light().copyWith(
      primary: _themeClass.lightPrimaryColor,
      secondary: _themeClass.secondaryColor,
    ),
    textTheme: TextTheme(
      headline1: GoogleFonts.nunito(
        color: _themeClass.textLightColor,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      bodyText1: GoogleFonts.nunito(
        color: _themeClass.textLightColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: _themeClass.secondaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeClass.secondaryColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(10.0, 10.0)),
        iconSize: MaterialStateProperty.all<double>(
            18.0), // Imposta la dimensione minima del bottone
        iconColor: MaterialStateColor.resolveWith((states) {
          return _themeClass.textDarkColor;
        }),
        backgroundColor: MaterialStateColor.resolveWith((states) {
          return _themeClass.secondaryColor; // Default color
        }),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: _themeClass.lightPrimaryColor,
      titleTextStyle: GoogleFonts.nunito(
        color: _themeClass.textLightColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: GoogleFonts.nunito(
        color: _themeClass.textLightColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) {
          return _themeClass.lightPrimaryColor;
        }),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: _themeClass.darkPrimaryColor,
    hoverColor: _themeClass.secondaryColor,
    colorScheme: const ColorScheme.dark().copyWith(
      primary: _themeClass.darkPrimaryColor,
      secondary: _themeClass.secondaryColor,
    ),
    textTheme: TextTheme(
      headline1: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      bodyText1: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      foregroundColor: Colors.white,
      backgroundColor: _themeClass.secondaryColor,
    ),
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: _themeClass.secondaryColor,
    ),
    iconButtonTheme: IconButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(Size(10.0, 10.0)),
        iconSize: MaterialStateProperty.all<double>(18.0),
        backgroundColor: MaterialStateColor.resolveWith((states) {
          return _themeClass.secondaryColor; // Default color
        }),
      ),
    ),
    dialogTheme: DialogTheme(
      backgroundColor: _themeClass.darkPrimaryColor,
      titleTextStyle: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      contentTextStyle: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    dropdownMenuTheme: DropdownMenuThemeData(
      menuStyle: MenuStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) {
          return _themeClass.darkPrimaryColor;
        }),
      ),
    ),
  );
}

ThemeClass _themeClass = ThemeClass();
