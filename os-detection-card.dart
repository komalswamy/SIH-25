import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/platform_detector.dart';

class OSDetectionCard extends StatelessWidget {
  final OperatingSystem operatingSystem;
  final bool isDetecting;

  const OSDetectionCard({
    Key? key,
    required this.operatingSystem,
    required this.isDetecting,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shadowColor: AppConstants.primaryBlue.withOpacity(0.2),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              AppConstants.lightGray.withOpacity(0.3),
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(AppConstants.cardPadding + 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 20),
              if (isDetecting) ...[
                _buildDetectingState(context),
              ] else ...[
                _buildDetectedState(context),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppConstants.primaryBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.computer,
            color: AppConstants.primaryBlue,
            size: 28,
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'System Detection',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: 20,
                ),
              ),
              Text(
                'Identifying your device automatically',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.mediumGray,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetectingState(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppConstants.lightGray.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryBlue),
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppConstants.detectingOS,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.darkGray,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Analyzing system properties and hardware configuration...',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppConstants.mediumGray,
                  ),
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppConstants.primaryBlue),
                  backgroundColor: AppConstants.lightGray,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetectedState(BuildContext context) {
    final isSupported = PlatformDetector.isSupportedForWiping(operatingSystem);
    final osDetails = PlatformDetector.getOSDetails(operatingSystem);
    
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSupported 
                ? AppConstants.successGreen.withOpacity(0.05)
                : AppConstants.warningOrange.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSupported 
                  ? AppConstants.successGreen.withOpacity(0.2)
                  : AppConstants.warningOrange.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isSupported 
                          ? AppConstants.successGreen.withOpacity(0.1)
                          : AppConstants.warningOrange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: isSupported 
                            ? AppConstants.successGreen
                            : AppConstants.warningOrange,
                        width: 2,
                      ),
                    ),
                    child: Icon(
                      PlatformDetector.getOSIcon(operatingSystem),
                      color: isSupported 
                          ? AppConstants.successGreen
                          : AppConstants.warningOrange,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          PlatformDetector.getOSDisplayName(operatingSystem),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppConstants.darkGray,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          PlatformDetector.getOSVersion(operatingSystem),
                          style: TextStyle(
                            fontSize: 14,
                            color: AppConstants.mediumGray,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSupported 
                                ? AppConstants.successGreen
                                : AppConstants.warningOrange,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            isSupported ? 'WIPING SUPPORTED' : 'WIPING NOT SUPPORTED',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Divider(color: AppConstants.lightGray),
              SizedBox(height: 16),
              _buildDetailRow('Platform', osDetails['platform'] ?? 'Unknown'),
              SizedBox(height: 8),
              _buildDetailRow('Architecture', osDetails['architecture'] ?? 'Unknown'),
              SizedBox(height: 8),
              _buildDetailRow('Wipe Support', osDetails['wiping_support'] ?? 'Unknown'),
            ],
          ),
        ),
        if (!isSupported) ...[
          SizedBox(height: 12),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppConstants.warningOrange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppConstants.warningOrange.withOpacity(0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppConstants.warningOrange,
                  size: 20,
                ),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'This platform does not support secure data wiping through this application.',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppConstants.warningOrange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: AppConstants.mediumGray,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: AppConstants.darkGray,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}