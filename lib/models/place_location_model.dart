import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceLocationModel {
  final String? title;
  final double latitude;
  final double longitude;
  final String? address;
  final double? radius;

  const PlaceLocationModel({
    this.title,
    required this.latitude,
    required this.longitude,
    this.address,
    this.radius,
  });

  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }

}