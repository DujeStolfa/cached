import 'package:aplikacija/models/transaction_model.dart';
import 'package:aplikacija/models/user_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as fire;
import 'package:flutter/cupertino.dart';

class MainModel extends ChangeNotifier {
  List<AppUser> users;

  MainModel(this.users);

  void addTransaction(index, walletID, transaction) {
    print('kul');
    users[index].wallets[walletID].addTransaction(transaction);
    print('even cooler');
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
      //kad se makne zvonko maknit i ovo
      /*for (var item in map['Transactions']) {
        transactionList.add(model.createTransaction(item));
      }*/
    }
    //Transaction t = model.createTransaction();

    print(map);
    print(DateTime.now().toString());
    print('evo me u creatte waller');
    return Wallet(map['id'], map['name'], map['currency'],
        map['balance'].toDouble(), transactionList);
  }
}

MainModel model = MainModel([
  AppUser(
    'jm',
    'Jana',
    'jana@pare.com',
    {
      'jm0': Wallet(
        'jm0',
        'Borsa',
        'HRK',
        110.0,
        [
          Transaction(
              10.0,
              false,
              'lisnato u bobisa tila san krafnu al nije bilo',
              fire.Timestamp(10, 0),
              '',
              ''),
          Transaction(
              20.0, true, 'nikolic placa', fire.Timestamp(10, 0), '', '')
        ],
      ),
    },
    [],
  ),
  AppUser(
    'zl',
    'Zvonko',
    'zvonko@pare.com',
    {
      'zl0': Wallet('zl0', 'Place', 'HRK', 30000.0, [
        Transaction(
            1000.0, true, 'Brajo 12. misec', fire.Timestamp(1, 1), 'placa', '')
      ]),
      'zl2': Wallet('zl2', 'Svakodnevno', 'HRK', 2000.0, [
        Transaction(200.0, false, 'Tommy', fire.Timestamp(1, 1), '', ''),
        Transaction(
            300.0, false, 'Picete', fire.Timestamp(1, 1), 'prijatelji', ''),
      ]),
    },
    ['prijatelji', 'marenda', 'placa'],
  )
]);
