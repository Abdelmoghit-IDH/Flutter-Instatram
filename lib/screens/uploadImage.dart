import 'dart:io';
import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:intl/intl.dart';
import 'package:path/path.dart' as Path;

class AddImage extends StatefulWidget {
  final String stationsName;
  AddImage({
    Key key,
    @required this.stationsName,
  }) : super(key: key);
  @override
  _AddImageState createState() => _AddImageState(stationsName);
}

class _AddImageState extends State<AddImage> {
  String stationsName;
  _AddImageState(String sname) {
    this.stationsName = sname;
  }
  bool uploading = false;
  firebase_storage.Reference ref;

  File _imaage;
  final picker = ImagePicker();
  final myController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("Add a photo")),
        actions: [
          //................................boutton upload
          TextButton(
              onPressed: () {
                setState(() {
                  uploading = true;
                });
                uploadFile(myController.text)
                    .whenComplete(() => Navigator.of(context).pop());
              },
              child: Text(
                AppTranslations.of(context).text("Upload"),
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: uploading
          ? Container(
              //..........................this is for loading after uploading an image
              width: double.infinity,
              height: double.infinity,
              child: Center(child: CircularProgressIndicator()),
            )
          : SingleChildScrollView(
              //..........................this is the normal body
              child: Container(
                height: MediaQuery.of(context).size.height * 0.91,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        //..........................ya hadi ya hadi
                        child: _imaage == null
                            ? IconButton(
                                //..................boutton pour ajouter image
                                icon: Icon(
                                  Icons.add_a_photo_outlined,
                                  size: 40,
                                  color: Colors.black,
                                ),
                                onPressed: onClickAddPhoto)
                            : Padding(
                                //..................l'image apres etre selectionne
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.5,
                                    child: Image.file(_imaage)),
                              )),
                    //..............................................TextField
                    Theme(
                      data: ThemeData(
                        primaryColor: Colors.orange,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: buildTitleTextField(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  TextField buildTitleTextField(BuildContext context) {
    return TextField(
      controller: myController,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
          filled: true,
          border: OutlineInputBorder(),
          hintText: AppTranslations.of(context).text('Enter the photo title'),
          labelText: AppTranslations.of(context).text('Title'),
          icon: Icon(Icons.title)),
    );
  }

  onClickAddPhoto() {
    var ad = AlertDialog(
      title: Text(AppTranslations.of(context).text("Choose photo from")),
      content: Container(
        height: 150,
        child: Column(
          children: [
            Divider(
              color: Colors.black,
            ),
            Container(
              width: 300,
              color: Colors.orange.withOpacity(0.1),
              child: ListTile(
                leading: Icon(Icons.image),
                title: Text(AppTranslations.of(context).text("Gallery")),
                onTap: () {
                  chooseImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              color: Colors.orange.withOpacity(0.1),
              child: ListTile(
                leading: Icon(Icons.add_a_photo),
                title: Text(AppTranslations.of(context).text("Camera")),
                onTap: () {
                  chooseImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
    showDialog(context: context, builder: (BuildContext context) => ad);
  }

  chooseImage(ImageSource x) async {
    final pickedFile = await picker.getImage(source: x);
    setState(() {
      _imaage = File(pickedFile?.path);
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _imaage = File(response.file.path);
      });
    } else {
      print(response.file);
    }
  }

  Future uploadFile(String filename) async {
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('stations/$stationsName/${Path.basename(_imaage.path)}');
    await ref.putFile(_imaage).whenComplete(() async {
      var downurl = await ref.getDownloadURL();
      var decodedImage = await decodeImageFromList(_imaage.readAsBytesSync());
      await FileStorageService.loadImage(
          stationsName,
          downurl.toString(),
          filename,
          decodedImage.width.toDouble(),
          decodedImage.height.toDouble());
    });
  }
}

class FileStorageService extends ChangeNotifier {
  FileStorageService();
  static Future<dynamic> loadImage(String stationName, String imageUrl,
      String filename, double imageWidth, double imageHeight) async {
    await FirebaseFirestore.instance.collection(stationName).add({
      'date': DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()),
      'imageUrl': imageUrl,
      'title': filename,
      'imageWidth': imageWidth,
      'imageHeight': imageHeight,
    });
  }
}
