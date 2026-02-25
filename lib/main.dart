import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:namazvaktim/Pages/DaysPage.dart';
import 'package:namazvaktim/Pages/QiblaPage.dart';
import 'package:namazvaktim/Pages/SettingsPage.dart';
import 'package:namazvaktim/Pages/HomePage.dart';
import 'package:namazvaktim/services/language_service.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'services/notification_service.dart';
import 'services/theme_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  tz.initializeTimeZones();
  await NotificationService.initialize();
  await LanguageService().loadLanguage();
  await AppThemes().loadTheme();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final LanguageService _languageService = LanguageService();
  final AppThemes _appThemes = AppThemes();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onChanged);
    _appThemes.addListener(_onChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onChanged);
    _appThemes.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final isRTL = _languageService.isRTL;
    return MaterialApp(
      title: _languageService.t('app_name'),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return Directionality(
          textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const BNavBar(),
    );
  }
}

class BNavBar extends StatefulWidget {
  const BNavBar({super.key});

  @override
  State<BNavBar> createState() => _BNavBarState();
}

class _BNavBarState extends State<BNavBar> {
  int _selectedIndex = 0;
  final LanguageService _lang = LanguageService();
  final AppThemes _appThemes = AppThemes();

  final List<Widget> _pages = [
    const HomePage(),
    const DaysPage(),
    const QiblaPage(),
    const SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onChanged);
    _appThemes.addListener(_onChanged);
  }

  @override
  void dispose() {
    _lang.removeListener(_onChanged);
    _appThemes.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = _appThemes.current;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: theme.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ));

    return Scaffold(
      backgroundColor: theme.background,
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildNavBar(theme),
    );
  }

  Widget _buildNavBar(AppThemeData theme) {
    final items = [
      _NavItem(icon: Icons.home_rounded, outlinedIcon: Icons.home_outlined,
          label: _lang.t('nav_home')),
      _NavItem(icon: Icons.auto_awesome_rounded,
          outlinedIcon: Icons.auto_awesome_outlined,
          label: _lang.t('nav_days')),
      _NavItem(icon: Icons.explore_rounded,
          outlinedIcon: Icons.explore_outlined, label: _lang.t('nav_qibla')),
      _NavItem(icon: Icons.settings_rounded,
          outlinedIcon: Icons.settings_outlined,
          label: _lang.t('nav_settings')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.surface,
        border: Border(
            top: BorderSide(color: Colors.white.withOpacity(0.07), width: 1)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, -4)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? theme.primary.withOpacity(0.12)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isSelected
                        ? Border.all(
                        color: theme.primary.withOpacity(0.25))
                        : null,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isSelected ? item.icon : item.outlinedIcon,
                        color: isSelected
                            ? theme.primary
                            : Colors.white30,
                        size: 22,
                      ),
                      const SizedBox(height: 4),
                      Text(item.label,
                          style: TextStyle(
                            fontFamily: 'MyFont2',
                            fontSize: 10,
                            color: isSelected
                                ? theme.primary
                                : Colors.white30,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          )),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData outlinedIcon;
  final String label;

  const _NavItem(
      {required this.icon,
        required this.outlinedIcon,
        required this.label});
}