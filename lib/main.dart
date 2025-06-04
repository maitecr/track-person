import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:track_person/screens/track_pacient_detail_screen.dart';
import 'package:track_person/screens/track_pacient_form_screen.dart';
import 'package:track_person/screens/track_pacient_list_screen.dart';
import 'package:track_person/util/app_routes.dart';
import 'package:track_person/provider/original_place.dart';
import 'package:track_person/util/sqflite.dart';
import 'package:firebase_core/firebase_core.dart';

// Future<void> deleteDatabaseFile() async {
//   final dbPath = await getDatabasesPath();
//   final fullPath = path.join(dbPath, 'track_person.db');
//   await deleteDatabase(fullPath);
//   print('🔥 Banco de dados deletado: $fullPath');
// }

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    // await deleteDatabaseFile();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => OriginalPlace(), 
      child: MaterialApp(
        title: 'Monitoramento',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: TrackPacientListScreen(),
        routes: {
          AppRoutes.TRACK_PACIENT_LIST: (ctx) => TrackPacientListScreen(),
          AppRoutes.TRACK_PACIENT_FORM: (ctx) => TrackPacientFormScreen(),
          AppRoutes.TRACK_PATIENT_DETAIL: (ctx) => TrackPacientDetailScreen(),
        },
      ),
    );
  }
}
