import 'package:flutter/material.dart';

const ColorScheme redColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF660F24),
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFFFDBE8),
  onPrimaryContainer: Color(0xFF660F24),
  secondary: Color(0xFFF24455),
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFFF94B2),
  onSecondaryContainer: Color(0xFFF24455),
  tertiary: Color(0xFF2B0013),
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFE5203A),
  onTertiaryContainer: Color(0xFF2B0013),
  error: Color(0xFFCF6679),
  onError: Colors.black,
  background: Color(0xFF1A0A0E),
  onBackground: Color(0xFFD6D5D5),
  surface: Color(0xFF2B161B),
  onSurface: Color(0xFFD6D5D5),
  surfaceVariant: Color(0xFF4C3035),
  onSurfaceVariant: Color(0xFFD6D5D5),
  outline: Color(0xFF4C3035),
  shadow: Colors.black,
  inverseSurface: Color(0xFFD6D5D5),
  onInverseSurface: Color(0xFF1A0A0E),
  inversePrimary: Color(0xFF2B0013),
);

const LinearGradient redGradient = LinearGradient(
  colors: [
    Color(0xFFFFDBE8),
    Color(0xFFFF94B2),
    Color(0xFFF24455),
    Color(0xFFE5203A),
    Color(0xFF660F24),
    Color(0xFF2B0013),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

ThemeData buildRedTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: redColorScheme,
    scaffoldBackgroundColor: redColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: redColorScheme.primary,
      foregroundColor: redColorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: redColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: redColorScheme.onBackground),
      bodyMedium: TextStyle(color: redColorScheme.onBackground),
      titleLarge: TextStyle(
        color: redColorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: redColorScheme.primary,
        foregroundColor: redColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: redColorScheme.primary,
        side: BorderSide(color: redColorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: redColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: redColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: redColorScheme.primary, width: 2),
      ),
      labelStyle: TextStyle(color: redColorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: redColorScheme.onSurfaceVariant),
    ),
    cardTheme: CardTheme(
      color: redColorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: redColorScheme.secondary,
      foregroundColor: redColorScheme.onSecondary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: redColorScheme.surface,
      selectedItemColor: redColorScheme.primary,
      unselectedItemColor: redColorScheme.onSurfaceVariant,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: redColorScheme.surfaceVariant,
      selectedColor: redColorScheme.primary,
      labelStyle: TextStyle(color: redColorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: redColorScheme.outline,
      thickness: 1,
    ),
  );
}
