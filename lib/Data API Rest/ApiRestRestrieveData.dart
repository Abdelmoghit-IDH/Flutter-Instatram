import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:apiflutter/models/tram.dart';
import 'package:apiflutter/models/wholejson.dart';
import 'package:apiflutter/screens/Home.dart';
import 'package:apiflutter/service/tram_service.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FutureBuilder<Response<WholeJSON>> getDataFromApiRest(BuildContext context) {
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
        final data = snapshot.data.body;
        return _dataTram(context, data);
      } else {
        return Center(
          child: CircularProgressIndicator(
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    },
  );
}

Expanded _dataTram(BuildContext context, WholeJSON wholeJSON) {
  TramService data = Provider.of<TramService>(context);

  // Todo : inialize the list of stations
  List<TramUtile> stationsT1 = [];
  List<TramUtile> stationsT2 = [];
  List<TramUtile> stationsT3 = [];
  List<TramUtile> stationsT4 = [];
  List<TramUtile> stationsT5 = [];
  List<TramUtile> stationsT6 = [];
  List<TramUtile> allStations = [];

  // Todo : affect the list of stations to the list define in the provider
  data.stationsT1 = stationsT1;
  data.stationsT2 = stationsT2;
  data.stationsT3 = stationsT3;
  data.stationsT4 = stationsT4;
  data.stationsT5 = stationsT5;
  data.stationsT6 = stationsT6;
  data.allStations = allStations;

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

    //...............trier tout les listes des lignes par l id...............
    //...............supposant que 2 id qui se suivent.......................
    //...............correspondent a 2 stations qui se suivent...............

    data.sortStation(stationsT1);
    data.sortStation(stationsT2);
    data.sortStation(stationsT3);
    data.sortStation(stationsT4);
    data.sortStation(stationsT5);
    data.sortStation(stationsT6);
  }

  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        custumButtomLinesList(
          AppTranslations.of(context).text("Lines list"),
          "ListLignes",
          context,
        ),
        custumButtomAllStations(
          AppTranslations.of(context).text("All Tram Stations"),
          context,
        ),
        SizedBox(
          height: SizeConfig.safeBlockVertical,
        ),
      ],
    ),
  );
}

//Todo: useful functions

//*************************This functions is used to custom welcome text**********************/

Center welcomeWidget(String text, Color color) {
  return Center(
      child: Text(
    text,
    style: TextStyle(
      fontSize: SizeConfig.safeBlockHorizontal * 13,
      fontWeight: FontWeight.bold,
      fontFamily: 'Celesse',
      color: color,
    ),
  ));
}

//************************This functions is used to custom bottom****************************/

Card custumButtomLinesList(
    String textButtom, String routeName, BuildContext context) {
  return Card(
    color: Theme.of(context).cardColor, //TODO
    shadowColor: Theme.of(context).primaryColor, //TODO
    elevation: 4,
    child: Container(
      width: SizeConfig.blockSizeHorizontal * 80,
      height: SizeConfig.blockSizeVertical * 8,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, "/$routeName");
        },
        child: Text(
          textButtom,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Jura-VariableFont',
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}

//************************This functions is used to custom bottom****************************/

Card custumButtomAllStations(String textButtom, BuildContext context) {
  return Card(
    color: Theme.of(context).cardColor, //TODO
    shadowColor: Theme.of(context).primaryColor, //TODO
    elevation: 4,
    child: Container(
      width: SizeConfig.blockSizeHorizontal * 80,
      height: SizeConfig.blockSizeVertical * 8,
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        child: Text(
          textButtom,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Jura-VariableFont',
            color: Theme.of(context).primaryColorDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
