import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceLocationModel {
  final double latitude;
  final double longitude;
  final String? address;

  const PlaceLocationModel({
    required this.latitude,
    required this.longitude,
    this.address,
  });

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

}