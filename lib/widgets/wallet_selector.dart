/// Popis novčanika
///
/// Izbornik na kojem su sažeto prikazani podaci o svakom korisnikovom
/// novčaniku i gumb za dodavanje novih novčanika.

import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/screens/new_wallet_dialog.dart';
import 'package:aplikacija/screens/remove_wallet_dialog.dart';
import 'package:aplikacija/screens/wallet_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletSelector extends StatefulWidget {
  @override
  _WalletSelectorState createState() => _WalletSelectorState();
}

class _WalletSelectorState extends State<WalletSelector> {
  // Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    DocumentSnapshot usersSnapshot = context.watch<DocumentSnapshot>();
    QuerySnapshot walletsSnapshot = context.watch<QuerySnapshot>();

    List walletNames = usersSnapshot.data()['walletNames'];
    int walletCount = walletNames.length;

    return Container(
      height: 275.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: walletCount + 1,
        itemBuilder: (BuildContext context, int index) {
          // Za svaki novčanik stvori njegovu karticu

          if (index < walletCount) {
            /*
            * Ako se ne radi o zadnjoj kartici
            * dohvati trenutni novčanik iz baze
            */
            Wallet currentWallet =
                model.createWallet(walletsSnapshot.docs[index].data());

            // Podaci za prikazivanje
            String name = currentWallet.name;
            String balance = currentWallet.balance.floor().toString();
            String lastTransaction = currentWallet.lastTransaction;

            return Padding(
              padding: EdgeInsets.only(left: 35.0, bottom: 15.0),
              child: Card(
                elevation: 8.0,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          WalletScreen(selectedWallet: currentWallet),
                    ),
                  ),
                  onLongPress: () {
                    setState(
                      () {
                        List<dynamic> wallets = context
                            .read<DocumentSnapshot>()
                            .data()['walletNames'];
                        print(wallets);
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) =>
                                RemoveWalletDialog(
                              selectedWallet: currentWallet,
                              walletNames: wallets,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: Container(
                    width: 260,
                    height: 260,
                    child: Padding(
                      padding: EdgeInsets.all(18.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              name,
                              style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Text(
                              balance,
                              style: TextStyle(
                                fontSize: 42.0,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              lastTransaction,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 19.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          } else {
            /*
            * Inače, neka zadnja kartica bude gumb za dodavanje
            * novog novčanika.
            */
            return Padding(
              padding: EdgeInsets.only(left: 35.0, bottom: 15.0, right: 35.0),
              child: Card(
                elevation: 8.0,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    Navigator.of(context).push(PageRouteBuilder(
                        opaque: false,
                        pageBuilder: (BuildContext context, _, __) =>
                            NewWalletDialog()));
                    Map data = {
                      'transactions': [],
                      'id': DateTime.now().toString(),
                      'name': 'Wallet',
                      'currency': 'HRK',
                      'balance': 30000.0,
                    };
                  },
                  child: Container(
                    width: 260,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Center(
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 80.0,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class WalletValue extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
