/// Servis za Cloud Firestore bazu podataka
///
/// Dohvaćanje podataka iz baze i spremanje podataka u bazu
/// u potpunosti se odvija preko ovog servisa. Osigurava
/// pravilno i konzistentno formatiranje podataka u bazi.

import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:aplikacija/models/transaction_model.dart' as transactionModel;
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  // Stream pružatelj kolekcije podataka trenutno prijavljenog korisnika
  Stream<DocumentSnapshot> collectionStream(BuildContext context) {
    String uid = context.read<AuthenticationService>().currentUser.uid;
    return _firestore.collection('users').doc(uid).snapshots();
  }

  // Stream pružatelj dokumenata s podacima o korisnikoivm novčanicima
  Stream<QuerySnapshot> documentStream(BuildContext context) {
    String uid = context.read<AuthenticationService>().currentUser.uid;
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('wallets')
        .snapshots();
  }

  // Stvara novog korisnika i dodaje ga u bazu
  Future<void> createUser(User user) {
    Map<String, dynamic> data = {
      'categories': [],
      'name': user.displayName,
      'mail': user.email,
      'walletCount': 0,
      'walletNames': [],
    };

    return _firestore.collection('users').doc(user.uid).set(data).then((value) {
      print('User created');
    }).catchError((error) => print(error));
  }

  // Stvara novi novčanik i dodaje ga u bazu
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

  // Briše odabrani novčanik iz baze
  void removeWallet(User user, Wallet wallet, List<dynamic> walletNames) {
    walletNames.remove(wallet.name);

    _firestore
        .collection('users')
        .doc(user.uid)
        .update({'walletNames': walletNames});

    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('wallets')
        .doc(wallet.id)
        .delete()
        .then((value) => print('Deleted Wallet'))
        .catchError((error) => print("Failed to remove wallet"));
  }

  // Dodaje novu transakciju u odabrani novčanik
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

  // Briše odabranu transakciju iz novčanika
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

  // Dodaje novu kategoriju u korisnikovu listu kategorija
  void addCategory(User user, List<dynamic> categories, String category) {
    categories.add(category);

    _firestore
        .collection('users')
        .doc(user.uid)
        .update({'categories': categories})
        .then((value) => print('Added a category'))
        .catchError((error) => print('Failed to add a category: $error'));
  }

  // Briše kategoriju iz korisnikove liste kategorija
  void removeCategory(User user, List<dynamic> categories, int index) {
    categories.removeAt(index);

    _firestore
        .collection('users')
        .doc(user.uid)
        .update({'categories': categories})
        .then((value) => print('Removed a category'))
        .catchError((error) => print('Failed to remove a category: $error'));
  }

  // Mijenja opis odabrane transakcije
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

  // Mijenja stanje odabrane transakcije
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
