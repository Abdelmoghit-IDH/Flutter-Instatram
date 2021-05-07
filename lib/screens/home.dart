import 'package:flutter/material.dart';
import 'package:ui/Global/SizeConfig.dart';
import 'package:ui/Language/AppTranslations.dart';
import 'package:ui/screens/TramListMap.dart';
import 'package:ui/screens/TramList.dart';

class Home extends StatefulWidget {
  const Home({Key key, this.index}) : super(key: key);
  final index;
  @override
  _HomeState createState() => _HomeState(index);
}

class _HomeState extends State<Home> {
  int _currentTabIndex = 0;
  final index;

  _HomeState(this.index);

  @override
  Widget build(BuildContext context) {
    //..........................................................le contenue des 2 tabs
    final _kTabPages = <Widget>[
      TramsList(index: this.index),
      TramListMap(index: this.index),
    ];
    //..........................................................les icons des 2 tabs
    final _kBottmonNavBarItems = <BottomNavigationBarItem>[
       BottomNavigationBarItem(icon: Icon(Icons.list), label: AppTranslations.of(context).text("List"),),
       BottomNavigationBarItem(icon: Icon(Icons.map), label: AppTranslations.of(context).text("Map"),),
    ];
    //..........................................................pour s'assurer qu'on a 2 tabs et 2 contenu
    assert(_kTabPages.length == _kBottmonNavBarItems.length);
    //..........................................................la bottom nav bar ou on a les icons
    final bottomNavBar = BottomNavigationBar(
      fixedColor: Theme.of(context).accentColor,
      iconSize: SizeConfig.blockSizeHorizontal * 7,
      items: _kBottmonNavBarItems,
      currentIndex: _currentTabIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (int index) {
        setState(() {
          _currentTabIndex = index;
        });
      },
      backgroundColor: Theme.of(context).primaryColorLight,
    );
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(
              color: Theme.of(context).primaryColorDark //change your color here
              ),
          foregroundColor: Colors.black,
          backgroundColor: Theme.of(context).primaryColorLight,
          centerTitle: true,
          title: Text(
            index != 7
                ?  'T${this.index} '+ AppTranslations.of(context)
                                        .text("Line Tram Stations")
                : 'All Tram Stations',
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontFamily: 'Jura-VariableFont',
              fontSize: SizeConfig.blockSizeHorizontal * 5,
              fontWeight: FontWeight.w800,
            ),
          )),
      body: _kTabPages[_currentTabIndex],
      bottomNavigationBar: bottomNavBar,
    );
  }
}
