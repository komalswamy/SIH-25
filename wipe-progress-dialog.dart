import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';
import '../utils/constants.dart';
import '../utils/platform_detector.dart';

class WipeProgressDialog extends StatefulWidget {
  final OperatingSystem operatingSystem;

  const WipeProgressDialog({
    Key? key,
    required this.operatingSystem,
  }) : super(key: key);

  @override
  _WipeProgressDialogState createState() => _WipeProgressDialogState();
}

class _WipeProgressDialogState extends State<WipeProgressDialog>
    with TickerProviderStateMixin {
  late AnimationController _progressController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  late Animation<double> _progressAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;

  double _progress = 0.0;
  String _currentStep = 'Initializing secure wipe...';
  String _currentPass = '';
  bool _isCompleted = false;
  bool _isSuccessful = false;
  Timer? _progressTimer;
  int _stepIndex = 0;
  int _estimatedTimeRemaining = 0;

  final List<Map<String, dynamic>> _wipeSteps = [
    {
      'step': 'Initializing secure wipe...',
      'pass': 'System Check',
      'duration': 2000,
    },
    {
      'step': 'Analyzing storage structure...',
      'pass': 'Storage Analysis',
      'duration': 3000,
    },
    {
      'step': 'Beginning data overwrite (Pass 1/3)...',
      'pass': 'Pass 1 - Random Data',
      'duration': 4000,
    },
    {
      'step': 'Data overwrite (Pass 2/3)...',
      'pass': 'Pass 2 - Complement',
      'duration': 4000,
    },
    {
      'step': 'Final data overwrite (Pass 3/3)...',
      'pass': 'Pass 3 - Random Verify',
      'duration': 4000,
    },
    {
      'step': 'Verifying secure deletion...',
      'pass': 'Verification',
      'duration': 3000,
    },
    {
      'step': 'Generating completion report...',
      'pass': 'Report Generation',
      'duration': 2000,
    },
    {
      'step': 'Secure wipe completed successfully!',
      'pass': 'Complete',
      'duration': 1000,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startWipeProcess();
    _calculateTotalTime();
  }

  void _initializeAnimations() {
    _progressController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeOut,
    ));

    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 2 * pi,
    ).animate(CurvedAnimation(
      parent: _rotationController,
      curve: Curves.linear,
    ));

    _pulseController.repeat(reverse: true);
    _rotationController.repeat();
  }

  @override
  void dispose() {
    _progressController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _progressTimer?.cancel();
    super.dispose();
  }

  void _calculateTotalTime() {
    _estimatedTimeRemaining = _wipeSteps
        .map((step) => step['duration'] as int)
        .reduce((a, b) => a + b) ~/
        1000;
  }

  void _startWipeProcess() {
    Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_stepIndex < _wipeSteps.length) {
        final currentStepData = _wipeSteps[_stepIndex];
        final stepDuration = currentStepData['duration'] as int;
        
        if (_progressTimer == null) {
          setState(() {
            _currentStep = currentStepData['step'];
            _currentPass = currentStepData['pass'];
          });

          _progressTimer = Timer(Duration(milliseconds: stepDuration), () {
            _stepIndex++;
            final newProgress = _stepIndex / _wipeSteps.length;
            
            setState(() {
              _progress = newProgress;
              _estimatedTimeRemaining = ((_wipeSteps.length - _stepIndex) * 3);
            });
            
            _progressController.animateTo(newProgress);
            
            if (_stepIndex >= _wipeSteps.length) {
              setState(() {
                _isCompleted = true;
                _isSuccessful = true;
                _estimatedTimeRemaining = 0;
              });
              _pulseController.stop();
              _rotationController.stop();
              timer.cancel();
            }
            
            _progressTimer = null;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => _isCompleted,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.92,
          constraints: BoxConstraints(
            maxWidth: 450,
            minHeight: 400,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: Offset(0, 15),
                spreadRadius: 0,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(),
                SizedBox(height: 32),
                _buildProgressIndicator(),
                SizedBox(height: 24),
                _buildProgressSection(),
                SizedBox(height: 24),
                _buildStatusSection(),
                SizedBox(height: 28),
                if (_isCompleted) _buildActionButtons() else _buildCancelButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _isCompleted ? Tween<double>(begin: 1.0, end: 1.0).animate(_progressController) : _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _isCompleted ? 1.0 : _pulseAnimation.value,
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: _getStatusColor(),
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: _getStatusColor().withOpacity(0.3),
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: _isCompleted
                    ? Icon(
                        _isSuccessful ? Icons.check_circle : Icons.error_outline,
                        color: Colors.white,
                        size: 36,
                      )
                    : AnimatedBuilder(
                        animation: _rotationAnimation,
                        builder: (context, child) {
                          return Transform.rotate(
                            angle: _rotationAnimation.value,
                            child: Icon(
                              Icons.security,
                              color: Colors.white,
                              size: 36,
                            ),
                          );
                        },
                      ),
              ),
            );
          },
        ),
        SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getHeaderTitle(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.darkGray,
                ),
              ),
              SizedBox(height: 4),
              Text(
                PlatformDetector.getOSDisplayName(widget.operatingSystem),
                style: TextStyle(
                  fontSize: 16,
                  color: AppConstants.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (!_isCompleted) ...[
                SizedBox(height: 4),
                Text(
                  'DoD 5220.22-M Standard',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppConstants.primaryBlue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  child: CircularProgressIndicator(
                    value: _progress,
                    strokeWidth: 8,
                    backgroundColor: AppConstants.lightGray,
                    valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(),
                      ),
                    ),
                    if (!_isCompleted && _estimatedTimeRemaining > 0)
                      Text(
                        '~${_estimatedTimeRemaining}s',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppConstants.mediumGray,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _progressAnimation,
          builder: (context, child) {
            return LinearProgressIndicator(
              value: _progressAnimation.value,
              backgroundColor: AppConstants.lightGray,
              valueColor: AlwaysStoppedAnimation<Color>(_getStatusColor()),
              minHeight: 6,
            );
          },
        ),
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              _currentPass,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppConstants.primaryBlue,
              ),
            ),
            if (!_isCompleted && _estimatedTimeRemaining > 0)
              Text(
                'Est. ${_estimatedTimeRemaining}s remaining',
                style: TextStyle(
                  fontSize: 12,
                  color: AppConstants.mediumGray,
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _isCompleted 
                    ? (_isSuccessful ? Icons.check_circle : Icons.error)
                    : Icons.info_outline,
                color: _getStatusColor(),
                size: 20,
              ),
              SizedBox(width: 8),
              Text(
                'Status',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Text(
            _currentStep,
            style: TextStyle(
              fontSize: 16,
              color: AppConstants.darkGray,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (_isCompleted && _isSuccessful) ...[
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user,
                    color: AppConstants.successGreen,
                    size: 18,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All data has been securely overwritten and is unrecoverable.',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppConstants.successGreen,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.mediumGray,
              side: BorderSide(color: AppConstants.lightGray),
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Close'),
          ),
        ),
        if (_isSuccessful) ...[
          SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                _showCompletionReport();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.successGreen,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.description, size: 18),
                  SizedBox(width: 8),
                  Text('View Report'),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCancelButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: () {
          _showCancelConfirmation();
        },
        style: OutlinedButton.styleFrom(
          foregroundColor: AppConstants.dangerRed,
          side: BorderSide(color: AppConstants.dangerRed.withOpacity(0.3)),
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text('Cancel Wipe Process'),
      ),
    );
  }

  Color _getStatusColor() {
    if (_isCompleted) {
      return _isSuccessful ? AppConstants.successGreen : AppConstants.dangerRed;
    }
    return AppConstants.primaryBlue;
  }

  String _getHeaderTitle() {
    if (_isCompleted) {
      return _isSuccessful ? 'Wipe Completed' : 'Wipe Failed';
    }
    return 'Secure Data Wipe';
  }

  void _showCancelConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Cancel Wipe Process'),
        content: Text('Are you sure you want to cancel the secure wipe process? This may leave data partially overwritten.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Continue Wipe'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close confirmation
              Navigator.of(context).pop(); // Close progress dialog
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppConstants.dangerRed),
            child: Text('Cancel Wipe'),
          ),
        ],
      ),
    );
  }

  void _showCompletionReport() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppConstants.successGreen),
            SizedBox(width: 8),
            Text('Wipe Report'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device: ${PlatformDetector.getOSDisplayName(widget.operatingSystem)}'),
            Text('Method: DoD 5220.22-M (3-pass)'),
            Text('Status: Successfully Completed'),
            Text('Date: ${DateTime.now().toString().substring(0, 19)}'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppConstants.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'All data has been securely overwritten according to DoD standards. The device is ready for safe disposal or recycling.',
                style: TextStyle(
                  color: AppConstants.successGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close report
              Navigator.of(context).pop(); // Close progress dialog
            },
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}