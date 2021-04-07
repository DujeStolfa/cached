import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  Stream<User> get authStateChanges => _firebaseAuth.authStateChanges();

  User get currentUser => _firebaseAuth.currentUser;

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<dynamic> signIn({String email, String password}) async {
    try {
      return await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      return e;
    }
  }

  Future<String> signUp({String email, String password}) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'signed up';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<String> signInAnon() async {
    try {
      await _firebaseAuth.signInAnonymously();
      return 'signed in anon';
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
