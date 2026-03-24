import 'dart:async';
import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cv_data.dart';
import 'pdf_generator.dart';

// ─── THEME PROVIDER ───────────────────────────────────────────────────────────

class _CVTheme extends InheritedWidget {
  final bool isDark;
  const _CVTheme({required this.isDark, required super.child});
  static bool of(BuildContext ctx) =>
      ctx.dependOnInheritedWidgetOfExactType<_CVTheme>()!.isDark;
  @override
  bool updateShouldNotify(_CVTheme old) => isDark != old.isDark;
}

// ─── COLORS ───────────────────────────────────────────────────────────────────

const _accent = Color(0xFF7C6FF7);
const _accentGreen = Color(0xFF00D4AA);

Color _cardBg(BuildContext ctx) =>
    _CVTheme.of(ctx) ? const Color(0xFF14141E) : Colors.white;
Color _surfaceBg(BuildContext ctx) =>
    _CVTheme.of(ctx) ? const Color(0xFF0A0A0F) : const Color(0xFFF4F4FA);
Color _textPrimary(BuildContext ctx) =>
    _CVTheme.of(ctx) ? const Color(0xFFF0F0F8) : const Color(0xFF0D0D1A);
Color _textSecondary(BuildContext ctx) =>
    _CVTheme.of(ctx) ? const Color(0xFF8B8BA0) : const Color(0xFF6B6B85);
Color _borderClr(BuildContext ctx) =>
    _CVTheme.of(ctx) ? const Color(0xFF22223A) : const Color(0xFFE0E0EE);

// ─── CV PAGE ──────────────────────────────────────────────────────────────────

class CVPage extends StatefulWidget {
  final bool isSlovak;
  final bool isDark;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const CVPage({
    super.key,
    required this.isSlovak,
    required this.isDark,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  State<CVPage> createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;
  late ScrollController _scrollCtrl;
  final _scrollProgress = ValueNotifier<double>(0);

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
    _scrollCtrl = ScrollController()
      ..addListener(() {
        final max = _scrollCtrl.position.maxScrollExtent;
        if (max > 0) _scrollProgress.value = _scrollCtrl.offset / max;
      });
  }

  @override
  void didUpdateWidget(CVPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSlovak != widget.isSlovak ||
        oldWidget.isDark != widget.isDark) {
      _fadeCtrl.reset();
      _fadeCtrl.forward();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _scrollCtrl.dispose();
    _scrollProgress.dispose();
    super.dispose();
  }

  Future<void> _printPdf() async {
    final cv = widget.isSlovak ? cvSK : cvEN;
    await generateAndPrintCV(cv);
  }

  @override
  Widget build(BuildContext context) {
    final cv = widget.isSlovak ? cvSK : cvEN;
    final isWide = MediaQuery.of(context).size.width > 900;

    return _CVTheme(
      isDark: widget.isDark,
      child: Builder(builder: (context) => Scaffold(
        backgroundColor: _surfaceBg(context),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(painter: _BgPainter(isDark: widget.isDark)),
              ),
              CustomScrollView(
                controller: _scrollCtrl,
                slivers: [
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1100),
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            isWide ? 48 : 20, 48, isWide ? 48 : 20, 40,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              _HeroSection(cv: cv, isSlovak: widget.isSlovak),
                              const SizedBox(height: 48),
                              if (isWide) ...[
                                // ── Zóna 1: hlavné 2 stĺpce ──
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(children: [
                                        _ProjectsSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _ExperienceSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _EducationSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _SocialSection(cv: cv),
                                      ]),
                                    ),
                                    const SizedBox(width: 32),
                                    SizedBox(
                                      width: 320,
                                      child: Column(children: [
                                        _TechStackSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _LanguagesSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _InterestsSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _SoftSkillsSection(cv: cv),
                                      ]),
                                    ),
                                  ],
                                ),
                                // ── Zóna 2: spodný pás cez celú šírku ──
                                const SizedBox(height: 32),
                                _BottomStrip(cv: cv),
                              ] else
                                Column(children: [
                                  _ProjectsSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _TechStackSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _ExperienceSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _EducationSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _SocialSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _LanguagesSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _InterestsSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _SoftSkillsSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _VolunteeringSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _CertificatesSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _ReferencesSection(cv: cv),
                                ]),
                              const SizedBox(height: 48),
                              Center(child: _DownloadButton(isSlovak: widget.isSlovak, onPrint: _printPdf)),
                              const SizedBox(height: 32),
                              _Footer(isSlovak: widget.isSlovak),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              _TopControls(
                isSlovak: widget.isSlovak,
                isDark: widget.isDark,
                onToggleLanguage: widget.onToggleLanguage,
                onToggleTheme: widget.onToggleTheme,
              ),
              // ── Scroll progress bar — on top of everything ──
              Positioned(
                top: 0, left: 0, right: 0,
                child: ValueListenableBuilder<double>(
                  valueListenable: _scrollProgress,
                  builder: (_, progress, __) => SizedBox(
                    height: 3,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: FractionallySizedBox(
                        widthFactor: progress,
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [_accent, _accentGreen]),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      )),
    );
  }
}

// ─── BACKGROUND PAINTER ───────────────────────────────────────────────────────

class _BgPainter extends CustomPainter {
  final bool isDark;
  const _BgPainter({required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()..style = PaintingStyle.fill;
    p.color = const Color(0xFF7C6FF7).withOpacity(isDark ? 0.04 : 0.06);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.1), 380, p);
    p.color = const Color(0xFF00D4AA).withOpacity(isDark ? 0.03 : 0.05);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.6), 300, p);
    p.color = const Color(0xFF7C6FF7).withOpacity(isDark ? 0.03 : 0.04);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.9), 250, p);
  }

  @override
  bool shouldRepaint(_BgPainter old) => old.isDark != isDark;
}

