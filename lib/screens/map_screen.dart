import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:track_person/models/place_location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {

  final PlaceLocationModel initialLocation;
  final bool isReadOnly;

  const MapScreen({super.key, 
    this.initialLocation = const PlaceLocationModel(
                            latitude: 37.422, 
                            longitude: -122.084),
    this.isReadOnly = false,
  });
 
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng? _pickedPosition;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione...'),
        actions: <Widget>[
          if(!widget.isReadOnly)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: _pickedPosition == null 
              ? null 
              : () {
                Navigator.of(context).pop(_pickedPosition);
              }, 
            )
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            widget.initialLocation.latitude, 
            widget.initialLocation.longitude,
            ),
            zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: (_pickedPosition == null && !widget.isReadOnly) 
              ? {}
              : {
                Marker(
                  markerId: MarkerId('p1'),
                  position: _pickedPosition ?? widget.initialLocation.toLatLng(),
                ),
              },
        ),
    );
  }
}