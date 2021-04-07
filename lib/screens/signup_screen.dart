/// Ekran za regstraciju korisnika
///
/// Sadrži formu za upis odgovarajućih podataka o korisniku i
/// funkcije pomoću kojih se osigurava ispravnost upisanih
/// podataka koji se prosljeđuju servisu za autentifikaciju i
/// Firebase Authu.

import 'package:aplikacija/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  static final String id = 'signup_screen';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name, _email, _password;

  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      context
          .read<AuthenticationService>()
          .signUp(email: _email.trim(), password: _password.trim());
      Navigator.pushNamed(context, 'home_screen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Text('Sign up',
              style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w300)),
          Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'Name'),
                        onSaved: (input) => _name = input,
                        validator: (input) => input.trim().isEmpty
                            ? 'Please enter a name'
                            : null)),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onSaved: (input) => _email = input,
                        validator: (input) => !input.contains('@')
                            ? 'Please enter a valid email'
                            : null)),
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'Password'),
                        onSaved: (input) => _password = input,
                        obscureText: true,
                        validator: (input) => input.length < 6
                            ? 'Password must be at least 6 characters long'
                            : null)),
                SizedBox(height: 15.0),
                Container(
                    width: 200,
                    child: RaisedButton(
                        onPressed: _submit,
                        child: Text('Sign up',
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
                        onPressed: () => Navigator.pop(context),
                        child: Text('Return to login')))
              ]))
        ])));
  }
}
