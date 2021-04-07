/// Klasa ReducedTransaction
///
/// Kako bi se optimizirao protok poataka o transakcijama kroz
/// aplikaciju, za prikazivanje dijagrama u aplikaciji koristi
/// se reducirana inačica klase Transaction.

class ReducedTransaction {
  final DateTime date;
  final double value;

  ReducedTransaction(
    this.date,
    this.value,
  );

  String get asString => '${this.date}, ${this.value}';
}
