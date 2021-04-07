/// Tekstni okvir koji se prikže korisniku u slučaju pogreške.

import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      body: Center(
        child: Text('Error.'),
      ),
    ));
  }
}
