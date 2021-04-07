/// Ekran s fijagramima pojedinog novčanika
///
/// Korisniku je prikazan naslov ekrana, dijagram salda
/// odabranog novčanika i dijagram transakcija tog novčanika.
/// Podatci se uzimaju izravno iz Cloud Firestore baze podataka.

import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/widgets/wallet_balance_graph.dart';
import 'package:aplikacija/widgets/wallet_graphs_header.dart';
import 'package:aplikacija/widgets/wallet_transaction_graph.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletGraphsScreen extends StatefulWidget {
  final Wallet selectedWallet;

  WalletGraphsScreen({Key key, @required this.selectedWallet})
      : super(key: key);

  @override
  _WalletGraphsScreenState createState() => _WalletGraphsScreenState();
}

class _WalletGraphsScreenState extends State<WalletGraphsScreen> {
  @override
  Widget build(BuildContext context) {
    QuerySnapshot walletsSnapshot = context.watch<QuerySnapshot>();
    Wallet currentWallet = widget.selectedWallet;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 0,
      ),
      body: ListView(children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            WalletGraphsHeader(
              selectedWallet: currentWallet,
              snapshot: walletsSnapshot,
            ),
            _floatingContainer([
              Text(
                'Balance history',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              WalletBalanceGraph(
                selectedWallet: widget.selectedWallet,
              ),
            ]),
            _floatingContainer([
              Text(
                'Transaction history',
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
              WalletTransactionGraph(
                selectedWallet: widget.selectedWallet,
              ),
            ]),
          ],
        ),
      ]),
    );
  }

  Widget _floatingContainer(List<Widget> children) {
    return Container(
      width: MediaQuery.of(context).size.width - 30,
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 8,
              offset: Offset(0, 8),
            ),
          ]),
      child: Column(
        children: children,
      ),
    );
  }
}
