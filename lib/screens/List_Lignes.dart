import 'package:apiflutter/Global/Global_variables.dart';
import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:apiflutter/shared_data/MainModel.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/tram.dart';
import '../models/wholejson.dart';
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
      theActualThemeIsdark = model.darkTheme;
      return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Builder(builder: (BuildContext context) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                SizedBox(height: SizeConfig.blockSizeHorizontal * 2),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Icon(null),
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
                        showBottomSheet(
                            context: context,
                            builder: (context) {
                              return Wrap(
                                children: [
                                  Container(
                                    color: Theme.of(context).accentColor,
                                    child: ListTile(
                                      title: Text(
                                        AppTranslations.of(context)
                                            .text("settings"),
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
                                      AppTranslations.of(context)
                                          .text("Light / Dark"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 5,
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
                                      AppTranslations.of(context)
                                          .text("English / Spanish"),
                                      style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            SizeConfig.blockSizeHorizontal * 5,
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
                                            print(model.isSpanish);
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
                Container(
                  height: SizeConfig.safeBlockVertical * 90,
                  child: _buildBody(context),
                ),
              ],
            );
          }));
    });
  }

  FutureBuilder<Response<WholeJSON>> _buildBody(BuildContext context) {
    return FutureBuilder<Response<WholeJSON>>(
      future: Provider.of<TramService>(context).getTrams(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                textAlign: TextAlign.center,
                textScaleFactor: 1.3,
              ),
            );
          }
          final popular = snapshot.data.body;
          return _buildTramList(context, popular);
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  ListView _buildTramList(BuildContext context, WholeJSON wholeJSON) {
    TramService data = Provider.of<TramService>(context);

    // Todo : inialize the list of stations
    List<TramUtile> stationsT1 = [];
    List<TramUtile> stationsT2 = [];
    List<TramUtile> stationsT3 = [];
    List<TramUtile> stationsT4 = [];
    List<TramUtile> stationsT5 = [];
    List<TramUtile> stationsT6 = [];

    // Todo : affect the list of stations to the list define in the provider
    data.stationsT1 = stationsT1;
    data.stationsT2 = stationsT2;
    data.stationsT3 = stationsT3;
    data.stationsT4 = stationsT4;
    data.stationsT5 = stationsT5;
    data.stationsT6 = stationsT6;

    for (var i = 0; i < wholeJSON.data.trams.length; i++) {
      data.allStations.add(TramUtile(
        connections: wholeJSON.data.trams[i].connections,
        id: double.parse(wholeJSON.data.trams[i].id),
        line: wholeJSON.data.trams[i].line,
        name: wholeJSON.data.trams[i].name,
        type: wholeJSON.data.trams[i].type,
        zone: wholeJSON.data.trams[i].zone,
        lat: double.parse(wholeJSON.data.trams[i].lat),
        lon: double.parse(wholeJSON.data.trams[i].lon),
      ));
      List<String> lignes = wholeJSON.data.trams[i].line.split('-');
      for (var j = 0; j < lignes.length; j++) {
        TramUtile tram = TramUtile(
          connections: wholeJSON.data.trams[i].connections,
          id: double.parse(wholeJSON.data.trams[i].id),
          line: lignes[j],
          name: wholeJSON.data.trams[i].name,
          type: wholeJSON.data.trams[i].type,
          zone: wholeJSON.data.trams[i].zone,
          lat: double.parse(wholeJSON.data.trams[i].lat),
          lon: double.parse(wholeJSON.data.trams[i].lon),
        );
        if (lignes[j].compareTo('T1') == 0) stationsT1.add(tram);
        if (lignes[j].compareTo('T2') == 0) stationsT2.add(tram);
        if (lignes[j].compareTo('T3') == 0) stationsT3.add(tram);
        if (lignes[j].compareTo('T4') == 0) stationsT4.add(tram);
        if (lignes[j].compareTo('T5') == 0) stationsT5.add(tram);
        if (lignes[j].compareTo('T6') == 0) stationsT6.add(tram);
      }
      //............................................................trier tout les listes des lignes par l id
      //.........................................................supposant que 2 id qui se suivent
      //.........................................................correspondent a 2 stations qui se suivent
      data.sortStation(stationsT1);
      data.sortStation(stationsT2);
      data.sortStation(stationsT3);
      data.sortStation(stationsT4);
      data.sortStation(stationsT5);
      data.sortStation(stationsT6);
    }
    List<String> lignes = [
      AppTranslations.of(context).text("Line") + " T1",
      AppTranslations.of(context).text("Line") + " T2",
      AppTranslations.of(context).text("Line") + " T3",
      AppTranslations.of(context).text("Line") + " T4",
      AppTranslations.of(context).text("Line") + " T5",
      AppTranslations.of(context).text("Line") + " T6",
      AppTranslations.of(context).text("All Tram Stations"),
    ];

    // ignore: unused_element
    String subTitleLigneStation(int index) {
      return index == 0
          ? AppTranslations.of(context).text("From") +
              stationsT1[0].name +
              AppTranslations.of(context).text("To") +
              stationsT1[stationsT1.length - 1].name
          : index == 1
              ? AppTranslations.of(context).text("From") +
                  stationsT2[0].name +
                  AppTranslations.of(context).text("To") +
                  stationsT2[stationsT2.length - 1].name
              : index == 2
                  ? AppTranslations.of(context).text("From") +
                      stationsT3[0].name +
                      AppTranslations.of(context).text("To") +
                      stationsT3[stationsT3.length - 1].name
                  : index == 3
                      ? AppTranslations.of(context).text("From") +
                          stationsT4[0].name +
                          AppTranslations.of(context).text("To") +
                          stationsT4[stationsT4.length - 1].name
                      : index == 4
                          ? AppTranslations.of(context).text("From") +
                              stationsT5[0].name +
                              AppTranslations.of(context).text("To") +
                              stationsT5[stationsT5.length - 1].name
                          : index == 5
                              ? AppTranslations.of(context).text("From") +
                                  stationsT6[0].name +
                                  AppTranslations.of(context).text("To") +
                                  stationsT6[stationsT6.length - 1].name
                              : "";
    }

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
                  Text(
                    subTitleLigneStation(index),
                    style:
                        TextStyle(color: Theme.of(context).primaryColorLight),
                  )
                ],
              ),
              onPressed: () {
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
