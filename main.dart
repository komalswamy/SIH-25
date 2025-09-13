import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'screens/home_screen.dart';
import 'utils/constants.dart';

void main() {
  runApp(SecureDataWipeApp());
}

class SecureDataWipeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Secure Data Wiping for Trustworthy IT Asset Recycling',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: AppConstants.primaryBlue,
        scaffoldBackgroundColor: AppConstants.lightGray,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppConstants.darkGray,
          ),
          headlineMedium: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: AppConstants.darkGray,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            color: AppConstants.darkGray,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            color: AppConstants.mediumGray,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppConstants.primaryBlue,
            foregroundColor: Colors.white,
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.all(8),
        ),
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}