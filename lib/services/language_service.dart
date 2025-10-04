import 'package:flutter/material.dart';
import '../languages/language_en.dart';
import '../languages/language_hi.dart';
import '../languages/language_gu.dart';

class LanguageService with ChangeNotifier {
  Locale _currentLocale = const Locale('en');
  Map<String, String> _currentStrings = english;

  Locale get currentLocale => _currentLocale;
  Map<String, String> get currentStrings => _currentStrings;

  void changeLanguage(String languageCode) {
    print('Changing language to: $languageCode'); // Debug print
    
    switch (languageCode) {
      case 'hi':
        _currentLocale = const Locale('hi');
        _currentStrings = hindi;
        break;
      case 'gu':
        _currentLocale = const Locale('gu');
        _currentStrings = gujarati;
        break;
      case 'en':
      default:
        _currentLocale = const Locale('en');
        _currentStrings = english;
        break;
    }
    
    print('Language changed. Notifying listeners...'); // Debug print
    notifyListeners(); // This triggers UI updates
  }

  String get(String key) {
    final value = _currentStrings[key];
    print('Getting key: $key -> $value'); // Debug print
    return value ?? key;
  }
}