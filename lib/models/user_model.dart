import 'package:aplikacija/models/wallet_model.dart';

class AppUser {
  final String id;
  final String name;
  final String mail;
  List<String> categories;
  Map<String, Wallet> wallets;

  AppUser(
    this.id,
    this.name,
    this.mail,
    this.wallets,
    this.categories,
  );
}