// ─── TOP CONTROLS ─────────────────────────────────────────────────────────────

class _TopControls extends StatelessWidget {
  final bool isSlovak;
  final bool isDark;
  final VoidCallback onToggleLanguage;
  final VoidCallback onToggleTheme;

  const _TopControls({
    required this.isSlovak,
    required this.isDark,
    required this.onToggleLanguage,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16, right: 16,
      child: Row(
        children: [
          // Theme toggle
          GestureDetector(
            onTap: onToggleTheme,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _cardBg(context),
                  shape: BoxShape.circle,
                  border: Border.all(color: _borderClr(context)),
                  boxShadow: [
                    BoxShadow(color: _accent.withOpacity(0.12), blurRadius: 16),
                  ],
                ),
                child: Icon(
                  isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: isDark ? const Color(0xFFFACC15) : _accent,
                  size: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Language toggle
          GestureDetector(
            onTap: onToggleLanguage,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  color: _cardBg(context),
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(color: _borderClr(context)),
                  boxShadow: [
                    BoxShadow(color: _accent.withOpacity(0.12), blurRadius: 16),
                  ],
                ),
                padding: const EdgeInsets.all(4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _LangBtn(label: 'SK', flag: '🇸🇰', active: isSlovak),
                    const SizedBox(width: 4),
                    _LangBtn(label: 'EN', flag: '🇬🇧', active: !isSlovak),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LangBtn extends StatelessWidget {
  final String label;
  final String flag;
  final bool active;
  const _LangBtn({required this.label, required this.flag, required this.active});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: active ? _accent : Colors.transparent,
        borderRadius: BorderRadius.circular(46),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(flag, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 6),
          Text(label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: active ? Colors.white : _textSecondary(context),
                letterSpacing: 0.5,
              )),
        ],
      ),
    );
  }
}

// ─── TYPING TEXT ──────────────────────────────────────────────────────────────

class _TypingText extends StatefulWidget {
  final List<String> texts;
  final TextStyle style;
  const _TypingText({required this.texts, required this.style});

  @override
  State<_TypingText> createState() => _TypingTextState();
}

class _TypingTextState extends State<_TypingText> {
  String _displayed = '';
  int _textIndex = 0;
  int _charIndex = 0;
  bool _deleting = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _schedule(const Duration(milliseconds: 600));
  }

  void _schedule(Duration d) {
    _timer?.cancel();
    _timer = Timer(d, _tick);
  }

  void _tick() {
    if (!mounted) return;
    final target = widget.texts[_textIndex];

    if (!_deleting) {
      if (_charIndex < target.length) {
        _charIndex++;
        setState(() => _displayed = target.substring(0, _charIndex));
        _schedule(const Duration(milliseconds: 80));
      } else {
        _deleting = true;
        _schedule(const Duration(milliseconds: 1800));
      }
    } else {
      if (_charIndex > 0) {
        _charIndex--;
        setState(() => _displayed = target.substring(0, _charIndex));
        _schedule(const Duration(milliseconds: 45));
      } else {
        _deleting = false;
        _textIndex = (_textIndex + 1) % widget.texts.length;
        _schedule(const Duration(milliseconds: 400));
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(_displayed, style: widget.style),
        _BlinkCursor(),
      ],
    );
  }
}

class _BlinkCursor extends StatefulWidget {
  @override
  State<_BlinkCursor> createState() => _BlinkCursorState();
}

class _BlinkCursorState extends State<_BlinkCursor>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _ctrl,
      child: const Text('|',
          style: TextStyle(color: _accent, fontWeight: FontWeight.w300, fontSize: 20)),
    );
  }
}

