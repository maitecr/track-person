import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:track_person/models/place_location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {

  final List<PlaceLocationModel> locations;
  final bool isReadOnly;

  const MapScreen({super.key, 
    required this.locations,
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
        title: Text(widget.isReadOnly ? 'Monitorando' : 'Selecione...'),
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
            widget.locations.first.latitude, 
            widget.locations.first.longitude,
            ),
            zoom: 13,
        ),
        onTap: widget.isReadOnly ? null : _selectPosition,
        markers: widget.isReadOnly
            ? widget.locations.map((loc) {
                return Marker(
                  markerId: MarkerId('${loc.latitude},${loc.longitude}'),
                  position: LatLng(loc.latitude, loc.longitude),
                  infoWindow: InfoWindow(title: loc.address),
                );
              }).toSet()
            : _pickedPosition == null
                ? {}
                : {
                    Marker(
                      markerId: MarkerId('p1'),
                      position: _pickedPosition!,
                    ),
                  },
        ),
    );
  }
}