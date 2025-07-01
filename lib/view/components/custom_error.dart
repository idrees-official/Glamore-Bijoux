import 'package:flutter/material.dart';
import 'package:webview_template/constants/my_app_colors.dart';
import 'package:webview_template/utils/internet_connectivity.dart';
import 'package:webview_template/view/screens/webview_screens/home_screen.dart';

/// Custom error screen that displays when webview encounters errors
/// 
/// This screen provides a professional error handling experience with:
/// - Clear error messaging
/// - Retry functionality
/// - Internet connectivity check
/// - Professional UI design
class CustomErrorScreen extends StatelessWidget {
  final String errorMessage;

  const CustomErrorScreen({
    super.key,
    required this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Error'),
        backgroundColor: MyColors.primaryColor,
        foregroundColor: MyColors.textOnPrimary,
        elevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              _buildErrorIcon(),
              
              const SizedBox(height: 32),
              
              // Error title
              _buildErrorTitle(),
              
              const SizedBox(height: 16),
              
              // Error message
              _buildErrorMessage(),
              
              const SizedBox(height: 32),
              
              // Action buttons
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the error icon with animation
  Widget _buildErrorIcon() {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MyColors.errorColor.withOpacity(0.1),
      ),
      child: Icon(
        Icons.error_outline_rounded,
        size: 64,
        color: MyColors.errorColor,
      ),
    );
  }

  /// Build the error title
  Widget _buildErrorTitle() {
    return Text(
      'Something went wrong',
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: MyColors.textPrimary,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build the error message
  Widget _buildErrorMessage() {
    return Text(
      errorMessage.isNotEmpty ? errorMessage : 'An unexpected error occurred while loading the content.',
      style: TextStyle(
        fontSize: 16,
        color: MyColors.textSecondary,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Build the action buttons
  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        // Retry button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _handleRetry(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
              foregroundColor: MyColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.refresh_rounded),
                const SizedBox(width: 8),
                Text(
                  'Retry',
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
        
        // Check internet button
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => _handleCheckInternet(context),
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
                  'Check Internet',
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

  /// Handle retry action
  Future<void> _handleRetry(BuildContext context) async {
    try {
      // Check internet connectivity first
      await CheckInternetConnection.checkInternetFunction();
      
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('No internet connection available'),
            backgroundColor: MyColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  /// Handle check internet action
  Future<void> _handleCheckInternet(BuildContext context) async {
    try {
      final isConnected = await CheckInternetConnection.isConnected();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isConnected 
                ? 'Internet connection is available'
                : 'No internet connection detected',
            ),
            backgroundColor: isConnected ? MyColors.successColor : MyColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to check internet connection'),
            backgroundColor: MyColors.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }
}
