import 'package:flutter/material.dart';
import 'package:track_person/util/app_routes.dart';

class TrackPacientListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de monitorados"),
        actions: <Widget> [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(AppRoutes.TRACK_PACIENT_FORM);
            },
          ),
        ],
      ),

      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
  
}