import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cv_data.dart';

const _accent = Color(0xFF7C6FF7);
const _accentGreen = Color(0xFF00D4AA);
const _cardBg = Color(0xFF14141E);
const _surfaceBg = Color(0xFF0A0A0F);
const _textPrimary = Color(0xFFF0F0F8);
const _textSecondary = Color(0xFF8B8BA0);
const _border = Color(0xFF22223A);

class CVPage extends StatefulWidget {
  final bool isSlovak;
  final VoidCallback onToggleLanguage;

  const CVPage({
    super.key,
    required this.isSlovak,
    required this.onToggleLanguage,
  });

  @override
  State<CVPage> createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> with SingleTickerProviderStateMixin {
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..forward();
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeOut);
  }

  @override
  void didUpdateWidget(CVPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSlovak != widget.isSlovak) {
      _fadeCtrl.reset();
      _fadeCtrl.forward();
    }
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cv = widget.isSlovak ? cvSK : cvEN;
    final width = MediaQuery.of(context).size.width;
    final isWide = width > 900;

    return Scaffold(
      backgroundColor: _surfaceBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Stack(
          children: [
            _buildBackground(),
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isWide ? 48 : 20,
                          vertical: 40,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _HeroSection(cv: cv),
                            const SizedBox(height: 48),
                            if (isWide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      children: [
                                        _ProjectsSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _ExperienceSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _EducationSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _VolunteeringSection(cv: cv),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 32),
                                  SizedBox(
                                    width: 320,
                                    child: Column(
                                      children: [
                                        _TechStackSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _SkillsSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _LanguagesSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _InterestsSection(cv: cv),
                                        const SizedBox(height: 32),
                                        _CertificatesSection(cv: cv),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else
                              Column(
                                children: [
                                  _ProjectsSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _TechStackSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _ExperienceSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _EducationSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _SkillsSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _LanguagesSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _InterestsSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _VolunteeringSection(cv: cv),
                                  const SizedBox(height: 32),
                                  _CertificatesSection(cv: cv),
                                ],
                              ),
                            const SizedBox(height: 60),
                            _Footer(isSlovak: widget.isSlovak),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _LangToggle(
              isSlovak: widget.isSlovak,
              onToggle: widget.onToggleLanguage,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground() {
    return Positioned.fill(
      child: CustomPaint(painter: _BgPainter()),
    );
  }
}

// ─── BACKGROUND PAINTER ───────────────────────────────────────────────────────

class _BgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    paint.color = const Color(0xFF7C6FF7).withOpacity(0.04);
    canvas.drawCircle(Offset(size.width * 0.85, size.height * 0.1), 380, paint);
    paint.color = const Color(0xFF00D4AA).withOpacity(0.03);
    canvas.drawCircle(Offset(size.width * 0.1, size.height * 0.6), 300, paint);
    paint.color = const Color(0xFF7C6FF7).withOpacity(0.03);
    canvas.drawCircle(Offset(size.width * 0.5, size.height * 0.9), 250, paint);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── LANGUAGE TOGGLE ─────────────────────────────────────────────────────────

class _LangToggle extends StatelessWidget {
  final bool isSlovak;
  final VoidCallback onToggle;

  const _LangToggle({required this.isSlovak, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 24,
      right: 24,
      child: GestureDetector(
        onTap: onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: _border, width: 1),
            boxShadow: [
              BoxShadow(
                color: _accent.withOpacity(0.15),
                blurRadius: 20,
                spreadRadius: 0,
              ),
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
      curve: Curves.easeInOut,
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
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? Colors.white : _textSecondary,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── HERO SECTION ─────────────────────────────────────────────────────────────

class _HeroSection extends StatelessWidget {
  final CVStrings cv;
  const _HeroSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.08),
            blurRadius: 60,
            spreadRadius: 0,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isWide)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _heroText()),
                const SizedBox(width: 32),
                _avatar(),
              ],
            )
          else
            Column(
              children: [
                Center(child: _avatar()),
                const SizedBox(height: 24),
                _heroText(),
              ],
            ),
          const SizedBox(height: 32),
          _divider(),
          const SizedBox(height: 24),
          _contactRow(context),
        ],
      ),
    );
  }

  Widget _heroText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filip Konštiak',
          style: GoogleFonts.spaceGrotesk(
            fontSize: 52,
            fontWeight: FontWeight.w700,
            color: _textPrimary,
            height: 1.1,
            letterSpacing: -1,
          ),
        ),
        const SizedBox(height: 8),
        _GradientText(
          text: 'Software Developer & IT Student',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
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
              Icon(Icons.format_quote_rounded, color: _accent, size: 20),
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
                        color: _textPrimary.withOpacity(0.9),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      cv.quoteAuthor,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: _accent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
        boxShadow: [
          BoxShadow(
            color: _accent.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'FK',
          style: TextStyle(
            color: Colors.white,
            fontSize: 36,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  Widget _divider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            _accent.withOpacity(0.4),
            _accentGreen.withOpacity(0.4),
            Colors.transparent,
          ],
        ),
      ),
    );
  }

  Widget _contactRow(BuildContext context) {
    final items = [
      _ContactItem(Icons.cake_outlined, '07.03.2000'),
      _ContactItem(Icons.location_on_outlined, 'Žilina, Slovensko'),
      _ContactItem(Icons.email_outlined, 'filip.konstiak@gmail.com'),
      _ContactItem(Icons.phone_outlined, '+421 904 271 405'),
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
                  Text(
                    i.text,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _textSecondary,
                    ),
                  ),
                ],
              ))
          .toList(),
    );
  }
}

