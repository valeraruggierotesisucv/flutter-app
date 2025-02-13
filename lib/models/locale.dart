import 'package:flutter/material.dart';

class LocaleModel extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  // Initialize with a default locale
  LocaleModel() {
    _locale = const Locale('en');
  }
}