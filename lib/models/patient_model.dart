import 'package:track_person/models/place_location_model.dart';

class PatientModel {
  final String name;
  final List<PlaceLocationModel> area;

  PatientModel({
    required this.name,
    required this.area,
  });
 

  toJson() {
    return {
    "name": name,
    "area": area,
    };
  }
}

