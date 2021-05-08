import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:ui/screens/List_Lignes.dart';
import 'package:ui/screens/splashsScreen.dart';
import 'package:ui/service/tram_service.dart';
import 'Global/Global_variables.dart';
import 'Language/AppTranslationsDelegate.dart';
import 'Language/Application.dart';
import 'package:scoped_model/scoped_model.dart';
import 'shared_data/MainModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;
  // *inialize model package that help us to pick up mode language after reload
  //* scoped_model is like provider package, we use it here because its simple also to avoid error causing by
  //* the use of two provider "provider and changeNotifierProvider"
  final MainModel _model = MainModel();

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

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: Provider(
        create: (_) => TramService.create(),
        dispose: (_, TramService service) => service.client.dispose(),
        child: BodyOfTheProvider(
            darkTheme: darkTheme,
            lightTheme: lightTheme,
            newLocaleDelegate: _newLocaleDelegate),
      ),
    );
  }
}

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
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: model.darkTheme ? widget._darkTheme : widget._lightTheme,
          localizationsDelegates: [
            widget._newLocaleDelegate,
            const AppTranslationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          locale: Locale('en', 'EN'),
          supportedLocales: application.supportedLocales(),
          localeResolutionCallback: (locale, supportedLocales) {
            if (model.isSpanish) {
              return supportedLocales.last;
            } else {
              return supportedLocales.first;
            }
          },
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
