import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  desktop,
  web
}

enum OperatingSystem {
  android,
  iOS,
  windows,
  macOS,
  linux,
  web,
  unknown
}

class PlatformDetector {
  /// Detects the current operating system
  static OperatingSystem getCurrentOS() {
    if (kIsWeb) {
      // For web, we detect the underlying OS from user agent
      return _detectWebOS();
    }

    try {
      if (Platform.isAndroid) {
        return OperatingSystem.android;
      } else if (Platform.isIOS) {
        return OperatingSystem.iOS;
      } else if (Platform.isWindows) {
        return OperatingSystem.windows;
      } else if (Platform.isMacOS) {
        return OperatingSystem.macOS;
      } else if (Platform.isLinux) {
        return OperatingSystem.linux;
      }
    } catch (e) {
      // Handle cases where Platform detection fails
      print('Platform detection error: $e');
    }

    return OperatingSystem.unknown;
  }

  /// Detects OS when running on web platform
  static OperatingSystem _detectWebOS() {
    // In a real implementation, you could use dart:html to check navigator.userAgent
    // For now, we'll return web as the OS type
    return OperatingSystem.web;
  }

  /// Returns a user-friendly display name for the OS
  static String getOSDisplayName(OperatingSystem os) {
    switch (os) {
      case OperatingSystem.android:
        return 'Android';
      case OperatingSystem.iOS:
        return 'iOS';
      case OperatingSystem.windows:
        return 'Windows';
      case OperatingSystem.macOS:
        return 'macOS';
      case OperatingSystem.linux:
        return 'Linux';
      case OperatingSystem.web:
        return 'Web Browser';
      case OperatingSystem.unknown:
        return 'Unknown OS';
    }
  }

  /// Returns an appropriate Material icon for the OS
  static IconData getOSIcon(OperatingSystem os) {
    switch (os) {
      case OperatingSystem.android:
        return Icons.smartphone;
      case OperatingSystem.iOS:
        return Icons.phone_iphone;
      case OperatingSystem.windows:
        return Icons.computer;
      case OperatingSystem.macOS:
        return Icons.laptop_mac;
      case OperatingSystem.linux:
        return Icons.developer_board;
      case OperatingSystem.web:
        return Icons.language;
      case OperatingSystem.unknown:
        return Icons.help_outline;
    }
  }

  /// Determines device type based on screen width
  static DeviceType getDeviceType(double screenWidth) {
    if (kIsWeb) {
      return DeviceType.web;
    }

    if (screenWidth < 600) {
      return DeviceType.mobile;
    } else if (screenWidth < 1024) {
      return DeviceType.tablet;
    } else {
      return DeviceType.desktop;
    }
  }

  /// Checks if the OS supports secure data wiping
  static bool isSupportedForWiping(OperatingSystem os) {
    return os == OperatingSystem.android ||
           os == OperatingSystem.windows ||
           os == OperatingSystem.linux;
  }

  /// Returns OS version information (placeholder for real implementation)
  static String getOSVersion(OperatingSystem os) {
    switch (os) {
      case OperatingSystem.android:
        return 'Android 10+';
      case OperatingSystem.windows:
        return 'Windows 10/11';
      case OperatingSystem.linux:
        return 'Linux Distribution';
      case OperatingSystem.iOS:
        return 'iOS 13+';
      case OperatingSystem.macOS:
        return 'macOS 10.15+';
      case OperatingSystem.web:
        return 'Modern Browser';
      case OperatingSystem.unknown:
        return 'Unknown Version';
    }
  }

  /// Returns additional OS details for display
  static Map<String, String> getOSDetails(OperatingSystem os) {
    switch (os) {
      case OperatingSystem.android:
        return {
          'platform': 'Mobile',
          'architecture': 'ARM/x64',
          'wiping_support': 'Full Support',
        };
      case OperatingSystem.windows:
        return {
          'platform': 'Desktop',
          'architecture': 'x64',
          'wiping_support': 'Full Support',
        };
      case OperatingSystem.linux:
        return {
          'platform': 'Desktop/Server',
          'architecture': 'x64/ARM',
          'wiping_support': 'Full Support',
        };
      case OperatingSystem.iOS:
        return {
          'platform': 'Mobile',
          'architecture': 'ARM',
          'wiping_support': 'Limited Support',
        };
      case OperatingSystem.macOS:
        return {
          'platform': 'Desktop',
          'architecture': 'Intel/Apple Silicon',
          'wiping_support': 'Limited Support',
        };
      case OperatingSystem.web:
        return {
          'platform': 'Web Browser',
          'architecture': 'Various',
          'wiping_support': 'Not Supported',
        };
      default:
        return {
          'platform': 'Unknown',
          'architecture': 'Unknown',
          'wiping_support': 'Not Supported',
        };
    }
  }
}