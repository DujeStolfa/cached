/// Dijagram salda novčanika
///
/// Prikazuje ukupno stanje odabranog novčanika nakon svake transakcije.

import 'dart:convert';
import 'package:aplikacija/models/prediction_api_response.dart';
import 'package:aplikacija/models/reduced_transaction_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

class WalletBalanceGraph extends StatefulWidget {
  final Wallet selectedWallet;

  WalletBalanceGraph({Key key, @required this.selectedWallet})
      : super(key: key);

  @override
  _WalletBalanceGraphState createState() => _WalletBalanceGraphState();
}

class _WalletBalanceGraphState extends State<WalletBalanceGraph> {
  QuerySnapshot _walletsSnapshot;
  List<dynamic> _transactionData = [
    [0],
    [0]
  ];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  bool showAvg = false;

  @override
  void initState() {
    super.initState();
  }

  // Dohvati predviđanje s autorskog API-ja
  Future<PredictionApiResponse> fetchPrediction(
      List totalValues, List relativeValues) async {
    http.Response response = await http.post(
      Uri.http('dujestolfa.pythonanywhere.com', 'api'),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode(
          <String, List>{"Total": totalValues, "Change": relativeValues}),
    );

    if (response.statusCode == 201) {
      dynamic decodedBody = jsonDecode(response.body);

      return PredictionApiResponse(decodedBody['prediction'],
          decodedBody['confidence'], decodedBody['prediction_shift']);
    } else {
      throw Exception('Failed to load prediction');
    }
  }

  // Dohvati podatke o korisnikovim transakcijama
  List fetchTransactionData() {
    List<ReducedTransaction> transactions = [];
    double currentBalance = 0;
    Map wallet;

    for (var element in _walletsSnapshot.docs) {
      var data = element.data();
      if (data['id'] == widget.selectedWallet.id) {
        wallet = data;
      }
    }

    currentBalance += wallet['balance'];

    for (var transaction in wallet['transactions']) {
      DateTime datetimeDate = DateTime.fromMillisecondsSinceEpoch(
          transaction['date'].millisecondsSinceEpoch);
      double value = (transaction['expense'])
          ? -1 * transaction['value'].toDouble()
          : transaction['value'].toDouble();

      ReducedTransaction altTransaction = ReducedTransaction(
        datetimeDate,
        value,
      );
      transactions.add(altTransaction);
    }

    transactions.sort((a, b) => a.date.compareTo(b.date));

    List<double> balanceHistory =
        List<double>.generate(transactions.length + 1, (index) => 0);

    balanceHistory[balanceHistory.length - 1] = currentBalance;

    for (var i = balanceHistory.length - 2; i >= 0; i--) {
      balanceHistory[i] = currentBalance - transactions[i].value;
      currentBalance -= transactions[i].value;
    }

    return [
      balanceHistory.sublist(1, balanceHistory.length),
      transactions.map((a) => a.value).toList()
    ];
  }

  // Stvori oznake za ordinatnu os dijagrama
  SideTitles leftTitles(List<double> recentTransactions) {
    return SideTitles(
      showTitles: true,
      getTextStyles: (value) => const TextStyle(
        color: Color(0xff67727d),
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      getTitles: (value) {
        return value.round().toString();
      },
      reservedSize: 28,
      margin: 12,
      interval: (recentTransactions.reduce(max) +
              min(recentTransactions.reduce(max) * 1.01, 100) -
              recentTransactions.reduce(min) +
              min(recentTransactions.reduce(min) * 0.99, 100)) /
          5,
    );
  }

  // Prilagodi sve podatke u format za prikazivanje na dijagram
  LineChartData mainData(PredictionApiResponse prediction) {
    List<double> recentTransactions;

    recentTransactions = _transactionData[0];
    for (var element in prediction.prediction) {
      recentTransactions.add(element);
    }
    List<FlSpot> spotList = [];
    int k = min(recentTransactions.length, 10);
    for (var i = 0; i < k; i++) {
      spotList.add(FlSpot(
          i.toDouble(), recentTransactions[recentTransactions.length - k + i]));
    }

    return LineChartData(
      extraLinesData: ExtraLinesData(verticalLines: [
        VerticalLine(
            x: k.toDouble() - prediction.predictionShift,
            color: Colors.green,
            dashArray: [8, 5])
      ]),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: const Color(0x25E88A1C),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: const Color(0x25E88A1C),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: leftTitles(recentTransactions),
        bottomTitles: SideTitles(),
      ),
      borderData: FlBorderData(
          show: true,
          border: Border.all(color: const Color(0x40E88A1C), width: 1)),
      minX: 0,
      maxX: k.toDouble() - 1,
      minY: (recentTransactions.reduce(min) < 0)
          ? recentTransactions.reduce(min) +
              max(recentTransactions.reduce(min) * 0.99, -100)
          : recentTransactions.reduce(min) -
              min(recentTransactions.reduce(min) * 0.99, 100),
      maxY: recentTransactions.reduce(max) +
          min(recentTransactions.reduce(max) * 1.01, 100),
      lineBarsData: [
        LineChartBarData(
          spots: spotList,
          isCurved: true,
          colors: gradientColors,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors:
                gradientColors.map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  // Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    _walletsSnapshot = context.watch<QuerySnapshot>();
    _transactionData = fetchTransactionData();

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.5,
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  right: 18.0, left: 12.0, top: 12, bottom: 12),
              child: FutureBuilder<PredictionApiResponse>(
                  future:
                      fetchPrediction(_transactionData[0], _transactionData[1]),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        return LineChart(mainData(snapshot.data));
                      }
                      return Center(child: CircularProgressIndicator());
                    }
                    return Center(
                      child: Icon(Icons.error),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }
}
