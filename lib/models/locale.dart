import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleModel extends ChangeNotifier {
  Locale? _locale;
  static const String _languageKey = 'selected_language';
  
  Locale? get locale => _locale;

  // Initialize with saved locale
  LocaleModel() {
    _loadSavedLocale();
  }

  // Load saved locale from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString(_languageKey);
    if (savedLanguage != null) {
      print('savedLanguage: $savedLanguage');
      _locale = Locale(savedLanguage);
    } else {
      _locale = const Locale('es'); // Default language
    }
    notifyListeners();
  }

  // Save locale to SharedPreferences
  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_languageKey, locale.languageCode);
    print('setLocale: $locale');
    notifyListeners();
  }
}