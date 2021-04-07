import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/screens/wallet_graphs_screen.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class WalletHeader extends StatefulWidget {
  final Wallet selectedWallet;
  QuerySnapshot snapshot;

  WalletHeader({Key key, @required this.selectedWallet, this.snapshot})
      : super(key: key);

  @override
  _WalletHeaderState createState() => _WalletHeaderState();
}

class _WalletHeaderState extends State<WalletHeader> {
  Wallet _currentWallet;
  double _balance;

  @override
  Widget build(BuildContext context) {
    QuerySnapshot walletsSnapshot = widget.snapshot;

    _currentWallet = model.createWallet(walletsSnapshot.docs
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
            alignment: Alignment.topLeft,
            child: Text(
              _currentWallet.name,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          SizedBox(height: 30),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              (_currentWallet.transactions.length > 2)
                  ? GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletGraphsScreen(
                              selectedWallet: widget.selectedWallet),
                        ),
                      ),
                      child: Icon(
                        Icons.analytics,
                        size: 30,
                        color: Theme.of(context).accentColor,
                      ),
                    )
                  : GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context)
                        ..showSnackBar(SnackBar(
                          content: Text(
                              "Please add at least 3 transactions to view analytics"),
                        )),
                      child: Icon(
                        Icons.analytics,
                        size: 30,
                        color: Colors.grey,
                      ),
                    ),
              Text(
                _currentWallet.balance.toString(),
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  color: (_currentWallet.balance >= 0)
                      ? Colors.green
                      : Colors.redAccent[700],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
