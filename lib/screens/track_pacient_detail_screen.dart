import 'package:flutter/material.dart';
import 'package:track_person/models/patient_model.dart';
//import 'package:map_places/screens/live_location_screen.dart';
import 'package:track_person/screens/map_screen.dart';
import 'package:track_person/screens/track_pacient_add_local_form_screen.dart';

class TrackPacientDetailScreen extends StatelessWidget {
  const TrackPacientDetailScreen({super.key});

  @override
    Widget build(BuildContext context) {
      final PatientModel patient = ModalRoute.of(context)?.settings.arguments as PatientModel;
      print('Localização recuperada: ${patient.area?.first.latitude}, ${patient.area?.first.longitude}');

      return Scaffold(
        appBar: AppBar(
          title: Text(patient.name),
        ),
        body: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: patient.area?.length ?? 0,
                      itemBuilder: (ctx, i) {
                        final area = patient.area![i];
                        return ListTile(
                          leading: Icon(Icons.location_on),
                          title: Text(area.address ?? 'Endereço não disponível'),
                        );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      TextButton.icon(
                        icon: Icon(Icons.add_location_alt_outlined),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (ctx) => TrackPacientAddLocalFormScreen(
                                patient: patient,
                              ),
                            ),
                          );
                        },
                        label: Text('Adicionar local'),
                      ),
                      TextButton.icon(
                        icon: Icon(Icons.map),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              fullscreenDialog: true,
                              builder: (ctx) => MapScreen(
                                isReadOnly: true,
                                initialLocation: patient.area!.first,
                              ),
                            ),
                          );
                        },
                        label: Text('Ver no mapa'),
                      ),
                    ],
                  ),
                ],
              ),
      );
    }
}