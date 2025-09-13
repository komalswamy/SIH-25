import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/platform_detector.dart';
import '../widgets/os_detection_card.dart';
import '../widgets/custom_button.dart';
import '../widgets/wipe_progress_dialog.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  OperatingSystem _currentOS = OperatingSystem.unknown;
  bool _isDetecting = true;
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _detectOS();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: AppConstants.longAnimationDuration,
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: AppConstants.defaultAnimationDuration,
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  void _detectOS() async {
    // Simulate detection delay for better UX
    await Future.delayed(Duration(milliseconds: 2000));
    
    if (mounted) {
      setState(() {
        _currentOS = PlatformDetector.getCurrentOS();
        _isDetecting = false;
      });
      _scaleController.forward();
    }
  }

  void _showWipeConfirmation() {
    if (!PlatformDetector.isSupportedForWiping(_currentOS)) {
      _showUnsupportedDialog();
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                color: AppConstants.dangerRed,
                size: 28,
              ),
              SizedBox(width: 12),
              Text(
                AppConstants.confirmWipe,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppConstants.wipeWarning,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppConstants.dangerRed.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppConstants.dangerRed.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      PlatformDetector.getOSIcon(_currentOS),
                      color: AppConstants.dangerRed,
                      size: 32,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Target System:',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.dangerRed,
                            ),
                          ),
                          Text(
                            PlatformDetector.getOSDisplayName(_currentOS),
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppConstants.dangerRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Method: DoD 5220.22-M (3-pass secure deletion)',
                style: TextStyle(
                  fontSize: 14,
                  color: AppConstants.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: AppConstants.mediumGray,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _startWipeProcess();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.dangerRed,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('Proceed with Wipe'),
            ),
          ],
        );
      },
    );
  }

  void _showUnsupportedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppConstants.warningOrange,
              ),
              SizedBox(width: 8),
              Text('Unsupported Platform'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Data wiping is not currently supported on ${PlatformDetector.getOSDisplayName(_currentOS)}.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppConstants.successGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Supported Platforms:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.successGreen,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('• Android devices'),
                    Text('• Windows computers'),
                    Text('• Linux systems'),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.primaryBlue,
              ),
            ),
          ],
        );
      },
    );
  }

  void _startWipeProcess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WipeProgressDialog(
          operatingSystem: _currentOS,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstants.primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppConstants.appTitle,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              AppConstants.appSubtitle,
              style: TextStyle(
                fontSize: 12,
                opacity: 0.9,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        leading: Container(
          margin: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.security,
            color: Colors.white,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppConstants.defaultMargin),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth > AppConstants.tabletBreakpoint
                        ? 600
                        : double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 24),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: OSDetectionCard(
                          operatingSystem: _currentOS,
                          isDetecting: _isDetecting,
                        ),
                      ),
                      SizedBox(height: 32),
                      CustomButton(
                        text: AppConstants.wipeButtonText,
                        onPressed: _isDetecting ? null : _showWipeConfirmation,
                        isEnabled: !_isDetecting,
                        icon: Icons.delete_forever,
                      ),
                      SizedBox(height: 24),
                      _buildInfoCard(),
                      SizedBox(height: 24),
                      _buildSecurityCard(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppConstants.primaryBlue,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'How It Works',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            _buildInfoItem(
              Icons.search,
              'System Detection',
              'Automatically identifies your operating system and hardware',
            ),
            _buildInfoItem(
              Icons.security,
              'Secure Deletion',
              'Uses military-grade DoD 5220.22-M standard with 3-pass overwrite',
            ),
            _buildInfoItem(
              Icons.verified,
              'Compliance Ready',
              'Meets enterprise IT asset disposal and recycling requirements',
            ),
            _buildInfoItem(
              Icons.timeline,
              'Progress Tracking',
              'Real-time monitoring of wiping process with detailed status',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2),
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppConstants.primaryBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppConstants.primaryBlue,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppConstants.darkGray,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityCard() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppConstants.cardPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shield,
                  color: AppConstants.successGreen,
                  size: 24,
                ),
                SizedBox(width: 8),
                Text(
                  'Security Standards',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.military_tech,
                        color: AppConstants.successGreen,
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DoD 5220.22-M Standard',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.successGreen,
                              ),
                            ),
                            Text(
                              'US Department of Defense approved method',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppConstants.mediumGray,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}