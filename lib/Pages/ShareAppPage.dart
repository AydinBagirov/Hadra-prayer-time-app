import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:namazvaktim/services/language_service.dart';

class ShareAppPage extends StatefulWidget {
  const ShareAppPage({super.key});

  @override
  State<ShareAppPage> createState() => _ShareAppPageState();
}

class _ShareAppPageState extends State<ShareAppPage> {
  final LanguageService _lang = LanguageService();

  static const String _apkUrl =
      'https://github.com/AydinBagirov/Namaz-Vaxti/releases/tag/v2.5.0';

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLangChanged);
  }

  @override
  void dispose() {
    _lang.removeListener(_onLangChanged);
    super.dispose();
  }

  void _onLangChanged() => setState(() {});

  void _copyLink() {
    Clipboard.setData(const ClipboardData(text: _apkUrl));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_lang.t('share_link_copied'),
            style: const TextStyle(fontFamily: 'MyFont2')),
        backgroundColor: const Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openGitHub() async {
    final uri = Uri.parse(_apkUrl);
    try {
      final launched =
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      if (!launched) {
        await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      }
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    }
  }

  Future<void> _shareViaApps() async {
    final text = '${_lang.t('share_text')}$_apkUrl';
    await Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E1A),
      body: Stack(
        children: [
          Positioned(
            bottom: 60,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFF80CBC4).withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white70, size: 20),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_lang.t('share_title'),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'MyFont2',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(_lang.t('share_subtitle'),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'MyFont2',
                                  color: Colors.white38)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1A3A4A), Color(0xFF0F2235)],
                            ),
                            border: Border.all(
                                color:
                                const Color(0xFF4ECDC4).withOpacity(0.18)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(18),
                                  color: Colors.white.withOpacity(0.06),
                                  border: Border.all(color: Colors.white12),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Image.asset(
                                      'assets/images/ApplicationLogo.png',
                                      fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(_lang.t('app_name'),
                                  style: const TextStyle(
                                      fontFamily: 'MyFont2',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 6),
                              Wrap(
                                spacing: 8,
                                runSpacing: 6,
                                alignment: WrapAlignment.center,
                                children: ['🕌', '🧭', '📅', '🌙']
                                    .map((e) => Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color:
                                    Colors.white.withOpacity(0.06),
                                    borderRadius:
                                    BorderRadius.circular(20),
                                  ),
                                  child: Text(e,
                                      style: const TextStyle(
                                          fontSize: 16)),
                                ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFF80CBC4).withOpacity(0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color:
                                const Color(0xFF80CBC4).withOpacity(0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.07),
                                      borderRadius: BorderRadius.circular(11),
                                    ),
                                    child: const Icon(Icons.code_rounded,
                                        color: Colors.white60, size: 20),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(_lang.t('share_apk_title'),
                                            style: const TextStyle(
                                                fontFamily: 'MyFont2',
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white)),
                                        Text(_lang.t('share_apk_subtitle'),
                                            style: const TextStyle(
                                                fontFamily: 'MyFont2',
                                                fontSize: 11,
                                                color: Colors.white38)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.link_rounded,
                                        color: Color(0xFF4ECDC4), size: 14),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _apkUrl,
                                        style: const TextStyle(
                                            fontFamily: 'MyFont2',
                                            fontSize: 11,
                                            color: Color(0xFF4ECDC4)),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _actionButton(
                                      icon: Icons.copy_rounded,
                                      label: _lang.t('share_apk_copy'),
                                      onTap: _copyLink,
                                      isPrimary: false,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _actionButton(
                                      icon: Icons.open_in_new_rounded,
                                      label: _lang.t('share_apk_open'),
                                      onTap: _openGitHub,
                                      isPrimary: true,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        GestureDetector(
                          onTap: _shareViaApps,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.share_rounded,
                                    color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Text(_lang.t('share_via'),
                                    style: const TextStyle(
                                        fontFamily: 'MyFont2',
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
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

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    required bool isPrimary,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 11),
        decoration: BoxDecoration(
          color: isPrimary
              ? const Color(0xFF4ECDC4).withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary
                ? const Color(0xFF4ECDC4).withOpacity(0.4)
                : Colors.white12,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: isPrimary ? const Color(0xFF4ECDC4) : Colors.white38,
                size: 15),
            const SizedBox(width: 6),
            Text(label,
                style: TextStyle(
                    fontFamily: 'MyFont2',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isPrimary
                        ? const Color(0xFF4ECDC4)
                        : Colors.white38)),
          ],
        ),
      ),
    );
  }
}