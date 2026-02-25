import 'package:flutter/material.dart';
import 'package:namazvaktim/services/language_service.dart';
import '../services/theme_service.dart';

class DaysPage extends StatefulWidget {
  const DaysPage({super.key});

  @override
  State<DaysPage> createState() => _DaysPageState();
}

class _DaysPageState extends State<DaysPage> {
  bool _isMiladi = true;
  final LanguageService _lang = LanguageService();
  final AppThemes _appThemes = AppThemes();

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

  String _getDayName(String azDay) {
    final azDays = [
      'Bazar ertəsi', 'Çərşənbə ax.', 'Çərşənbə',
      'Cümə axşamı', 'Cümə', 'Şənbə', 'Bazar'
    ];
    final azDaysOld = [
      'Bazarertəsi', 'Çərşənbə axşamı', 'Çərşənbə',
      'Cümə axşamı', 'Cümə', 'Şənbə', 'Bazar'
    ];
    int idx = azDays.indexOf(azDay);
    if (idx == -1) idx = azDaysOld.indexOf(azDay);
    if (idx == -1) return azDay;
    return _lang.t('day_${idx + 1}');
  }

  String _getMiladiMonthName(String azMonth) {
    const azMonths = [
      'Yanvar', 'Fevral', 'Mart', 'Aprel', 'May', 'İyun',
      'İyul', 'Avqust', 'Sentyabr', 'Oktyabr', 'Noyabr', 'Dekabr'
    ];
    final idx = azMonths.indexOf(azMonth);
    if (idx == -1) return azMonth;
    return _lang.t('month_${idx + 1}');
  }

  String _translateMiladiDate(String miladiDate) {
    final parts = miladiDate.split(' ');
    if (parts.length < 3) return miladiDate;
    final day = parts[0];
    final month = _getMiladiMonthName(parts[1]);
    final year = parts[2];
    return '$day $month $year';
  }

  String _translateHijriDate(String hijriDate) {
    final parts = hijriDate.split(' ');
    if (parts.length < 3) return hijriDate;
    final day = parts[0];
    final azHijriMonths = [
      'Məhərrəm', 'Səfər', 'Rəbiüləvvəl', 'Rəbiülaxır',
      'Cəmadiyələvvəl', 'Cəmadiyəlaxır', 'Rəcəb', 'Şaban',
      'Ramazan', 'Şəvval', 'Zilqədə', 'Zilhiccə',
    ];
    final idx = azHijriMonths.indexOf(parts[1]);
    final monthName = idx != -1 ? _lang.t('hijri_${idx + 1}') : parts[1];
    final year = parts[2];
    return '$day $monthName $year';
  }

