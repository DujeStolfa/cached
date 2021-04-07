import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikacija/models/transaction_model.dart' as transactionModel;
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Stream<DocumentSnapshot> collectionStream(String uid) {
    return _firestore.doc('users/$uid').snapshots();
    /*.collection(name)
        .doc('ghQULo9yLG5kX2agtLTa')
        .collection('wallets')
        .doc('7OcbKLDvRaFHkD7Vibly')
        .snapshots();*/
  }

  Stream<QuerySnapshot> documentStream(String uid) {
    // jesu li ov aimena naopako??
    return _firestore.collection('users/$uid/wallets').snapshots();
  }

  Future<void> createUser(User user, String name) {
    //Map data = {walets, categories, name, email, uid}

    Map<String, dynamic> data = {
      'categories': [],
      'name': name,
      'mail': user.email,
      'walletCount': 0,
    };

    return _firestore.collection('users').doc(user.uid).set(data).then((value) {
      // dodaj walletse prazne ==> doda se na prvon ucitavanju
      print('resi');
    }).catchError((error) => print('o ne $error'));
  }

  Future<void> addWallet(Wallet wallet, User user, List walletNames) {
    Map<String, dynamic> walletData = wallet.toFirestoreMap();

    walletNames.add(wallet.name);

    _firestore
        .collection('users')
        .doc(user.uid)
        .update({'walletNames': walletNames});
    print(wallet.toFirestoreMap());
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallets')
        .doc(wallet.id)
        .set(walletData) // random id
        .then((value) => print("Wallet Updated"))
        .catchError((error) => print("Failed to update wallet: $error"));
  }

  Future<void> addTransaction(
      Map<String, dynamic> data, Wallet wallet, User user) {
    //lista.append pa updejt na usera? ga zi oooo si meee
    //pa rpappp
    print(wallet.transactions);
    wallet.addTransaction(model.createTransaction(data));
    // jel mogu nekako appendat na listu u bazi ili svaki put saljen novu - ne?

    print('kkkkkkkkkkkk');

    print(wallet.transactions);
    print('');
    List<Map> updatedTransactions = wallet.transactions
        .map((element) => element.convertTransaction())
        .toList(); //ovo je glupo ne bit riba element.nesto(eleent) nego samo element.convert() :////
    //List<dynamic> previousTransactions = wallet.transactions.toMap();
    print(updatedTransactions);
    print('GOREEEEEEEEEEEE');
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallets')
        .doc(wallet.id)
        .update(
            {'transactions': updatedTransactions, 'balance': wallet.balance})
        .then((value) => print('Added transaction'))
        .catchError((error) => print('Failed to add transaciton: $error'));
  }

  void removeTransaction(List<transactionModel.Transaction> transactionsList,
      User user, Wallet wallet) {
    List<Map> updatedTransactions = transactionsList
        .map((element) => element.convertTransaction())
        .toList();

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallets')
        .doc(wallet.id)
        .update(
            {'transactions': updatedTransactions, 'balance': wallet.balance})
        .then((value) => print('Removed transaction'))
        .catchError((error) => print('Failed to remove transaciton: $error'));
  }

  void addCategory(User user, List<dynamic> categories, String category) {
    categories.add(category);

    _firestore
        .collection('users')
        .doc(user.uid)
        .update({'categories': categories})
        .then((value) => print('Added a category'))
        .catchError((error) => print('Failed to add a category: $error'));
  }

  void updateTransactionDescription(
      String transactionId, String description, User user, Wallet wallet) {
    List<Map> updatedTransactions = [];

    wallet.transactions.forEach((element) {
      if (element.id != transactionId) {
        updatedTransactions.add(element.convertTransaction());
      } else {
        Map currentTransaction = element.convertTransaction();
        currentTransaction['description'] = description;

        updatedTransactions.add(currentTransaction);
      }
    });

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallets')
        .doc(wallet.id)
        .update({'transactions': updatedTransactions})
        .then((value) => print(('Updated Transaction')))
        .catchError((error) => print('Failed to update transaction'));
  }

  void updateTransaction(transactionModel.Transaction updatedTransaction,
      User user, Wallet wallet) {
    List<Map> updatedTransactions = [];

    wallet.transactions.forEach((element) {
      if (element.id != updatedTransaction.id) {
        updatedTransactions.add(element.convertTransaction());
      } else {
        updatedTransactions.add(updatedTransaction.convertTransaction());
      }
    });

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallets')
        .doc(wallet.id)
        .update({'transactions': updatedTransactions})
        .then((value) => print(('Updated Transaction')))
        .catchError((error) => print('Failed to update transaction'));
  }

  /*Map getCurrentUserData(String uid) {
    _firestore
        .collection('users')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      return documentSnapshot.data();
    });
  }*/
}