// ─── HERO SECTION ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final CVStrings cv;
  final bool isSlovak;
  const _HeroSection({required this.cv, required this.isSlovak});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _borderClr(context)),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.08),
            blurRadius: 60,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWide)
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: _heroText(context)),
              const SizedBox(width: 32),
              _avatar(),
            ])
          else
            Column(children: [
              Center(child: _avatar()),
              const SizedBox(height: 24),
              _heroText(context),
            ]),
          const SizedBox(height: 32),
          _divider(),
          const SizedBox(height: 24),
          _contactRow(context),
        ],
      ),
    );
  }

  Widget _heroText(BuildContext context) {
    final typingTexts = isSlovak
        ? ['Developer', 'IT Študent', 'Muzikant', 'Paddleboarder', 'Šachista']
        : ['Developer', 'IT Student', 'Musician', 'Paddleboarder', 'Chess Player'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filip Konštiak',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 52,
            fontWeight: FontWeight.w700,
            color: _textPrimary(context),
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        _TypingText(
          texts: typingTexts,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: _accent,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: _accent.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: _accent.withOpacity(0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.format_quote_rounded, color: _accent, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cv.quote,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: _textPrimary(context).withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(cv.quoteAuthor,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: _accent, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        _ProfileChips(cv: cv),
      ],
    );
  }

  Widget _avatar() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          colors: [_accent, _accentGreen],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [BoxShadow(color: _accent.withOpacity(0.3), blurRadius: 30)],
      ),
      child: const Center(
        child: Text('FK',
            style: TextStyle(
                color: Colors.white, fontSize: 36, fontWeight: FontWeight.w700, letterSpacing: 2)),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Color(0x667C6FF7),
            Color(0x6600D4AA),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _contactRow(BuildContext context) {
    final items = [
      _CD(Icons.cake_outlined, '07.03.2000'),
      _CD(Icons.location_on_outlined, 'Žilina, Slovensko'),
      _CD(Icons.email_outlined, 'filip.konstiak@gmail.com'),
      _CD(Icons.phone_outlined, '+421 904 271 405'),
    ];
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: items
          .map((i) => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(i.icon, size: 16, color: _accent),
                  const SizedBox(width: 6),
                  Text(i.text,
                      style: GoogleFonts.inter(fontSize: 13, color: _textSecondary(context))),
                ],
              ))
          .toList(),
    );
  }
}

