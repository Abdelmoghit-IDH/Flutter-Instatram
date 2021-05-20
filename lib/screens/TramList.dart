import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:apiflutter/screens/StationMap.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../models/tram.dart';
import '../service/tram_service.dart';
import 'Gallerystation.dart';

// ignore: must_be_immutable
class TramsList extends StatefulWidget {
  final index;

  TramsList({
    Key key,
    this.index,
  }) : super(key: key);
  @override
  _TramsListState createState() => _TramsListState(index);
}

class _TramsListState extends State<TramsList> {
  final indexx; //........................................l'indice referant le num de la ligne
  //......................................................nomé indexx pour le distinguer du index en bas
  _TramsListState(this.indexx);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTramList(context),
    );
  }

  ListView _buildTramList(BuildContext context) {
    TramService data = Provider.of<TramService>(context);
    List<TramUtile> listTarget;
    if (indexx == 1) listTarget = data.stationsT1;
    if (indexx == 2) listTarget = data.stationsT2;
    if (indexx == 3) listTarget = data.stationsT3;
    if (indexx == 4) listTarget = data.stationsT4;
    if (indexx == 5) listTarget = data.stationsT5;
    if (indexx == 6) listTarget = data.stationsT6;
    if (indexx == 7) listTarget = data.allStations;

    return ListView.builder(
      itemCount: listTarget.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return TimelineTile(
          //.................................................TimelineTile pour faire appaitre les stations liées
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: index == 0,
          isLast: index == listTarget.length - 1,
          indicatorStyle: IndicatorStyle(
            width: 40,
            height: 40,
            indicator:
                _IndicatorExample(station: listTarget[index], index: index + 1),
            drawGap: true,
          ),
          beforeLineStyle: LineStyle(
            color: Theme.of(context).accentColor,
          ),
          endChild: _RowExample(example: listTarget[index]),
        );
      },
    );
  }
}

//...........................................cette Classe qui represente un widget est celle qui definie ce qui
//...........................................se trouve a gauche de chaque statio
//...........................................dans notre cas une icone comme marker (pour l'instant)
class _IndicatorExample extends StatelessWidget {
  const _IndicatorExample({Key key, this.station, this.index})
      : super(key: key);

  final TramUtile station;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.fromBorderSide(
          BorderSide(
            color: Theme.of(context).accentColor,
            width: 4,
          ),
        ),
      ),
      child: Center(
          child: IconButton(
        padding: const EdgeInsets.all(0.0),
        icon: Icon(
          Icons.location_pin,
          color: index % 4 == 0
              ? Colors.red
              : index % 4 == 1
                  ? Colors.blue
                  : index % 4 == 2
                      ? Colors.green
                      : index % 4 == 3
                          ? Colors.yellow
                          : null,
        ),
        onPressed: () {
          //todo
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => StationMap(station: this.station)),
          );
        },
      )),
    );
  }
}

//...........................................cette Classe qui represente un widget est celle qui definie ce qui
//...........................................se trouve a droite du dernier widget dont on a parle
//...........................................dans notre cas le nom du station et l icon clicable pour passer
//...........................................au photos de chaque station
// ignore: must_be_immutable
class _RowExample extends StatelessWidget {
  _RowExample({
    Key key,
    this.example,
  }) : super(key: key);

  final TramUtile example;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Gallerystation(stationsName: example.name)),
          );
        },
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                example.name,
                style: TextStyle(
                  color: Theme.of(context).primaryColorDark,
                  fontFamily: 'Jura-VariableFont',
                  fontSize: SizeConfig.blockSizeHorizontal * 4.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Icon(
              Icons.navigate_next,
              color: Theme.of(context).accentColor,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
}
