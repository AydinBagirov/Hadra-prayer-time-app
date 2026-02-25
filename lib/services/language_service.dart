import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/translations.dart';

class LanguageService extends ChangeNotifier {
  static const String _langKey = 'selected_language';

  String _currentLanguage = 'az';

  String get currentLanguage => _currentLanguage;

  bool get isRTL => false;

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
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧'},
    {'code': 'az', 'name': 'Azərbaycan dili', 'nativeName': 'Azərbaycan', 'flag': '🇦🇿'},
    {'code': 'tr', 'name': 'Türkçe', 'nativeName': 'Türkçe', 'flag': '🇹🇷'},
    {'code': 'ru', 'name': 'Русский', 'nativeName': 'Русский', 'flag': '🇷🇺'},
    {'code': 'fr', 'name': 'Français', 'nativeName': 'Français', 'flag': '🇫🇷'},
    {'code': 'de', 'name': 'Deutsch', 'nativeName': 'Deutsch', 'flag': '🇩🇪'},
    {'code': 'es', 'name': 'Español', 'nativeName': 'Español', 'flag': '🇪🇸'},
    {'code': 'fa', 'name': 'فارسی', 'nativeName': 'فارسی', 'flag': '🇮🇷'},
    {'code': 'ar', 'name': 'العربية', 'nativeName': 'العربية', 'flag': '🇸🇦'},
    {'code': 'id', 'name': 'Bahasa Indonesia', 'nativeName': 'Indonesia', 'flag': '🇮🇩'},
    {'code': 'ko', 'name': '한국어', 'nativeName': '한국어', 'flag': '🇰🇷'},
    {'code': 'zh', 'name': '中文', 'nativeName': '中文', 'flag': '🇨🇳'},
    {'code': 'ja', 'name': '日本語', 'nativeName': '日本語', 'flag': '🇯🇵'},
    {'code': 'mn', 'name': 'Монгол', 'nativeName': 'Монгол', 'flag': '🇲🇳'},
    {'code': 'ur', 'name': 'اردو', 'nativeName': 'اردو', 'flag': '🇵🇰'},
    {'code': 'hi', 'name': 'हिन्दी', 'nativeName': 'हिन्दी', 'flag': '🇮🇳'},
  ];
}