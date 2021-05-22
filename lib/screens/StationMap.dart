import 'package:apiflutter/Global/Global_variables.dart';
import 'package:apiflutter/Global/SizeConfig.dart';
import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/tram.dart';

class StationMap extends StatefulWidget {
  final TramUtile station;
  const StationMap({Key key, this.station}) : super(key: key);

  @override
  _StationMapState createState() => _StationMapState(station);
}

class _StationMapState extends State<StationMap> {
  final TramUtile station;
  bool isMapCreated = false;
  GoogleMapController _controller;

  _StationMapState(this.station);

  changeMapMode() {
    if (theActualThemeIsdark) {
      getJsonFile("assets/map_styles/dark.json").then(setMapStyle);
    } else {
      getJsonFile("assets/map_styles/light.json").then(setMapStyle);
    }
  }

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
      appBar: AppBar(
          iconTheme: IconThemeData(
              color: Theme.of(context).primaryColorDark //change your color here
              ),
          foregroundColor: Colors.black,
          backgroundColor: Theme.of(context).bottomAppBarColor,
          centerTitle: true,
          title: Text(
            station.name,
            style: TextStyle(
              color: Theme.of(context).primaryColorDark,
              fontFamily: 'Jura-VariableFont',
              fontSize: SizeConfig.blockSizeHorizontal * 5,
              fontWeight: FontWeight.w800,
            ),
          )),
      body: _buildTramList(context),
    );
  }

  Container _buildTramList(BuildContext context) {
    List<Marker> markers = [
      Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: InfoWindow(
            title: station.name,
            snippet: ".... " +
                AppTranslations.of(context).text("Line") +
                " " +
                station.line +
                " ...."),
        markerId: MarkerId(station.name),
        position: LatLng(station.lat, station.lon),
      ),
    ];

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
          target: LatLng(station.lat, station.lon),
          zoom: 18,
        ),
      ),
    );
  }
}
