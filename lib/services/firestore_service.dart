import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikacija/models/transaction_model.dart' as transactionModel;

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  Stream<DocumentSnapshot> collectionStream(String uid) {
    return _firestore.doc('users/$uid').snapshots();
  }

  Stream<QuerySnapshot> documentStream(String uid) {
    return _firestore.collection('users/$uid/wallets').snapshots();
  }

  Future<void> createUser(User user, String name) {
    Map<String, dynamic> data = {
      'categories': [],
      'name': name,
      'mail': user.email,
      'walletCount': 0,
    };

    return _firestore.collection('users').doc(user.uid).set(data).then((value) {
      print('User created');
    }).catchError((error) => print(error));
  }

  Future<void> addWallet(Wallet wallet, User user, List walletNames) {
    Map<String, dynamic> walletData = wallet.toFirestoreMap();

    walletNames.add(wallet.name);

    _firestore
        .collection('users')
        .doc(user.uid)
        .update({'walletNames': walletNames});

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallets')
        .doc(wallet.id)
        .set(walletData)
        .then((value) => print("Wallet Updated"))
        .catchError((error) => print("Failed to update wallet: $error"));
  }

  Future<void> addTransaction(
      Map<String, dynamic> data, Wallet wallet, User user) {
    wallet.addTransaction(model.createTransaction(data));

    List<Map> updatedTransactions = wallet.transactions
        .map((element) => element.convertTransaction())
        .toList();

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
}
