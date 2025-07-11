import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_person/provider/original_place.dart';
import 'package:track_person/widgets/location_input.dart';
import 'package:provider/provider.dart';
class TrackPacientFormScreen extends StatefulWidget {

  @override
  State<TrackPacientFormScreen> createState() => _TrackPacientFormScreenState();
}

class _TrackPacientFormScreenState extends State<TrackPacientFormScreen> {
  final _nameController = TextEditingController();
  final _titleController = TextEditingController();

  LatLng? _pickedPosition;
  double? _pickedRadius;

  void _selectPosition(LatLng position, double radius) {
    setState((){
      _pickedPosition = position;
      _pickedRadius = radius;
    });
  }

  bool _isValidForm() {
    return (_nameController.text.isNotEmpty && _pickedPosition != null); 
  }

  void _submitForm() {
    if(!_isValidForm()) return;

    Provider.of<OriginalPlace>(context, listen: false).addTrackedPatient(_nameController.text, _titleController.text, _pickedPosition!, _pickedRadius!);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registre Monitorado"),
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),

                    SizedBox(height: 10,),

                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Título do Local',
                      ),
                    ),

                    SizedBox(height: 10,),

                    LocationInput(_selectPosition),
                  ],
                ),
              ),
            )
          ),

          ElevatedButton.icon(
            icon: Icon(Icons.add),
            label: Text('Adicionar'),
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all<Color>(const Color.fromRGBO(117, 158, 255, 1)),
              elevation: WidgetStateProperty.all<double>(0),
              padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.zero, // Remove as bordas arredondadas
                                                ) 
                                              ),
            ),
            onPressed: _isValidForm() ? _submitForm : null, 
          )
        ],
      ),
    );
  }
}