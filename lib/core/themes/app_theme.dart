import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Couleurs Premium
  static const Color darkBackground = Color(0xFF0A0A0A); // Noir très profond
  static const Color surfaceColor =
      Color(0xFF1E1E1E); // Gris sombre pour surface
  static const Color neonGreen = Color(0xFFCCFF00); // Vert Cyberpunk
  static const Color neonBlue = Color(0xFF00F3FF); // Bleu Néon (Cyan)
  static const Color neonPurple = Color(0xFFBB86FC); // Purple Néon
  static const Color neonOrange = Color(0xFFFF9900); // Orange Néon
  static const Color electricBlue =
      Color(0xFF2962FF); // Bleu électrique (secondaire)
  static const Color errorRed = Color(0xFFFF3366);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: darkBackground,
      primaryColor: neonGreen,

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: neonGreen,
        secondary: electricBlue,
        surface: surfaceColor,
        background: darkBackground,
        error: errorRed,
        onPrimary: Colors.black, // Texte sur le vert néon
        onSurface: Colors.white,
      ),

      // Typographie
      textTheme:
          GoogleFonts.outfitTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 32,
        ),
        headlineMedium: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.outfit(
          color: Colors.white70,
          fontSize: 16,
        ),
      ),

      // App Bar Transparente
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Outfit',
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      // Boutons Néon
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: neonGreen,
          foregroundColor: Colors.black, // Texte noir sur vert
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),

      // Floating Action Button
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: neonGreen,
        foregroundColor: Colors.black,
      ),

      // Champs de texte modernes
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor.withOpacity(0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: neonGreen, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
        prefixIconColor: Colors.white54,
      ),

      // Cards par défaut (si on n'utilise pas le Glass)
      cardTheme: CardThemeData(
        color: surfaceColor.withOpacity(0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  // On garde le light theme minimaliste au cas où, mais on force le dark par défaut dans main
  static ThemeData get lightTheme => darkTheme;
}
