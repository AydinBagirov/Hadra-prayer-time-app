import 'package:flutter/material.dart';
import 'package:namazvaktim/services/language_service.dart';
import '../services/theme_service.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> with TickerProviderStateMixin {
  final LanguageService _lang = LanguageService();
  final AppThemes _appThemes = AppThemes();
  String _selectedId = AppThemes().currentId;

  late AnimationController _previewController;
  late Animation<double> _previewAnim;

  final Map<String, String> _themeNames = {
    'ocean': 'Ocean',
    'desert': 'Desert',
    'emerald': 'Emerald',
    'royal': 'Royal',
    'crimson': 'Crimson',
    'silver': 'Silver',
  };

  @override
  void initState() {
    super.initState();
    _lang.addListener(_onLangChanged);
    _previewController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _previewAnim = CurvedAnimation(
      parent: _previewController,
      curve: Curves.easeOutCubic,
    );
    _previewController.forward();
  }

  @override
  void dispose() {
    _lang.removeListener(_onLangChanged);
    _previewController.dispose();
    super.dispose();
  }

  void _onLangChanged() => setState(() {});

  void _selectTheme(String id) async {
    setState(() => _selectedId = id);
    _previewController.reset();
    _previewController.forward();
    await _appThemes.saveTheme(id);
  }

  AppThemeData get _current => AppThemes.getById(_selectedId);

  @override
  Widget build(BuildContext context) {
    final t = _current;
    return Scaffold(
      backgroundColor: t.background,
      body: Stack(
        children: [
          Positioned(
            top: -80, right: -60,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              width: 280, height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  t.primary.withOpacity(0.12),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -60, left: -40,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  t.accent.withOpacity(0.08),
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
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.06),
                            borderRadius: BorderRadius.circular(11),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              color: Colors.white70, size: 16),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Text(
                        _lang.t('theme'),
                        style: const TextStyle(
                          fontSize: 22,
                          fontFamily: 'MyFont2',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: FadeTransition(
                    opacity: _previewAnim,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.05),
                        end: Offset.zero,
                      ).animate(_previewAnim),
                      child: _buildPreviewCard(),
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    const Text(
                      'THEMES',
                      style: TextStyle(
                        fontFamily: 'MyFont2',
                        fontSize: 11,
                        color: Colors.white38,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Container(height: 1,
                            color: Colors.white.withOpacity(0.06))),
                  ]),
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GridView.builder(
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: AppThemes.themes.length,
                      itemBuilder: (context, index) {
                        final theme = AppThemes.themes[index];
                        return _ThemeCard(
                          theme: theme,
                          name: _themeNames[theme.id] ?? theme.id,
                          isSelected: _selectedId == theme.id,
                          onTap: () => _selectTheme(theme.id),
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewCard() {
    final theme = _current;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [theme.cardGradientStart, theme.cardGradientEnd],
        ),
        border: Border.all(color: theme.primary.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: theme.primary.withOpacity(0.15), blurRadius: 30),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(width: 8, height: 8,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: theme.primary)),
              const SizedBox(width: 8),
              Text(
                _lang.t('prayer_times'),
                style: TextStyle(
                    fontFamily: 'MyFont2', fontSize: 12,
                    color: theme.primary, letterSpacing: 0.5),
              ),
              const Spacer(),
              Text(
                _themeNames[_selectedId] ?? '',
                style: TextStyle(
                    fontFamily: 'MyFont2', fontSize: 11,
                    color: theme.accent.withOpacity(0.7)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...['Imsak', _lang.t('dhuhr'), _lang.t('maghrib')]
              .asMap()
              .entries
              .map((e) {
            final isHighlighted = e.key == 1;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isHighlighted
                      ? theme.primary.withOpacity(0.15)
                      : Colors.white.withOpacity(0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isHighlighted
                        ? theme.primary.withOpacity(0.4)
                        : Colors.white.withOpacity(0.06),
                  ),
                ),
                child: Row(
                  children: [
                    Text(e.value,
                        style: TextStyle(
                            fontFamily: 'MyFont2',
                            fontSize: 13,
                            color: isHighlighted
                                ? theme.primary
                                : Colors.white60,
                            fontWeight: isHighlighted
                                ? FontWeight.bold
                                : FontWeight.normal)),
                    const Spacer(),
                    Text(
                        e.key == 0
                            ? '05:42'
                            : e.key == 1
                            ? '12:30'
                            : '19:15',
                        style: TextStyle(
                            fontFamily: 'MyFont2',
                            fontSize: 13,
                            color: isHighlighted
                                ? theme.accent
                                : Colors.white38,
                            fontWeight: isHighlighted
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatefulWidget {
  final AppThemeData theme;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeCard({
    required this.theme,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_ThemeCard> createState() => _ThemeCardState();
}

class _ThemeCardState extends State<_ThemeCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 150));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.96).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) =>
            Transform.scale(scale: _scaleAnim.value, child: child),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [t.cardGradientStart, t.cardGradientEnd],
            ),
            border: Border.all(
              color: widget.isSelected
                  ? t.primary.withOpacity(0.7)
                  : Colors.white.withOpacity(0.07),
              width: widget.isSelected ? 2 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
              BoxShadow(
                  color: t.primary.withOpacity(0.25),
                  blurRadius: 16)
            ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _ColorDot(color: t.primary, size: 22),
                  const SizedBox(width: 6),
                  _ColorDot(color: t.accent, size: 16),
                  const SizedBox(width: 6),
                  _ColorDot(
                      color: t.background, size: 12, hasBorder: true),
                ],
              ),
              const SizedBox(height: 12),
              Text(widget.name,
                  style: TextStyle(
                      fontFamily: 'MyFont2',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: widget.isSelected
                          ? t.primary
                          : Colors.white60)),
              const SizedBox(height: 6),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: widget.isSelected ? 20 : 0,
                height: 2,
                decoration: BoxDecoration(
                    color: t.primary,
                    borderRadius: BorderRadius.circular(2)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  final Color color;
  final double size;
  final bool hasBorder;

  const _ColorDot(
      {required this.color, required this.size, this.hasBorder = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border:
        hasBorder ? Border.all(color: Colors.white24, width: 1) : null,
      ),
    );
  }
}