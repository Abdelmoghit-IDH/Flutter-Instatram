import 'package:flutter/material.dart';

bool theActualThemeIsdark = false;
bool isSpanishLanguage = false;

//**********************theme**********************/
// Todo: Dark Theme
ThemeData darkTheme = ThemeData(
  bottomAppBarColor: Color(0xff303135),
  cardColor: Color(0xff303135),
  primaryColorDark: Colors.white,
  primaryColorLight: Colors.white,
  scaffoldBackgroundColor: Color(0xff202125),
  accentColor: Color(0xfffbbc05), //Colors.red[200],
  brightness: Brightness.dark,
  primaryColor: Color(0xffbb8c00), //Color(0xff332940),
);
// Todo: Light Theme
ThemeData lightTheme = ThemeData(
  bottomAppBarColor: Colors.white,
  cardColor: Colors.white,
  primaryColorLight: Colors.black,
  primaryColorDark: Color(0xff1f1b24),
  scaffoldBackgroundColor: Colors.white,
  accentColor: Colors.deepOrangeAccent,
  brightness: Brightness.light,
  primaryColor: Color(0xffea4335), //Colors.red[300],
);
//***********************theme*********************/
