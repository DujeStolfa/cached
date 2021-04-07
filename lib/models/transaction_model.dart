/// Klasa Transaction
///
/// U aplikaciji se pri rukovanju transakcijama koriste instance
/// klase Transaction. Modul Cloud Firestore koristi se za pretvaranje
/// datuma izvršenja transakcije iz tipa Timestamp optimiziranog za bazu
/// podataka u tip DateTime prilagođen korištenju u ostatku aplikacije.

import 'package:cloud_firestore/cloud_firestore.dart';

class Transaction {
  final String id;
  String description;
  final double value;
  final Timestamp date;
  final bool expense;
  final String category;
  bool isExpanded;

  Transaction(
    this.value,
    this.expense,
    this.description,
    this.date,
    this.category,
    this.id, {
    this.isExpanded = true,
  });

  DateTime get dateTimeDate =>
      DateTime.fromMillisecondsSinceEpoch(this.date.millisecondsSinceEpoch);

  List<int> get listDate =>
      [this.dateTimeDate.year, this.dateTimeDate.month, this.dateTimeDate.day];

  String stringDate() {
    DateTime displayDate = this.dateTimeDate;

    String day = displayDate.day.toString();
    String month = displayDate.month.toString();
    String year = displayDate.year.toString();

    return '$day. $month. $year.';
  }

  Map<String, dynamic> convertTransaction() {
    return {
      'value': this.value,
      'expense': this.expense,
      'description': this.description,
      'date': this.date,
      'category': this.category,
      'id': this.id,
      'isExpanded': this.isExpanded,
    };
  }
}
