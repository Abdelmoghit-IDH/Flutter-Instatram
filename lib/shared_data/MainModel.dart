import 'dart:ui';
import 'package:apiflutter/Language/Application.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class MainModel extends Model {
// todo: ************************Theme mode config**************************
  //* this variable is used to fetch the right data saved locally
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme; //* to get the value of the darktheme value

  //* constractor and init useful variables
  MainModel() {
    _loadFromPrefs();
    _loadFromPrefss();
    _darkTheme = false;
    _isSpanish = false;
  }
  //* this fuction is used to switch the mode
  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  //* init local preferences
  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  //* load pref stored locally
  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  //* save pref on change locally
  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }

// todo: ************************language config**************************
  //*languagesList also moved to the Application class just like the languageCodesList
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  final String keyy = "language";
  SharedPreferences _prefss;
  bool _isSpanish;

  bool get isSpanish => _isSpanish;

  toggleLanguage() {
    _isSpanish = !_isSpanish;
    _isSpanish
        ? application.onLocaleChanged(Locale(languagesMap[languagesList[1]]))
        : application.onLocaleChanged(Locale(languagesMap[languagesList[0]]));

    _saveToPrefss();
    notifyListeners();
  }

  _initPrefss() async {
    if (_prefss == null) _prefss = await SharedPreferences.getInstance();
  }

  _loadFromPrefss() async {
    await _initPrefss();
    _isSpanish = _prefss.getBool(keyy) ?? false;
    notifyListeners();
  }

  _saveToPrefss() async {
    await _initPrefss();
    _prefss.setBool(keyy, _isSpanish);
  }

  bool isBottomSheetOn = false;
  bool get bottomSheet => isBottomSheetOn;
  setBottomSheet(bool state) {
    isBottomSheetOn = state;
    notifyListeners();
  }
}
