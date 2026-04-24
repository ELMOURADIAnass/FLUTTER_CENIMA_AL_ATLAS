import 'package:flutter/material.dart';
import '../utils/localization.dart';

// Provider for managing app language state
class LanguageProvider extends ChangeNotifier {
  String _currentLanguage = 'fr';

  String get currentLanguage => _currentLanguage;

  AppLocalizations get localizations => AppLocalizations(_currentLanguage);

  Locale get locale {
    switch (_currentLanguage) {
      case 'ar':
        return const Locale('ar');
      case 'en':
        return const Locale('en');
      default:
        return const Locale('fr');
    }
  }

  bool get isRTL => _currentLanguage == 'ar';

  void setLanguage(String languageCode) {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      notifyListeners();
    }
  }

  void toggleLanguage() {
    switch (_currentLanguage) {
      case 'fr':
        _currentLanguage = 'en';
        break;
      case 'en':
        _currentLanguage = 'ar';
        break;
      case 'ar':
        _currentLanguage = 'fr';
        break;
      default:
        _currentLanguage = 'fr';
    }
    notifyListeners();
  }
}
