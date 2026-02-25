import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeData {
  final String id;
  final String nameKey;
  final Color primary;
  final Color accent;
  final Color background;
  final Color surface;
  final Color cardGradientStart;
  final Color cardGradientEnd;
  final List<Color> glowColors;

  const AppThemeData({
    required this.id,
    required this.nameKey,
    required this.primary,
    required this.accent,
    required this.background,
    required this.surface,
    required this.cardGradientStart,
    required this.cardGradientEnd,
    required this.glowColors,
  });
}

class AppThemes extends ChangeNotifier {
  static const List<AppThemeData> themes = [
    AppThemeData(
      id: 'ocean',
      nameKey: 'theme_ocean',
      primary: Color(0xFF4ECDC4),
      accent: Color(0xFF45B7D1),
      background: Color(0xFF080E1A),
      surface: Color(0xFF0D1B2A),
      cardGradientStart: Color(0xFF1A3A4A),
      cardGradientEnd: Color(0xFF0F2235),
      glowColors: [Color(0xFF4ECDC4), Color(0xFF45B7D1)],
    ),
    AppThemeData(
      id: 'desert',
      nameKey: 'theme_desert',
      primary: Color(0xFFD4A853),
      accent: Color(0xFFE8C47A),
      background: Color(0xFF0F0A04),
      surface: Color(0xFF1A1408),
      cardGradientStart: Color(0xFF2A1F0A),
      cardGradientEnd: Color(0xFF1A1408),
      glowColors: [Color(0xFFD4A853), Color(0xFFE8C47A)],
    ),
    AppThemeData(
      id: 'emerald',
      nameKey: 'theme_emerald',
      primary: Color(0xFF2ECC71),
      accent: Color(0xFF27AE60),
      background: Color(0xFF030D08),
      surface: Color(0xFF081A10),
      cardGradientStart: Color(0xFF0D2E18),
      cardGradientEnd: Color(0xFF081A10),
      glowColors: [Color(0xFF2ECC71), Color(0xFF27AE60)],
    ),
    AppThemeData(
      id: 'royal',
      nameKey: 'theme_royal',
      primary: Color(0xFF9B59B6),
      accent: Color(0xFFAD7CC4),
      background: Color(0xFF07050F),
      surface: Color(0xFF110D1C),
      cardGradientStart: Color(0xFF1E1430),
      cardGradientEnd: Color(0xFF110D1C),
      glowColors: [Color(0xFF9B59B6), Color(0xFFAD7CC4)],
    ),
    AppThemeData(
      id: 'crimson',
      nameKey: 'theme_crimson',
      primary: Color(0xFFE74C3C),
      accent: Color(0xFFEF7C6F),
      background: Color(0xFF0F0505),
      surface: Color(0xFF1C0A0A),
      cardGradientStart: Color(0xFF2E1010),
      cardGradientEnd: Color(0xFF1C0A0A),
      glowColors: [Color(0xFFE74C3C), Color(0xFFEF7C6F)],
    ),
    AppThemeData(
      id: 'silver',
      nameKey: 'theme_silver',
      primary: Color(0xFFBDC3C7),
      accent: Color(0xFFECF0F1),
      background: Color(0xFF080A0C),
      surface: Color(0xFF131619),
      cardGradientStart: Color(0xFF1E2328),
      cardGradientEnd: Color(0xFF131619),
      glowColors: [Color(0xFFBDC3C7), Color(0xFFECF0F1)],
    ),
  ];

  static final AppThemes _instance = AppThemes._internal();
  factory AppThemes() => _instance;
  AppThemes._internal();

  String _currentId = 'ocean';
  String get currentId => _currentId;
  AppThemeData get current => getById(_currentId);

  static AppThemeData getById(String id) =>
      themes.firstWhere((t) => t.id == id, orElse: () => themes.first);

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    _currentId = prefs.getString('app_theme') ?? 'ocean';
    notifyListeners();
  }

  Future<void> saveTheme(String id) async {
    _currentId = id;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_theme', id);
    notifyListeners();
  }
}