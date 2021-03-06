/// Main datoteka aplikacije
///
/// Postavlja ID-jeve za pristupanje pojedinim ekranima, pružatelje
/// streamova i pokreće autentifikacijski wrapper.

import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/screens/error_screen.dart';
import 'package:aplikacija/screens/home_screen.dart';
import 'package:aplikacija/screens/loading_screen.dart';
import 'package:aplikacija/screens/login_screen.dart';
import 'package:aplikacija/screens/new_transaction_screen.dart';
import 'package:aplikacija/screens/new_transfer_screen.dart';
import 'package:aplikacija/screens/signup_screen.dart';
import 'package:aplikacija/screens/authentication_wrapper.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // U slučaju greške prikaži ekran s greškom
        if (snapshot.hasError) {
          return ErrorScreen();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Cached',
            debugShowCheckedModeBanner: false,
            home: MyHomeScreen(),
          );
        }

        // Pri učitavanju prikaži indikator
        return LoadingScreen();
      },
    );
  }
}

class MyHomeScreen extends StatefulWidget {
  @override
  _MyHomeScreenState createState() => _MyHomeScreenState();
}

class _MyHomeScreenState extends State<MyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Pokreni sve potrebene Providere
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<AuthenticationService>().authStateChanges,
        ),
        Provider<FirestoreService>(
          create: (_) => FirestoreService(FirebaseFirestore.instance),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FirestoreService>().collectionStream(context),
        ),
        StreamProvider(
          create: (context) =>
              context.read<FirestoreService>().documentStream(context),
        ),
        ChangeNotifierProvider<MainModel>(
          create: (context) => model,
        )
      ],
      child: MaterialApp(
        title: 'Flutter',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.deepOrange[600],
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: AuthenticationWrapper(),
        routes: {
          // Postavi rute u aplikaciji
          LoginScreen.id: (context) => LoginScreen(),
          SignupScreen.id: (context) => SignupScreen(),
          HomeScreen.id: (context) => HomeScreen(),
          NewTransactionScreen.id: (context) => NewTransactionScreen(),
          NewTransferScreen.id: (context) => NewTransferScreen(),
        },
      ),
    );
  }
}
