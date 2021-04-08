/// Nadzorna ploča
///
/// Korisniku su na nadzornoj ploči prikazani izbonik (SpeedDial)
/// za unos nove transakcije ili transfera, izbornik sa popisom
/// svih korisnikovih novčanika i dijagram salda svih transakcija.

import 'package:aplikacija/widgets/app_icons.dart';
import 'package:aplikacija/widgets/graph_list.dart';
import 'package:aplikacija/widgets/wallet_selector.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static final String id = 'home_screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        appBar: AppBar(centerTitle: true, elevation: 0.0, actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              iconSize: 30.0,
              color: Colors.white,
              onPressed: () {
                context.read<AuthenticationService>().signOut();
              })
        ]),
        floatingActionButton: SpeedDial(
          animatedIconTheme: IconThemeData(size: 22.0),
          child: Icon(Icons.add),
          closeManually: false,
          curve: Curves.bounceIn,
          overlayColor: Colors.black,
          overlayOpacity: 0.1,
          tooltip: 'Speed Dial',
          heroTag: 'speed-dial-hero-tag',
          backgroundColor: Theme.of(context).accentColor,
          foregroundColor: Colors.white,
          elevation: 4.0,
          shape: CircleBorder(),
          children: [
            SpeedDialChild(
              child: Icon(AppIcons.transaction),
              backgroundColor: Theme.of(context).accentColor,
              label: 'Transaction',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => Navigator.pushNamed(context, 'new_transaction'),
            ),
            SpeedDialChild(
              child: Icon(AppIcons.transfer),
              backgroundColor: Theme.of(context).accentColor,
              label: 'Transfer',
              labelStyle: TextStyle(fontSize: 18.0),
              onTap: () => Navigator.pushNamed(context, 'new_transfer'),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
                padding: EdgeInsets.fromLTRB(40.0, 60.0, 40.0, 20.0),
                child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Text('Dashboard',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 40.0,
                            fontWeight: FontWeight.w700)))),
            Expanded(
                child: Container(
                    decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(35.0)),
                        color: Colors.white),
                    child: ListView(children: [
                      Column(children: [
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 14.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Wallets',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0))
                                ])),
                        WalletSelector(),
                        Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 10.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Total balance trend',
                                      style: TextStyle(
                                          color: Colors.blueGrey,
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 1.0))
                                ])),
                        GraphList(),
                        SizedBox(
                          height: 25,
                        )
                      ]),
                    ])))
          ],
        ));
  }
}
