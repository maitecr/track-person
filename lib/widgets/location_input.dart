import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_person/models/place_location_model.dart';
import 'package:track_person/screens/map_screen.dart';
import 'package:track_person/util/location_util.dart';

class LocationInput extends StatefulWidget {

    final Function(LatLng, double) onSelectPosition;
  
    const LocationInput(this.onSelectPosition, {super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String? _previewImageUrl;

  void _showPreview(double lat, double lng) {
    final staticMapImageUrl = LocationUtil.generateLocationPreviewImage(
                                            latitude: lat, 
                                            longitude: lng);
    setState(() {
      _previewImageUrl = staticMapImageUrl;
    });  
  }


  Future<void> _selectOnMap() async {
    final currentLoc = await Location().getLocation();

    final Map selectionsResults = await Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (ctx) => MapScreen(
          locations: [
            PlaceLocationModel(
              latitude: currentLoc.latitude!,
              longitude: currentLoc.longitude!
            )
          ],
        ),
      )
    );

    if(selectionsResults == null) return;

    final LatLng selectedPosition = selectionsResults['position'];
    final double selectedRadius = selectionsResults['radius'];

    _showPreview(selectedPosition.latitude, selectedPosition.longitude);

    print("PEGAR LOCALIZAÇÃO ATUAL - LAT: ${selectedPosition.latitude}");
    print("PEGAR LOCALIZAÇÃO ATUAL - LNG: ${selectedPosition.longitude}");
    print("RAIO SELECIONADO: $selectedRadius metros");


    widget.onSelectPosition(selectedPosition, selectedRadius);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Color.fromARGB(255, 158, 158, 158),
            )
          ),
          child: _previewImageUrl == null
                ? Text('Localização não informada')
                : Image.network(
                  _previewImageUrl!,
                  fit: BoxFit.cover,
                  ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [          
            TextButton.icon(
              icon: Icon(Icons.location_on), 
              label: Text('Selecione no mapa'),
              onPressed: _selectOnMap,
            )
          ],
        )
      ],
    );
  }
}