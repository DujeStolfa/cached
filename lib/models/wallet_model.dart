/// Klasa Wallet
///
/// Predstavlja podatke o pojedinom novčaniku korisnika u obliku
/// prilagođenom za korištenje u aplikaciji. Library Equatable pruža
/// funkcionalnost jednostavnijeg uspoređivanja dviju instanci
/// ove klase.

import 'package:aplikacija/models/transaction_model.dart';
import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final String id;
  final String name;
  final String currency;
  double balance;
  List<Transaction> transactions;

  Wallet(
    this.id,
    this.name,
    this.currency,
    this.balance,
    this.transactions,
  );

  @override
  List<Object> get props => [id];

  // Dodaj transakciju u listu transakcija
  void addTransaction(Transaction transaction) {
    int selectedDate = transaction.intDate;

    int index = 0;

    /* 
    * Izračunaj indeks u listi transakcija na kojem bi se 
    * trebala nalaziti prosljeđena transakcija da bi ta lista 
    * i dalje bila sortirana silazno.
    */
    for (var i = 0; i < this.transactions.length; i++) {
      int dateAtIndex = this.transactions[i].intDate;

      if (dateAtIndex <= selectedDate) {
        index = i;
        break;
      } else {
        index = i + 1;
      }
    }

    transactions.insert(index, transaction);

    // Prilagodi stanje novčanika
    if (transaction.expense) {
      balance -= transaction.value;
    } else {
      balance += transaction.value;
    }
  }

  // Izbriši transakciju iz liste transakcija
  Transaction removeTransaction(String transactionId) {
    int selectedIndex = this.indexFromId(transactionId);
    Transaction selectedTransaction = this.transactions[selectedIndex];

    if (selectedIndex >= 0) {
      this.transactions.removeAt(selectedIndex);
    }

    // Prilagodi stanje novčanika
    if (selectedTransaction.expense) {
      this.balance += selectedTransaction.value;
    } else {
      this.balance -= selectedTransaction.value;
    }

    return selectedTransaction;
  }

  // Dohvati indeks na kojem se nalazi transakcija sa zadanim ID-jem
  int indexFromId(String id) {
    for (var i = 0; i < this.transactions.length; i++) {
      if (transactions[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  // Pretvori novčanik u mapu prilagođenu Firestore bazi podataka
  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': this.id,
      'name': this.name,
      'currency': this.currency,
      'balance': this.balance,
      'transactions': this.transactions,
    };
  }

  // Dohvati opis najnovije transakcije novčanika
  String get lastTransaction {
    Transaction lastTransaction;
    if (this.transactions.length == 0) {
      return 'No recorded transactions';
    }
    lastTransaction = this.transactions[0];

    return lastTransaction.expense
        ? '-' +
            lastTransaction.value.toString() +
            ", " +
            lastTransaction.description
        : lastTransaction.value.toString() + ", " + lastTransaction.description;
  }
}
