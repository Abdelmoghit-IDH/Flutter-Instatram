import 'package:apiflutter/Data%20API%20Rest/ApiRestRestrieveData.dart';
import 'package:apiflutter/Global/Global_variables.dart';
import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:apiflutter/shared_data/MainModel.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      isSpanishLanguage = model.isSpanish;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            Container(
              height: SizeConfig.safeBlockVertical * 75,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Icon(null),
                      logoWidget("InstaTram"),
                      IconButton(
                        icon: Icon(
                          Icons.settings,
                          size: SizeConfig.blockSizeHorizontal * 8,
                        ),
                        onPressed: () {
                          //************ButtomSheet pour afficher les paramétres de l'app***********/
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Wrap(
                                  children: [
                                    Container(
                                      color: Theme.of(context).accentColor,
                                      child: ListTile(
                                        title: Text(
                                          model.isSpanish
                                              ? "Ajustes"
                                              : 'Settings',
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.blockSizeHorizontal *
                                                    5,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        model.isSpanish
                                            ? "Claro / Oscuro"
                                            : "Light / Dark",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  5,
                                        ),
                                      ),
                                      trailing: Transform.scale(
                                        scale: 1.5,
                                        child: Switch(
                                          inactiveThumbColor:
                                              Theme.of(context).accentColor,
                                          activeColor:
                                              Theme.of(context).accentColor,
                                          value: model.darkTheme,
                                          onChanged: (bool state) async {
                                            setState(() {
                                              theActualThemeIsdark = state;
                                              model.toggleTheme();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      leading: Text(
                                        model.isSpanish
                                            ? "Inglés / Español"
                                            : "English / Spanish",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              SizeConfig.blockSizeHorizontal *
                                                  5,
                                        ),
                                      ),
                                      trailing: Transform.scale(
                                        scale: 1.5,
                                        child: Switch(
                                          activeColor:
                                              Theme.of(context).accentColor,
                                          inactiveThumbColor:
                                              Theme.of(context).accentColor,
                                          value: model.isSpanish,
                                          onChanged: (bool state) async {
                                            setState(() {
                                              model.toggleLanguage();
                                            });
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                      )
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 22,
                  ),
                  welcomeWidget(
                    model.isSpanish ? "Bienvenido" : "Welcome",
                    Theme.of(context).primaryColorDark,
                  ),
                  welcomeWidget(
                    model.isSpanish ? "A" : "To",
                    Theme.of(context).primaryColorDark,
                  ),
                  welcomeWidget("Barcelona", Colors.orange),
                ],
              ),
            ),
            Builder(builder: (BuildContext context) {
              return getDataFromApiRest(context);
            })
          ],
        ),
      );
    });
  }
}
