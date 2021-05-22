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
              width: double.infinity,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(null),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
                      logoWidget("InstaTram"),
                      SizedBox(height: SizeConfig.blockSizeHorizontal * 6),
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
                                      color: Theme.of(context).primaryColor,
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
                                        scale: 1.3,
                                        child: Switch(
                                          inactiveThumbColor:
                                              Theme.of(context).primaryColor,
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          value: model.darkTheme,
                                          onChanged: (bool state) async {
                                            setState(() {
                                              //**Changer le theme OnSwitch**/
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
                                        scale: 1.3,
                                        child: Switch(
                                          activeColor:
                                              Theme.of(context).primaryColor,
                                          inactiveThumbColor:
                                              Theme.of(context).primaryColor,
                                          value: model.isSpanish,
                                          onChanged: (bool state) async {
                                            setState(() {
                                              //***Changer la langue OnSwitch***/
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
                  welcomeWidget("Barcelona",
                      Theme.of(context).primaryColor), //Color(0xfbbc05)
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
  //************************This functions is used to custom logo text*************************/

  Center logoWidget(String text) {
    return Center(
        child: Text(
      text,
      style: TextStyle(
        fontSize: SizeConfig.safeBlockHorizontal * 9,
        fontFamily: 'Pattaya-Regular',
        color: Theme.of(context).primaryColorLight,
      ),
    ));
  }
}
