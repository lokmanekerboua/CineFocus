import 'package:flutter/material.dart';

class AppTheme {
  // ─── Palette commune ───────────────────────────────────────────────────────
  static const Color _seedColor = Colors.deepPurple;

  // Dark
  static const Color _darkBg        = Color(0xFF0D0B14);
  static const Color _darkSurface   = Color(0xFF16121F);
  static const Color _darkCard      = Color(0xFF1E1829);
  static const Color _darkBorder    = Color(0x1AFFFFFF); // white 10 %
  static const Color _darkFill      = Color(0x0DFFFFFF); // white 5 %
  static const Color _darkLabel     = Color(0xB3FFFFFF); // white 70 %
  static const Color _darkHint      = Color(0x61FFFFFF); // white 38 %
  static const Color _darkAccent    = Color(0xFF7C4DFF); // deep purple 400
  static const Color _darkOnSurface = Color(0xFFEDE7FF);

  // Light
  static const Color _lightBg        = Color(0xFFF5F3FF);
  static const Color _lightSurface   = Color(0xFFFFFFFF);
  static const Color _lightCard      = Color(0xFFFFFFFF);
  static const Color _lightBorder    = Color(0x1A5E35B1); // purple 10 %
  static const Color _lightFill      = Color(0x0A5E35B1); // purple 4 %
  static const Color _lightLabel     = Color(0xFF4A3B6B);
  static const Color _lightHint      = Color(0xFF9E8FBB);
  static const Color _lightAccent    = Color(0xFF6200EE);
  static const Color _lightOnSurface = Color(0xFF1A0E2E);

  // ─── Radius ────────────────────────────────────────────────────────────────
  static final BorderRadius _cardRadius  = BorderRadius.circular(20);
  static final BorderRadius _inputRadius = BorderRadius.circular(16);

  // ───────────────────────────────────────────────────────────────────────────
  // DARK THEME
  // ───────────────────────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: _seedColor,
      scaffoldBackgroundColor: _darkBg,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _darkOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _darkOnSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: _darkCard,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: _cardRadius,
          side: const BorderSide(color: _darkBorder),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkFill,
        border: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: _darkAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: Color(0xFFCF6679), width: 2),
        ),
        labelStyle: const TextStyle(color: _darkLabel),
        hintStyle: const TextStyle(color: _darkHint),
        floatingLabelStyle: const TextStyle(color: _darkAccent),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkAccent,
          side: const BorderSide(color: _darkAccent),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _darkSurface,
        selectedItemColor: _darkAccent,
        unselectedItemColor: _darkHint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // Navigation bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _darkSurface,
        indicatorColor: _darkAccent.withOpacity(0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _darkAccent);
          }
          return const IconThemeData(color: _darkHint);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: _darkAccent,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return const TextStyle(color: _darkHint, fontSize: 12);
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: _darkBorder,
        thickness: 1,
        space: 1,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: _darkFill,
        labelStyle: const TextStyle(color: _darkOnSurface),
        side: const BorderSide(color: _darkBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkCard,
        contentTextStyle: const TextStyle(color: _darkOnSurface),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _darkAccent;
          return _darkHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _darkAccent.withOpacity(0.3);
          }
          return _darkFill;
        }),
      ),
    );
  }

  // ───────────────────────────────────────────────────────────────────────────
  // LIGHT THEME
  // ───────────────────────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: _seedColor,
      scaffoldBackgroundColor: _lightBg,

      // AppBar
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBg,
        surfaceTintColor: Colors.transparent,
        foregroundColor: _lightOnSurface,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: _lightOnSurface,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
        ),
      ),

      // Cards
      cardTheme: CardThemeData(
        color: _lightCard,
        surfaceTintColor: Colors.transparent,
        elevation: 2,
        shadowColor: const Color(0x1A6200EE),
        shape: RoundedRectangleBorder(
          borderRadius: _cardRadius,
          side: const BorderSide(color: _lightBorder),
        ),
        clipBehavior: Clip.antiAlias,
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightFill,
        border: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: _lightAccent, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: Color(0xFFB00020), width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: _inputRadius,
          borderSide: const BorderSide(color: Color(0xFFB00020), width: 2),
        ),
        labelStyle: const TextStyle(color: _lightLabel),
        hintStyle: const TextStyle(color: _lightHint),
        floatingLabelStyle: const TextStyle(color: _lightAccent),
      ),

      // Elevated button
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightAccent,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Text button
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightAccent,
          textStyle: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined button
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightAccent,
          side: const BorderSide(color: _lightAccent),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),

      // Bottom navigation
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: _lightSurface,
        selectedItemColor: _lightAccent,
        unselectedItemColor: _lightHint,
        type: BottomNavigationBarType.fixed,
        elevation: 4,
      ),

      // Navigation bar (Material 3)
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: _lightSurface,
        indicatorColor: _lightAccent.withOpacity(0.12),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: _lightAccent);
          }
          return IconThemeData(color: _lightHint);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              color: _lightAccent,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            );
          }
          return TextStyle(color: _lightHint, fontSize: 12);
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: _lightBorder,
        thickness: 1,
        space: 1,
      ),

      // Chip
      chipTheme: ChipThemeData(
        backgroundColor: _lightFill,
        labelStyle: TextStyle(color: _lightOnSurface),
        side: const BorderSide(color: _lightBorder),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),

      // Snackbar
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _lightOnSurface,
        contentTextStyle: const TextStyle(color: Colors.white),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),

      // Dialog
      dialogTheme: DialogThemeData(
        backgroundColor: _lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return _lightAccent;
          return _lightHint;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return _lightAccent.withOpacity(0.25);
          }
          return _lightFill;
        }),
      ),
    );
  }
}