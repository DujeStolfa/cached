/// Serivs za autentifikaciju
///
/// Omogućuje prijavu, odjavu i registraciju korisnika te olakšava
/// rukovanje sa Firebaseovim autentifikacijskim uslugama.

import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // Prati promjene u autentifikacijskom stanju korisnika
  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  // Dohvati trenutno prijavljenog korisnika
  User get currentUser => _firebaseAuth.currentUser;

  // Odjavi korisnika
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Prijavi korisnika
  Future<dynamic> signIn({String email, String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Signed in';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw Exception(e.message);
    }
  }

  // Registriraj korisnika
  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Signed up';
    } on FirebaseAuthException catch (e) {
      print(e.message);
      return e.message;
    }
  }
}
