/// Widget s transaction porukom
///
/// Poruka koja se prikazuje ako korisnik nema dovoljan broj
/// novčanika za dodavanj transakcija.

import 'package:flutter/material.dart';

class DisabledTransactionMessage extends StatefulWidget {
  @override
  _DisabledTransactionMessageState createState() =>
      _DisabledTransactionMessageState();
}

class _DisabledTransactionMessageState
    extends State<DisabledTransactionMessage> {
  // Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Container(
        child: Text(
          'Please create a wallet to use transactions',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
