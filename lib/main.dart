import 'package:apiflutter/shared_data/MainModel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import 'Global/Global_variables.dart';
import 'Language/AppTranslationsDelegate.dart';
import 'Language/Application.dart';
import 'Screens/List_Lignes.dart';
import 'Screens/splashsScreen.dart';
import 'screens/WelcomeScreen.dart';
import 'service/tram_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  _setupLogging();
  runApp(MyApp());
}

void _setupLogging() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  AppTranslationsDelegate _newLocaleDelegate;

  //* inialize model package that help us to pick up mode language after reload
  //* scoped_model is like provider package, we use it here because its simple 
  //* also to avoid error causing by the use of two provider "provider and changeNotifierProvider"

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
  //***Definir ces deux variables pour changer le mode***/
  final ThemeData _darkTheme;
  final ThemeData _lightTheme;
  //***Definir cette variable pour le changement de la langue***/
  final AppTranslationsDelegate _newLocaleDelegate;

  @override
  _BodyOfTheProviderState createState() => _BodyOfTheProviderState();
}

class _BodyOfTheProviderState extends State<BodyOfTheProvider> {
  @override
  Widget build(BuildContext context) {
    //***ScopedModelDescendant: utilisée cette class pour faciliter la mise a jour du theme***/
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
            //***Ce test est utilisée pour changer la langue en ce basant sur 
            //***la valeur de la variable is spanish, si true le language de l"app
            //***devient espagnol, anglais sinon  ***/
            if (model.isSpanish) {
              return supportedLocales.last;
            } else {
              return supportedLocales.first;
            }
          },
          initialRoute: '/',
          //***Dans cette partie en defini les class des differentes screen pour la navigation***/
          routes: {
            '/': (context) => SplashScreen(),
            '/ListLignes': (context) => ListLignes(),
            '/WelcomeScreen': (context) => WelcomeScreen(),
          },
        );
      },
    );
  }
}
