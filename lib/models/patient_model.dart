import 'package:track_person/models/place_location_model.dart';

class PatientModel {
  final String id;
  final String name;
  final String? code;
  final List<PlaceLocationModel>? area;

  PatientModel({
    required this.id,
    required this.name,
    this.code,
    this.area,
  });
 

  toJson() {
    return {
    "name": name,
    "code": code,
    "area": area,
    };
  }
}

