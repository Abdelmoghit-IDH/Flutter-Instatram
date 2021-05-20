import 'package:apiflutter/Global/Global_variables.dart';
import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:apiflutter/screens/home.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(children: [
        Column(
          children: [
            Container(
              height: SizeConfig.safeBlockVertical * 75,
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 4,
                  ),
                  logoWidget("InstaTram"),
                  SizedBox(
                    height: SizeConfig.safeBlockVertical * 22,
                  ),
                  welcomeWidget(
                    AppTranslations.of(context).text("Welcome"),
                    Theme.of(context).primaryColorDark,
                  ),
                  welcomeWidget(
                    AppTranslations.of(context).text("to"),
                    Theme.of(context).primaryColorDark,
                  ),
                  welcomeWidget("Barcelona", Colors.orange),
                ],
              ),
            ),
            Expanded(
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
            ),
          ],
        ),
      ]),
    );
  }
}

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

//************************This functions is used to custom logo text*************************/

Center logoWidget(String text) {
  return Center(
      child: Text(
    text,
    style: TextStyle(
      fontSize: SizeConfig.safeBlockHorizontal * 9,
      fontFamily: 'Pattaya-Regular',
      color: Colors.black,
    ),
  ));
}

//************************This functions is used to custom bottom****************************/

Container custumButtomLinesList(
    String textButtom, String routeName, BuildContext context) {
  return Container(
    width: SizeConfig.blockSizeHorizontal * 80,
    height: SizeConfig.blockSizeVertical * 8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).primaryColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
    ),
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
  );
}

//************************This functions is used to custom bottom****************************/

Container custumButtomAllStations(String textButtom, BuildContext context) {
  return Container(
    width: SizeConfig.blockSizeHorizontal * 80,
    height: SizeConfig.blockSizeVertical * 8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      color: Theme.of(context).primaryColor,
      boxShadow: [
        BoxShadow(
          color: Colors.black12,
          spreadRadius: 0.5,
          blurRadius: 3,
          offset: Offset(0, 2),
        ),
      ],
    ),
    child: TextButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Home(index: indexAllStations)),
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
  );
}
