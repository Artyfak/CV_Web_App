import 'dart:html' as html;
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'cv_data.dart';

// ─── COLORS ───────────────────────────────────────────────────────────────────

final _cAccent      = PdfColor.fromHex('#7C6FF7');
final _cGreen       = PdfColor.fromHex('#00D4AA');
final _cText        = PdfColor.fromHex('#0D0D1A');
final _cSub         = PdfColor.fromHex('#6B6B85');
final _cBorder      = PdfColor.fromHex('#E0E0EE');
final _cSurface     = PdfColor.fromHex('#F4F4FA');

// Solid chip colors (opacity nevyzerá dobre v PDF)
final _cChipBg      = PdfColor.fromHex('#EDE9FE'); // svetlá fialová
final _cChipFg      = PdfColor.fromHex('#4B3FBF'); // tmavá fialová
final _cChipGreenBg = PdfColor.fromHex('#D1FAF3'); // svetlá zelená
final _cChipGreenFg = PdfColor.fromHex('#0A7A64'); // tmavá zelená
final _cChipGrayBg  = PdfColor.fromHex('#EBEBF5'); // svetlá sivá
final _cChipGrayFg  = PdfColor.fromHex('#3D3D5C'); // tmavá sivá

PdfColor _o(PdfColor c, double a) => PdfColor(c.red, c.green, c.blue, a);

// ─── ENTRY POINT ──────────────────────────────────────────────────────────────

Future<void> generateAndPrintCV(CVStrings cv) async {
  final bytes = await _buildPdf(cv);
  final blob = html.Blob([bytes], 'application/pdf');
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.window.open(url, '_blank');
  Future.delayed(const Duration(minutes: 2), () => html.Url.revokeObjectUrl(url));
}

// ─── BUILD PDF ────────────────────────────────────────────────────────────────

