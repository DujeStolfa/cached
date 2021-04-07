class ReducedTransaction {
  final DateTime date;
  final double value;

  ReducedTransaction(
    this.date,
    this.value,
  );

  String get asString => '${this.date}, ${this.value}';
}
