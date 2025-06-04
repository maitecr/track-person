import 'dart:math';
import 'package:track_person/models/patient_model.dart';
import 'package:track_person/models/place_location_model.dart';

class CheckAreaDelimited {
  static void verificar(PatientModel patient) {
    final current = patient.currentLocation;
    final areas = patient.area;

    if (current == null || areas == null || areas.isEmpty) {
      print('Dados insuficientes para verificar localização do paciente: ${patient.name}');
      return;
    }

    final estaFora = _isForaDeTodasAsAreas(current, areas);

    if (estaFora) {
      print('🚨 Paciente "${patient.name}" está FORA da área permitida!');
    } else {
      print('✅ Paciente "${patient.name}" está dentro da área permitida.');
    }
  }

  static bool _isForaDeTodasAsAreas(
      PlaceLocationModel current, List<PlaceLocationModel> areas) {
    for (final area in areas) {
      final distancia = _calcularDistanciaEmMetros(
        current.latitude,
        current.longitude,
        area.latitude,
        area.longitude,
      );

      final raio = area.radius ?? 0;
      if (distancia <= raio) {
        return false; // está dentro de uma área
      }
    }
    return true; // está fora de todas as áreas
  }

  static double _calcularDistanciaEmMetros(
      double lat1, double lon1, double lat2, double lon2) {
    const double raioTerra = 6371000; // em metros
    final dLat = _deg2rad(lat2 - lat1);
    final dLon = _deg2rad(lon2 - lon1);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(_deg2rad(lat1)) * cos(_deg2rad(lat2)) *
            sin(dLon / 2) * sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return raioTerra * c;
  }

  static double _deg2rad(double grau) {
    return grau * pi / 180;
  }
}
