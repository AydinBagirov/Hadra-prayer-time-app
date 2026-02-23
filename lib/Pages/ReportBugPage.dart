import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:namazvaktim/services/language_service.dart';

class ReportBugPage extends StatefulWidget {
  const ReportBugPage({super.key});

  @override
  State<ReportBugPage> createState() => _ReportBugPageState();
}

class _ReportBugPageState extends State<ReportBugPage> {
  final LanguageService _lang = LanguageService();
  final TextEditingController _descController = TextEditingController();
  bool _sending = false;
  String? _resultMsg;
  bool _success = false;
  String _version = '';


  static const String _supportEmail = 'aydinbagirov219@gmail.com';

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLangChanged);
    _loadVersion();
  }

  @override
  void dispose() {
    _lang.removeListener(_onLangChanged);
    _descController.dispose();
    super.dispose();
  }

  void _onLangChanged() => setState(() {});

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    setState(() => _version = '${info.version} (${info.buildNumber})');
  }

  Future<void> _sendReport() async {
    final desc = _descController.text.trim();
    if (desc.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.t('bug_empty'),
              style: const TextStyle(fontFamily: 'MyFont2')),
          backgroundColor: const Color(0xFFFF6B6B),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _sending = true);

    final subject = Uri.encodeComponent('[Bug Report] Namaz Vaxtı');
    final body = Uri.encodeComponent(
      'Xəta təsviri:\n$desc\n\n'
          '---\nVersiya: $_version\nDil: ${_lang.currentLanguage}',
    );
    final uri = Uri.parse('mailto:$_supportEmail?subject=$subject&body=$body');

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        setState(() {
          _success = true;
          _resultMsg = _lang.t('bug_sent_ok');
          _sending = false;
        });
        _descController.clear();
      } else {
        setState(() {
          _success = false;
          _resultMsg = _lang.t('bug_sent_fail');
          _sending = false;
        });
      }
    } catch (e) {
      setState(() {
        _success = false;
        _resultMsg = _lang.t('bug_sent_fail');
        _sending = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080E1A),
      body: Stack(
        children: [
          Positioned(
            top: -50, right: -40,
            child: Container(
              width: 180, height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xFFFF6B6B).withOpacity(0.08),
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
                          Text(_lang.t('bug_title'),
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: 'MyFont2',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                          Text(_lang.t('bug_subtitle'),
                              style: const TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'MyFont2',
                                  color: Colors.white38)),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6B6B).withOpacity(0.07),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: const Color(0xFFFF6B6B).withOpacity(0.2)),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 48, height: 48,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF6B6B).withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.bug_report_rounded,
                                    color: Color(0xFFFF6B6B), size: 26),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(_lang.t('bug_title'),
                                        style: const TextStyle(
                                            fontFamily: 'MyFont2',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFFF6B6B))),
                                    const SizedBox(height: 4),
                                    Text(_lang.t('bug_device_info'),
                                        style: const TextStyle(
                                            fontFamily: 'MyFont2',
                                            fontSize: 11,
                                            color: Colors.white38)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),


                        Text(_lang.t('bug_desc_label'),
                            style: const TextStyle(
                                fontFamily: 'MyFont2',
                                fontSize: 13,
                                color: Colors.white60)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: TextField(
                            controller: _descController,
                            maxLines: 6,
                            style: const TextStyle(
                                fontFamily: 'MyFont2',
                                fontSize: 14,
                                color: Colors.white),
                            decoration: InputDecoration(
                              hintText: _lang.t('bug_desc_hint'),
                              hintStyle: const TextStyle(
                                  fontFamily: 'MyFont2',
                                  fontSize: 13,
                                  color: Colors.white24),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16),
                            ),
                          ),
                        ),

                        const SizedBox(height: 8),


                        Row(
                          children: [
                            const Icon(Icons.info_outline_rounded,
                                color: Colors.white24, size: 14),
                            const SizedBox(width: 6),
                            Text('$_version  ·  ${_lang.currentLanguage.toUpperCase()}',
                                style: const TextStyle(
                                    fontFamily: 'MyFont2',
                                    fontSize: 11,
                                    color: Colors.white24)),
                          ],
                        ),

                        const SizedBox(height: 24),


                        SizedBox(
                          width: double.infinity,
                          child: GestureDetector(
                            onTap: _sending ? null : _sendReport,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: _sending
                                      ? [Colors.white12, Colors.white12]
                                      : [
                                    const Color(0xFFFF6B6B),
                                    const Color(0xFFFF8E53),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: _sending
                                    ? const SizedBox(
                                    width: 20, height: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white))
                                    : Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.send_rounded,
                                        color: Colors.white, size: 18),
                                    const SizedBox(width: 8),
                                    Text(_lang.t('bug_send'),
                                        style: const TextStyle(
                                            fontFamily: 'MyFont2',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),


                        if (_resultMsg != null) ...[
                          const SizedBox(height: 16),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: _success
                                  ? const Color(0xFF4ECDC4).withOpacity(0.1)
                                  : const Color(0xFFFF6B6B).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _success
                                    ? const Color(0xFF4ECDC4).withOpacity(0.3)
                                    : const Color(0xFFFF6B6B).withOpacity(0.3),
                              ),
                            ),
                            child: Text(_resultMsg!,
                                style: TextStyle(
                                    fontFamily: 'MyFont2',
                                    fontSize: 13,
                                    color: _success
                                        ? const Color(0xFF4ECDC4)
                                        : const Color(0xFFFF6B6B))),
                          ),
                        ],

                        const SizedBox(height: 30),
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