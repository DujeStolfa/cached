/// Dijaloški okvir za stvaranje novog novčanika
///
/// Pri stvaranju novčanika korisnik unosi njegov početni
/// iznos njegov naziv. Pdatke o trenutnom korisniku pruža
/// Firebase Auth, dok se preko autorskog servisa obrađuju
/// i spremaju u Cloud Firestore bazu podataka.

import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewWalletDialog extends StatefulWidget {
  @override
  _NewWalletDialogState createState() => _NewWalletDialogState();
}

class _NewWalletDialogState extends State<NewWalletDialog> {
  final _formKey = GlobalKey<FormState>();

  String _name = 'My Wallet';
  String _currency = 'HRK';
  double _balance = 0.0;

  // Osiguraj ispravnost unesenih podataka i dodaj novčanik u bazu podataka
  void _submit(FirestoreService service, User currentUser, List walletNames) {
    _formKey.currentState.save();

    Map<String, dynamic> formData = {
      'transactions': [],
      'id': DateTime.now().toString(),
      'name': _name,
      'currency': _currency,
      'balance': _balance,
    };

    service.addWallet(
      model.createWallet(formData),
      currentUser,
      walletNames,
    );

    Navigator.pop(context);
  }

  // Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<AuthenticationService>().currentUser;
    FirestoreService service = context.watch<FirestoreService>();
    DocumentSnapshot usersSnapshot = context.watch<DocumentSnapshot>();

    List walletNames = usersSnapshot.data()['walletNames'];

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(0.92),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Create a wallet', style: TextStyle(fontSize: 29)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Name'),
                    onSaved: (input) => _name = input,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Initial balance',
                    ),
                    onSaved: (input) => _balance = double.parse(input),
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  child: FlatButton(
                    child: Text('Cancel',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  width: 120,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text('Done',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600)),
                    onPressed: () => _submit(service, currentUser, walletNames),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
