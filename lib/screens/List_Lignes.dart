import 'package:apiflutter/Global/Global_variables.dart';
import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:apiflutter/shared_data/MainModel.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';
import '../service/tram_service.dart';
import 'home.dart';

class ListLignes extends StatefulWidget {
  @override
  _ListLignesState createState() => _ListLignesState();
}

class _ListLignesState extends State<ListLignes> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      //**cette variable est utilisée pour avoir le theme de la dernier ouverture**/
      theActualThemeIsdark = model.darkTheme;
      return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  height: SizeConfig.safeBlockVertical * 10,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_sharp,
                          size: SizeConfig.blockSizeHorizontal * 6,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Text(
                        model.isSpanish ? 'Lista de líneas' : 'Lines list',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontFamily: 'Jura-VariableFont',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
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
                                        scale: 1.5,
                                        child: Switch(
                                          activeColor:
                                              Theme.of(context).accentColor,
                                          inactiveThumbColor:
                                              Theme.of(context).accentColor,
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
                ),
              ),
              Container(
                height: SizeConfig.safeBlockVertical * 90,
                child: _tramList(context),
              ),
            ],
          ));
    });
  }

//**Cette fonction est utilisée pour construire les button des lignes**/

  ListView _tramList(BuildContext context) {
    //***On declare cette variable pour prendre les données utile depuis Provider***//
    TramService data = Provider.of<TramService>(context);

    //***List qui coontient toute les chaines de character des noms des lignes***//
    List<String> lignes = [
      AppTranslations.of(context).text("Line") + " T1",
      AppTranslations.of(context).text("Line") + " T2",
      AppTranslations.of(context).text("Line") + " T3",
      AppTranslations.of(context).text("Line") + " T4",
      AppTranslations.of(context).text("Line") + " T5",
      AppTranslations.of(context).text("Line") + " T6",
      AppTranslations.of(context).text("All Tram Stations"),
    ];

    //***Cette fonction est utilisée pour ajouter subTitle à station par index***//
    String subTitleLigneStation(int index) {
      return index == 0
          ? AppTranslations.of(context).text("From") +
              data.stationsT1[0].name +
              AppTranslations.of(context).text("To") +
              data.stationsT1[data.stationsT1.length - 1].name
          : index == 1
              ? AppTranslations.of(context).text("From") +
                  data.stationsT2[0].name +
                  AppTranslations.of(context).text("To") +
                  data.stationsT2[data.stationsT2.length - 1].name
              : index == 2
                  ? AppTranslations.of(context).text("From") +
                      data.stationsT3[0].name +
                      AppTranslations.of(context).text("To") +
                      data.stationsT3[data.stationsT3.length - 1].name
                  : index == 3
                      ? AppTranslations.of(context).text("From") +
                          data.stationsT4[0].name +
                          AppTranslations.of(context).text("To") +
                          data.stationsT4[data.stationsT4.length - 1].name
                      : index == 4
                          ? AppTranslations.of(context).text("From") +
                              data.stationsT5[0].name +
                              AppTranslations.of(context).text("To") +
                              data.stationsT5[data.stationsT5.length - 1].name
                          : index == 5
                              ? AppTranslations.of(context).text("From") +
                                  data.stationsT6[0].name +
                                  AppTranslations.of(context).text("To") +
                                  data.stationsT6[data.stationsT6.length - 1]
                                      .name
                              : "";
    }
    //***Return list des buttons des lignes ***//
    return ListView.builder(
      itemCount: lignes.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          color: Theme.of(context).primaryColor,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 40,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            lignes[index],
                            style: TextStyle(
                              color: Theme.of(context).primaryColorDark,
                              fontFamily: 'Jura-VariableFont',
                              fontSize: 23,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.navigate_next,
                          color: Colors.grey,
                          size: 26,
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: Text(
                      subTitleLigneStation(index),
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(color: Theme.of(context).primaryColorLight),
                    ),
                  )
                ],
              ),
              onPressed: () {
                //***On clique buttom tab 'index' => Aller au screen Home(index)***//
                //***Il faut noté que le parametre index represente le button de chaque***/
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Home(index: index + 1)),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
