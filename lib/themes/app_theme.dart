import 'package:flutter/material.dart';
import 'colors.dart'; // Importieren Sie die benutzerdefinierten Farben

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // Verwenden Sie hier Ihre benutzerdefinierten Farben
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      colorScheme: ColorScheme(
        primary: primaryColor,
        primaryContainer: primaryColor.withOpacity(0.8),
        secondary: secondaryColor,
        secondaryContainer: secondaryColor.withOpacity(0.8),
        surface: surfaceColor,
        error: errorColor,
        onPrimary: onPrimaryColor,
        onSecondary: onSecondaryColor,
        onSurface: onSurfaceColor,
        onError: onErrorColor,
        brightness: Brightness.light,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: onPrimaryColor,
      ),
      textTheme: _customTextTheme,
      useMaterial3: true,
    );
  }

  static const TextTheme _customTextTheme = TextTheme(
    displayLarge: TextStyle(
      fontFamily: 'Roquefort',
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: TextStyle(
      fontFamily: 'Roquefort',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displaySmall: TextStyle(
      fontFamily: 'Roquefort',
      fontSize: 16,
      fontWeight: FontWeight.bold,
      color: Color.fromARGB(127, 0, 0, 0),
    ),
    bodyLarge: TextStyle(
        fontFamily: 'Roquefort',
        fontSize: 18,
        fontWeight: FontWeight.normal,
        color: secondaryColor),
    bodyMedium: TextStyle(
        fontFamily: 'Roquefort',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondaryColor),
    bodySmall: TextStyle(
        fontFamily: 'Roquefort',
        fontSize: 10,
        fontWeight: FontWeight.normal,
        color: secondaryColor),
    labelLarge: TextStyle(
      fontFamily: 'Roquefort',
      fontSize: 22,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontFamily: 'Roquefort',
      fontSize: 20,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    labelSmall: TextStyle(
      fontFamily: 'Roquefort',
      fontSize: 14,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
  );
}
