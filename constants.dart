import 'package:flutter/material.dart';

class AppConstants {
  // Colors
  static const Color primaryBlue = Color(0xFF1565C0);
  static const Color successGreen = Color(0xFF4CAF50);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color dangerRed = Color(0xFFE53935);
  static const Color lightGray = Color(0xFFF5F5F5);
  static const Color mediumGray = Color(0xFF757575);
  static const Color darkGray = Color(0xFF212121);

  // Strings
  static const String appTitle = 'Secure Data Wiping';
  static const String appSubtitle = 'Trustworthy IT Asset Recycling';
  static const String wipeButtonText = 'Wipe and Clear All Data';
  static const String detectingOS = 'Detecting Operating System...';
  static const String confirmWipe = 'Confirm Data Wipe';
  static const String wipeWarning = 
    'This action will permanently delete all data on this device. '
    'This operation cannot be undone. Are you sure you want to continue?';

  // Sizing
  static const double cardPadding = 16.0;
  static const double defaultMargin = 16.0;
  static const double buttonHeight = 56.0;
  static const double iconSize = 48.0;

  // Breakpoints for responsive design
  static const double mobileBreakpoint = 600;
  static const double tabletBreakpoint = 1024;

  // Wiping Methods
  static const List<Map<String, dynamic>> wipingMethods = [
    {
      'id': 'dod',
      'name': 'DoD 5220.22-M',
      'passes': 3,
      'description': 'US Department of Defense standard - Military-grade secure deletion'
    },
    {
      'id': 'nist',
      'name': 'NIST SP 800-88',
      'passes': 1,
      'description': 'NIST Guidelines for Media Sanitization - Single secure pass'
    },
    {
      'id': 'gutmann',
      'name': 'Gutmann',
      'passes': 35,
      'description': 'Peter Gutmann\'s 35-pass algorithm - Maximum security'
    },
  ];

  // Animation Durations
  static const Duration defaultAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
  static const Duration progressUpdateDuration = Duration(milliseconds: 2000);
}