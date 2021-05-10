import 'package:apiflutter/models/wholejson.dart';
import 'package:apiflutter/service/tram_service.dart';
import 'package:chopper/chopper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Gallerystation.dart';

class TramsList extends StatefulWidget {
  @override
  _TramsListState createState() => _TramsListState();
}

class _TramsListState extends State<TramsList> {
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

  ListView _buildMovieList(BuildContext context, WholeJSON wholeJSON) {
    return ListView.builder(
      itemCount: wholeJSON.data.trams.length,
      padding: EdgeInsets.all(8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  color: Colors.red,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Gallerystation(
                              stationsName: wholeJSON.data.trams[index].name)),
                    )
                  },
                  child: null,
                ),
                Container(
                  width: 150,
                  height: 60,
                  child: Text(
                    wholeJSON.data.trams[index].name,
                    style: TextStyle(fontSize: 14, color: Colors.blue),
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 60,
                    child: Column(
                      children: <Widget>[
                        Text(
                          wholeJSON.data.trams[index].lat,
                          style: TextStyle(
                              fontSize: 14, color: Colors.orangeAccent),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                            child: Container(
                                child: Text(
                          wholeJSON.data.trams[index].lon,
                          style:
                              TextStyle(fontSize: 12, color: Colors.redAccent),
                        ))),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
