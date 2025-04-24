import 'dart:convert';
import 'dart:math';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:track_person/models/patient_model.dart';
import 'package:track_person/models/place_location_model.dart';
import 'package:track_person/util/location_util.dart';
import 'package:track_person/util/generate_patient_code.dart';
import 'package:track_person/util/sqflite.dart';

class OriginalPlace with ChangeNotifier {

  //final _firebaseUrl = [YOUR_FIREBASE_URL];

  List<PatientModel> _items = [];

  Future<void> loadPatients() async {
    final response = await http.get(Uri.parse('$_firebaseUrl/track_person.json'));
    print(jsonDecode(response.body));

    if (response.statusCode == 200) {
      final extractedData = jsonDecode(response.body) as Map<String, dynamic>?;
      if (extractedData == null) return;

        _items = extractedData.entries.map((entry) {
        final data = entry.value;
        final areaList = (data['area'] as List<dynamic>?)?.map((area) {
          return PlaceLocationModel(
            title: area['title'],
            latitude: area['lat'],
            longitude: area['lng'],
            address: area['address'],
          );
        }).toList();

        return PatientModel(
          id: entry.key,
          name: data['name'],
          code: data['code'],
          area: areaList,
        );
        }).toList();
        
        notifyListeners();
    } else {
      throw Exception('Erro ao carregar pacientes.');
    }

    // final dataList = await SqfliteDB.getData('track_person');
    // _items = dataList.map(
    //   (item) => PatientModel(
    //     id: item['id'],
    //     name: item['name'],
    //     area: [
    //       PlaceLocationModel(
    //         latitude: item['lat'],
    //         longitude: item['lng'],
    //         address: item['address'],
    //       )
    //     ],
    //   ),
    // ).toList();
    //notifyListeners();  
  }

  List<PatientModel> get items {
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  PatientModel itemByIndex(int index) {
    return _items[index];
  }

  Future<void> addTrackedPatient(String name, String title, LatLng position) async {

    String patientCode = generatePatientCode(name);
    print(patientCode);

    String address = await LocationUtil.getAddressFrom(position);

    final newPatient = PatientModel(
      id: Random().nextDouble().toString(), 
      name: name, 
      code: patientCode,
      area: [
          PlaceLocationModel(
          title: title,
          latitude: position.latitude, 
          longitude: position.longitude,
          address: address,
        ),
      ]
    );

    http.post(
      Uri.parse('$_firebaseUrl/track_person.json'),
      body: jsonEncode({
        'name': newPatient.name,
        'code': newPatient.code,
        'area': newPatient.area?.map((loc) => {
          'title': loc.title,
          'lat': loc.latitude,
          'lng': loc.longitude,
          'address': loc.address,
        }).toList(),
      })
    );

    // _items.add(newPatient);
    // SqfliteDB.insert('track_person', {
    //   'id': newPatient.id,
    //   'name': newPatient.name,
    //   'lat': position.latitude,
    //   'lng': position.longitude,
    //   'address': address,
    // });
    notifyListeners();
  }

  Future<void> addLocationToPatient(String patientId, String title, LatLng position) async {
    final patientIndex = _items.indexWhere((p) => p.id == patientId);
    if(patientIndex < 0) return;

    String address = await LocationUtil.getAddressFrom(position);

    final newLocation = PlaceLocationModel(
      title: title,
      latitude: position.latitude, 
      longitude: position.longitude,
      address: address,
    );

    final updatedArea = [...?_items[patientIndex].area, newLocation];

    final updatedPatient = PatientModel(
      id: _items[patientIndex].id,
      name: _items[patientIndex].name,
      area: updatedArea,
    );

      _items[patientIndex] = updatedPatient;

    await http.patch(
      Uri.parse('$_firebaseUrl/track_person/${updatedPatient.id}.json'),
      body: jsonEncode({
        'area': updatedArea.map((loc) => {
          'title': loc.title,
          'lat': loc.latitude,
          'lng': loc.longitude,
          'address': loc.address,
        }).toList(),
      }),
    );

    notifyListeners();
  }

}