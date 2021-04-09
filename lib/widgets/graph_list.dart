/// Widget za dijagrame na nadzonoj ploči
///
/// Prikazuje dijagram ukupnog stanja svih korisnikovih računa
/// samo ako je upisan značajan broj transakcija.

import 'package:aplikacija/widgets/line_graph_total.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GraphList extends StatefulWidget {
  @override
  _GraphListState createState() => _GraphListState();
}

class _GraphListState extends State<GraphList> {
  // Poruka koja se prikazuje ako se dijagram ne može prikazati
  Widget _graphMessage() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Center(
        child: Text(
          'Add a few more transactions, and your overall balance will be displayed here',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.blueGrey[700],
          ),
        ),
      ),
    );
  }

  // Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    QuerySnapshot walletsSnapshot = context.watch<QuerySnapshot>();
    int transactions = 0;

    for (var wallet in walletsSnapshot.docs) {
      transactions += wallet.data()['transactions'].length;
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: (transactions >= 3) ? LineGraphTotal() : _graphMessage(),
        ),
        SizedBox(
          height: 20,
        )
      ],
    );
  }
}
