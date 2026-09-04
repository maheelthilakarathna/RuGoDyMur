import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const navy = Color(0xFF2F3C7E);
  static const coral = Color(0xFFF96167);
  static const chipBg = Color(0xFFECEEF6);
  static const tint = Color(0xFFDCE1F0);
  static const tintDeep = Color(0xFFB9C2E3);
  static const fieldBg = Color(0xFFF4F5FA);
  static const border = Color(0xFFD7D9E6);
  static const star = Color(0xFFF9E795);
  static const bodyTextLight = Color(0xFF3A3A3A);
  static const navRail = Color(0xFF2F3C7E);
  static const navRailMuted = Color(0xFFC7CCE8);
}

class AppTheme {
  AppTheme._();

  static const _headingFont = 'serif';

  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: Brightness.light,
      primary: AppColors.navy,
      secondary: AppColors.coral,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: scheme,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.navy,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontFamily: _headingFont,
          fontWeight: FontWeight.bold,
          color: AppColors.navy,
        ),
        titleLarge: TextStyle(
          fontFamily: _headingFont,
          fontWeight: FontWeight.bold,
          color: AppColors.navy,
        ),
        titleMedium: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A3A3A)),
        bodyMedium: TextStyle(color: Color(0xFF3A3A3A)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.coral,
        unselectedItemColor: Color(0xFF9AA0B4),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.fieldBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.navy, width: 1.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
      ),
    );
  }

  static ThemeData dark() {
    const surface = Color(0xFF14172A);
    const card = Color(0xFF1D2140);
    final scheme = ColorScheme.fromSeed(
      seedColor: AppColors.navy,
      brightness: Brightness.dark,
      primary: const Color(0xFF8C97D6),
      secondary: AppColors.coral,
      surface: surface,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: surface,
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontFamily: _headingFont,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: TextStyle(
          fontFamily: _headingFont,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        bodyMedium: TextStyle(color: Color(0xFFD7D9E6)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: AppColors.coral,
        unselectedItemColor: Color(0xFF8A8FA8),
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.coral,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          textStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.coral, width: 1.6),
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
    );
  }
}

IconData iconForName(String name) {
  const map = <String, IconData>{
    'pets': Icons.pets,
    'restaurant': Icons.restaurant,
    'set_meal': Icons.set_meal,
    'toys': Icons.toys,
    'sports_baseball': Icons.sports_baseball,
    'auto_awesome': Icons.auto_awesome,
    'extension': Icons.extension,
    'link': Icons.link,
    'content_cut': Icons.content_cut,
    'bathtub': Icons.bathtub,
    'brush': Icons.brush,
    'favorite': Icons.favorite,
    'opacity': Icons.opacity,
    'medication': Icons.medication,
    'healing': Icons.healing,
    'shopping_bag': Icons.shopping_bag,
    'park': Icons.park,
    'bed': Icons.bed,
    'ramen_dining': Icons.ramen_dining,
  };
  return map[name] ?? Icons.pets;
}