class _CD {
  final IconData icon;
  final String text;
  _CD(this.icon, this.text);
}

// ─── DOWNLOAD BUTTON ──────────────────────────────────────────────────────────

class _DownloadButton extends StatefulWidget {
  final bool isSlovak;
  final VoidCallback onPrint;
  const _DownloadButton({required this.isSlovak, required this.onPrint});

  @override
  State<_DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends State<_DownloadButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final label = widget.isSlovak ? 'Stiahnuť CV' : 'Download CV';
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onPrint,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered ? [_accentGreen, _accent] : [_accent, _accentGreen],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(_hovered ? 0.4 : 0.2),
                blurRadius: _hovered ? 20 : 10,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.download_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── PROFILE CHIPS ────────────────────────────────────────────────────────────

class _ProfileChips extends StatelessWidget {
  final CVStrings cv;
  const _ProfileChips({required this.cv});

  @override
  Widget build(BuildContext context) {
    final traits = cv.profileDesc.split(' • ');
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: traits
          .map((t) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: _accentGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: _accentGreen.withOpacity(0.25)),
                ),
                child: Text(t.trim(),
                    style: GoogleFonts.inter(
                        fontSize: 12, color: _accentGreen, fontWeight: FontWeight.w500)),
              ))
          .toList(),
    );
  }
}

// ─── SECTION CARD ─────────────────────────────────────────────────────────────

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _SectionCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _borderClr(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: _accent, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  style: GoogleFonts.spaceGrotesk(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _textSecondary(context),
                    letterSpacing: 1.5,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

// ─── EXPERIENCE ───────────────────────────────────────────────────────────────

class _ExperienceSection extends StatelessWidget {
  final CVStrings cv;
  const _ExperienceSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.experienceTitle,
      icon: Icons.work_outline_rounded,
      child: Column(
        children: cv.experience
            .asMap()
            .entries
            .map((e) => _TimelineItem(item: e.value, isLast: e.key == cv.experience.length - 1))
            .toList(),
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ExperienceItem item;
  final bool isLast;
  const _TimelineItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: _accent,
                    boxShadow: [BoxShadow(color: _accent.withOpacity(0.5), blurRadius: 6)],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: _borderClr(context),
                      margin: const EdgeInsets.only(top: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.role,
                      style: GoogleFonts.inter(
                          fontSize: 16, fontWeight: FontWeight.w600, color: _textPrimary(context))),
                  const SizedBox(height: 2),
                  Text(item.company,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: _accent, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 6),
                  Text(item.description,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: _textSecondary(context), height: 1.5)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: _textSecondary(context)),
                      const SizedBox(width: 4),
                      Text(item.period,
                          style: GoogleFonts.inter(fontSize: 12, color: _textSecondary(context))),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, size: 12, color: _textSecondary(context)),
                      const SizedBox(width: 4),
                      Text(item.location,
                          style: GoogleFonts.inter(fontSize: 12, color: _textSecondary(context))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── EDUCATION ────────────────────────────────────────────────────────────────

class _EducationSection extends StatelessWidget {
  final CVStrings cv;
  const _EducationSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.educationTitle,
      icon: Icons.school_outlined,
      child: Column(
        children: cv.education
            .asMap()
            .entries
            .map((e) => _EduItem(item: e.value, isLast: e.key == cv.education.length - 1))
            .toList(),
      ),
    );
  }
}

class _EduItem extends StatelessWidget {
  final EducationItem item;
  final bool isLast;
  const _EduItem({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 12, height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, color: _accentGreen,
                    boxShadow: [BoxShadow(color: _accentGreen.withOpacity(0.5), blurRadius: 6)],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: _borderClr(context),
                      margin: const EdgeInsets.only(top: 4),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.school,
                      style: GoogleFonts.inter(
                          fontSize: 15, fontWeight: FontWeight.w600, color: _textPrimary(context))),
                  const SizedBox(height: 2),
                  Text(item.degree,
                      style: GoogleFonts.inter(
                          fontSize: 13, color: _accentGreen, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined, size: 12, color: _textSecondary(context)),
                      const SizedBox(width: 4),
                      Text(item.period,
                          style: GoogleFonts.inter(fontSize: 12, color: _textSecondary(context))),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined, size: 12, color: _textSecondary(context)),
                      const SizedBox(width: 4),
                      Text(item.location,
                          style: GoogleFonts.inter(fontSize: 12, color: _textSecondary(context))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── LANGUAGES ────────────────────────────────────────────────────────────────

class _LanguagesSection extends StatelessWidget {
  final CVStrings cv;
  const _LanguagesSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.languagesTitle,
      icon: Icons.language_rounded,
      child: Column(children: cv.languages.map((l) => _LangItem(item: l)).toList()),
    );
  }
}

class _LangItem extends StatelessWidget {
  final LanguageItem item;
  const _LangItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.language,
                    style: GoogleFonts.inter(
                        fontSize: 14, fontWeight: FontWeight.w600, color: _textPrimary(context))),
                Text(item.label,
                    style: GoogleFonts.inter(fontSize: 11, color: _textSecondary(context))),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: _accent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: _accent.withOpacity(0.3)),
            ),
            child: Text(item.level,
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 12, fontWeight: FontWeight.w700, color: _accent)),
          ),
          const SizedBox(width: 12),
          Row(
            children: List.generate(
              6,
              (i) => Container(
                width: 8, height: 8,
                margin: EdgeInsets.only(left: i == 0 ? 0 : 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < item.dots ? _accentGreen : _accentGreen.withOpacity(0.12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── INTERESTS ────────────────────────────────────────────────────────────────

class _InterestsSection extends StatelessWidget {
  final CVStrings cv;
  const _InterestsSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.aboutTitle,
      icon: Icons.interests_outlined,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: cv.interests
            .map((i) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _surfaceBg(context),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _borderClr(context)),
                  ),
                  child: Text(i,
                      style: GoogleFonts.inter(fontSize: 12, color: _textSecondary(context))),
                ))
            .toList(),
      ),
    );
  }
}

