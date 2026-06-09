import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ─── Palette (Inspired by the Teal Moody Design) ──────────────────────────
  static const Color _primaryTeal = Color(0xFF00F2CC);
  static const Color _accentTeal = Color(0xFF00D7C3);
  static const Color _darkBg = Color(0xFF080E11);
  static const Color _darkSurface = Color(0xFF121E21);
  static const Color _darkCard = Color(0xFF17262B);
  static const Color _darkBorder = Color(0x3300F2CC); // Teal with 20% opacity
  static const Color _textPrimary = Colors.white;
  static const Color _textSecondary = Color(0xFF94A3B8);

  // ─── Radius ────────────────────────────────────────────────────────────────
  static final BorderRadius _cardRadius = BorderRadius.circular(32);
  static final BorderRadius _buttonRadius = BorderRadius.circular(16);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBg,
      colorScheme: const ColorScheme.dark(
        primary: _primaryTeal,
        onPrimary: Colors.black,
        secondary: _accentTeal,
        surface: _darkSurface,
        onSurface: _textPrimary,
        error: Color(0xFFFF4D4D),
      ),
      textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(color: _textPrimary, fontWeight: FontWeight.bold),
        titleLarge: const TextStyle(color: _textPrimary, fontWeight: FontWeight.w600),
        bodyLarge: const TextStyle(color: _textPrimary),
        bodyMedium: const TextStyle(color: _textSecondary),
      ),

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),

      // Cards with Glow-ready style
      cardTheme: CardThemeData(
        color: _darkCard,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: _cardRadius,
          side: const BorderSide(color: _darkBorder, width: 1),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryTeal,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: _buttonRadius),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
          elevation: 0,
          shadowColor: _primaryTeal.withAlpha(150),
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withOpacity(0.05),
        border: OutlineInputBorder(
          borderRadius: _buttonRadius,
          borderSide: const BorderSide(color: _darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _buttonRadius,
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _buttonRadius,
          borderSide: const BorderSide(color: _primaryTeal, width: 2),
        ),
        labelStyle: const TextStyle(color: _textSecondary),
        hintStyle: const TextStyle(color: _textSecondary),
        prefixIconColor: _textSecondary,
      ),

      // Bottom Navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkBg,
        selectedItemColor: _primaryTeal,
        unselectedItemColor: _textSecondary,
        elevation: 0,
      ),
    );
  }

  // Helper for that specific background gradient/glow
  static BoxDecoration get moodyGradientBackground {
    return const BoxDecoration(
      gradient: RadialGradient(
        center: Alignment(-0.3, -0.4),
        radius: 1.5,
        colors: [
          Color(0xFF0D3B36), // More pronounced teal glow
          Color(0xFF080E11), // Deep dark background
        ],
        stops: [0.0, 1.0],
      ),
    );
  }

  // Helper for a glowing effect on containers
  static BoxDecoration glowDecoration({Color? color, double opacity = 0.2, double blur = 40}) {
    return BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: (color ?? _primaryTeal).withOpacity(opacity),
          blurRadius: blur,
          spreadRadius: blur / 4,
        ),
      ],
    );
  }

  static ThemeData get lightTheme => darkTheme;
}
