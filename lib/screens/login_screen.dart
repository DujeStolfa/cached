/// Ekran za prijavu korisnika
///
/// Sadrži formu za upis odgovarajućih podataka o korisniku i
/// funkcije pomoću kojih se osigurava ispravnost upisanih
/// podataka. Korišteni je autorski servis za autentifikaciju
/// i odgovarajući modul (Firebase Auth).

import 'package:aplikacija/services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _password, _error;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      try {
        context
            .read<AuthenticationService>()
            .signIn(email: _email.trim(), password: _password.trim());
      } catch (e) {
        setState(() {
          _error = e.message;
        });
      }
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
            Text('Welcome',
                style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w300)),
            SizedBox(height: 7.5),
            errorAlert(),
            Form(
                key: _formKey,
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                          decoration: InputDecoration(labelText: 'Email'),
                          onSaved: (input) => _email = input,
                          validator: (input) => !input.contains('@')
                              ? 'Please enter a valid email'
                              : null)),
                  Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 10.0),
                      child: TextFormField(
                          decoration: InputDecoration(labelText: 'Password'),
                          onSaved: (input) => _password = input,
                          obscureText: true,
                          validator: (input) => input.length < 6
                              ? 'Password must be at least 6 characters long'
                              : null)),
                  SizedBox(height: 15),
                  Container(
                      width: 200,
                      child: RaisedButton(
                          onPressed: _submit,
                          child: Text('Log in',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.5)),
                          color: Theme.of(context).primaryColor)),
                  Container(
                      width: 200,
                      height: 35.0,
                      child: FlatButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, 'signup_screen'),
                          child: Text('Create an account'))),
                ]))
          ])),
    );
  }

  Widget errorAlert() {
    if (_error != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _error,
                maxLines: 3,
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _error = null;
                });
              },
              icon: Icon(
                Icons.close,
              ),
            ),
          ],
        ),
      );
    } else {
      return SizedBox(height: 0);
    }
  }
}
