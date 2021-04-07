import 'dart:convert';
import 'package:aplikacija/models/prediction_api_response.dart';
import 'package:aplikacija/models/reduced_transaction_model.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
/* TODO: 
  x | sredit ovo racunanje ukupnog iznosa  
  grafovi - za svaki wallet isto sta i ovde kme
          - jos jedna vrsta grafova
  kartice
  transfer momenat

  .. sitnice ..
  200 tommy i hrk
  transfer ikone



 */

class LineGraphTotal extends StatefulWidget {
  @override
  _LineGraphTotalState createState() => _LineGraphTotalState();
}

class _LineGraphTotalState extends State<LineGraphTotal> {
  Future<PredictionApiResponse> _apiResponse;
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
  Widget build(BuildContext context) {
    _walletsSnapshot = context.watch<QuerySnapshot>();
    _transactionData = fetchTransactionData();
    //_transactionData = fetchTransactionData(context);
    print('Ginem Ginem GInem Ginem Ginem Ginem Ginem Ginem Ginem Ginem');
    print(_transactionData);
    print('Ginem Ginem GInem Ginem Ginem Ginem Ginem Ginem Ginem Ginem');
    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Container(
            //decoration: const BoxDecoration(color: Color(0xff232d37)),
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

  Future<PredictionApiResponse> fetchPrediction(
      List totalValues, List relativeValues) async {
    print(relativeValues);
    http.Response response = await http.post(
      Uri.http('dujestolfa.pythonanywhere.com', 'api'),
      headers: {
        "Content-Type": "application/json; charset=utf-8",
      },
      body: jsonEncode(
          <String, List>{"Total": totalValues, "Change": relativeValues}),
    );
    print('jel ovo radi');
    print(response.statusCode);
    print(jsonDecode(response.body));
    if (response.statusCode == 201) {
      dynamic decodedBody = jsonDecode(response.body);
      print(decodedBody);
      print('evo me');
      return PredictionApiResponse(decodedBody['prediction'],
          decodedBody['confidence'], decodedBody['prediction_shift']);
    } else {
      throw Exception('Failed to load prediction');
    }
  }

  List fetchTransactionData() {
    List<ReducedTransaction> allTransactions = [];

    double currentBalance = 0;

    for (var wallet in _walletsSnapshot.docs) {
      currentBalance += wallet.data()['balance'];
      for (var transaction in wallet.data()['transactions']) {
        DateTime datetimeDate = DateTime.fromMillisecondsSinceEpoch(
            transaction['date'].millisecondsSinceEpoch);
        double value = (transaction['expense'])
            ? -1 * transaction['value'].toDouble()
            : transaction['value'].toDouble();

        ReducedTransaction altTransaction = ReducedTransaction(
          datetimeDate,
          value,
        );
        allTransactions.add(altTransaction);
      }
    }

    allTransactions.sort((a, b) => a.date.compareTo(b.date));

    List<double> balanceHistory =
        List<double>.generate(allTransactions.length + 1, (index) => 0);

    balanceHistory[balanceHistory.length - 1] = currentBalance;

    for (var i = balanceHistory.length - 2; i >= 0; i--) {
      balanceHistory[i] = currentBalance - allTransactions[i].value;
      currentBalance -= allTransactions[i].value;
    }
    //print(balanceHistory.sublist(0, balanceHistory.length - 1));
    //print(allTransactions.map((a) => a.value));
    /*PredictionApiResponse resp = await fetchPrediction(
        balanceHistory.sublist(0, balanceHistory.length - 1),
        allTransactions.map((a) => a.value).toList());
        .sublist(0, balanceHistory.length - 1)
        */
    print('balanssssss');
    print(balanceHistory.sublist(0, balanceHistory.length));
    print(allTransactions.map((a) => a.value).toList());
    print('jel bar ovo radi');
    return [
      balanceHistory.sublist(1, balanceHistory.length),
      allTransactions.map((a) => a.value).toList()
    ];
  }

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
            5);
  }

  LineChartData mainData(PredictionApiResponse prediction) {
// prodi svaki novcanik - 10 po 10
// poslagaj transakcije od novog u ukupne

/*
{
        "Total": np.array([244, 344, 594, 694, 664, 634, 619, 689, 389, 589]),
        "Change": np.array([100, 250, 100, -30, -30, -15, 56, -300, 80, 200]),
    }
     */
    //List<double> recentTransactions = balanceHistory(context);
    /*[
      244,
      344,
      594,
      694,
      664,
      634,
      619,
      689,
      389,
      589
    ];*/

    //getAllTransactions(context).map((e) => e.value.toDouble()).toList();
    List<double> recentTransactions = _transactionData[0];
    for (var element in prediction.prediction) {
      recentTransactions.add(element.round() * 1.0);
    }
    //https://dev.to/kamilpowalowski/stock-charts-with-flchart-library-1gd2

    List<FlSpot> spotList = [];
    int k = min(recentTransactions.length, 100);
    for (var i = 0; i < k; i++) {
      spotList.add(FlSpot(
          i.toDouble(), recentTransactions[recentTransactions.length - k + i]));
    }

    /*spotList = [
      FlSpot(0, 244),
      FlSpot(1, 344),
      FlSpot(2, 594),
      FlSpot(3, 694),
      FlSpot(4, 664),
      FlSpot(5, 634),
      FlSpot(6, 619),
      FlSpot(7, 689),
      FlSpot(8, 389),
      FlSpot(9, 289),
    ];*/

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
      minY: recentTransactions.reduce(min) -
          min(recentTransactions.reduce(min) * 0.99, 100),
      maxY: recentTransactions.reduce(max) +
          min(recentTransactions.reduce(max) * 1.01, 100),
      lineBarsData: [
        LineChartBarData(
          spots: spotList,
          isCurved: true,
          colors: gradientColors,
          //barWidth: 2,
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
}
