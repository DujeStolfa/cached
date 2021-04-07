import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static final String id = 'login_screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _validated = false;
  String _email, _password;
  dynamic _emailValidated;

  Future<dynamic> _submit({String emailValue, String passwordValue}) async {
    if (emailValue == null && passwordValue == null) {
      setState(() {
        _validated = _formKey.currentState.validate();
      });
    }
    _formKey.currentState.save();
    dynamic credential = await context
        .read<AuthenticationService>()
        .signIn(email: _email.trim(), password: _password.trim());

    if (credential is UserCredential && _validated) {
      return null;
      //udi u aplikaciju i to sve}
    } else if (emailValue !=
            null /*&&
        credential.message ==
            'There is no user record corresponding to this identifier. The user may have been deleted.'*/
        ) {
      return 'This email is not registered, please create an account';

      /*print(credential.message);
      switch (credential.message) {
        case 'The password is invalid or the user does not have a password.':
          {
            return;
          }
        case 'There is no user record corresponding to this identifier. The user may have been deleted.':
          {
            break;
          }
      }*/
    } else if (passwordValue != null &&
        credential.message ==
            'The password is invalid or the user does not have a password.') {
      return 'Incorrect password';
    }

    return null;
    /*print(
          'C r eeeeee d e n t i al  a l a  lll  l lll     l  l l llll!!!!!!!!!!!!!!');
      print(credential);

      if (credential != null) {
        print(credential);
        User user = credential.user;
        print('');
        print('');
        print(user.uid);
        print('');
        context
            .read<FirestoreService>()
            .createUser(user, 'Vjeverica'); // ovo triba u signup......
      }*/
  }

  _validateEmail(input) async {
    /////// !!!!!!!!! dodat u bazu listu usera i tjt :///////////////1!!11111
    if (!input.contains('@')) {
      return 'Please enter a valid email';
    }
    dynamic result = await _submit(emailValue: input);
    print('vamo gledat');
    print(result);
    setState(() {
      _emailValidated = result;
    });
  }

  _validatePassword(input) {}

  /* _validateLoginInput() {
    final FormState form = _formKey.currentState;
      if (_formKey.currentState.validate()) {
        form.save();
        _sheetController.setState(() {
          _loading = true;
        });

  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
          Text('Welcome',
              style: TextStyle(fontSize: 45.0, fontWeight: FontWeight.w300)),
          Form(
              key: _formKey,
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
                    child: TextFormField(
                        decoration: InputDecoration(labelText: 'Email'),
                        onSaved: (input) => _email = input,
                        validator: (input) {
                          _validateEmail(input);
                          return _emailValidated;
                          /*
                          dynamic rezultat = _validateEmail(input);
                          print(rezultat);
                          print('kul');
                          return ' fuck';*/
                          /*{
                          _submit(input);
                          if (!input.contains('@')) {
                            return 'Please enter a valid email';
                          }
                          /*else if ( !context
                              .watch<AuthenticationService>()
                              .userExists) {
                            return 'This email is not registered, please ceate an account';
                          }*/
                          return null;
                        }*/
                        })),
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
        ])));
  }
}