// ─── VOLUNTEERING ─────────────────────────────────────────────────────────────

class _VolunteeringSection extends StatelessWidget {
  final CVStrings cv;
  const _VolunteeringSection({super.key, required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.volunteeringTitle,
      icon: Icons.volunteer_activism_outlined,
      child: Column(
        children: cv.volunteering
            .asMap()
            .entries
            .map((e) => Padding(
                  padding: EdgeInsets.only(bottom: e.key == cv.volunteering.length - 1 ? 0 : 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6, height: 6,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: _accentGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(e.value.role,
                                style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: _textPrimary(context))),
                            Text(e.value.organization,
                                style: GoogleFonts.inter(
                                    fontSize: 12, color: _textSecondary(context))),
                          ],
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ─── CERTIFICATES ─────────────────────────────────────────────────────────────

class _CertificatesSection extends StatelessWidget {
  final CVStrings cv;
  const _CertificatesSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.certificatesTitle,
      icon: Icons.workspace_premium_outlined,
      child: Column(
        children: cv.certificates
            .map((c) => Row(
                  children: [
                    const Icon(Icons.verified_outlined, size: 16, color: _accent),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(c,
                          style: GoogleFonts.inter(fontSize: 14, color: _textPrimary(context))),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

// ─── PROJECTS ─────────────────────────────────────────────────────────────────

class _ProjectsSection extends StatelessWidget {
  final CVStrings cv;
  const _ProjectsSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.projectsTitle,
      icon: Icons.folder_open_rounded,
      child: Column(
        children: cv.projects
            .asMap()
            .entries
            .map((e) => _ProjectCard(item: e.value, isLast: e.key == cv.projects.length - 1))
            .toList(),
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectItem item;
  final bool isLast;
  const _ProjectCard({required this.item, required this.isLast});

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  void _openUrl() {
    final url = widget.item.githubUrl;
    if (url == null) return;
    html.window.open(url, '_blank');
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Text(label,
          style: GoogleFonts.inter(
              fontSize: 10, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.8)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final clickable = widget.item.githubUrl != null;
    return Padding(
      padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 16),
      child: MouseRegion(
        cursor: clickable ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: clickable ? _openUrl : null,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _hovered ? _accent.withOpacity(0.06) : _surfaceBg(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _hovered ? _accent.withOpacity(0.35) : _borderClr(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.code_rounded, size: 16, color: _accent),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(widget.item.name,
                                style: GoogleFonts.spaceGrotesk(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: _textPrimary(context))),
                          ),
                        ],
                      ),
                    ),
                    if (widget.item.wip)
                      _badge('WIP', const Color(0xFFF59E0B))
                    else if (widget.item.onRequest)
                      _badge('Na vyžiadanie', const Color(0xFF00D4AA))
                    else if (clickable)
                      const Icon(Icons.open_in_new_rounded, size: 16, color: _accent),
                  ],
                ),
                const SizedBox(height: 8),
                Text(widget.item.description,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: _textSecondary(context), height: 1.5)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: widget.item.tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: _accent.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(tag,
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: _accent,
                                    fontWeight: FontWeight.w500)),
                          ))
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── TECH STACK ───────────────────────────────────────────────────────────────

class _TechStackSection extends StatelessWidget {
  final CVStrings cv;
  const _TechStackSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.techStackTitle,
      icon: Icons.layers_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: cv.techStack.map((c) => _TechCategoryRow(category: c)).toList(),
      ),
    );
  }
}

class _TechCategoryRow extends StatelessWidget {
  final TechCategory category;
  const _TechCategoryRow({required this.category});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category.label.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: _textSecondary(context).withOpacity(0.6),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.items.map((i) => _TechBadge(item: i)).toList(),
          ),
        ],
      ),
    );
  }
}

