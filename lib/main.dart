import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:track_person/screens/auth_screen.dart';
import 'package:track_person/screens/track_pacient_detail_screen.dart';
import 'package:track_person/screens/track_pacient_form_screen.dart';
import 'package:track_person/screens/track_pacient_list_screen.dart';
import 'package:track_person/util/app_routes.dart';
import 'package:track_person/provider/original_place.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:track_person/util/check_area_delimited.dart';
import 'package:track_person/util/auth_session_manager.dart';

Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

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
          colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 26, 32, 92)),
        ),
        home: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // inicia o timer após login
                  AuthSessionManager().startSessionTimeout();
                  return TrackPacientListScreen();
                } else {
                  // cancela timer se deslogar
                  AuthSessionManager().cancelTimeout();
                  return AuthScreen();
                }
              },
            ),
        routes: {
          AppRoutes.TRACK_PACIENT_LIST: (ctx) => TrackPacientListScreen(),
          AppRoutes.TRACK_PACIENT_FORM: (ctx) => TrackPacientFormScreen(),
          AppRoutes.TRACK_PATIENT_DETAIL: (ctx) => TrackPacientDetailScreen(),
        },
      ),
    );
  }
}
