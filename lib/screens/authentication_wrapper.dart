/// Wrapper za autentififkaciju
///
/// Widget koji osigurava da je korisniku prikazana nadzorna
/// ploča samo ako je prijavljen i registriran. Korišten je
/// autorski servis za Firebase autentifikaciju.

import 'package:aplikacija/screens/home_screen.dart';
import 'package:aplikacija/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    if (firebaseUser != null) {
      return HomeScreen();
    } else {
      return LoginScreen();
    }
  }
}
