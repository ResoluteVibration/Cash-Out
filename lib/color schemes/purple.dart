import 'package:flutter/material.dart';

// The purple color scheme is a dynamic, vivid palette.
const ColorScheme purpleColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF7226FF), // A bright purple. Used for key UI elements.
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFFFE5F1), // A very light, soft pink.
  onPrimaryContainer: Color(0xFF7226FF),
  secondary: Color(0xFFF042FF), // A vibrant magenta.
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFF87F5F5), // A bright cyan.
  onSecondaryContainer: Color(0xFFF042FF),
  tertiary: Color(0xFF160078), // A very deep purple-blue.
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFF010030), // An extremely dark, muted purple.
  onTertiaryContainer: Colors.white,
  error: Color(0xFFCF6679),
  onError: Colors.black,
  errorContainer: Color(0xFFF2DDE1),
  onErrorContainer: Color(0xFF3B101C),
  background: Color(0xFF131326), // A deep, dark purple background.
  onBackground: Color(0xFFD6D5D5),
  surface: Color(0xFF212133), // A slightly lighter dark purple for surfaces.
  onSurface: Color(0xFFD6D5D5),
  surfaceVariant: Color(0xFF3A3A52), // A dark grey-purple for less prominent elements.
  onSurfaceVariant: Color(0xFFD6D5D5),
  outline: Color(0xFF3A3A52),
  shadow: Colors.black,
  inverseSurface: Color(0xFFD6D5D5),
  onInverseSurface: Color(0xFF1B1B1B),
  inversePrimary: Color(0xFF010030),
);

// Gradient for the purple theme.
const LinearGradient purpleGradient = LinearGradient(
  colors: [
    Color(0xFFFFE5F1),
    Color(0xFFF042FF),
    Color(0xFF7226FF),
    Color(0xFF160078),
    Color(0xFF010030),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

ThemeData buildPurpleTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: purpleColorScheme,
    scaffoldBackgroundColor: purpleColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: purpleColorScheme.primary,
      foregroundColor: purpleColorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: purpleColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: purpleColorScheme.onBackground),
      bodyMedium: TextStyle(color: purpleColorScheme.onBackground),
      titleLarge: TextStyle(
        color: purpleColorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: purpleColorScheme.primary,
        foregroundColor: purpleColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: purpleColorScheme.primary,
        side: BorderSide(color: purpleColorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: purpleColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: purpleColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: purpleColorScheme.primary, width: 2),
      ),
      labelStyle: TextStyle(color: purpleColorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: purpleColorScheme.onSurfaceVariant),
    ),
    cardTheme: CardTheme(
      color: purpleColorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: purpleColorScheme.secondary,
      foregroundColor: purpleColorScheme.onSecondary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: purpleColorScheme.surface,
      selectedItemColor: purpleColorScheme.primary,
      unselectedItemColor: purpleColorScheme.onSurfaceVariant,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: purpleColorScheme.surfaceVariant,
      selectedColor: purpleColorScheme.primary,
      labelStyle: TextStyle(color: purpleColorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: purpleColorScheme.outline,
      thickness: 1,
    ),
  );
}
