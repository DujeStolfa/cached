/// Popis transakcija
///
/// Prikazuje sve transakcije odabranog novčanika kao listu widgeta
/// ExpansionPanel. Upravlja proširivanjem, zatvaranjem, mijenjanjem
/// i brisanjem transakcija.

import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/transaction_model.dart' as TransactionModel;
import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/screens/edit_transaction_dialog.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:aplikacija/widgets/empty_wallet_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatefulWidget {
  final Wallet selectedWallet;

  TransactionList({Key key, @required this.selectedWallet}) : super(key: key);

  @override
  _TransactionListState createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  // Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    QuerySnapshot walletsSnapshot = context.watch<QuerySnapshot>();

    User currentUser = context.watch<AuthenticationService>().currentUser;
    dynamic service = context.watch<FirestoreService>();
    Wallet _currentWallet = model.createWallet(walletsSnapshot.docs
        .where((element) => element.id == widget.selectedWallet.id)
        .toList()[0]
        .data());
    List<TransactionModel.Transaction> _transactions =
        _currentWallet.transactions;

    return (_transactions.isEmpty)
        ? EmptyWalletMessage()
        : ExpansionPanelList(
            expansionCallback: (int index, bool isExpanded) {
              setState(() {
                TransactionModel.Transaction currentTransaction =
                    _transactions[index];
                currentTransaction.isExpanded = !isExpanded;
                service.updateTransaction(
                    currentTransaction, currentUser, _currentWallet);
              });
            },
            children: _transactions.map<ExpansionPanel>(
                (TransactionModel.Transaction transaction) {
              print(transaction.isExpanded);

              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isExpanded) {
                  return Dismissible(
                    direction: DismissDirection.startToEnd,
                    background: Container(
                      color: Colors.red,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    key: Key(transaction.id),
                    onDismissed: (direction) {
                      /*
                      * Izbriši transakciju s popisa i pozovi Firestore servis
                      * da je izbriše iz baze podataka.
                      */
                      setState(() {
                        widget.selectedWallet.removeTransaction(transaction.id);
                        service.removeTransaction(
                          widget.selectedWallet.transactions,
                          currentUser,
                          widget.selectedWallet,
                        );
                      });
                    },
                    child: InkWell(
                      splashColor: Colors.blue.withAlpha(30),
                      onLongPress: () {
                        // Otvori dijaloški okvir za promjenu opisa transakcije
                        setState(() {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (BuildContext context, _, __) =>
                                  EditTransactionDialog(
                                      transactionId: transaction.id,
                                      selectedWallet: widget.selectedWallet)));
                        });
                      },
                      child: ListTile(
                        trailing: (transaction.expense)
                            ? Icon(
                                Icons.arrow_drop_down,
                                color: Colors.redAccent[700],
                              )
                            : Icon(
                                Icons.arrow_drop_up,
                                color: Colors.green,
                              ),
                        title: Text(
                          transaction.value.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w400),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
                body: ListTile(
                  isThreeLine: false,
                  title: Text(
                    transaction.description,
                  ),
                  subtitle: Text(transaction.stringDate()),
                  trailing: (transaction.category != '')
                      ? Chip(
                          label: Text(
                            transaction.category,
                            style: TextStyle(color: Colors.white, fontSize: 14),
                          ),
                          backgroundColor: Theme.of(context).accentColor,
                        )
                      : null,
                ),
                isExpanded: transaction.isExpanded,
              );
            }).toList(),
          );
  }
}
