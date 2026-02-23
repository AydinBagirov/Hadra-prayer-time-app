import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:namazvaktim/services/language_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final LanguageService _lang = LanguageService();

  static const String _email = 'aydinbagirov219@gmail.com';
  static const String _instagramHandle = 'AYDIN BAĞIROV';
  static const String _instagramUsername = 'aydin_hakkani';
  static const String _instagramUrl = 'https://instagram.com/aydin_hakkani';

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

  void _copyToClipboard(String text, String message) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(fontFamily: 'MyFont2')),
        backgroundColor: const Color(0xFF4ECDC4),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _openEmail() async {
    final uri = Uri(scheme: 'mailto', path: _email);
    try {
      await launchUrl(uri);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.t('contact_email_error'),
              style: const TextStyle(fontFamily: 'MyFont2')),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _openInstagram() async {
    final appUri = Uri.parse('instagram://user?username=aydin_hakkani');
    final webUri = Uri.parse(_instagramUrl);
    try {
      final launched = await launchUrl(appUri,
          mode: LaunchMode.externalNonBrowserApplication);
      if (!launched) {
        await launchUrl(webUri, mode: LaunchMode.inAppBrowserView);
      }
    } catch (_) {
      try {
        await launchUrl(webUri, mode: LaunchMode.inAppBrowserView);
      } catch (_) {
        await launchUrl(webUri, mode: LaunchMode.platformDefault);
      }
    }
  }

  Widget _contactCard({
    required Widget iconWidget,
    required Color color,
    required String label,
    required String value,
    required VoidCallback onOpen,
    required VoidCallback onCopy,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Center(child: iconWidget),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontFamily: 'MyFont2',
                        fontSize: 11,
                        color: Colors.white38)),
                const SizedBox(height: 2),
                Text(value,
                    style: TextStyle(
                        fontFamily: 'MyFont2',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: color),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          GestureDetector(
            onTap: onCopy,
            child: Container(
              width: 36,
              height: 36,
              margin: const EdgeInsets.only(right: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.copy_rounded,
                  color: Colors.white38, size: 16),
            ),
          ),
          GestureDetector(
            onTap: onOpen,
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.open_in_new_rounded, color: color, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E1A),
      body: Stack(
        children: [
          Positioned(
            top: -50,
            left: -40,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFDD2A7B).withOpacity(0.07),
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
                          Text(_lang.t('contact_title'),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'MyFont2',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(_lang.t('contact_subtitle'),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'MyFont2',
                                  color: Colors.white38)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 28),
                          margin: const EdgeInsets.only(bottom: 28),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF1A2A3A), Color(0xFF0F1E2E)],
                            ),
                            border: Border.all(
                                color:
                                const Color(0xFFDD2A7B).withOpacity(0.2)),
                          ),
                          child: Column(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFF58529),
                                      Color(0xFFDD2A7B),
                                      Color(0xFF8134AF),
                                    ],
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset('assets/images/AppLogo.png',
                                    fit: BoxFit.cover),
                              ),
                              const SizedBox(height: 12),
                              Text(_instagramHandle,
                                  style: const TextStyle(
                                      fontFamily: 'MyFont2',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
                              const SizedBox(height: 4),
                              Text(_lang.t('contact_subtitle'),
                                  style: const TextStyle(
                                      fontFamily: 'MyFont2',
                                      fontSize: 12,
                                      color: Colors.white38)),
                            ],
                          ),
                        ),
                        _contactCard(
                          iconWidget: const Icon(Icons.email_rounded,
                              color: Color(0xFF4ECDC4), size: 22),
                          color: const Color(0xFF4ECDC4),
                          label: _lang.t('contact_email'),
                          value: _email,
                          onCopy: () => _copyToClipboard(
                              _email, _lang.t('contact_email_copy')),
                          onOpen: _openEmail,
                        ),
                        _contactCard(
                          iconWidget: ShaderMask(
                            shaderCallback: (bounds) => const LinearGradient(
                              colors: [
                                Color(0xFFF58529),
                                Color(0xFFFFFFFF),
                                Color(0xFF8134AF),
                              ],
                              begin: Alignment.bottomLeft,
                              end: Alignment.topRight,
                            ).createShader(bounds),
                            child: Image.asset('assets/images/instagramlogo.jpg',
                                width: 39, height: 39),
                          ),
                          color: const Color(0xFFDD2A7B),
                          label: 'Instagram',
                          value: _instagramUsername,
                          onCopy: () => _copyToClipboard(
                              _instagramUsername, _lang.t('contact_email_copy')),
                          onOpen: _openInstagram,
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