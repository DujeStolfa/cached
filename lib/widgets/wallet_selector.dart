import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/user_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/screens/new_transaction_screen.dart';
import 'package:aplikacija/screens/new_wallet_dialog.dart';
import 'package:aplikacija/screens/wallet_screen.dart';
//import 'package:aplikacija/screens/new_wallet_dialog.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletSelector extends StatefulWidget {
  @override
  _WalletSelectorState createState() => _WalletSelectorState();
}

class _WalletSelectorState extends State<WalletSelector> {
  //AppUser _currentUser = model.users[1];

  @override
  Widget build(BuildContext context) {
    //User currentUser = context.watch<AuthenticationService>().currentUser;
    /*int walletCount = context
        .watch<FirestoreService>()
        .getCurrentUserData(currentUser.uid)['walletCount'];*/

    DocumentSnapshot usersSnapshot = context.watch<DocumentSnapshot>();
    QuerySnapshot walletsSnapshot = context.watch<QuerySnapshot>();

    //usersSnapshot.data()['walletCount'];
    List walletNames = usersSnapshot.data()['walletNames'];
    int walletCount = walletNames.length;

    //stavit vo tocka data u zasebne varijable??

    return Container(
      height: 275.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: walletCount + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index < walletCount) {
            print(index);

            print('');
            print(usersSnapshot.data()); // u onaj if!!!!
            print('---');
            print(walletsSnapshot.docs[index].data());
            Wallet currentWallet =
                model.createWallet(walletsSnapshot.docs[index].data());

            String name = currentWallet.name;
            String currency = currentWallet.currency;
            String balance = currentWallet.balance.floor().toString();
            String lastTransaction = currentWallet.lastTransaction;

            print(name);
            print(currency);
            print(balance);

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
                      )),
                  child: Container(
                    width: 260,
                    child: Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
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
                                  child: Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          /*currentWallet.balance
                                              .round()
                                              .toString()*/
                                          balance,
                                          style: TextStyle(
                                            fontSize: 42.0,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Flexible(
                                    child: Container(
                                      child: Text(
                                        lastTransaction,
                                        textAlign: TextAlign.right,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ),
/*Text(
                                        lastTransaction,
                                        style: TextStyle(
                                          fontSize: 19.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),*/
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Padding(
              padding: EdgeInsets.only(left: 35.0, bottom: 15.0, right: 35.0),
              child: Card(
                elevation: 8.0,
                child: InkWell(
                  splashColor: Colors.blue.withAlpha(30),
                  onTap: () {
                    //service.addWallet
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
                    /*User currentUser =
                        context.read<AuthenticationService>().currentUser;
                    int walletCount = context
                        .read<FirestoreService>()
                        .getCurrentUserData(currentUser.uid)['walletCount'];*/
                    /*context.read<FirestoreService>().addWallet(
                          model.createWallet(data),
                          currentUser,
                          walletNames,
                        );*/ ///////////
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