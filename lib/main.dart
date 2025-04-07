import 'package:flutter/material.dart';
import 'package:track_person/screens/track_pacient_form_screen.dart';
import 'package:track_person/screens/track_pacient_list_screen.dart';
import 'package:track_person/util/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page')
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monitoramento',
      home: TrackPacientListScreen(),
      routes: {
        AppRoutes.TRACK_PACIENT_LIST: (ctx) => TrackPacientListScreen(),
        AppRoutes.TRACK_PACIENT_FORM: (ctx) => TrackPacientFormScreen(),
      },
    );
  }
}
