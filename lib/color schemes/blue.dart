import 'package:flutter/material.dart';

// The blue color scheme is a cool, futuristic palette.
const ColorScheme blueColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF977DFF), // A medium purple-blue. Used for key UI elements.
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFF2E6EE), // A very light lilac.
  onPrimaryContainer: Color(0xFF977DFF),
  secondary: Color(0xFF0033FF), // A vibrant electric blue.
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFFCCCF2), // A very light pink.
  onSecondaryContainer: Color(0xFF0033FF),
  tertiary: Color(0xFF0600AB), // A deep, dark blue.
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFF00033D), // An extremely dark blue.
  onTertiaryContainer: Colors.white,
  error: Color(0xFFCF6679),
  onError: Colors.black,
  errorContainer: Color(0xFFF2DDE1),
  onErrorContainer: Color(0xFF3B101C),
  background: Color(0xFF131326), // A deep, dark blue background.
  onBackground: Color(0xFFD6D5D5),
  surface: Color(0xFF212133), // A slightly lighter dark blue for surfaces.
  onSurface: Color(0xFFD6D5D5),
  surfaceVariant: Color(0xFF3A3A52), // A dark grey-blue for less prominent elements.
  onSurfaceVariant: Color(0xFFD6D5D5),
  outline: Color(0xFF3A3A52),
  shadow: Colors.black,
  inverseSurface: Color(0xFFD6D5D5),
  onInverseSurface: Color(0xFF1B1B1B),
  inversePrimary: Color(0xFF00033D),
);

// Gradient for the blue theme.
const LinearGradient blueGradient = LinearGradient(
  colors: [
    Color(0xFFF2E6EE),
    Color(0xFF977DFF),
    Color(0xFF0033FF),
    Color(0xFF0600AB),
    Color(0xFF00033D),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

ThemeData buildBlueTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: blueColorScheme,
    scaffoldBackgroundColor: blueColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: blueColorScheme.primary,
      foregroundColor: blueColorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: blueColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: blueColorScheme.onBackground),
      bodyMedium: TextStyle(color: blueColorScheme.onBackground),
      titleLarge: TextStyle(
        color: blueColorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: blueColorScheme.primary,
        foregroundColor: blueColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: blueColorScheme.primary,
        side: BorderSide(color: blueColorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: blueColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: blueColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: blueColorScheme.primary, width: 2),
      ),
      labelStyle: TextStyle(color: blueColorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: blueColorScheme.onSurfaceVariant),
    ),
    cardTheme: CardTheme(
      color: blueColorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: blueColorScheme.secondary,
      foregroundColor: blueColorScheme.onSecondary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: blueColorScheme.surface,
      selectedItemColor: blueColorScheme.primary,
      unselectedItemColor: blueColorScheme.onSurfaceVariant,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: blueColorScheme.surfaceVariant,
      selectedColor: blueColorScheme.primary,
      labelStyle: TextStyle(color: blueColorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: blueColorScheme.outline,
      thickness: 1,
    ),
  );
}