class _TechBadge extends StatefulWidget {
  final TechItem item;
  const _TechBadge({required this.item});

  @override
  State<_TechBadge> createState() => _TechBadgeState();
}

class _TechBadgeState extends State<_TechBadge> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.item.colorHex);
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: _hovered ? color.withOpacity(0.15) : color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: _hovered ? color.withOpacity(0.5) : color.withOpacity(0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22, height: 22,
              decoration: BoxDecoration(
                  color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(6)),
              child: Center(
                child: Text(widget.item.symbol,
                    style: TextStyle(
                        fontSize: 9, fontWeight: FontWeight.w800, color: color)),
              ),
            ),
            const SizedBox(width: 8),
            Text(widget.item.name,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: _hovered ? color : _textPrimary(context))),
          ],
        ),
      ),
    );
  }
}

// ─── SOFT SKILLS ──────────────────────────────────────────────────────────────

class _SoftSkillsSection extends StatelessWidget {
  final CVStrings cv;
  const _SoftSkillsSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.softSkillsTitle,
      icon: Icons.psychology_outlined,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: cv.softSkills
            .map((s) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _accent.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _accent.withOpacity(0.2)),
                  ),
                  child: Text(s,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: _accent, fontWeight: FontWeight.w500)),
                ))
            .toList(),
      ),
    );
  }
}

// ─── SOCIAL NETWORKS ──────────────────────────────────────────────────────────

