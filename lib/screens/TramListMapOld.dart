import 'package:apiflutter/models/wholejson.dart';
import 'package:apiflutter/service/Stations.dart';
import 'package:apiflutter/service/tram_service.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TramListMap extends StatefulWidget {
  @override
  _TramListMapState createState() => _TramListMapState();
}

class _TramListMapState extends State<TramListMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movie Listings'),
      ),
      body: _buildBody(context),
    );
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
          return _buildMovieList(context, popular);
        } else {
          // Show a loading indicator while waiting for the movies
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  Container _buildMovieList(BuildContext context, WholeJSON wholeJSON) {
    for (var i = 0; i < wholeJSON.data.trams.length; i++) {
      stations.add(
        Stations(
          stationsName: wholeJSON.data.trams[i].name,
          lattitude: double.parse(wholeJSON.data.trams[i].lat),
          longitude: double.parse(wholeJSON.data.trams[i].lon),
        ),
      );
      print(stations[i]);
    }

    List<Marker> allMarkers = [];

    stations.forEach((element) {
      print(element);
      allMarkers.add(Marker(
          infoWindow: InfoWindow(
            title: element.stationsName,
            snippet: "Ha nta ba hatim 5 5"
          ),
          markerId: MarkerId(element.stationsName),
          position: LatLng(element.lattitude, element.longitude)));
    });

    return Container(
      height: double.infinity,
      width: double.infinity,
      child: GoogleMap(
        markers: Set.from(allMarkers),
        initialCameraPosition: CameraPosition(
          target: LatLng(41.3797331039552, 2.06704907259576),
          zoom: 12,
        ),
      ),
    );
  }
}

List<Stations> stations = [];
