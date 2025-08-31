import 'package:flutter/material.dart';

// The green color scheme is a vibrant, nature-inspired palette.
const ColorScheme greenColorScheme = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF076653), // A deep, rich green. Used for key UI elements like buttons and icons.
  onPrimary: Colors.white,
  primaryContainer: Color(0xFFE2FBCE), // A very light, muted green. Used for containers with high contrast.
  onPrimaryContainer: Color(0xFF076653),
  secondary: Color(0xFF0C342C), // A very dark teal. Used for secondary actions and text.
  onSecondary: Colors.white,
  secondaryContainer: Color(0xFFE3EF26), // A bright, almost lime green.
  onSecondaryContainer: Color(0xFF0C342C),
  tertiary: Color(0xFF06231D), // A very dark green.
  onTertiary: Colors.white,
  tertiaryContainer: Color(0xFFFFFDEE), // A very light cream color.
  onTertiaryContainer: Color(0xFF06231D),
  error: Color(0xFFCF6679),
  onError: Colors.black,
  errorContainer: Color(0xFFF2DDE1),
  onErrorContainer: Color(0xFF3B101C),
  background: Color(0xFF1B1B1B), // A dark background color.
  onBackground: Color(0xFFD6D5D5),
  surface: Color(0xFF282828), // A slightly lighter dark color for surfaces like cards and sheets.
  onSurface: Color(0xFFD6D5D5),
  surfaceVariant: Color(0xFF4C4C4C), // A darker grey for less prominent elements.
  onSurfaceVariant: Color(0xFFD6D5D5),
  outline: Color(0xFF4C4C4C), // A light grey for borders.
  shadow: Colors.black,
  inverseSurface: Color(0xFFD6D5D5),
  onInverseSurface: Color(0xFF1B1B1B),
  inversePrimary: Color(0xFF326B50),
);

// Gradient for the green theme.
const LinearGradient greenGradient = LinearGradient(
  colors: [
    Color(0xFFE3EF26),
    Color(0xFF076653),
    Color(0xFF06231D),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

ThemeData buildGreenTheme() {
  return ThemeData(
    useMaterial3: true,
    colorScheme: greenColorScheme,
    scaffoldBackgroundColor: greenColorScheme.background,
    appBarTheme: AppBarTheme(
      backgroundColor: greenColorScheme.primary,
      foregroundColor: greenColorScheme.onPrimary,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: greenColorScheme.onPrimary,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: greenColorScheme.onBackground),
      bodyMedium: TextStyle(color: greenColorScheme.onBackground),
      titleLarge: TextStyle(
        color: greenColorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: greenColorScheme.primary,
        foregroundColor: greenColorScheme.onPrimary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: greenColorScheme.primary,
        side: BorderSide(color: greenColorScheme.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: greenColorScheme.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: greenColorScheme.outline),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: greenColorScheme.primary, width: 2),
      ),
      labelStyle: TextStyle(color: greenColorScheme.onSurfaceVariant),
      hintStyle: TextStyle(color: greenColorScheme.onSurfaceVariant),
    ),
    cardTheme: CardTheme(
      color: greenColorScheme.surface,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: greenColorScheme.secondary,
      foregroundColor: greenColorScheme.onSecondary,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: greenColorScheme.surface,
      selectedItemColor: greenColorScheme.primary,
      unselectedItemColor: greenColorScheme.onSurfaceVariant,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: greenColorScheme.surfaceVariant,
      selectedColor: greenColorScheme.primary,
      labelStyle: TextStyle(color: greenColorScheme.onSurface),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: greenColorScheme.outline,
      thickness: 1,
    ),
  );
}
