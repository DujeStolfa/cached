/// Dijaloški okvir za brisanje kategorija
///
/// Dugim pritiskom na kategoriju, korisniku se prikazuje okvir
/// pomoću kojeg potvrđuje brisanje odabrane kategorije.

import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RemoveCategoryDialog extends StatefulWidget {
  final List<dynamic> categories;
  final int selectedIndex;

  const RemoveCategoryDialog({Key key, this.categories, this.selectedIndex})
      : super(key: key);

  @override
  _RemoveCategoryDialogState createState() => _RemoveCategoryDialogState();
}

class _RemoveCategoryDialogState extends State<RemoveCategoryDialog> {
  // Izgradi Widget tree
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
              'Do you want to delete this category?',
              style: TextStyle(fontSize: 21),
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 30,
              ),
              child: Text(
                widget.categories[widget.selectedIndex].toUpperCase(),
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
                      User user =
                          context.read<AuthenticationService>().currentUser;
                      context.read<FirestoreService>().removeCategory(
                            user,
                            widget.categories,
                            widget.selectedIndex,
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
