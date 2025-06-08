import 'package:flutter/material.dart';
import 'package:track_person/widgets/location_input.dart';
import 'package:track_person/provider/original_place.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_person/models/patient_model.dart';
import 'package:provider/provider.dart';
import 'package:track_person/widgets/logout_button.dart';

class TrackPacientAddLocalFormScreen extends StatefulWidget {

  final PatientModel patient;

  const TrackPacientAddLocalFormScreen({
    super.key,
    required this.patient,
  });

  @override
  State<TrackPacientAddLocalFormScreen> createState() => _TrackPacientAddLocalFormScreenState();
}

class _TrackPacientAddLocalFormScreenState extends State<TrackPacientAddLocalFormScreen> {

  final _titleController = TextEditingController();
  LatLng? _pickedPosition;
  double? _pickedRadius;

  void _selectPosition(LatLng position, double radius) {
    print(position.latitude);
    print(position.longitude);
    print("Raio selecionado: $radius metros");
    setState((){
      _pickedPosition = position;
      _pickedRadius = radius;
    });
  }

  bool _isValidForm() {
    return (_pickedPosition != null && _pickedRadius != null); 
  }

  void _submitForm() {
    if(!_isValidForm()) return;

    Provider.of<OriginalPlace>(context, listen: false).addLocationToPatient(widget.patient.id, _titleController.text, _pickedPosition!, _pickedRadius!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.patient.name}'),
      ),
      
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [

                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título do Local',
                      ),
                    ),

                    SizedBox(height: 10,),
                                     
                    LocationInput(_selectPosition, ),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            icon: Icon(Icons.add),
                            label: Text('Adicionar'),
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all<Color>(Color.fromRGBO(117, 158, 255, 1)),
                              elevation: WidgetStateProperty.all<double>(0),
                              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.zero, 
                                                                ), 
                                                              ),
                            ),
                            onPressed: _isValidForm() ? _submitForm : null, 
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10,),

                  ],
                ),
              ),
            ),
          ),
        ],
      ),

    );
  }
}