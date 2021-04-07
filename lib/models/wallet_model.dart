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

  void addTransaction(Transaction transaction) {
    int selectedDate = transaction.intDate;

    int index = 0;

    /* 
    * Izračunaj indeks u listi transakcija na kojem bi se 
    * trebala nalaziti prosljeđena transakcija da bi ta lista 
    * i dalje bila sortirana.
    */
    for (var i = 0; i < this.transactions.length; i++) {
      int dateAtIndex = this.transactions[i].intDate;

      if (dateAtIndex <= selectedDate) {
        index = i;
        break;
      } else {
        index = i + 1;
      }

      /*print(dateAtIndex);

      print(selectedDate);
      print(index);
      print('');

      if (dateAtIndex[0] < selectedDate[0]) {
        index = i;
      } else {
        if (dateAtIndex[1] < selectedDate[1]) {
          index = i;
        } else {
          if (dateAtIndex[2] < selectedDate[2]) {
            index = i;
          } else {
            index = i;
            break;
          }
        }
      }*/
    }

    transactions.insert(index, transaction);

    if (transaction.expense) {
      balance -= transaction.value;
    } else {
      balance += transaction.value;
    }
  }

  Transaction removeTransaction(String transactionId) {
    int selectedIndex = this.indexFromId(transactionId);
    Transaction selectedTransaction = this.transactions[selectedIndex];

    if (selectedIndex >= 0) {
      this.transactions.removeAt(selectedIndex);
    }

    if (selectedTransaction.expense) {
      this.balance += selectedTransaction.value;
    } else {
      this.balance -= selectedTransaction.value;
    }

    return selectedTransaction;
  }

  int indexFromId(String id) {
    for (var i = 0; i < this.transactions.length; i++) {
      if (transactions[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'id': this.id,
      'name': this.name,
      'currency': this.currency,
      'balance': this.balance,
      'transactions': this.transactions,
    };
  }

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
