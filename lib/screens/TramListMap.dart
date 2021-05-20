import 'package:apiflutter/Global/Global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../models/tram.dart';
import '../service/tram_service.dart';

class TramListMap extends StatefulWidget {
  final index;
  const TramListMap({Key key, this.index}) : super(key: key);

  @override
  _TramListMapState createState() => _TramListMapState();
}

class _TramListMapState extends State<TramListMap> {
  //....................l'indice referant le num de la ligne
  //....................nomé widget.index pour le distinguer du widget.index en bas

  bool isMapCreated = false;
  GoogleMapController _controller;

  //************Cette fonction est utilisée pour changer la couleur de la Map**********/
  changeMapMode() {
    if (theActualThemeIsdark) {
      getJsonFile("assets/map_styles/dark.json").then(setMapStyle);
    } else {
      getJsonFile("assets/map_styles/light.json").then(setMapStyle);
    }
  }
  //***Fonction utile pour fetch fichier json***/
  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  void setMapStyle(String mapStyle) {
    _controller.setMapStyle(mapStyle);
  }

  @override
  void initState() {
    super.initState();
    changeMapMode();
  }

  @override
  Widget build(BuildContext context) {
    if (isMapCreated) {
      changeMapMode();
    }
    return Scaffold(
      body: _buildTramList(context),
    );
  }

  Container _buildTramList(BuildContext context) {
    TramService data = Provider.of<TramService>(context);
    //...................ce fichier ou n a l'acces depuis n'importe ou dans le projet
    //...................on reprend l'un des list dont on a beasoin
    List<TramUtile> listTarget;
    if (widget.index == 1) listTarget = data.stationsT1;
    if (widget.index == 2) listTarget = data.stationsT2;
    if (widget.index == 3) listTarget = data.stationsT3;
    if (widget.index == 4) listTarget = data.stationsT4;
    if (widget.index == 5) listTarget = data.stationsT5;
    if (widget.index == 6) listTarget = data.stationsT6;
    if (widget.index == 7) listTarget = data.allStations;

    List<Marker> markers = [];

    listTarget.forEach((element) {
      print(element);
      markers.add(
        Marker(
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
              title: element.name, snippet: "........EMPTY.FOR.NOW........"),
          markerId: MarkerId(element.name),
          position: LatLng(element.lat, element.lon),
        ),
      );
    });

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: GoogleMap(
        mapType: MapType.normal,
        onMapCreated: (GoogleMapController controller) {
          _controller = controller;
          isMapCreated = true;
          changeMapMode();
          setState(() {});
        },
        markers: Set.from(markers),
        initialCameraPosition: CameraPosition(
          target: LatLng(
              //...........................................les lignes qui suivent pour afficher la map
              //...........................................dans le centre des sations cibles
              (listTarget[0].lat + listTarget[listTarget.length - 1].lat) / 2,
              (listTarget[0].lon + listTarget[listTarget.length - 1].lon) / 2),
          zoom: 12,
        ),
      ),
    );
  }
}
