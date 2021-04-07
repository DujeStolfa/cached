/// Ekran pojedinog novčanika
///
/// Prikazano je zaglavlje sa svim podatcima o novčaniku
/// i Widget ispisa transakcija tog novčanika.

import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/widgets/empty_wallet_message.dart';
import 'package:aplikacija/widgets/transaction_list.dart';
import 'package:aplikacija/widgets/wallet_header.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletScreen extends StatefulWidget {
  final Wallet selectedWallet;

  WalletScreen({Key key, @required this.selectedWallet}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
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
            WalletHeader(
              selectedWallet: currentWallet,
              snapshot: walletsSnapshot,
            ),
            SizedBox(height: 20),
            (currentWallet.transactions.isNotEmpty)
                ? TransactionList(selectedWallet: currentWallet)
                : EmptyWalletMessage(),
          ],
        ),
      ]),
    );
  }
}
