import 'package:track_person/models/place_location_model.dart';

class PatientModel {
  final String id;
  final String name;
  final String? code;
  final List<PlaceLocationModel>? area;
  final PlaceLocationModel? currentLocation;

  PatientModel({
    required this.id,
    required this.name,
    this.code,
    this.area,
    this.currentLocation,
  });
 

  toJson() {
    return {
    "name": name,
    "code": code,
    "area": area,
    "currentLocation": currentLocation?.toJson(),
    };
  }
}