Future<Uint8List> _buildPdf(CVStrings cv) async {
  final doc = pw.Document(title: 'Filip Konštiak — CV');

  final regular = await PdfGoogleFonts.interRegular();
  final bold    = await PdfGoogleFonts.interBold();
  final medium  = await PdfGoogleFonts.interMedium();
  final italic  = await PdfGoogleFonts.interItalic();

  pw.TextStyle ts(double size, {pw.Font? font, PdfColor? color, double? letterSpacing, double? lineSpacing}) =>
      pw.TextStyle(
        font: font ?? regular,
        fontSize: size,
        color: color ?? _cText,
        letterSpacing: letterSpacing,
        lineSpacing: lineSpacing,
      );

  // ── Section header ──────────────────────────────────────────────────────────
  pw.Widget sectionHead(String title) => pw.Container(
        margin: const pw.EdgeInsets.only(top: 14, bottom: 8),
        padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: pw.BoxDecoration(
          color: _cChipBg,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
          border: pw.Border.all(color: _cAccent, width: 0.5),
        ),
        child: pw.Text(title.toUpperCase(),
            style: ts(9, font: bold, color: _cChipFg, letterSpacing: 1.5)),
      );

  // ── Tag chip ────────────────────────────────────────────────────────────────
  pw.Widget chip(String label, {PdfColor? bg, PdfColor? fg}) => pw.Container(
        margin: const pw.EdgeInsets.only(right: 4, bottom: 4),
        padding: const pw.EdgeInsets.symmetric(horizontal: 7, vertical: 3),
        decoration: pw.BoxDecoration(
          color: bg ?? _cChipBg,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
        ),
        child: pw.Text(label, style: ts(8, color: fg ?? _cChipFg, font: medium)),
      );

  // ── Dot bullet ──────────────────────────────────────────────────────────────
  pw.Widget bullet(PdfColor color) => pw.Container(
        width: 6, height: 6,
        margin: const pw.EdgeInsets.only(top: 4, right: 8),
        decoration: pw.BoxDecoration(color: color, shape: pw.BoxShape.circle),
      );

  // ── Experience item ─────────────────────────────────────────────────────────
  pw.Widget expItem(ExperienceItem item, bool isLast) => pw.Padding(
        padding: pw.EdgeInsets.only(bottom: isLast ? 0 : 10),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(children: [
            pw.Container(
              width: 8, height: 8,
              decoration: pw.BoxDecoration(color: _cAccent, shape: pw.BoxShape.circle),
            ),
            if (!isLast)
              pw.Container(width: 1, height: 28, color: _cBorder,
                  margin: const pw.EdgeInsets.only(top: 2)),
          ]),
          pw.SizedBox(width: 10),
          pw.Expanded(child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(item.role, style: ts(11, font: bold)),
              pw.Text(item.company, style: ts(9.5, color: _cAccent, font: medium)),
              pw.SizedBox(height: 2),
              pw.Text(item.description, style: ts(9, color: _cSub, lineSpacing: 1)),
              pw.SizedBox(height: 2),
              pw.Text('${item.period}  •  ${item.location}',
                  style: ts(8, color: _cSub)),
            ],
          )),
        ]),
      );

  // ── Education item ──────────────────────────────────────────────────────────
  pw.Widget eduItem(EducationItem item, bool isLast) => pw.Padding(
        padding: pw.EdgeInsets.only(bottom: isLast ? 0 : 10),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Column(children: [
            pw.Container(
              width: 8, height: 8,
              decoration: pw.BoxDecoration(color: _cGreen, shape: pw.BoxShape.circle),
            ),
            if (!isLast)
              pw.Container(width: 1, height: 24, color: _cBorder,
                  margin: const pw.EdgeInsets.only(top: 2)),
          ]),
          pw.SizedBox(width: 10),
          pw.Expanded(child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(item.school, style: ts(11, font: bold)),
              pw.Text(item.degree, style: ts(9.5, color: _cGreen, font: medium)),
              pw.SizedBox(height: 2),
              pw.Text('${item.period}  •  ${item.location}',
                  style: ts(8, color: _cSub)),
            ],
          )),
        ]),
      );

  // ── Project card ────────────────────────────────────────────────────────────
  pw.Widget projectCard(ProjectItem item) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 8),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: _cSurface,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: _cBorder, width: 0.5),
        ),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(children: [
            pw.Expanded(child: pw.Text(item.name, style: ts(11, font: bold))),
            if (item.onRequest)
              chip('Na vyžiadanie', bg: _cChipGreenBg, fg: _cChipGreenFg)
            else if (item.wip)
              chip('WIP', bg: PdfColor.fromHex('#FEF3C7'),
                  fg: PdfColor.fromHex('#92400E')),
          ]),
          pw.SizedBox(height: 3),
          pw.Text(item.description, style: ts(9, color: _cSub, lineSpacing: 1)),
          pw.SizedBox(height: 5),
          pw.Wrap(children: item.tags.map((t) => chip(t)).toList()),
          if (item.githubUrl != null) ...[
            pw.SizedBox(height: 3),
            pw.Text(item.githubUrl!, style: ts(8, color: _cAccent)),
          ],
        ]),
      );

  // ── Language item ───────────────────────────────────────────────────────────
  pw.Widget langItem(LanguageItem item) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8),
        child: pw.Row(children: [
          pw.Expanded(child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(item.language, style: ts(10, font: bold)),
              pw.Text(item.label, style: ts(8, color: _cSub)),
            ],
          )),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: pw.BoxDecoration(
              color: _cChipBg,
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
              border: pw.Border.all(color: _cAccent, width: 0.5),
            ),
            child: pw.Text(item.level, style: ts(9, font: bold, color: _cChipFg)),
          ),
          pw.SizedBox(width: 8),
          pw.Row(children: List.generate(6, (i) => pw.Container(
            width: 6, height: 6,
            margin: const pw.EdgeInsets.only(left: 2),
            decoration: pw.BoxDecoration(
              color: i < item.dots ? _cGreen : PdfColor.fromHex('#C8C8DC'),
              shape: pw.BoxShape.circle,
            ),
          ))),
        ]),
      );

  // ── Tech badge ──────────────────────────────────────────────────────────────
  pw.Widget techBadge(TechItem item) {
    final color = PdfColor(
      ((item.colorHex >> 16) & 0xFF) / 255,
      ((item.colorHex >> 8) & 0xFF) / 255,
      (item.colorHex & 0xFF) / 255,
    );
    return pw.Container(
      margin: const pw.EdgeInsets.only(right: 4, bottom: 4),
      padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: pw.BoxDecoration(
        color: _cChipGrayBg,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(6)),
        border: pw.Border.all(color: color, width: 0.5),
      ),
      child: pw.Text(item.name, style: ts(8.5, color: color, font: medium)),
    );
  }

  // ── Volunteer item ──────────────────────────────────────────────────────────
  pw.Widget volItem(VolunteerItem item) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 6),
        child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          bullet(_cGreen),
          pw.Expanded(child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(item.role, style: ts(10, font: medium)),
              pw.Text(item.organization, style: ts(8.5, color: _cSub)),
            ],
          )),
        ]),
      );

  // ── Reference card ──────────────────────────────────────────────────────────
  pw.Widget refCard(ReferenceItem item) => pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 6),
        padding: const pw.EdgeInsets.all(10),
        decoration: pw.BoxDecoration(
          color: _cSurface,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
          border: pw.Border.all(color: _cBorder, width: 0.5),
        ),
        child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Text(item.name, style: ts(11, font: bold)),
          pw.Text(item.role, style: ts(9, color: _cAccent, font: medium)),
          pw.Text(item.organization, style: ts(9, color: _cSub)),
          if (item.contact != null) ...[
            pw.SizedBox(height: 3),
            pw.Text(item.contact!, style: ts(8.5, font: italic, color: _cGreen)),
          ],
        ]),
      );

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  pw.Widget header() => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: pw.BoxDecoration(
      gradient: pw.LinearGradient(
        colors: [_cAccent, _cGreen],
        begin: pw.Alignment.centerLeft,
        end: pw.Alignment.centerRight,
      ),
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
    ),
    child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
      pw.Container(
        width: 48, height: 48,
        decoration: const pw.BoxDecoration(color: PdfColors.white, shape: pw.BoxShape.circle),
        child: pw.Center(child: pw.Text('FK', style: ts(16, font: bold, color: _cAccent))),
      ),
      pw.SizedBox(width: 14),
      pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('Filip Konštiak', style: ts(20, font: bold, color: PdfColors.white)),
        pw.Text('IT Developer', style: ts(10, color: PdfColors.white)),
      ]),
    ]),
  );

  pw.Widget contactRow() => pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 7),
    decoration: pw.BoxDecoration(
      color: _cSurface,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      border: pw.Border.all(color: _cBorder, width: 0.5),
    ),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text('07.03.2000', style: ts(8, color: _cSub)),
        pw.Text('Žilina, Slovensko', style: ts(8, color: _cSub)),
        pw.Text('filip.konstiak@gmail.com', style: ts(8, color: _cSub)),
        pw.Text('+421 904 271 405', style: ts(8, color: _cSub)),
        pw.Text('github.com/Artyfak', style: ts(8, color: _cAccent)),
      ],
    ),
  );

  pw.Widget quoteBox() => pw.Container(
    padding: const pw.EdgeInsets.all(9),
    decoration: pw.BoxDecoration(
      color: _cChipBg,
      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
      border: pw.Border.all(color: _cAccent, width: 0.5),
    ),
    child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text('"', style: ts(14, color: _cAccent, font: bold)),
      pw.SizedBox(width: 5),
      pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text('Make it work, make it right, make it fast.',
            style: ts(8.5, font: italic, color: _cText)),
        pw.Text('— Kent Beck', style: ts(8, color: _cAccent, font: medium)),
      ])),
    ]),
  );

  pw.Widget techStackWidget() => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: cv.techStack.map((cat) => pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(cat.label.toUpperCase(),
            style: ts(7.5, color: _cSub, letterSpacing: 1.2)),
        pw.SizedBox(height: 3),
        pw.Wrap(children: cat.items.map(techBadge).toList()),
      ]),
    )).toList(),
  );

  // ─── PAGE 1: Header + Experience + Education | Tech Stack + Languages ──────

  doc.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(28),
    build: (ctx) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        header(),
        pw.SizedBox(height: 8),
        contactRow(),
        pw.SizedBox(height: 8),
        quoteBox(),
        pw.SizedBox(height: 10),
        pw.Expanded(
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // LEFT: Experience + Education
              pw.Expanded(flex: 3, child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  sectionHead(cv.experienceTitle),
                  ...cv.experience.asMap().entries.map(
                      (e) => expItem(e.value, e.key == cv.experience.length - 1)),
                  sectionHead(cv.educationTitle),
                  ...cv.education.asMap().entries.map(
                      (e) => eduItem(e.value, e.key == cv.education.length - 1)),
                ],
              )),
              pw.SizedBox(width: 14),
              // RIGHT: Tech Stack + Languages
              pw.Expanded(flex: 2, child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  sectionHead(cv.techStackTitle),
                  techStackWidget(),
                  sectionHead(cv.languagesTitle),
                  ...cv.languages.map(langItem),
                ],
              )),
            ],
          ),
        ),
      ],
    ),
  ));

  // ─── PAGE 2: Projects | Soft Skills + Interests + Bottom strip ────────────

  doc.addPage(pw.Page(
    pageFormat: PdfPageFormat.a4,
    margin: const pw.EdgeInsets.all(28),
    build: (ctx) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Top row: Projects | Soft Skills + Interests + Social
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(flex: 3, child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                sectionHead(cv.projectsTitle),
                ...cv.projects.map(projectCard),
              ],
            )),
            pw.SizedBox(width: 14),
            pw.Expanded(flex: 2, child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                sectionHead(cv.softSkillsTitle),
                pw.Wrap(children: cv.softSkills.map((s) =>
                    chip(s, bg: _cChipBg, fg: _cChipFg)).toList()),
                sectionHead(cv.aboutTitle),
                pw.Wrap(children: cv.interests.map((i) =>
                    chip(i, bg: _cChipGrayBg, fg: _cChipGrayFg)).toList()),
                sectionHead(cv.socialTitle),
                ...cv.socialLinks.map((s) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(children: [
                    bullet(_cAccent),
                    pw.Text(s.name, style: ts(10, font: medium)),
                    pw.SizedBox(width: 4),
                    pw.Flexible(child: pw.Text(s.url, style: ts(8, color: _cAccent))),
                  ]),
                )),
              ],
            )),
          ],
        ),
        pw.SizedBox(height: 14),
        // Bottom strip: Volunteering | Certificates | References
        pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                sectionHead(cv.volunteeringTitle),
                ...cv.volunteering.map(volItem),
              ],
            )),
            pw.SizedBox(width: 14),
            pw.Expanded(child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                sectionHead(cv.certificatesTitle),
                ...cv.certificates.map((c) => pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 4),
                  child: pw.Row(children: [
                    bullet(_cAccent),
                    pw.Expanded(child: pw.Text(c, style: ts(10))),
                  ]),
                )),
              ],
            )),
            pw.SizedBox(width: 14),
            pw.Expanded(child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                sectionHead(cv.referencesTitle),
                ...cv.references.map(refCard),
              ],
            )),
          ],
        ),
      ],
    ),
  ));

  return doc.save();
}
