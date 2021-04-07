import 'package:flutter/material.dart';

class DisabledTransferMessage extends StatefulWidget {
  @override
  _DisabledTransferMessageState createState() =>
      _DisabledTransferMessageState();
}

class _DisabledTransferMessageState extends State<DisabledTransferMessage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
      child: Container(
        child: Text(
          'Use of transfers requires at least two wallets',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.blueGrey,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
