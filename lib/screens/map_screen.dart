import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:track_person/models/place_location_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:track_person/provider/original_place.dart';

class MapScreen extends StatefulWidget {

  final List<PlaceLocationModel> locations;
  final PlaceLocationModel? currentLocation;
  final String? patientId;
  final bool isReadOnly;

  const MapScreen({super.key, 
    required this.locations,
    this.isReadOnly = false,
    this.currentLocation,
    this.patientId,
  });
 
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {

  LatLng? _pickedPosition;
  double _delimitedRadius = 100;

  PlaceLocationModel? _liveLocation;
  Timer? _timer;

  GoogleMapController? _mapController;

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
  void initState() {
    super.initState();
      _fetchLiveLocation();
      _timer = Timer.periodic(const Duration(seconds: 15), (timer) {
        _fetchLiveLocation();
      });
  }

  Future<void> _fetchLiveLocation() async {
    print('Entrou no fetchLiveLocation');

    print('Iniciando fetchLiveLocation para paciente: ${widget.patientId}');

    if (widget.patientId == null) {
      print('patientId é nulo, abortando fetch.');
      return;
    }

    final provider = Provider.of<OriginalPlace>(context, listen: false);
    final loc = await provider.fetchCurrentLocation(widget.patientId!);

    if (loc != null) {
      setState(() {
        _liveLocation = loc;
      });

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLng(
            LatLng(loc.latitude, loc.longitude),
          ),
        );
      }
    } else {
      print('Localização atual não disponível.');
    }

  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

  final allLocations = [
    ...widget.locations.where((loc) => loc.title != 'Localização Atual'),
    if (_liveLocation != null) _liveLocation!,
  ];
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
              onMapCreated: (controller) {
                _mapController = controller;
              },
              initialCameraPosition: CameraPosition(
                target: allLocations.isNotEmpty
                ? LatLng(allLocations.first.latitude, allLocations.first.longitude,)
                : LatLng(0, 0),
                zoom: 13,
              ),
              onTap: widget.isReadOnly ? null : _selectPosition,
              markers: widget.isReadOnly
                  ? allLocations.map((loc) {
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
                      ? allLocations
                        .where((loc) => loc.title != 'Localização Atual')
                        .map((loc) {
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