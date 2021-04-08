import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoveWalletDialog extends StatefulWidget {
  final Wallet selectedWallet;
  final List<dynamic> walletNames;

  const RemoveWalletDialog({Key key, this.selectedWallet, this.walletNames})
      : super(key: key);

  @override
  _RemoveWalletDialogState createState() => _RemoveWalletDialogState();
}

class _RemoveWalletDialogState extends State<RemoveWalletDialog> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white.withOpacity(0.92),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Do you want to delete this Wallet?',
              style: TextStyle(fontSize: 21),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: Text(
                widget.selectedWallet.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 29,
                  color: Colors.redAccent[700],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120,
                  child: FlatButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                Container(
                  width: 120,
                  child: RaisedButton(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      'Delete',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () {
                      print(widget.walletNames);
                      User user =
                          context.read<AuthenticationService>().currentUser;
                      context.read<FirestoreService>().removeWallet(
                            user,
                            widget.selectedWallet,
                            widget.walletNames,
                          );
                      Navigator.pop(context);
                    },
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
