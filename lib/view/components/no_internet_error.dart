import 'package:flutter/material.dart';
import 'package:webview_template/constants/my_app_colors.dart';
import 'package:webview_template/utils/internet_connectivity.dart';
import 'package:webview_template/view/screens/webview_screens/home_screen.dart';

/// No internet error screen that displays when there's no internet connection
/// 
/// This screen provides a professional offline experience with:
/// - Clear offline messaging
/// - Internet connectivity check
/// - Retry functionality
/// - Professional UI design
class NoInternetErrorScreen extends StatefulWidget {
  const NoInternetErrorScreen({super.key});

  @override
  State<NoInternetErrorScreen> createState() => _NoInternetErrorScreenState();
}

class _NoInternetErrorScreenState extends State<NoInternetErrorScreen> {
  bool _isCheckingConnection = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Offline illustration
              _buildOfflineIllustration(),
              
              const SizedBox(height: 32),
              
              // Error title
              _buildErrorTitle(),
              
              const SizedBox(height: 16),
              
              // Error message
              _buildErrorMessage(),
              
              const SizedBox(height: 48),
              
              // Action buttons
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the offline illustration
  Widget _buildOfflineIllustration() {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.errorColor.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: MyColors.errorColor.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        Icons.wifi_off_rounded,
        size: 80,
        color: MyColors.errorColor,
      ),
    );
  }

  /// Build the error title
  Widget _buildErrorTitle() {
    return Text(
      'No Internet Connection',
      style: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: MyColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build the error message
  Widget _buildErrorMessage() {
    return Text(
      'Please check your internet connection and try again. Make sure you have a stable connection to access the content.',
      style: TextStyle(
        fontSize: 16,
        color: MyColors.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build the action buttons
  Widget _buildActionButtons() {
    return Column(
      children: [
        // Reload button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isCheckingConnection ? null : _handleReload,
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
              foregroundColor: MyColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: _isCheckingConnection
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(MyColors.textOnPrimary),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Checking...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.refresh_rounded),
                      const SizedBox(width: 8),
                      Text(
                        'Reload',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Check connection button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _isCheckingConnection ? null : _handleCheckConnection,
            style: OutlinedButton.styleFrom(
              foregroundColor: MyColors.primaryColor,
              side: BorderSide(color: MyColors.primaryColor),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_rounded),
                const SizedBox(width: 8),
                Text(
                  'Check Connection',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        
        const SizedBox(height: 16),
        
        // Settings button
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: _handleOpenSettings,
            style: TextButton.styleFrom(
              foregroundColor: MyColors.textSecondary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.settings_rounded),
                const SizedBox(width: 8),
                Text(
                  'Open Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Handle reload action
  Future<void> _handleReload() async {
    setState(() {
      _isCheckingConnection = true;
    });

    try {
      // Check internet connectivity
      await CheckInternetConnection.checkInternetFunction();
      final isConnected = await CheckInternetConnection.isConnected();
      
      if (mounted) {
        if (isConnected) {
          // Navigate back to home screen
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Still no internet connection available'),
              backgroundColor: MyColors.errorColor,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to check internet connection'),
            backgroundColor: MyColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingConnection = false;
        });
      }
    }
  }

  /// Handle check connection action
  Future<void> _handleCheckConnection() async {
    setState(() {
      _isCheckingConnection = true;
    });

    try {
      final isConnected = await CheckInternetConnection.isConnected();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isConnected 
                ? 'Internet connection is available! You can now reload the app.'
                : 'No internet connection detected. Please check your network settings.',
            ),
            backgroundColor: isConnected ? MyColors.successColor : MyColors.errorColor,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: isConnected ? 3 : 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to check internet connection'),
            backgroundColor: MyColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingConnection = false;
        });
      }
    }
  }

  /// Handle open settings action
  void _handleOpenSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Network Settings'),
        content: const Text(
          'Would you like to open your device\'s network settings to check your internet connection?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // You can add platform-specific code here to open settings
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Please check your device\'s network settings'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
