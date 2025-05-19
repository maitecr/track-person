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
  double _delimitedRadius = 100;

  void _selectPosition(LatLng position) {
    setState(() {
      _pickedPosition = position;
    });
  }

  void _submit() {
    if (_pickedPosition == null) return;
      Navigator.of(context).pop({
        'position': _pickedPosition,
        'radius': _delimitedRadius,
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
              onPressed:_pickedPosition == null ? null : _submit, 
            )
        ],
      ),

      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.locations.isNotEmpty
                ? LatLng(widget.locations.first.latitude, widget.locations.first.longitude,)
                : LatLng(0, 0),
                zoom: 13,
              ),
              onTap: widget.isReadOnly ? null : _selectPosition,
              markers: widget.isReadOnly
                  ? widget.locations.map((loc) {
                      final isCurrent = loc.title == 'Localização Atual';
                      return Marker(
                        markerId: MarkerId('${loc.latitude},${loc.longitude}'),
                        position: LatLng(loc.latitude, loc.longitude),
                        infoWindow: InfoWindow(
                          title: isCurrent ? 'Localização atual' : loc.address ?? 'Local',
                          snippet: loc.address,
                        ),
                        icon: isCurrent
                                ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure)
                                : BitmapDescriptor.defaultMarker,
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
              circles: widget.isReadOnly
                      ? widget.locations.map((loc) {
                          return Circle(
                            circleId: CircleId('${loc.latitude},${loc.longitude}'),
                            center: LatLng(loc.latitude, loc.longitude),
                            radius: loc.radius ?? 100,   
                            strokeColor: Colors.blue,
                            fillColor: Colors.blue.withOpacity(0.2),
                            strokeWidth: 2,
                          );
                        }).toSet()
                      :
               _pickedPosition == null
                ? {}
                : {
                  Circle(
                    circleId: CircleId('c1'),
                    center: _pickedPosition!,
                    radius: _delimitedRadius,
                    strokeColor: Colors.blue,
                    fillColor: Colors.blue.withOpacity(0.2),
                    strokeWidth: 2,
                  ),
                },
              ),
          ),
            if (!widget.isReadOnly && _pickedPosition != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  SizedBox(height: 10),
                  Text('Raio: ${_delimitedRadius.toStringAsFixed(0)} metros'),
                  Slider(
                    value: _delimitedRadius,
                    min: 10,
                    max: 1000,
                    divisions: 99,
                    label: "${_delimitedRadius.toStringAsFixed(0)} m",
                    onChanged: (val) {
                      setState(() {
                        _delimitedRadius = val;
                      });
                    },
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
        ],
      ),
    );
  }
}