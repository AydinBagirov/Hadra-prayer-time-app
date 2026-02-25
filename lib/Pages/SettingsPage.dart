import 'package:flutter/material.dart';
import 'package:namazvaktim/Pages/ThemePage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:namazvaktim/Pages/NotificationsPage.dart';
import 'package:namazvaktim/Pages/ReportBugPage.dart';
import 'package:namazvaktim/Pages/ContactPage.dart';
import 'package:namazvaktim/Pages/ShareAppPage.dart';
import 'package:namazvaktim/services/language_service.dart';

import '../services/theme_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LanguageService _lang = LanguageService();
  final AppThemes _appThemes = AppThemes();
  String _version = '';

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onChanged);
    _appThemes.addListener(_onChanged);
    _loadVersion();
  }

  @override
  void dispose() {
    _lang.removeListener(_onChanged);
    _appThemes.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _version = '${info.version} (${info.buildNumber})');
  }

  void _showLanguageDialog(AppThemeData theme) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_lang.t('select_language'),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, fontFamily: 'MyFont2', color: Colors.white)),
              const SizedBox(height: 16),
              ConstrainedBox(
                constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: LanguageService.availableLanguages.map((lang) {
                      final isSelected = _lang.currentLanguage == lang['code'];
                      return GestureDetector(
                        onTap: () async {
                          await _lang.setLanguage(lang['code']!);
                          if (mounted) Navigator.of(context).pop();
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? theme.primary.withOpacity(0.12) : Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: isSelected ? theme.primary.withOpacity(0.5) : Colors.white12,
                              width: isSelected ? 1.5 : 1,
                            ),
                          ),
                          child: Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              children: [
                                Text(lang['flag']!, style: const TextStyle(fontSize: 22)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                    Text(lang['nativeName']!,
                                        style: TextStyle(fontFamily: 'MyFont2', fontSize: 14, fontWeight: FontWeight.bold,
                                            color: isSelected ? theme.primary : Colors.white),
                                        overflow: TextOverflow.ellipsis),
                                    Text(lang['name']!,
                                        style: const TextStyle(fontFamily: 'MyFont2', fontSize: 11, color: Colors.white38),
                                        overflow: TextOverflow.ellipsis),
                                  ]),
                                ),
                                if (isSelected) Icon(Icons.check_circle_rounded, color: theme.primary, size: 20),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _settingsItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    VoidCallback? onTap,
    required AppThemeData theme,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.07)),
        ),
        child: Row(
          children: [
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(color: iconColor.withOpacity(0.15), borderRadius: BorderRadius.circular(11)),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title,
                    style: const TextStyle(fontFamily: 'MyFont2', fontSize: 15, color: Colors.white70),
                    overflow: TextOverflow.ellipsis),
                if (subtitle != null)
                  Text(subtitle,
                      style: TextStyle(fontFamily: 'MyFont2', fontSize: 12, color: theme.primary),
                      overflow: TextOverflow.ellipsis),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.white24, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _appThemes.current;
    final currentLangInfo = LanguageService.availableLanguages
        .firstWhere((l) => l['code'] == _lang.currentLanguage, orElse: () => LanguageService.availableLanguages.first);

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          Positioned(top: -60, right: -40,
            child: Container(width: 220, height: 220,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [theme.primary.withOpacity(0.08), Colors.transparent])),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Text(_lang.t('settings'),
                      style: const TextStyle(fontSize: 22, fontFamily: 'MyFont2', fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 22),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft, end: Alignment.bottomRight,
                        colors: [theme.cardGradientStart, theme.cardGradientEnd],
                      ),
                      border: Border.all(color: theme.primary.withOpacity(0.18)),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 64, height: 64,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            color: Colors.white.withOpacity(0.06),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Image.asset('assets/images/ApplicationLogo.png', fit: BoxFit.cover),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(_lang.t('app_name'),
                            style: const TextStyle(fontSize: 16, fontFamily: 'MyFont2', fontWeight: FontWeight.bold, color: Colors.white)),
                        const SizedBox(height: 4),
                        Text('${_lang.t('version')} $_version',
                            style: TextStyle(fontSize: 11, color: theme.primary, fontFamily: 'MyFont2')),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Text(_lang.t('parameters'),
                        style: const TextStyle(fontFamily: 'MyFont2', fontSize: 12, color: Colors.white38, letterSpacing: 0.6)),
                    const SizedBox(width: 10),
                    Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.06))),
                  ]),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ListView(
                      children: [
                        _settingsItem(
                          theme: theme,
                          icon: Icons.notifications_outlined,
                          iconColor: theme.primary,
                          title: _lang.t('notifications'),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationsPage())),
                        ),
                        _settingsItem(
                          theme: theme,
                          icon: Icons.language_outlined,
                          iconColor: const Color(0xFFFFD700),
                          title: _lang.t('language'),
                          subtitle: '${currentLangInfo['flag']} ${currentLangInfo['nativeName']}',
                          onTap: () => _showLanguageDialog(theme),
                        ),
                        _settingsItem(
                          theme: theme,
                          icon: Icons.dark_mode_outlined,
                          iconColor: const Color(0xFF5B9BD5),
                          title: _lang.t('theme'),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemePage())),
                        ),
                        _settingsItem(
                          theme: theme,
                          icon: Icons.bug_report_outlined,
                          iconColor: const Color(0xFFFF6B6B),
                          title: _lang.t('report_bug'),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportBugPage())),
                        ),
                        _settingsItem(
                          theme: theme,
                          icon: Icons.mail_outline_rounded,
                          iconColor: const Color(0xFFB39DDB),
                          title: _lang.t('contact'),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ContactPage())),
                        ),
                        _settingsItem(
                          theme: theme,
                          icon: Icons.share_outlined,
                          iconColor: const Color(0xFF80CBC4),
                          title: _lang.t('share_app'),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ShareAppPage())),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}