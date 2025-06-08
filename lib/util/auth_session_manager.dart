import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthSessionManager {
  static final AuthSessionManager _instance = AuthSessionManager._internal();

  factory AuthSessionManager() => _instance;

  AuthSessionManager._internal();

  Timer? _logoutTimer;

  void startSessionTimeout() {
    _logoutTimer?.cancel(); 
    _logoutTimer = Timer(Duration(hours: 10), () async {
      await FirebaseAuth.instance.signOut();
    });
  }

  void cancelTimeout() {
    _logoutTimer?.cancel();
  }
}
