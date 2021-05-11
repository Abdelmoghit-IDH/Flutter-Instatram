import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'uploadImage.dart';
import 'dart:async';

class Gallerystation extends StatefulWidget {
  final String stationsName;
  // In the constructor, require a Todo.
  Gallerystation({Key key, @required this.stationsName, todo})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(stationsName);
}

final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

class _HomePageState extends State<Gallerystation> {
  String sname;
  _HomePageState(String sname) {
    this.sname = sname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[800],
        appBar: AppBar(
            title:
                Text(AppTranslations.of(context).text("Photos of ") + sname)),
        floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.add_a_photo),
          label: Text(AppTranslations.of(context).text("Add a photo")),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddImage(stationsName: sname)));
          },
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: refresh,
          child: Container(
            child: FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('stations')
                    .doc(sname)
                    .get(),
                builder: (BuildContext context,
                    AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                    List listeImages = _buildImageGrid(snapshot.data.data());
                    return ListView.builder(
                        itemCount: listeImages.length,
                        padding: EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                //border: Border.all(color: Colors.grey),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 2,
                                    blurRadius: 10,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            //color: Colors.green,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      'images/profil.jpg'),
                                                  radius: 20,
                                                  //backgroundColor: ,
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  "Xavi Lopez",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                )
                                              ],
                                            ),
                                          ),
                                          Text(
                                            "1/1/2000 10:15",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Text(
                                              ".......................title here...........................")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    listeImages[index],
                                    SizedBox(
                                      height: 3,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.favorite_border,
                                            size: 30,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                    /*return GridView.custom(
                          shrinkWrap: true,
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1,
                            mainAxisSpacing: 5.0,
                            crossAxisSpacing: 5.0,
                          ),
                          childrenDelegate: SliverChildListDelegate(
                              _buildImageGrid(snapshot.data.data())),
                        );*/
                  } else {
                    // Show a loading indicator while waiting for the movies
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ));
  }

  List _buildImageGrid(Map<String, dynamic> dataxxx) {
    List<Widget> list = [];

    dataxxx.forEach((key, value) {
      list.add(
        Container(
          child: CachedNetworkImage(
            height: 250,
            fit: BoxFit.contain,
            placeholder: (context, url) => Container(
              //color: Colors.grey,
              width: double.infinity,

              child: SizedBox(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            imageUrl: dataxxx[key],
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
      //dataxxx[key].
    });

    return list;
  }
  //todo: this future function is used to refresh the screen
  Future<Null> refresh() async {
    await Future.delayed(Duration(seconds: 1));
    setState(() {});
  }
}

class FileStorageService extends ChangeNotifier {
  FileStorageService();

  static Future<dynamic> loadImage(String stationName) async {
    await FirebaseFirestore.instance
        .collection('/stations')
        .doc(stationName)
        .set({"bka": " bla"});
    int i = 0;

    Map<String, String> tb = {};

    await FirebaseStorage.instance
        .ref()
        .child('stations')
        .child(stationName)
        .listAll()
        .then((value) => value.items.forEach((element) {
              element.getDownloadURL().then((value) async {
                tb.putIfAbsent(i.toString(), () => value);

                i++;

                await FirebaseFirestore.instance
                    .collection('/stations')
                    .doc(stationName)
                    .update(tb);
              });
            }));

    await FirebaseFirestore.instance
        .collection('/stations')
        .doc(stationName)
        .update({"bka": FieldValue.delete()});
  }
}
