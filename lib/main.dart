import 'package:flutter/material.dart';
import 'package:forex_aploader/bank_list.dart';

import 'menu.dart';

void main() {
  final ColorScheme colorScheme = ColorScheme(
    primary: Colors.blueGrey[900]!, // Dark grey for primary elements
    primaryContainer: Colors.blueGrey[700]!, // Slightly lighter grey for containers
    secondary: Colors.blueGrey[600]!, // Secondary grey
    secondaryContainer: Colors.blueGrey[500]!, // Container for secondary color
    surface: Colors.blueGrey[900]!, // Background color for surfaces like cards
    background: Colors.blueGrey[900]!, // Overall background color
    error: Colors.red, // Error color
    onPrimary: Colors.white, // Text/icon color on primary elements
    onSecondary: Colors.white, // Text/icon color on secondary elements
    onSurface: Colors.white, // Text/icon color on surfaces
    onBackground: Colors.white, // Text color on background
    onError: Colors.white, // Text color on error surfaces
    brightness: Brightness.dark, // Overall brightness
  );

  final containerThemeData = ContainerDecorations(
  );

  runApp(

  MaterialApp(
    debugShowCheckedModeBanner: false,
  //debugShowMaterialGrid: true,
  title: 'CSV File Upload',
    theme: ThemeData(
      colorScheme: colorScheme,
      primaryColor: Colors.blueGrey[900], // Shaded grey for title bar
      scaffoldBackgroundColor: Colors.blueGrey[400], // Grey background
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.blueGrey[900], // Shaded grey for app bar
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // White text in app bar
        ),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey[900], // Button background color
          foregroundColor: Colors.white, // Button text color
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.blueGrey[600], // Grey background for input fields
        hintStyle: const TextStyle(color: Colors.white54),
        labelStyle: const TextStyle(color: Colors.white),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade900),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueGrey.shade100),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.white),
        ),

      ),
    ),
  home: const Scaffold(body: Menu()),//CSVJSON(),
  )


      );
}

class ContainerDecorations {
  static BoxDecoration get decoration {
    return BoxDecoration(
      color: Colors.grey[900], // Surface color
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 6.0,
          offset: Offset(0, 2),
        ),
      ],
      border: Border.all(
        color: Colors.white.withOpacity(0.5), // Border color
      ),
    );
  }
}