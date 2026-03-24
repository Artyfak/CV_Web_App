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
  bool _isDark = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Filip Konštiak — CV',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: _isDark ? Brightness.dark : Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C6FF7),
          brightness: _isDark ? Brightness.dark : Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(
          _isDark ? ThemeData.dark().textTheme : ThemeData.light().textTheme,
        ),
        useMaterial3: true,
      ),
      home: CVPage(
        isSlovak: _isSlovak,
        isDark: _isDark,
        onToggleLanguage: () => setState(() => _isSlovak = !_isSlovak),
        onToggleTheme: () => setState(() => _isDark = !_isDark),
      ),
    );
  }
}
