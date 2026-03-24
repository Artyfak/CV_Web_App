import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'cv_page.dart';

void main() {
  runApp(const CVApp());
}

class CVApp extends StatefulWidget {
  const CVApp({super.key});

  @override
  State<CVApp> createState() => _CVAppState();
}

class _CVAppState extends State<CVApp> {
  bool _isSlovak = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filip Konštiak — CV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7C6FF7),
          secondary: Color(0xFF00D4AA),
          surface: Color(0xFF12121A),
        ),
        textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
        useMaterial3: true,
      ),
      home: CVPage(
        isSlovak: _isSlovak,
        onToggleLanguage: () => setState(() => _isSlovak = !_isSlovak),
      ),
    );
  }
}
