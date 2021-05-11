import 'dart:io';
import 'package:apiflutter/Language/AppTranslations.dart';
import 'package:apiflutter/Screens/Gallerystation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class AddImage extends StatefulWidget {
  final String stationsName;
  // In the constructor, require a Todo.
  AddImage({Key key, @required this.stationsName, todo}) : super(key: key);
  @override
  _AddImageState createState() => _AddImageState(stationsName);
}

class _AddImageState extends State<AddImage> {
  UploadTask task;
  File file;
  String fileName;
  String sname;
  _AddImageState(String sname) {
    this.sname = sname;
  }
  bool uploading = false;
  double val = 0;
  DocumentReference imgRef;
  firebase_storage.Reference ref;

  File _imaage;
  final picker = ImagePicker();
  final myController = TextEditingController();
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.of(context).text("Add a photo")),
        actions: [
          // ignore: deprecated_member_use
          FlatButton(
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
      /*body: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(4),
              child: GridView.builder(
                  itemCount: 2,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () =>
                                    !uploading ? chooseImage() : null),
                          )
                        : _imaage != null
                            ? Container(
                                margin: EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: FileImage(_imaage),
                                        fit: BoxFit.cover)),
                              )
                            : Container();
                  }),
            ),
            TextField(
              controller: myController..text = "image title",
              onChanged: (text) => {},
            ),
            uploading
                ? Center(
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        child: Text(
                          'uploading...',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                      )
                    ],
                  ))
                : Container(),
          ],
        )*/
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.91,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  //backgroundImage: _imaage != null ? FileImage(_imaage) : null,
                  //radius: 100,
                  //backgroundColor: brown,

                  child: _imaage == null
                      ? IconButton(
                          icon: Icon(
                            Icons.add_a_photo_outlined,
                            size: 40,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            //!uploading ? chooseImage() : null;
                            var ad = AlertDialog(
                              title: Text(AppTranslations.of(context)
                                  .text("Choose photo from")),
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
                                        title: Text(AppTranslations.of(context)
                                            .text("Gallery")),
                                        onTap: () {
                                          !uploading
                                              ? chooseImage(ImageSource.gallery)
                                              : null;
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
                                        title: Text(AppTranslations.of(context)
                                            .text("Camera")),
                                        onTap: () {
                                          !uploading
                                              ? chooseImage(ImageSource.camera)
                                              : null;
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                            showDialog(
                                context: context,
                                builder: (BuildContext context) => ad);
                          })
                      : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Image.file(_imaage)),
                        )),
              Theme(
                data: ThemeData(
                  primaryColor: Colors.orange,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(40.0),
                  //..............................................................TextField
                  child: TextField(
                    controller: myController, //..text = "image title",
                    //onChanged: (text) => {},
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(
                        //fillColor: Color(0x99D79D6A),
                        filled: true,
                        border: OutlineInputBorder(),
                        hintText: AppTranslations.of(context)
                            .text('Enter the photo title'),
                        labelText: AppTranslations.of(context).text('Title'),
                        icon: Icon(Icons.title)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
    int i = 1;

    setState(() {
      val = i / 1;
    });
    ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('stations/$sname/$filename');
    await ref.putFile(_imaage).whenComplete(() async {
      await FileStorageService.loadImage(sname);
    });
  }
  /*Future chooseImage() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() => file = File(path));
  }

  Future uploadFile(String fileName) async {
    if (file == null) return;

    final destination = 'stations/$sname/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() async {
      await FileStorageService.loadImage(sname);
    });
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }*/

  @override
  void initState() {
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('stations').doc(sname);
  }
}
