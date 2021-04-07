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

  /*@override
  bool operator ==(Object other) => other is Wallet && other.id == id;*/

  void addTransaction(Transaction transaction) {
    List<int> selectedDate = transaction.listDate;

    //nadi indeks
    int index = 0;

    for (var i = 0; i < this.transactions.length; i++) {
      List<int> dateAtIndex = this.transactions[i].listDate;

      if (dateAtIndex[0] > selectedDate[0]) {
        index = i + 1;
      } else {
        if (dateAtIndex[1] > selectedDate[1]) {
          index = i + 1;
        } else {
          if (dateAtIndex[2] > selectedDate[2]) {
            index = i + 1;
          } else {
            index = i;
            break;
          }
        }
      }
    }
    /*print('dobar dan dobrodosli u ndziajn ja sam mirjana mikulec');
    print(index);
    print(selectedDate);*/

    transactions.insert(index, transaction);

    //transactions.add(transaction);

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

    /*if (selectedIndex >= 0) {
                    widget.selectedWallet.transactions.removeAt(selectedIndex);
                    
                    service.removeTransaction(
                      widget.selectedWallet.transactions,
                      currentUser,
                      widget.selectedWallet,
                    );
                  }*/

    return selectedTransaction;
  }

  int indexFromId(String id) {
    ///pominit ime u transactionindexfromid..........
    for (var i = 0; i < this.transactions.length; i++) {
      if (transactions[i].id == id) {
        return i;
      }
    }
    return -1;
  }

  Map<String, dynamic> toFirestoreMap() {
    //cpnvert wallet ...
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