class _ContactItem {
  final IconData icon;
  final String text;
  _ContactItem(this.icon, this.text);
}

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
                child: Text(
                  t.trim(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: _accentGreen,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _border),
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
                    color: _textSecondary,
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
            .map((e) => _TimelineItem(
                  item: e.value,
                  isLast: e.key == cv.experience.length - 1,
                ))
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
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accent,
                    boxShadow: [
                      BoxShadow(
                        color: _accent.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: _border,
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
                  Text(
                    item.role,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.company,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _accent,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.description,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 12, color: _textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        item.period,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: _textSecondary),
                      ),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined,
                          size: 12, color: _textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        item.location,
                        style: GoogleFonts.inter(
                            fontSize: 12, color: _textSecondary),
                      ),
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
            .map((e) => _EduItem(
                  item: e.value,
                  isLast: e.key == cv.education.length - 1,
                ))
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
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _accentGreen,
                    boxShadow: [
                      BoxShadow(
                        color: _accentGreen.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 1,
                      color: _border,
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
                  Text(
                    item.school,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    item.degree,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: _accentGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          size: 12, color: _textSecondary),
                      const SizedBox(width: 4),
                      Text(item.period,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: _textSecondary)),
                      const SizedBox(width: 12),
                      Icon(Icons.location_on_outlined,
                          size: 12, color: _textSecondary),
                      const SizedBox(width: 4),
                      Text(item.location,
                          style: GoogleFonts.inter(
                              fontSize: 12, color: _textSecondary)),
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

// ─── SKILLS ───────────────────────────────────────────────────────────────────

class _SkillsSection extends StatelessWidget {
  final CVStrings cv;
  const _SkillsSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.skillsTitle,
      icon: Icons.code_rounded,
      child: Column(
        children: cv.programmingSkills
            .map((s) => _SkillBar(skill: s))
            .toList(),
      ),
    );
  }
}

class _SkillBar extends StatelessWidget {
  final SkillItem skill;
  const _SkillBar({required this.skill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  skill.name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _textPrimary,
                  ),
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Container(
                    width: 8,
                    height: 8,
                    margin: EdgeInsets.only(left: i == 0 ? 0 : 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: i < skill.level
                          ? _accent
                          : _accent.withOpacity(0.15),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: skill.level / 5,
              backgroundColor: _accent.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                _accent.withOpacity(0.8),
              ),
              minHeight: 4,
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
      child: Column(
        children: cv.languages.map((l) => _LangItem(item: l)).toList(),
      ),
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
                Text(
                  item.language,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _textPrimary,
                  ),
                ),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: _textSecondary,
                  ),
                ),
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
            child: Text(
              item.level,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _accent,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Row(
            children: List.generate(
              6,
              (i) => Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i < item.dots
                      ? _accentGreen
                      : _accentGreen.withOpacity(0.12),
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
            .map((interest) => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _surfaceBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: _border),
                  ),
                  child: Text(
                    interest,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _textSecondary,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}

// ─── VOLUNTEERING ─────────────────────────────────────────────────────────────

class _VolunteeringSection extends StatelessWidget {
  final CVStrings cv;
  const _VolunteeringSection({required this.cv});

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: cv.volunteeringTitle,
      icon: Icons.volunteer_activism_outlined,
      child: Column(
        children: cv.volunteering
            .map((v) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(top: 6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _accentGreen,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              v.role,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: _textPrimary,
                              ),
                            ),
                            Text(
                              v.organization,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: _textSecondary,
                              ),
                            ),
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
                    Icon(Icons.verified_outlined, size: 16, color: _accent),
                    const SizedBox(width: 10),
                    Text(
                      c,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: _textPrimary,
                      ),
                    ),
                  ],
                ))
            .toList(),
      ),
    );
  }
}

// ─── PROJECTS ────────────────────────────────────────────────────────────────

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
            color: _hovered ? _accent.withOpacity(0.06) : _surfaceBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? _accent.withOpacity(0.35) : _border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Icon(Icons.code_rounded, size: 16, color: _accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.item.name,
                            style: GoogleFonts.spaceGrotesk(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (widget.item.wip)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF59E0B).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.3)),
                      ),
                      child: Text(
                        'WIP',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFF59E0B),
                          letterSpacing: 1,
                        ),
                      ),
                    )
                  else if (widget.item.githubUrl != null)
                    Icon(Icons.open_in_new_rounded, size: 16, color: _textSecondary),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.item.description,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _textSecondary,
                  height: 1.5,
                ),
              ),
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
                          child: Text(
                            tag,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: _accent,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
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
        children: cv.techStack.map((cat) => _TechCategoryRow(category: cat)).toList(),
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
              color: _textSecondary.withOpacity(0.6),
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: category.items.map((item) => _TechBadge(item: item)).toList(),
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
            color: _hovered ? color.withOpacity(0.5) : color.withOpacity(0.2),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Text(
                  widget.item.symbol,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              widget.item.name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _hovered ? color : _textPrimary,
              ),
            ),
          ],
        ),
      ),
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
          fontSize: 12,
          color: _textSecondary.withOpacity(0.5),
        ),
      ),
    );
  }
}

// ─── GRADIENT TEXT ────────────────────────────────────────────────────────────

class _GradientText extends StatelessWidget {
  final String text;
  final TextStyle style;

  const _GradientText({required this.text, required this.style});

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => const LinearGradient(
        colors: [_accent, _accentGreen],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(bounds),
      child: Text(text, style: style),
    );
  }
}
