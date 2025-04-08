import 'package:flutter/material.dart';
import 'package:track_person/provider/original_place.dart';
import 'package:track_person/util/app_routes.dart';
import 'package:provider/provider.dart';

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

      body: FutureBuilder(
        future: Provider.of<OriginalPlace>(context, listen: false).loadPatients(),
        builder: (ctx, snapshop) => snapshop.connectionState == ConnectionState.waiting
                                      ? Center(child: CircularProgressIndicator(),)
                                      : Consumer<OriginalPlace>(
          child: Center(child: Text('Sem pacientes cadastrados'), ),
          builder: (ctx, originalPlace, ch) => originalPlace.itemsCount == 0 
                          ? ch! 
                          : ListView.builder(
                            itemCount: originalPlace.itemsCount,
                            itemBuilder: (ctx, i) => ListTile(
                              title: Text(originalPlace.itemByIndex(i).name),
                              onTap: () {},
                            ), 
                          ),
        ),
      ),
    );
  }
  
}