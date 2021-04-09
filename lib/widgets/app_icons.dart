/// Widget za ikone
///
/// Omogućuje prikazivanje autorskih ikona za transakciju i transfer.

import 'package:flutter/widgets.dart';

class AppIcons {
  AppIcons._();

  static const _kFontFam = 'AppIcons';
  static const String _kFontPkg = null;

  static const IconData transaction =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData transfer =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}
