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

  // Dohvati datum transakcije u DateTime formatu
  DateTime get dateTimeDate =>
      DateTime.fromMillisecondsSinceEpoch(this.date.millisecondsSinceEpoch);

  // Dohvati datum transakcije kao listu oblika [godina, mjesec, dan]
  List<int> get listDate =>
      [this.dateTimeDate.year, this.dateTimeDate.month, this.dateTimeDate.day];

  // Dohvati datum transakcije kao broj oblika yyyymmdd
  int get intDate {
    int yearInt = this.dateTimeDate.year;
    int monthInt = this.dateTimeDate.month;
    int dayInt = this.dateTimeDate.day;

    String year = "0000" + yearInt.toString();
    year = year.substring(year.length - 4);
    String month = "00" + monthInt.toString();
    month = month.substring(month.length - 2);
    String day = "00" + dayInt.toString();
    day = day.substring(day.length - 2);

    return int.parse(year + month + day);
  }

  // Pretvori datum transakcije u String oblika "dd. mm. yyyy.""
  String stringDate() {
    DateTime displayDate = this.dateTimeDate;

    String day = displayDate.day.toString();
    String month = displayDate.month.toString();
    String year = displayDate.year.toString();

    return '$day. $month. $year.';
  }

  // Pretvori transakciju u Map objekt
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
