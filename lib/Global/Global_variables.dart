import 'package:flutter/material.dart';

bool theActualThemeIsdark = false;
bool isSpanishLanguage = false;

//** Index all stations**/
const int indexAllStations = 7;

//**********************theme**********************/
// Todo: Dark Theme
ThemeData darkTheme = ThemeData(
  primaryColorDark: Colors.white,
  primaryColorLight: Colors.grey[800],
  scaffoldBackgroundColor: Color(0xff202125),
  accentColor: Colors.red[200],
  brightness: Brightness.dark,
  primaryColor: Color(0xff332940),
);
// Todo: Light Theme
ThemeData lightTheme = ThemeData(
  primaryColorLight: Colors.grey[400],
  primaryColorDark: Color(0xff1f1b24),
  scaffoldBackgroundColor: Colors.white,
  accentColor: Colors.deepOrangeAccent,
  brightness: Brightness.light,
  primaryColor: Colors.red[300],
);
//***********************theme*********************/
