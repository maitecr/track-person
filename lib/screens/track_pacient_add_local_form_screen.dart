import 'package:flutter/material.dart';
import 'package:track_person/models/patient_model.dart';

class TrackPacientAddLocalFormScreen extends StatelessWidget {

  final PatientModel patient;

  const TrackPacientAddLocalFormScreen({
    super.key,
    required this.patient,
  });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${patient.name}'),
      ),
      
    );
  }
}