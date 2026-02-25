import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:namazvaktim/services/language_service.dart';
import '../services/ezan_service.dart';
import '../services/theme_service.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  bool imsakNotification   = false;
  bool sunriseNotification = false;
  bool dhuhrNotification   = false;
  bool asrNotification     = false;
  bool maghribNotification = false;
  bool ishaNotification    = false;

  String selectedEzan = 'notification';

  // Ezan çalınırmı
  bool _isPlaying = false;

  final LanguageService _lang = LanguageService();
  final AppThemes _appThemes = AppThemes();

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onChanged);
    _appThemes.addListener(_onChanged);
    _loadSettings();
  }

  @override
  void dispose() {
    _lang.removeListener(_onChanged);
    _appThemes.removeListener(_onChanged);
    // Səhifə bağlandıqda ezanı durdur
    if (_isPlaying) EzanService.stopEzan();
    super.dispose();
  }

  void _onChanged() => setState(() {});

  List<Map<String, String>> get ezanSounds => [
    {'id': 'notification', 'name': _lang.t('notification_only')},
    {'id': 'default',      'name': _lang.t('default_ezan')},
  ];

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final status = await Permission.notification.status;
    if (status.isDenied || status.isPermanentlyDenied) {
      setState(() {
        imsakNotification = sunriseNotification = dhuhrNotification =
            asrNotification = maghribNotification = ishaNotification = false;
        selectedEzan = prefs.getString('selectedEzan') ?? 'notification';
      });
      return;
    }
    setState(() {
      imsakNotification   = prefs.getBool('imsakNotification')   ?? false;
      sunriseNotification = prefs.getBool('sunriseNotification') ?? false;
      dhuhrNotification   = prefs.getBool('dhuhrNotification')   ?? false;
      asrNotification     = prefs.getBool('asrNotification')     ?? false;
      maghribNotification = prefs.getBool('maghribNotification') ?? false;
      ishaNotification    = prefs.getBool('ishaNotification')    ?? false;
      selectedEzan        = prefs.getString('selectedEzan')      ?? 'notification';
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('imsakNotification',   imsakNotification);
    await prefs.setBool('sunriseNotification', sunriseNotification);
    await prefs.setBool('dhuhrNotification',   dhuhrNotification);
    await prefs.setBool('asrNotification',     asrNotification);
    await prefs.setBool('maghribNotification', maghribNotification);
    await prefs.setBool('ishaNotification',    ishaNotification);
    await prefs.setBool('imsakEzan',   imsakNotification   && selectedEzan == 'default');
    await prefs.setBool('sunriseEzan', sunriseNotification && selectedEzan == 'default');
    await prefs.setBool('dhuhrEzan',   dhuhrNotification   && selectedEzan == 'default');
    await prefs.setBool('asrEzan',     asrNotification     && selectedEzan == 'default');
    await prefs.setBool('maghribEzan', maghribNotification && selectedEzan == 'default');
    await prefs.setBool('ishaEzan',    ishaNotification    && selectedEzan == 'default');
    await prefs.setString('selectedEzan', selectedEzan);

    if (mounted) {
      final theme = _appThemes.current;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_lang.t('settings_saved'),
              style: const TextStyle(fontFamily: 'MyFont2')),
          backgroundColor: theme.cardGradientStart,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<bool> _ensurePermission() async {
    var status = await Permission.notification.status;
    if (status.isGranted) return true;
    if (status.isPermanentlyDenied) {
      if (mounted) _showPermissionDialog(permanent: true);
      return false;
    }
    status = await Permission.notification.request();
    if (status.isGranted) {
      setState(() {
        imsakNotification = sunriseNotification = dhuhrNotification =
            asrNotification = maghribNotification = ishaNotification = true;
      });
      await _saveSettings();
      return true;
    } else {
      setState(() {
        imsakNotification = sunriseNotification = dhuhrNotification =
            asrNotification = maghribNotification = ishaNotification = false;
      });
      await _saveSettings();
      return false;
    }
  }

  void _showPermissionDialog({bool permanent = false}) {
    final theme = _appThemes.current;
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [theme.cardGradientStart, theme.surface],
            ),
            border: Border.all(color: theme.primary.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: theme.primary.withOpacity(0.08),
                blurRadius: 32,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // İkon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: theme.primary.withOpacity(0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                        color: theme.primary.withOpacity(0.25), width: 1.5),
                  ),
                  child: Icon(
                    permanent
                        ? Icons.settings_outlined
                        : Icons.notifications_outlined,
                    color: theme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 18),

                // Başlıq
                Text(
                  _lang.t('notif_permission_title'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'MyFont2',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),

                // Mətn
                Text(
                  permanent
                      ? _lang.t('notif_permission_permanent')
                      : _lang.t('notif_permission_body'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'MyFont2',
                    fontSize: 13,
                    color: Colors.white54,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                // Düymələr
                if (permanent) ...[
                  // Ayarlara get
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      openAppSettings();
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [theme.primary, theme.accent],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        _lang.t('open_settings'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'MyFont2',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Bağla
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(16),
                        border:
                        Border.all(color: Colors.white.withOpacity(0.10)),
                      ),
                      child: Text(
                        _lang.t('close'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'MyFont2',
                          fontSize: 14,
                          color: Colors.white54,
                        ),
                      ),
                    ),
                  ),
                ] else ...[
                  // Tək "Bağla" düyməsi
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: theme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: theme.primary.withOpacity(0.3)),
                      ),
                      child: Text(
                        _lang.t('close'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'MyFont2',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: theme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Play / Pause toggle ───────────────────────────────────────────
  Future<void> _toggleEzan() async {
    if (_isPlaying) {
      await EzanService.stopEzan();
      setState(() => _isPlaying = false);
    } else {
      await EzanService.playEzan();
      setState(() => _isPlaying = true);
    }
  }

  // ── Namaz switch satırı — sadə, eyni rəng ────────────────────────
  Widget _prayerSwitch({
    required String title,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final theme = _appThemes.current;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: value
            ? theme.primary.withOpacity(0.08)
            : Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: value
              ? theme.primary.withOpacity(0.35)
              : Colors.white.withOpacity(0.07),
          width: value ? 1.3 : 1,
        ),
      ),
      child: Row(
        children: [
          // İkon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: value
                  ? theme.primary.withOpacity(0.16)
                  : Colors.white.withOpacity(0.06),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon,
                color: value ? theme.primary : Colors.white30, size: 18),
          ),
          const SizedBox(width: 12),
          // Ad
          Expanded(
            child: Text(title,
                style: TextStyle(
                    fontFamily: 'MyFont2',
                    fontSize: 14,
                    fontWeight:
                    value ? FontWeight.w600 : FontWeight.w400,
                    color: value ? Colors.white : Colors.white38)),
          ),
          // Switch
          Transform.scale(
            scale: 0.82,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: theme.primary,
              activeTrackColor: theme.primary.withOpacity(0.28),
              inactiveThumbColor: Colors.white24,
              inactiveTrackColor: Colors.white10,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _appThemes.current;
    final isEzanSelected = selectedEzan == 'default';

    return Scaffold(
      backgroundColor: theme.background,
      body: Stack(
        children: [
          Positioned(
            top: -60, right: -40,
            child: Container(
              width: 220, height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  theme.primary.withOpacity(0.08),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // ── Header ──────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 8, 20, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_rounded,
                            color: Colors.white70, size: 20),
                      ),
                      Text(_lang.t('notification_settings'),
                          style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'MyFont2',
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 8),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [

                      // ── Səs seçim kartı ──────────────────────────
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              theme.cardGradientStart,
                              theme.cardGradientEnd,
                            ],
                          ),
                          border: Border.all(
                              color: theme.primary.withOpacity(0.18)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Başlıq
                            Row(children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.volume_up_rounded,
                                    color: theme.primary, size: 20),
                              ),
                              const SizedBox(width: 12),
                              Text(_lang.t('select_ezan'),
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'MyFont2',
                                      color: Colors.white)),
                            ]),
                            const SizedBox(height: 14),

                            // Seçim sıraları
                            ...ezanSounds.map((sound) {
                              final isSelected = selectedEzan == sound['id'];
                              final isEzan = sound['id'] == 'default';
                              return GestureDetector(
                                onTap: () {
                                  // Ezan dəyişərsə çalanı durdur
                                  if (_isPlaying) {
                                    EzanService.stopEzan();
                                    setState(() => _isPlaying = false);
                                  }
                                  setState(() => selectedEzan = sound['id']!);
                                  _saveSettings();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14, vertical: 11),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? theme.primary.withOpacity(0.12)
                                        : Colors.white.withOpacity(0.04),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                        color: isSelected
                                            ? theme.primary.withOpacity(0.4)
                                            : Colors.white12),
                                  ),
                                  child: Row(children: [
                                    Icon(
                                      isSelected
                                          ? Icons.radio_button_checked_rounded
                                          : Icons.radio_button_off_rounded,
                                      color: isSelected
                                          ? theme.primary
                                          : Colors.white24,
                                      size: 18,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(sound['name']!,
                                          style: TextStyle(
                                              fontFamily: 'MyFont2',
                                              fontSize: 13,
                                              color: isSelected
                                                  ? Colors.white
                                                  : Colors.white54)),
                                    ),

                                    // Yalnız ezan seçilisə — Dinlə/Durdur düyməsi
                                    if (isEzan && isSelected)
                                      GestureDetector(
                                        onTap: _toggleEzan,
                                        child: AnimatedContainer(
                                          duration: const Duration(
                                              milliseconds: 200),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: _isPlaying
                                                ? const Color(0xFFFF6B6B)
                                                .withOpacity(0.15)
                                                : theme.primary
                                                .withOpacity(0.15),
                                            borderRadius:
                                            BorderRadius.circular(20),
                                            border: Border.all(
                                              color: _isPlaying
                                                  ? const Color(0xFFFF6B6B)
                                                  .withOpacity(0.4)
                                                  : theme.primary
                                                  .withOpacity(0.35),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                _isPlaying
                                                    ? Icons.pause_rounded
                                                    : Icons.play_arrow_rounded,
                                                color: _isPlaying
                                                    ? const Color(0xFFFF6B6B)
                                                    : theme.primary,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                _isPlaying
                                                    ? _lang.t('stop')
                                                    : _lang.t('listen'),
                                                style: TextStyle(
                                                  fontFamily: 'MyFont2',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: _isPlaying
                                                      ? const Color(0xFFFF6B6B)
                                                      : theme.primary,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                  ]),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      // ── Namaz vaxtları bölmə başlığı ─────────────
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(children: [
                          Text(_lang.t('prayer_times_section'),
                              style: const TextStyle(
                                  fontFamily: 'MyFont2',
                                  fontSize: 12,
                                  color: Colors.white38,
                                  letterSpacing: 0.6)),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Container(
                                  height: 1,
                                  color: Colors.white.withOpacity(0.06))),
                        ]),
                      ),

                      // ── Namaz switchləri — eyni tema rəngi ───────
                      _prayerSwitch(
                        title: _lang.t('imsak'),
                        icon: Icons.nights_stay_rounded,
                        value: imsakNotification,
                        onChanged: (v) async {
                          if (v) { final ok = await _ensurePermission(); if (!ok) return; }
                          setState(() => imsakNotification = v);
                          _saveSettings();
                        },
                      ),
                      _prayerSwitch(
                        title: _lang.t('sunrise'),
                        icon: Icons.wb_twilight_rounded,
                        value: sunriseNotification,
                        onChanged: (v) async {
                          if (v) { final ok = await _ensurePermission(); if (!ok) return; }
                          setState(() => sunriseNotification = v);
                          _saveSettings();
                        },
                      ),
                      _prayerSwitch(
                        title: _lang.t('dhuhr'),
                        icon: Icons.wb_sunny,
                        value: dhuhrNotification,
                        onChanged: (v) async {
                          if (v) { final ok = await _ensurePermission(); if (!ok) return; }
                          setState(() => dhuhrNotification = v);
                          _saveSettings();
                        },
                      ),
                      _prayerSwitch(
                        title: _lang.t('asr'),
                        icon: Icons.cloud_queue_rounded,
                        value: asrNotification,
                        onChanged: (v) async {
                          if (v) { final ok = await _ensurePermission(); if (!ok) return; }
                          setState(() => asrNotification = v);
                          _saveSettings();
                        },
                      ),
                      _prayerSwitch(
                        title: _lang.t('maghrib'),
                        icon: Icons.nightlight_round_sharp,
                        value: maghribNotification,
                        onChanged: (v) async {
                          if (v) { final ok = await _ensurePermission(); if (!ok) return; }
                          setState(() => maghribNotification = v);
                          _saveSettings();
                        },
                      ),
                      _prayerSwitch(
                        title: _lang.t('isha'),
                        icon: Icons.nights_stay,
                        value: ishaNotification,
                        onChanged: (v) async {
                          if (v) { final ok = await _ensurePermission(); if (!ok) return; }
                          setState(() => ishaNotification = v);
                          _saveSettings();
                        },
                      ),

                      const SizedBox(height: 16),

                      // ── Hamısını aç / kapat ───────────────────────
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final ok = await _ensurePermission();
                                if (!ok) return;
                                setState(() {
                                  imsakNotification =
                                      sunriseNotification =
                                      dhuhrNotification =
                                      asrNotification =
                                      maghribNotification =
                                      ishaNotification = true;
                                });
                                _saveSettings();
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color: theme.primary.withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: theme.primary.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.notifications_active_outlined,
                                        color: theme.primary, size: 18),
                                    const SizedBox(width: 8),
                                    Text(_lang.t('enable_all'),
                                        style: TextStyle(
                                            fontFamily: 'MyFont2',
                                            color: theme.primary,
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  imsakNotification =
                                      sunriseNotification =
                                      dhuhrNotification =
                                      asrNotification =
                                      maghribNotification =
                                      ishaNotification = false;
                                });
                                _saveSettings();
                              },
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 13),
                                decoration: BoxDecoration(
                                  color:
                                  const Color(0xFFFF6B6B).withOpacity(0.10),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                      color: const Color(0xFFFF6B6B)
                                          .withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.notifications_off_outlined,
                                        color: Color(0xFFFF6B6B), size: 18),
                                    const SizedBox(width: 8),
                                    Text(_lang.t('disable_all'),
                                        style: const TextStyle(
                                            fontFamily: 'MyFont2',
                                            color: Color(0xFFFF6B6B),
                                            fontSize: 13)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),
                    ],
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