class _SocialSection extends StatelessWidget {
  final CVStrings cv;
  const _SocialSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.socialTitle,
      icon: Icons.share_outlined,
      child: Row(
        children: cv.socialLinks
            .asMap()
            .entries
            .map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                        right: e.key < cv.socialLinks.length - 1 ? 12 : 0),
                    child: _SocialLink(item: e.value, isLast: true),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class _SocialLink extends StatefulWidget {
  final SocialItem item;
  final bool isLast;
  const _SocialLink({required this.item, required this.isLast});

  @override
  State<_SocialLink> createState() => _SocialLinkState();
}

class _SocialLinkState extends State<_SocialLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = Color(widget.item.colorHex);
    return Padding(
      padding: EdgeInsets.only(bottom: widget.isLast ? 0 : 10),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTap: () => html.window.open(widget.item.url, '_blank'),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: _hovered ? color.withOpacity(0.1) : _surfaceBg(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                  color: _hovered ? color.withOpacity(0.4) : _borderClr(context)),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      widget.item.symbol,
                      style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: color),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.name,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: _hovered ? color : _textPrimary(context),
                    ),
                  ),
                ),
                Icon(
                  Icons.open_in_new_rounded,
                  size: 14,
                  color: _hovered ? color : _textSecondary(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── REFERENCES ───────────────────────────────────────────────────────────────

class _ReferencesSection extends StatelessWidget {
  final CVStrings cv;
  const _ReferencesSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.referencesTitle,
      icon: Icons.people_outline_rounded,
      child: Column(
        children: cv.references
            .asMap()
            .entries
            .map((e) => _ReferenceCard(item: e.value, isLast: e.key == cv.references.length - 1))
            .toList(),
      ),
    );
  }
}

class _ReferenceCard extends StatelessWidget {
  final ReferenceItem item;
  final bool isLast;
  const _ReferenceCard({required this.item, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _surfaceBg(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _borderClr(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [_accent, _accentGreen],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  item.name.split(' ').map((w) => w[0]).take(2).join(),
                  style: const TextStyle(
                      color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name,
                      style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: _textPrimary(context))),
                  const SizedBox(height: 2),
                  Text(item.role,
                      style: GoogleFonts.inter(
                          fontSize: 12, color: _accent, fontWeight: FontWeight.w500)),
                  Text(item.organization,
                      style: GoogleFonts.inter(fontSize: 12, color: _textSecondary(context))),
                  if (item.contact != null) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, size: 12, color: _accentGreen),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(item.contact!,
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: _accentGreen,
                                  fontStyle: FontStyle.italic)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── BOTTOM STRIP (equal height via post-frame measurement) ───────────────────

class _BottomStrip extends StatefulWidget {
  final CVStrings cv;
  const _BottomStrip({required this.cv});

  @override
  State<_BottomStrip> createState() => _BottomStripState();
}

class _BottomStripState extends State<_BottomStrip> {
  double? _height;
  final _volKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _measure();
  }

  @override
  void didUpdateWidget(_BottomStrip old) {
    super.didUpdateWidget(old);
    if (old.cv != widget.cv) _measure();
  }

  void _measure() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final h = _volKey.currentContext?.size?.height;
      if (h != null && h != _height) setState(() => _height = h);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Volunteering — prirodzená výška, meriame ju
        Expanded(
          child: _VolunteeringSection(key: _volKey, cv: widget.cv),
        ),
        const SizedBox(width: 32),
        // Certificates — natiahnuté na výšku Dobrovoľníctva
        Expanded(
          child: SizedBox(
            height: _height,
            child: _CertificatesSection(cv: widget.cv),
          ),
        ),
        const SizedBox(width: 32),
        // References — natiahnuté na výšku Dobrovoľníctva
        Expanded(
          child: SizedBox(
            height: _height,
            child: _ReferencesSection(cv: widget.cv),
          ),
        ),
      ],
    );
  }
}

// ─── FOOTER ───────────────────────────────────────────────────────────────────

class _Footer extends StatelessWidget {
  final bool isSlovak;
  const _Footer({required this.isSlovak});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        isSlovak
            ? '© 2026 Filip Konštiak • Vytvorené vo Flutter'
            : '© 2026 Filip Konštiak • Built with Flutter',
        style: GoogleFonts.inter(
            fontSize: 12, color: _textSecondary(context).withOpacity(0.5)),
      ),
    );
  }
}
