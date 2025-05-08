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

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "latitude": latitude,
      "longitude": longitude,
      "address": address,
      "radius": radius,
    };
  }

  factory PlaceLocationModel.fromJson(Map<String, dynamic> json) {
    return PlaceLocationModel(
      title: json['title'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      radius: (json['radius'] as num?)?.toDouble(),
    );
  }

}