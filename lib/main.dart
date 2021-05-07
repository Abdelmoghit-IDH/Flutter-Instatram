import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ui/Global/theme_changer.dart';
import 'package:ui/screens/List_Lignes.dart';
import 'package:ui/screens/splashsScreen.dart';
import 'package:ui/service/tram_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Global/Global_variables.dart';
import 'Language/AppTranslationsDelegate.dart';
import 'Language/Application.dart';
import 'package:ui/Global/Global_variables.dart';

void main() {
  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  @override
  void initState() {
    super.initState();

    _newLocaleDelegate = AppTranslationsDelegate(newLocale: null);
    application.onLocaleChanged = onLocaleChange;
  }

  void onLocaleChange(Locale locale) {
    setState(() {
      _newLocaleDelegate = AppTranslationsDelegate(newLocale: locale);
    });
  }

  //**********************theme**********************/
  // Todo: Dark Theme
  ThemeData _darkTheme = ThemeData(
    primaryColorDark: Colors.white,
    primaryColorLight: Colors.grey[800],
    scaffoldBackgroundColor: Colors.black,
    accentColor: Colors.red[200],
    brightness: Brightness.dark,
    primaryColor: Color(0xff332940),
  );
  // Todo: Light Theme
  // ignore: unused_element
  ThemeData _lightTheme = ThemeData(
    primaryColorLight: Colors.grey[400],
    primaryColorDark: Color(0xff1f1b24),
    scaffoldBackgroundColor: Colors.white,
    accentColor: Colors.deepOrangeAccent,
    brightness: Brightness.light,
    primaryColor: Colors.red[300],
  );
//***********************theme*********************/

  @override
  Widget build(BuildContext context) {
    //SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
    return Provider(
      create: (_) => TramService.create(),
      dispose: (_, TramService service) => service.client.dispose(),
      child: BodyOfTheProvider(
          darkTheme: _darkTheme,
          lightTheme: _lightTheme,
          newLocaleDelegate: _newLocaleDelegate),
    );
  }
}

// ignore: must_be_immutable
class BodyOfTheProvider extends StatefulWidget {
  BodyOfTheProvider({
    Key key,
    @required ThemeData darkTheme,
    @required ThemeData lightTheme,
    @required AppTranslationsDelegate newLocaleDelegate,
  })  : _darkTheme = darkTheme,
        _lightTheme = lightTheme,
        _newLocaleDelegate = newLocaleDelegate,
        super(key: key);

  final ThemeData _darkTheme;
  final ThemeData _lightTheme;
  final AppTranslationsDelegate _newLocaleDelegate;

  @override
  _BodyOfTheProviderState createState() => _BodyOfTheProviderState();
}

class _BodyOfTheProviderState extends State<BodyOfTheProvider> {
  getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      theActualThemeIsdark = prefs.getBool("theme");
    });
  }

  @override
  void initState() {
    super.initState();
    language();
    getTheme();
  }

  //languagesList also moved to the Application class just like the languageCodesList
  static final List<String> languagesList = application.supportedLanguages;
  static final List<String> languageCodesList =
      application.supportedLanguagesCodes;

  final Map<dynamic, dynamic> languagesMap = {
    languagesList[0]: languageCodesList[0],
    languagesList[1]: languageCodesList[1],
  };

  language() {
    if (!isSpanishLanguage) {
      application.onLocaleChanged(Locale(languagesMap[languagesList[1]]));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ThemeBuilder(
      defaultBrightness: Brightness.light,
      builder: (context, _brightness) {
        //TramService data = Provider.of<TramService>(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theActualThemeIsdark ? widget._darkTheme : widget._lightTheme,
          localizationsDelegates: [
            widget._newLocaleDelegate,
            const AppTranslationsDelegate(),
            //provides localised strings
            GlobalMaterialLocalizations.delegate,
            //provides RTL support
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: application.supportedLocales(),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashScreen(),
            '/ListLignes': (context) => ListLignes(),
          },
        );
      },
    );
  }
}
