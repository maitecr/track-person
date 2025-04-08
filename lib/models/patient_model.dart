import 'package:track_person/models/place_location_model.dart';

class PatientModel {
  final String id;
  final String name;
  final List<PlaceLocationModel>? area;

  PatientModel({
    required this.id,
    required this.name,
    this.area,
  });
 

  toJson() {
    return {
    "name": name,
    "area": area,
    };
  }
}

