import 'package:flutter/material.dart';
import 'TramListMap.dart';
import 'mapofStations.dart';

class MapCoordinate extends StatelessWidget {
  const MapCoordinate({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text("InstaTram"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text("Maps of stations", style: TextStyle(fontSize: 40)),
            IconButton(
                icon: Icon(
                  Icons.map,
                  size: 60,
                  color: Colors.green,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TramListMap()),
                  );
                }),
            Text("List of stations", style: TextStyle(fontSize: 40)),
            IconButton(
                icon: Icon(
                  Icons.list,
                  color: Colors.red,
                  size: 60,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TramsList()),
                  );
                })
          ],
        ),
      ),
    ));
  }
}