  Widget _toggleWidget(AppThemeData theme) {
    return GestureDetector(
      onTap: () => setState(() => _isMiladi = !_isMiladi),
      child: Container(
        height: 36, width: 140,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        child: Stack(
          children: [
            AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: _isMiladi ? Alignment.centerLeft : Alignment.centerRight,
              child: Container(
                width: 70, height: 36,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: theme.primary.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: theme.primary.withOpacity(0.5)),
                ),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Text(_lang.t('miladi'),
                        style: TextStyle(
                            fontFamily: 'MyFont2', fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: _isMiladi ? theme.primary : Colors.white38)),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(_lang.t('hijri'),
                        style: TextStyle(
                            fontFamily: 'MyFont2', fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: !_isMiladi ? theme.primary : Colors.white38)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _diniGunCard(AppThemeData theme, String adAz, String gunAz, String hicriAz, String miladiAz) {
    final translatedDay = _getDayName(gunAz);
    final translatedMiladi = _translateMiladiDate(miladiAz);
    final translatedHijri = _translateHijriDate(hicriAz);
    final dateText = _isMiladi ? translatedMiladi : translatedHijri;

    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.07)),
      ),
      child: Row(
        children: [
          Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: theme.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
              border: Border.all(color: theme.primary.withOpacity(0.2)),
            ),
            child: Icon(Icons.nightlight_round_sharp, color: theme.primary, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(adAz,
                    style: const TextStyle(
                        fontFamily: 'MyFont2', fontSize: 14,
                        fontWeight: FontWeight.w600, color: Colors.white),
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Flexible(
                      child: Text(translatedDay,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontFamily: 'MyFont2', fontSize: 12, color: Colors.white38)),
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 3, height: 3,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.white24),
                    ),
                    Flexible(
                      child: Text(dateText,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontFamily: 'MyFont2', fontSize: 12,
                              color: theme.primary, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = _appThemes.current;

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
          Positioned(bottom: 80, left: -60,
            child: Container(width: 160, height: 160,
              decoration: BoxDecoration(shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [theme.accent.withOpacity(0.06), Colors.transparent])),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_lang.t('religious_days'),
                            style: const TextStyle(
                                fontSize: 20, fontFamily: 'MyFont2',
                                fontWeight: FontWeight.bold, color: Colors.white),
                            overflow: TextOverflow.ellipsis),
                      ),
                      const SizedBox(width: 8),
                      _toggleWidget(theme),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    Text(_lang.t('year_range'),
                        style: const TextStyle(
                            fontFamily: 'MyFont2', fontSize: 12,
                            color: Colors.white38, letterSpacing: 0.6)),
                    const SizedBox(width: 10),
                    Expanded(child: Container(height: 1, color: Colors.white.withOpacity(0.06))),
                  ]),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.only(bottom: 24),
                    children: [
                      _diniGunCard(theme, _lang.t('hd_mirac'), "Cümə axşamı", "26 Rəcəb 1447", "15 Yanvar 2026"),
                      _diniGunCard(theme, _lang.t('hd_berat'), "Bazarertəsi", "14 Şaban 1447", "2 Fevral 2026"),
                      _diniGunCard(theme, _lang.t('hd_ramazan_start'), "Cümə axşamı", "1 Ramazan 1447", "19 Fevral 2026"),
                      _diniGunCard(theme, _lang.t('hd_qadr'), "Bazarertəsi", "26 Ramazan 1447", "16 Mart 2026"),
                      _diniGunCard(theme, _lang.t('hd_eid_fitr_1'), "Cümə", "1 Şəvval 1447", "20 Mart 2026"),
                      _diniGunCard(theme, _lang.t('hd_eid_fitr_2'), "Şənbə", "2 Şəvval 1447", "21 Mart 2026"),
                      _diniGunCard(theme, _lang.t('hd_eid_fitr_3'), "Bazar", "3 Şəvval 1447", "22 Mart 2026"),
                      _diniGunCard(theme, _lang.t('hd_terviye'), "Bazarertəsi", "8 Zilhiccə 1447", "25 May 2026"),
                      _diniGunCard(theme, _lang.t('hd_arefe'), "Çərşənbə axşamı", "9 Zilhiccə 1447", "26 May 2026"),
                      _diniGunCard(theme, _lang.t('hd_eid_adha_1'), "Çərşənbə", "10 Zilhiccə 1447", "27 May 2026"),
                      _diniGunCard(theme, _lang.t('hd_eid_adha_2'), "Cümə axşamı", "11 Zilhiccə 1447", "28 May 2026"),
                      _diniGunCard(theme, _lang.t('hd_eid_adha_3'), "Cümə", "12 Zilhiccə 1447", "29 May 2026"),
                      _diniGunCard(theme, _lang.t('hd_eid_adha_4'), "Şənbə", "13 Zilhiccə 1447", "30 May 2026"),
                      _diniGunCard(theme, _lang.t('hd_hijri_new_year'), "Çərşənbə axşamı", "1 Muharrəm 1448", "16 İyun 2026"),
                      _diniGunCard(theme, _lang.t('hd_ashura'), "Cümə axşamı", "10 Muharrəm 1448", "25 İyun 2026"),
                      _diniGunCard(theme, _lang.t('hd_mawlid'), "Bazarertəsi", "11 Rəbüiləvvəl 1448", "24 Avqust 2026"),
                      _diniGunCard(theme, _lang.t('hd_three_months'), "Cümə axşamı", "1 Rəcəb 1448", "10 Dekabr 2026"),
                      _diniGunCard(theme, _lang.t('hd_ragaib'), "Cümə axşamı", "1 Rəcəb 1448", "10 Dekabr 2026"),
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