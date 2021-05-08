import 'dart:ui';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui/Language/Application.dart';

class MainModel extends Model {
  // todo: theme config
  final String key = "theme";
  SharedPreferences _prefs;
  bool _darkTheme;

  bool get darkTheme => _darkTheme;

  // ignore: non_constant_identifier_names
  MainModel() {
    _loadFromPrefs();
    _loadFromPrefss();
    _darkTheme = false;
    _isSpanish = false;
  }

  toggleTheme() {
    _darkTheme = !_darkTheme;
    _saveToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if (_prefs == null) _prefs = await SharedPreferences.getInstance();
  }

  _loadFromPrefs() async {
    await _initPrefs();
    _darkTheme = _prefs.getBool(key) ?? false;
    notifyListeners();
  }

  _saveToPrefs() async {
    await _initPrefs();
    _prefs.setBool(key, _darkTheme);
  }

  // todo: language config**************************************************
  //languagesList also moved to the Application class just like the languageCodesList
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

  // ignore: non_constant_identifier_names

  toggleLanguage() {
    _isSpanish = !_isSpanish;
    _isSpanish
        ? application.onLocaleChanged(Locale(languagesMap[languagesList[1]]))
        : application.onLocaleChanged(Locale(languagesMap[languagesList[0]]));

    _saveToPrefss();
    notifyListeners();
  }

  // ignore: unused_element
  _initPrefss() async {
    if (_prefss == null) _prefss = await SharedPreferences.getInstance();
  }

  // ignore: unused_element
  _loadFromPrefss() async {
    await _initPrefss();
    _isSpanish = _prefss.getBool(keyy) ?? false;
    notifyListeners();
  }

  // ignore: unused_element
  _saveToPrefss() async {
    await _initPrefss();
    _prefss.setBool(keyy, _isSpanish);
  }
}
