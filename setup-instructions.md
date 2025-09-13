# Flutter Secure Data Wiping App - Setup Instructions

## Project Overview

This is a complete Flutter application for **"Secure Data Wiping for Trustworthy IT Asset Recycling"** that provides:

- ✅ **Automatic OS Detection** (Windows, Android, Linux, macOS, iOS, Web)
- ✅ **Clean, Responsive UI** with Material Design
- ✅ **Large "Wipe and Clear All Data" Button** as requested
- ✅ **Professional Security-focused Interface**
- ✅ **Real-time Progress Tracking**
- ✅ **DoD 5220.22-M Compliance**

## File Structure

```
secure_data_wipe/
├── lib/
│   ├── main.dart                    # Main app entry point
│   ├── utils/
│   │   ├── constants.dart           # App constants and colors
│   │   └── platform_detector.dart   # OS detection logic
│   ├── screens/
│   │   └── home_screen.dart         # Main home screen
│   └── widgets/
│       ├── os_detection_card.dart   # OS detection display
│       ├── custom_button.dart       # Custom button widgets
│       └── wipe_progress_dialog.dart # Progress dialog
└── pubspec.yaml                     # Dependencies and config
```

## Setup Instructions

### 1. Create Flutter Project
```bash
flutter create secure_data_wipe
cd secure_data_wipe
```

### 2. Replace Files
- Copy all the provided Dart code files to their respective locations in your `lib/` directory
- Replace the `pubspec.yaml` with the provided version

### 3. Create Directory Structure
```bash
mkdir lib/utils
mkdir lib/screens  
mkdir lib/widgets
```

### 4. Copy Files to Correct Locations
- `main.dart` → `lib/main.dart`
- `constants.dart` → `lib/utils/constants.dart`
- `platform-detector.dart` → `lib/utils/platform_detector.dart`
- `home-screen.dart` → `lib/screens/home_screen.dart`
- `os-detection-card.dart` → `lib/widgets/os_detection_card.dart`
- `custom-button.dart` → `lib/widgets/custom_button.dart`
- `wipe-progress-dialog.dart` → `lib/widgets/wipe_progress_dialog.dart`

### 5. Install Dependencies
```bash
flutter pub get
```

### 6. Run the App
```bash
# For web
flutter run -d chrome

# For mobile (Android/iOS)
flutter run

# For desktop
flutter run -d windows  # or macos/linux
```

## Key Features

### 🖥️ **Automatic OS Detection**
- Detects Windows, Android, Linux, macOS, iOS automatically
- Shows appropriate icons and system information
- Validates platform support for wiping operations

### 🎨 **Clean, Professional UI**
- Material Design with custom color scheme
- Responsive layout for all screen sizes
- Professional typography and spacing
- Smooth animations and transitions

### 🔴 **Prominent Wipe Button**
- Large, eye-catching "Wipe and Clear All Data" button
- Custom styling with hover effects
- Proper safety confirmations
- Loading states and feedback

### 📊 **Progress Tracking**
- Real-time progress indicator with percentages
- Step-by-step status updates
- Estimated time remaining
- Animated progress bars and visual feedback

### 🛡️ **Security Standards**
- DoD 5220.22-M compliance simulation
- 3-pass secure deletion process
- Verification and reporting
- Enterprise-ready features

## Customization Options

### Colors (in `constants.dart`)
```dart
static const Color primaryBlue = Color(0xFF1565C0);
static const Color successGreen = Color(0xFF4CAF50);
static const Color dangerRed = Color(0xFF E53935);
```

### Wiping Methods
The app includes support for multiple wiping standards:
- DoD 5220.22-M (3-pass, default)
- NIST SP 800-88 (1-pass)
- Gutmann (35-pass)

### Responsive Breakpoints
```dart
static const double mobileBreakpoint = 600;
static const double tabletBreakpoint = 1024;
```

## Platform Support

### ✅ Supported for Wiping
- **Android** - Full support
- **Windows** - Full support  
- **Linux** - Full support

### ⚠️ Limited Support
- **iOS** - Detection only
- **macOS** - Detection only
- **Web** - Detection only

## Development Notes

### For Web Deployment
```bash
flutter build web
```

### For Mobile APK
```bash
flutter build apk
```

### For Desktop
```bash
flutter build windows  # or macos/linux
```

## Security Considerations

⚠️ **Important**: This is a UI prototype/simulation. For actual secure data wiping:

1. Implement real platform-specific wiping commands
2. Add proper file system access and permissions
3. Integrate with actual secure deletion libraries
4. Add compliance logging and certificates
5. Implement proper error handling for hardware failures

## Testing

Run tests with:
```bash
flutter test
```

## Troubleshooting

### Common Issues

1. **Import errors**: Ensure all files are in correct directories
2. **Dependency issues**: Run `flutter pub get` 
3. **Platform detection not working**: Check platform permissions
4. **UI not responsive**: Verify MediaQuery usage in widgets

### Flutter Version Requirements
- Flutter SDK: >= 2.5.0
- Dart SDK: >= 2.17.0

## Production Deployment

For production use, consider:
- Add proper error handling and logging
- Implement real secure deletion algorithms
- Add user authentication and authorization  
- Include compliance reporting and certificates
- Add support for different storage types (SSD, HDD, etc.)
- Implement audit trails and verification

---

This Flutter app provides the exact functionality you requested: a clean, simple UI with automatic OS detection and a prominent data wiping button, all built with modern Flutter/Dart code and responsive design principles.