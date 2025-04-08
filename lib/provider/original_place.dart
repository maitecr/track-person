import 'dart:math';

import 'package:flutter/material.dart';
import 'package:track_person/models/patient_model.dart';
import 'package:track_person/models/place_location_model.dart';
import 'package:track_person/util/sqflite.dart';

class OriginalPlace with ChangeNotifier {
  
  List<PatientModel> _items = [];

  Future<void> loadPatients() async {
    final dataList = await SqfliteDB.getData('track_person');
  _items = dataList.map(
    (item) => PatientModel(
      id: item['id'],
      name: item['name'],
      area: [
        PlaceLocationModel(
          latitude: item['lat'],
          longitude: item['lng'],
          address: item['address'],
        )
      ],
    ),
  ).toList();
  notifyListeners();  }

  List<PatientModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  PatientModel itemByIndex(int index) {
    return _items[index];
  }


  void addTrackedPatient(String name) {
    final newPatient = PatientModel(
      id: Random().nextDouble().toString(), 
      name: name, 
      area: null,
    );

    _items.add(newPatient);
    SqfliteDB.insert('track_person', {
    'id': newPatient.id,
    'name': newPatient.name,
    'lat': 0.0,
    'lng': 0.0,
    'address': '',
      });
    notifyListeners();
  }

}