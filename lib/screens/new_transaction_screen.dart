import 'package:aplikacija/models/main_model.dart';
import 'package:aplikacija/models/transaction_model.dart';
import 'package:aplikacija/models/user_model.dart';
import 'package:aplikacija/models/wallet_model.dart';
import 'package:aplikacija/services/auth_service.dart';
import 'package:aplikacija/services/firestore_service.dart';
import 'package:aplikacija/widgets/disabled_transaction_message.dart';
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
  //final AppUser _currentUser = ;

  int _selectedIndex;
  //List<String> _categories = model.users[1].categories;
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
    // kad se pritisne done botun provjeri jel sve dobro uneseno
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      if (_selectedIndex != null) {
        _selectedCategory = categories[_selectedIndex];
      } else {
        _selectedCategory = '';
      }

      print(_selectedCategory);
      print(_selectedDescription);
      print(_selectedExpense);
      print(_selectedValue);
      print(_selectedWallet);

      print(DateTime.now().toString());
      Timestamp timestamp = Timestamp.fromMillisecondsSinceEpoch(
          _selectedDate.millisecondsSinceEpoch);

      //napravi transaction, zasto? aaaaa ?! mozda je sve ok
      //napravi mapu data i posalji na firebase

      Map<String, dynamic> transactionData = {
        'value': _selectedValue,
        'expense': _selectedExpense,
        'description': _selectedDescription,
        'date': timestamp,
        'category': _selectedCategory,
        'id': DateTime.now().toString(),
        'isExpanded': false,
      };

      print('a a a a  a  a a   a a a  a a  a n n nn vn vnvn vn vn vn vn vnv ');
      print(_selectedWallet.transactions);
      print('');
      service.addTransaction(transactionData, _selectedWallet, user);
      print('');
      print(_selectedWallet.transactions);
      print('');

      /*Transaction newTransaction = Transaction(_selectedValue, _selectedExpense,
          _selectedDescription, _selectedDate, _selectedCategory);

      AppUser modelUser = model.users.where((AppUser user) {
        return user.id == _currentUser.id;
      }).toList()[0];
      print('vvv');
      //modelUser.wallets[_selectedWallet.id].transactions.add(newTransaction);
      //modelUser.wallets[_selectedWallet.id].addTransaction(newTransaction);

      model.addTransaction(1, _selectedWallet.id, newTransaction);
      print('bbbb');
      print(model.users[1].wallets['zl0'].balance);*/
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
  /*
  Widget _buildWalletDropdown(List<dynamic> wallets) {
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
          items: wallets.map(
            (category) {
              return DropdownMenuItem(
                value: category,
                child: Text(
                  category,
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  } */

  Widget _buildChips(List<dynamic> categories) {
    // stvara listu kategorija

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
      // This next line does the trick.
      scrollDirection: Axis.horizontal,
      children: chips,
    );
  }

  @override
  Widget build(BuildContext context) {
    _walletsSnapshot = context.watch<QuerySnapshot>();
    //User currentUser = context.watch<AuthenticationService>().currentUser;
    Map<String, dynamic> userSnapshotData =
        context.watch<DocumentSnapshot>().data();
    User currentUser = context.watch<AuthenticationService>().currentUser;

    dynamic service = context.watch<FirestoreService>();

    // odavde nastavnit
    // ovo vraca wallete sa praznon liston transakcija
    // pa se svaki put ka resetira u bazi :/
    _wallets = _walletsSnapshot.docs
        .map((element) => model.createWallet(element.data()))
        .toList();
    for (var wallet in _wallets) {
      print(' ');
      print(wallet.name);
    }

    //if (!_loaded) {
    //_selectedWallet = _wallets[0];
//      _loaded = true;
    //  }
    if (_selectedWallet != null) {
      print('___________________' + _selectedWallet.name);
    }
    List<dynamic> categories = userSnapshotData['categories'];
    //List<dynamic> wallets = userSnapshotData['walletNames'];

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
                                  // botun za otvorit datetime izbornik
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
