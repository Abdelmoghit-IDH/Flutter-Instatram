import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'uploadImage.dart';


class Gallerystation extends StatefulWidget {
  final String stationsName;
  Gallerystation({Key key, @required this.stationsName}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(stationsName);
}



class _HomePageState extends State<Gallerystation> {
  String sname;
  _HomePageState(String sname) {
    this.sname = sname;
  }

  double paddingSize = 8;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
          title: Text(AppTranslations.of(context).text("Photos of ") + sname)),
      floatingActionButton: FloatingActionButton.extended(
        icon: Icon(Icons.add_a_photo),
        label: Text(AppTranslations.of(context).text("Add a photo")),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddImage(stationsName: sname)));
        },
      ),
      body: StreamBuilder(
        //................. ici on stream du firestore le snapshot de la collection
        //................. correspendante au nom de la station
        //........................................................................
        //................. un autre avantage ici pour le widget stream c'est que
        //................. a chaque changement dans le firestore s'applique instantanemant
        //................. y compris l'ajout d'un poste
        stream: FirebaseFirestore.instance.collection(sname).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            //............ce docs est une liste qui contient les documents(chacun est un post)
            //............il est contenu dans la data du snapshot
            List<QueryDocumentSnapshot> docs = snapshot.data.docs;
            //............ le sort ici se fait par rapport a la date pour
            //............ voir en premier les postes les plus recents
            sortDocs(docs);
            //............ le return pour contruire les postes
            return buildListView(docs);
          } else {
            //............avant le chargment de donnés
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  ListView buildListView(List<QueryDocumentSnapshot> docsList) {
    return ListView.builder(
        itemCount: docsList.length,
        padding: EdgeInsets.all(
            paddingSize), // padding size est un double definie en hors
        //......................................va etre reutilise apres
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
                    offset: Offset(0, 3), // changes position of shadow
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          //........... image du profil et le nom
                          //........... pas de backend en dessous just pour l'illustration
                          buildProfilContainer(),
                          //............ la date du poste
                          Text(
                            docsList[index].data()['date'],
                            style: TextStyle(color: Colors.grey),
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
                        //........titre du poste
                        children: [Text(docsList[index].data()['title'])],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //........... l image du poste
                    buildImageContainer(
                        docsList[index].data()['imageUrl'],
                        docsList[index].data()['imageWidth'],
                        docsList[index].data()['imageHeight']),
                    SizedBox(
                      height: 3,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //...... l icone de like mais pas de backend
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
  }

  Container buildProfilContainer() {
    return Container(
      //color: Colors.green,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/images/profil.jpg'),
            radius: 20,
            //backgroundColor: ,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Xavi Lopez",
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Container buildImageContainer(
      String imageUrl, double imageWidth, double imageHeight) {
    // au lien d'ituliser double.infinity
    //car on a besoin de cette valeur dans un apport
    double imageContainerWidth =
        MediaQuery.of(context).size.width - paddingSize;
    return Container(
      width: imageContainerWidth,
      //ce rapport est c'est pour garder la place exact a laquelle on a besoin pour afficher
      //l image
      height: imageContainerWidth < imageWidth
          ? imageHeight * imageContainerWidth / imageWidth
          : imageHeight,
      child: CachedNetworkImage(
        fit: BoxFit.scaleDown,
        placeholder: (context, url) => Container(
          //color: Colors.grey,
          child: SizedBox(
            height: 100,
            width: 100,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
        imageUrl: imageUrl,
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}

sortDocs(List<QueryDocumentSnapshot> docsList) {
  QueryDocumentSnapshot docInter;
  for (var i = 0; i < docsList.length; i++) {
    for (var j = 0; j < docsList.length; j++) {
      if (docsList[i].data()['date'].compareTo(docsList[j].data()['date']) >
          0) {
        docInter = docsList[i];
        docsList[i] = docsList[j];
        docsList[j] = docInter;
      }
    }
  }
}
