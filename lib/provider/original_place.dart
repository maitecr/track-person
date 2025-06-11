import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'package:track_person/models/patient_model.dart';
import 'package:track_person/models/place_location_model.dart';
import 'package:track_person/util/location_util.dart';
import 'package:track_person/util/generate_patient_code.dart';
import 'package:track_person/util/check_area_delimited.dart';

class OriginalPlace with ChangeNotifier {

  List<PatientModel> _items = [];

  Timer? _timerVerify;

  Future<void> loadPatients() async {
    final ref = FirebaseDatabase.instance.ref('track_person');

    final snapshot = await ref.get();

    if (!snapshot.exists) {
      print('Nenhum paciente encontrado no banco.');
      return;
    }

    final extractedData = snapshot.value as Map<dynamic, dynamic>?;

    if (extractedData == null) return;

    _items = extractedData.entries.map((entry) {
      final key = entry.key as String;
      final data = entry.value as Map<dynamic, dynamic>;

      final areaList = (data['area'] as List<dynamic>?)
          ?.where((area) => area != null)
          .map((area) {
        final areaMap = area as Map<dynamic, dynamic>;
        return PlaceLocationModel(
          title: areaMap['title'],
          latitude: areaMap['lat'],
          longitude: areaMap['lng'],
          address: areaMap['address'],
          radius: (areaMap['radius'] as num?)?.toDouble(),
        );
      }).toList();

      final currentLocationData = data['currentLocation'] as Map<dynamic, dynamic>?;
      final currentLocation = currentLocationData != null
          ? PlaceLocationModel(
              title: currentLocationData['title'],
              latitude: currentLocationData['latitude'],
              longitude: currentLocationData['longitude'],
              address: currentLocationData['address'],
              radius: (currentLocationData['radius'] as num?)?.toDouble(),
            )
          : null;

      return PatientModel(
        id: key,
        name: data['name'],
        code: data['code'],
        area: areaList,
        currentLocation: currentLocation,
      );
    }).toList();

    _items.sort((a, b) => a.name.compareTo(b.name)); 

    startTimerVerification();

    notifyListeners();
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

  Future<void> addTrackedPatient(String name, String title, LatLng position, double radius) async {
    String patientCode = generatePatientCode(name);
    String address = await LocationUtil.getAddressFrom(position);

    final newPatient = PatientModel(
      id: '', 
      name: name,
      code: patientCode,
      area: [
        PlaceLocationModel(
          title: title,
          latitude: position.latitude,
          longitude: position.longitude,
          address: address,
          radius: radius,
        ),
      ],
      currentLocation: null,
    );

    final ref = FirebaseDatabase.instance.ref('track_person').push(); // cria um novo ID único

    await ref.set({
      'name': newPatient.name,
      'code': newPatient.code,
      'area': newPatient.area?.map((loc) => {
        'title': loc.title,
        'lat': loc.latitude,
        'lng': loc.longitude,
        'address': loc.address,
        'radius': loc.radius,
      }).toList(),
      'currentLocation': {},
    });

    notifyListeners();
  }

  Future<void> addLocationToPatient(String patientId, String title, LatLng position, double radius) async {
    final patientIndex = _items.indexWhere((p) => p.id == patientId);
    if (patientIndex < 0) return;

    String address = await LocationUtil.getAddressFrom(position);

    final newLocation = PlaceLocationModel(
      title: title,
      latitude: position.latitude,
      longitude: position.longitude,
      address: address,
      radius: radius,
    );

    final updatedArea = [...?_items[patientIndex].area, newLocation];

    final oldPatient = _items[patientIndex];

    final updatedPatient = PatientModel(
      id: _items[patientIndex].id,
      name: _items[patientIndex].name,
      area: updatedArea,
      currentLocation: oldPatient.currentLocation,
    );

    _items[patientIndex] = updatedPatient;

    final ref = FirebaseDatabase.instance.ref('track_person/$patientId/area');

    await ref.set(updatedArea.map((loc) => {
      'title': loc.title,
      'lat': loc.latitude,
      'lng': loc.longitude,
      'address': loc.address,
      'radius': loc.radius,
    }).toList());

    notifyListeners();
  }

Future<PlaceLocationModel?> fetchCurrentLocation(String patientId) async {
  final ref = FirebaseDatabase.instance.ref('track_person/$patientId/currentLocation');

  final snapshot = await ref.get();

  print('Conectou no banco de dados para o paciente $patientId');

  if (!snapshot.exists) {
    print('Localização não encontrada para o paciente $patientId');
    return null;
  }

  final data = snapshot.value as Map<dynamic, dynamic>;

  final location = PlaceLocationModel(
    title: data['title'] ?? 'Localização Atual',
    latitude: data['latitude'],
    longitude: data['longitude'],
    address: data['address'] ?? 'Endereço desconhecido',
    radius: (data['radius'] as num?)?.toDouble(),
  );

  print('📍 Localização atual do paciente $patientId: '
      '(${location.latitude}, ${location.longitude})');

  startTimerVerification();

  return location;
}

void startTimerVerification({Duration intervalo = const Duration(seconds: 15)}) {
    _timerVerify?.cancel(); 

    _timerVerify = Timer.periodic(intervalo, (_) async {
      await updateCurrenLocations();
      for (final patient in _items) {
        CheckAreaDelimited.verificar(patient);
      }
    });
  }

Future<void> updateCurrenLocations() async {
  for (int i = 0; i < _items.length; i++) {
    final loc = await fetchCurrentLocation(_items[i].id);
    if (loc != null) {
      _items[i] = PatientModel(
        id: _items[i].id,
        name: _items[i].name,
        code: _items[i].code,
        area: _items[i].area,
        currentLocation: loc,
      );
    }
  }
  notifyListeners();
}

}