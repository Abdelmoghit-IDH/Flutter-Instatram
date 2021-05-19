import 'dart:io';
import 'package:path/path.dart';

import 'package:file_picker/file_picker.dart';
import 'package:apiflutter/api/firebase_api.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DetailImageStation extends StatelessWidget {
  static final String title = 'Image Gallery';
  final String stationsName;
  // In the constructor, require a Todo.
  DetailImageStation({Key key, @required this.stationsName, todo})
      : super(key: key);

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: title,
        theme: ThemeData(primarySwatch: Colors.green),
        home: MainPage(),
      );
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  UploadTask task;
  File file;
  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file.path) : 'No File';
    // Use the Todo to create the UI.
    return Scaffold(
        body: Padding(
            padding: EdgeInsets.all(32),
            child: Center(
              child: Column(
                children: [
                  FutureBuilder(
                      future: getImage(context),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          return Container(
                              width: MediaQuery.of(context).size.width / 1.5,
                              height: MediaQuery.of(context).size.width / 1.5,
                              child: snapshot.data);
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: MediaQuery.of(context).size.width / 1.2,
                            height: MediaQuery.of(context).size.width / 1.2,
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Container();
                      }),
                  // ignore: deprecated_member_use
                  FlatButton(
                    color: Colors.green,
                    onPressed: selectFile,
                    child: Text('Select File'),
                  ),
                  SizedBox(height: 8),
                  Text(fileName,
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                  // ignore: deprecated_member_use
                  FlatButton(
                    color: Colors.green,
                    onPressed: uploadFile,
                    child: Text('Upload File'),
                  ),
                  SizedBox(height: 48),
                ],
              ),
            )));
  }

  Future<Widget> getImage(BuildContext context) async {
    Image image;
    String nothing;
    await FileStorageService.loadImage(context, nothing).then((value) {
      image = Image.network(
        value.toString(),
        fit: BoxFit.scaleDown,
      );
    });
    return image;
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result == null) return;
    final path = result.files.single.path;
    setState(() => file = File(path));
  }

  Future uploadFile() async {
    selectFile();
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}

class FileStorageService extends ChangeNotifier {
  FileStorageService();
  // ignore: non_constant_identifier_names
  static Future<dynamic> loadImage(BuildContext context, String Image) async {
    return await FirebaseStorage.instance.ref().child(Image).getDownloadURL();
  }
}
