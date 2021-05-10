import 'package:flutter/material.dart';

class DataCenter extends ChangeNotifier {
  
  //Name Screen
  double lon, lat;
  String nameStation;

  setName(newName) {
    nameStation = newName;
    notifyListeners();
  }

  getName() {
    return nameStation;
  }

  setlon(numero) {
    lon = numero;
    notifyListeners();
  }

  getlon() {
    return lon;
  }

  setlat(lattitude) {
    lat = lattitude;
    notifyListeners();
  }

  getlat() {
    return lat;
  }
}
