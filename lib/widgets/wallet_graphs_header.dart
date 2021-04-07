import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WalletGraphsHeader extends StatefulWidget {
  final Wallet selectedWallet;
  QuerySnapshot snapshot;
  WalletGraphsHeader({Key key, @required this.selectedWallet, this.snapshot})
      : super(key: key);

  @override
  _WalletGraphsHeaderState createState() => _WalletGraphsHeaderState();
}

class _WalletGraphsHeaderState extends State<WalletGraphsHeader> {
  Wallet _currentWallet;

  @override
  Widget build(BuildContext context) {
    QuerySnapshot walletsSnapshot = widget.snapshot;
    /*Wallet currentWallet =
                .createWallet(walletsSnapshot.docs.where((wallet) => wallet.id).toList()[0]);*/
    /*Wallet currentWallet = await context.read<FirestoreService>().getWalletById(widget.selectedWallet.id, context.read<AuthenticationService>().currentUser,);*/

    Wallet _currentWallet = model.createWallet(walletsSnapshot.docs
        .where((element) => element.id == widget.selectedWallet.id)
        .toList()[0]
        .data());

    return Container(
      width: MediaQuery.of(context).size.width - 65,
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
        children: [
          Align(
            alignment: Alignment.center,
            child: Text(
              _currentWallet.name + ' - analytics',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
