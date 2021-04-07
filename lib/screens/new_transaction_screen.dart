/// Forma za upis nove transakcije
///
/// Korisniku je prikazana forma sa svim potrebnim poljima
/// za stvaranje nove transakcije. Upisani se podatci šalju
/// servisu koji te podatke dalje prosljeđuje u bazu podataka
/// na Cloud Firestoreu.

import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/widgets/disabled_transaction_message.dart';
import 'package:aplikacija/models/main_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'add_category_dialog.dart';

class NewTransactionScreen extends StatefulWidget {
  static final String id = 'new_transaction';

  @override
  _NewTransactionScreenState createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  int _selectedIndex;
  bool _loaded = false;

  double _selectedValue;
  String _selectedDescription;
  bool _selectedExpense = true;
  DateTime _selectedDate = DateTime.now();
  String _selectedCategory;
  Wallet _selectedWallet;
  List<Wallet> _wallets;
  QuerySnapshot _walletsSnapshot;

  @override
  void initState() {
    super.initState();
  }

  void _submit(dynamic service, User user, List categories) {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_selectedIndex != null) {
        _selectedCategory = categories[_selectedIndex];
      } else {
        _selectedCategory = '';
      }

      Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
          _selectedDate.millisecondsSinceEpoch);

      Map<String, dynamic> transactionData = {
        'value': _selectedValue,
        'expense': _selectedExpense,
        'description': _selectedDescription,
        'date': timestamp,
        'category': _selectedCategory,
        'id': DateTime.now().toString(),
        'isExpanded': false,
      };

      Navigator.pop(context);
    }
  }

  void _selectDate(BuildContext context) async {
    // otvara datepicker

    final DateTime selected = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime.now());

    if (selected != null) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _setExpense(bool value) {
    setState(() {
      _selectedExpense = value;
    });
  }

  Widget _buildWalletDropdown() {
    print(_selectedWallet.name);
    return Row(
      children: [
        Icon(
          Icons.account_balance_wallet_outlined,
          size: 27,
        ),
        SizedBox(width: 12),
        DropdownButton<Wallet>(
          onChanged: (Wallet selectedWallet) {
            setState(() {
              _selectedWallet = selectedWallet;
            });
          },
          value: _selectedWallet,
          items: _wallets.map(
            (Wallet wallet) {
              return DropdownMenuItem(
                value: wallet,
                child: Text(
                  wallet.name,
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildChips(List<dynamic> categories) {
    List<Widget> chips = [];

    for (int i = 0; i < categories.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: _selectedIndex == i,
        label: Text(categories[i], style: TextStyle(color: Colors.white)),
        elevation: 3,
        pressElevation: 2,
        backgroundColor: Colors.indigo[300],
        selectedColor: Theme.of(context).accentColor,
        onSelected: (bool selected) {
          setState(() {
            if (selected) {
              _selectedIndex = i;
            }
          });
        },
      );

      if (i != 0) {
        chips.add(Padding(
            padding: EdgeInsets.symmetric(horizontal: 10), child: choiceChip));
      } else {
        chips.add(Padding(
            padding: EdgeInsets.fromLTRB(25, 0, 10, 0), child: choiceChip));
      }
    }

    return ListView(
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    _walletsSnapshot = context.watch<QuerySnapshot>();
    Map<String, dynamic> userSnapshotData =
        context.watch<DocumentSnapshot>().data();
    User currentUser = context.watch<AuthenticationService>().currentUser;

    dynamic service = context.watch<FirestoreService>();

    _wallets = _walletsSnapshot.docs
        .map((element) => model.createWallet(element.data()))
        .toList();

    List<dynamic> categories = userSnapshotData['categories'];

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40.0, 60.0, 40.0, 20.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Text(
                'New transaction',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(35.0)),
                color: Colors.white,
              ),
              child: (_wallets.length < 1)
                  ? DisabledTransactionMessage()
                  : ListView(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Radio(
                                    value: true,
                                    groupValue: _selectedExpense,
                                    onChanged: _setExpense,
                                  ),
                                  Text('Expense',
                                      style: TextStyle(fontSize: 16.0)),
                                  SizedBox(width: 40),
                                  Radio(
                                    value: false,
                                    groupValue: _selectedExpense,
                                    onChanged: _setExpense,
                                  ),
                                  Text('Income',
                                      style: TextStyle(fontSize: 16.0)),
                                  SizedBox(width: 25),
                                ],
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30.0,
                                      vertical: 10.0,
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        labelText: 'Value',
                                        hintText: '100.00',
                                      ),
                                      keyboardType: TextInputType.number,
                                      onSaved: (input) =>
                                          _selectedValue = double.parse(input),
                                      validator: (input) => input.trim().isEmpty
                                          ? 'Please enter a value'
                                          : null,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 30.0,
                                      vertical: 10.0,
                                    ),
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          labelText: 'Description'),
                                      onSaved: (input) =>
                                          _selectedDescription = input,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                (_selectedWallet != null)
                                    ? _buildWalletDropdown()
                                    : () {
                                        setState(() {
                                          _selectedWallet = _wallets[0];
                                        });
                                        return _buildWalletDropdown();
                                      }(),
                                Container(
                                  width: 120,
                                  child: OutlineButton.icon(
                                    onPressed: () {
                                      _selectDate(context);
                                    },
                                    label: Text(
                                      'Date',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    icon: Icon(Icons.date_range_outlined),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(30, 25, 30, 14),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Categories',
                                    style: TextStyle(
                                      color: Colors.blueGrey,
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1.0,
                                    ),
                                  ),
                                  Container(
                                    height: 30,
                                    child: IconButton(
                                      icon: Icon(Icons.add),
                                      color: Colors.blueGrey,
                                      onPressed: () async {
                                        String newCategory = await Navigator.of(
                                                context)
                                            .push(PageRouteBuilder(
                                                opaque: false,
                                                pageBuilder:
                                                    (BuildContext context, _,
                                                            __) =>
                                                        AddCategoryDialog()));
                                        if (newCategory != null &&
                                            newCategory != '') {
                                          service.addCategory(
                                            currentUser,
                                            categories,
                                            newCategory,
                                          );
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              height: 40,
                              child: _buildChips(categories),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Padding(
                                padding: EdgeInsets.only(top: 25, right: 40),
                                child: Container(
                                  width: 150,
                                  child: RaisedButton(
                                    onPressed: () => _submit(
                                        service, currentUser, categories),
                                    color: Theme.of(context).accentColor,
                                    child: Text(
                                      'Done',
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
