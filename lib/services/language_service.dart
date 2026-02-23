import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/translations.dart';

class LanguageService extends ChangeNotifier {
  static const String _langKey = 'selected_language';

  String _currentLanguage = 'az';

  String get currentLanguage => _currentLanguage;

  bool get isRTL => _currentLanguage == 'ar' || _currentLanguage == 'fa';

  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_langKey) ?? 'az';
    notifyListeners();
  }

  Future<void> setLanguage(String langCode) async {
    _currentLanguage = langCode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_langKey, langCode);
    notifyListeners();
  }

  String t(String key) {
    final langMap = Translations.all[_currentLanguage] ?? Translations.all['az']!;
    return langMap[key] ?? Translations.all['az']![key] ?? key;
  }

  static const List<Map<String, String>> availableLanguages = [
    {'code': 'az', 'name': 'Azərbaycan dili', 'nativeName': 'Azərbaycan', 'flag': '🇦🇿'},
    {'code': 'tr', 'name': 'Türkçe', 'nativeName': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧'},
    {'code': 'fa', 'name': 'فارسی', 'nativeName': 'فارسی', 'flag': '🇮🇷'},
    {'code': 'ar', 'name': 'العربية', 'nativeName': 'العربية', 'flag': '🇸🇦'},
    {'code': 'id', 'name': 'Bahasa Indonesia', 'nativeName': 'Indonesia', 'flag': '🇮🇩'},
  ];
}