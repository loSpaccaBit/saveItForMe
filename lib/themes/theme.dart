import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  Color lightPrimaryColor = Color.fromRGBO(255, 255, 244, 1);
  Color darkPrimaryColor = const Color.fromRGBO(17, 24, 39, 1);
  Color secondaryColor = Color.fromRGBO(89, 147, 255, 1);
  Color lightCardColor = Color.fromRGBO(255, 255, 240, 1);
  Color darkCardColor = Color.fromRGBO(32, 41, 58, 1);

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
    listTileTheme: ListTileThemeData(
      titleTextStyle: GoogleFonts.nunito(
        color: _themeClass.textLightColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      subtitleTextStyle: GoogleFonts.nunito(
        color: _themeClass.textLightColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardTheme(
      color: _themeClass.lightCardColor,
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
      textStyle: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      menuStyle: MenuStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) {
          return _themeClass.darkPrimaryColor;
        }),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
      // Bordi abilitati (non in errore, senza focus)
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0), // Bordo arrotondato
        borderSide: BorderSide(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      // Bordi in errore
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
          width: 1.0,
        ),
      ),
      // Bordi con focus
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: _themeClass.secondaryColor,
          width: 2.0,
        ),
      ),
      // Bordi disabilitati
      // Bordi in errore con focus
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8.0),
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        ),
      ),
    ),
  
    listTileTheme: ListTileThemeData(
      titleTextStyle: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 22,
        fontWeight: FontWeight.w700,
      ),
      subtitleTextStyle: GoogleFonts.nunito(
        color: _themeClass.textDarkColor,
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
    cardTheme: CardTheme(
      color: _themeClass.darkCardColor,
    ),
  );
}

ThemeClass _themeClass = ThemeClass();
