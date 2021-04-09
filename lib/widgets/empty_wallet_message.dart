/// Widget sa porukom za novčanik
///
/// Poruka koja se prikazuje ako novčanik nema unesenih transakcija.

import 'package:flutter/material.dart';

class EmptyWalletMessage extends StatelessWidget {
  // Izgradi Widget tree
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .8,
      child: Text(
        'This wallet has no added transactions.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
