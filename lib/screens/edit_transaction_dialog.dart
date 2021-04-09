/// Dijaloški okvir za uređivanje transakcije
///
/// Pri dugom pritisku na transakciju korisniku se prikazuje ovaj
/// okvir s poljem za promjenu novog opisa transakcije. Korišten
/// je autorski servis za autentifikaciju i sam Firebase Auth za
/// rukovanje i dohvaćanje podataka o trenutnom korisniku.

import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditTransactionDialog extends StatefulWidget {
  final String transactionId;
  final Wallet selectedWallet;

  EditTransactionDialog(
      {Key key, @required this.transactionId, this.selectedWallet})
      : super(key: key);

  @override
  _EditTransactionDialogState createState() => _EditTransactionDialogState();
}

class _EditTransactionDialogState extends State<EditTransactionDialog> {
  final _formKey = GlobalKey<FormState>();

  String _description;

  // Osiguraj ispravnost unesenih podataka i vrati se na prethodni Screen
  void _submit(FirestoreService service, User currentUser) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      service.updateTransactionDescription(widget.transactionId, _description,
          currentUser, widget.selectedWallet);

      Navigator.pop(context, _description);
    }
  }

  //Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    User currentUser = context.watch<AuthenticationService>().currentUser;
    FirestoreService service = context.watch<FirestoreService>();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(0.92),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Edit transaction', style: TextStyle(fontSize: 29)),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Desription'),
                    onSaved: (input) => _description = input,
                    validator: (input) => input.trim().isEmpty
                        ? 'You left the description feild empty.'
                        : null,
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
                    onPressed: () => _submit(service, currentUser),
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
