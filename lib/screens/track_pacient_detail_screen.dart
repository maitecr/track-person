import 'package:flutter/material.dart';
import 'package:track_person/models/patient_model.dart';
import 'package:track_person/screens/map_screen.dart';
import 'package:track_person/screens/track_pacient_add_local_form_screen.dart';
import 'package:track_person/provider/original_place.dart';
import 'package:provider/provider.dart';
import 'package:track_person/widgets/logout_button.dart';

class TrackPacientDetailScreen extends StatefulWidget {
  const TrackPacientDetailScreen({super.key});

  @override
  State<TrackPacientDetailScreen> createState() => _TrackPacientDetailScreenState();
}

class _TrackPacientDetailScreenState extends State<TrackPacientDetailScreen> {

  late PatientModel patient;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    patient = ModalRoute.of(context)!.settings.arguments as PatientModel;
  }

  Future<void> _refreshData() async {
    final provider = Provider.of<OriginalPlace>(context, listen: false);
    await provider.loadPatients();
    final updated = provider.items.firstWhere((p) => p.id == patient.id);
    setState(() {
      patient = updated;
    });
  }

  @override
    Widget build(BuildContext context) {
      //final PatientModel patient = ModalRoute.of(context)?.settings.arguments as PatientModel;
      //print('Localização recuperada: ${patient.area?.first.latitude}, ${patient.area?.first.longitude}');

      return Scaffold(
        appBar: AppBar(
          title: Text(patient.name),
          actions: <Widget>[
            LogoutButton(),
          ],
        ),
        
        body: RefreshIndicator(
          onRefresh: _refreshData,
          child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: patient.area?.length ?? 0,
                        itemBuilder: (ctx, i) {
                          final area = patient.area![i];
                          return ListTile(
                            leading: Icon(Icons.location_on),
                            title: Text(area.title ?? 'Local não disponível') ,
                            subtitle: Text(area.address ?? 'Endereço não disponível'),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          icon: Icon(Icons.add_location_alt_outlined),
                          onPressed: () async {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (ctx) => TrackPacientAddLocalFormScreen(
                                  patient: patient,
                                ),
                              ),
                            );
                            await _refreshData();
                          },
                          label: Text('Adicionar local'),
                        ),
                        TextButton.icon(
                          icon: Icon(Icons.map),
                          onPressed: () {
                              final locations = [
                                        ...?patient.area, 
                                        if (patient.currentLocation != null) patient.currentLocation!,
                                        ];

                            Navigator.of(context).push(
                              MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (ctx) => MapScreen(
                                  isReadOnly: true,
                                  locations: locations,
                                  currentLocation: patient.currentLocation,
                                  patientId: patient.id,
                                ),
                              ),
                            );
                          },
                          label: Text('Monitorar'),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      );
    }
}