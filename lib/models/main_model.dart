/// Klasa MainModel
///
/// Koristi se za pretvaranje dijela podataka u objekte
/// klasa Transaction i Wallet.

import 'package:aplikacija/models/transaction_model.dart';
import 'package:aplikacija/models/user_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  List<AppUser> users;

  MainModel(this.users);

  void addTransaction(index, walletID, transaction) {
    users[index].wallets[walletID].addTransaction(transaction);
    notifyListeners();
  }

  Transaction createTransaction(Map map) {
    return Transaction(
      map['value'].toDouble(),
      map['expense'],
      map['description'],
      map['date'],
      map['category'],
      map['id'],
      isExpanded: map['isExpanded'],
    );
  }

  Wallet createWallet(Map map) {
    List<Transaction> transactionList = [];
    try {
      for (var item in map['transactions']) {
        transactionList.add(model.createTransaction(item));
      }
    } catch (e) {
      print(e);
    }

    return Wallet(map['id'], map['name'], map['currency'],
        map['balance'].toDouble(), transactionList);
  }
}

MainModel model = MainModel([]);
