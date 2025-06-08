import 'package:flutter/material.dart';
import 'package:track_person/provider/original_place.dart';
import 'package:track_person/util/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:track_person/widgets/logout_button.dart';

class TrackPacientListScreen extends StatefulWidget {
  @override
  _TrackPacientListScreenState createState() => _TrackPacientListScreenState();
}

class _TrackPacientListScreenState extends State<TrackPacientListScreen> {
  @override
  void initState() {
    super.initState();
    // Chama o loadPatients assim que a tela for carregada
    Provider.of<OriginalPlace>(context, listen: false).loadPatients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de monitorados"),
        actions: <Widget>[
          LogoutButton(),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.TRACK_PACIENT_FORM);
        },
        child: Icon(Icons.add),
      ),
  
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<OriginalPlace>(context, listen: false).loadPatients();
        },
        child: Consumer<OriginalPlace>(
          builder: (ctx, originalPlace, ch) {
            if (originalPlace.itemsCount == 0) {
              return Center(child: Text('Sem pacientes cadastrados'));
            }
            return ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: originalPlace.itemsCount,
              itemBuilder: (ctx, i) => ListTile(
                title: Text(originalPlace.itemByIndex(i).name),
                subtitle: Text('Código: ${originalPlace.itemByIndex(i).code ?? 'Sem código'}'),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.TRACK_PATIENT_DETAIL,
                    arguments: originalPlace.itemByIndex(i),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
