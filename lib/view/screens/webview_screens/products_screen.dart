import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geolocator/geolocator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_template/constants/my_app_colors.dart';
import 'package:webview_template/constants/my_app_urls.dart';
import 'package:webview_template/controllers/error_handle.dart';
import 'package:webview_template/utils/internet_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:path/path.dart' as path;

/// Products screen that displays the products webview content
/// 
/// This screen implements professional webview features including:
/// - Proper loading states with SpinningLines animation
/// - Pull-to-refresh functionality
/// - Error handling for network issues
/// - External URL handling
/// - File download capabilities
/// - Geolocation permissions
class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  // Webview controller and state management
  InAppWebViewController? _webViewController;
  late PullToRefreshController _pullToRefreshController;
  
  // Loading and state variables
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  double _progress = 0.0;
  
  // Permission and feature flags
  bool _hasGeolocationPermission = false;
  bool _isInitialized = false;

  // Products URL
  static const String _productsUrl = 'https://www.glamorebijoux.ch/collections/gold-18-carat';

  @override
  void initState() {
    super.initState();
    _initializeWebView();
    _checkInternetConnection();
  }

  @override
  void dispose() {
    _pullToRefreshController.dispose();
    super.dispose();
  }

  /// Initialize webview with proper configuration
  void _initializeWebView() {
    _pullToRefreshController = PullToRefreshController(
      settings: PullToRefreshSettings(
        color: MyColors.primaryColor,
        backgroundColor: MyColors.backgroundColor,
        size: PullToRefreshSize.DEFAULT,
      ),
      onRefresh: _handlePullToRefresh,
    );
  }

  /// Check internet connectivity on app start
  Future<void> _checkInternetConnection() async {
    try {
      await CheckInternetConnection.checkInternetFunction();
    } catch (e) {
      debugPrint('Internet check error: $e');
    }
  }

  /// Handle pull-to-refresh action
  Future<void> _handlePullToRefresh() async {
    try {
      if (_webViewController != null) {
        if (Platform.isAndroid) {
          await _webViewController!.reload();
        } else if (Platform.isIOS) {
          final url = await _webViewController!.getUrl();
          if (url != null) {
            await _webViewController!.loadUrl(
              urlRequest: URLRequest(url: url),
            );
          }
        }
      }
    } catch (e) {
      debugPrint('Pull to refresh error: $e');
      _showErrorSnackBar('Failed to refresh content');
    } finally {
      _pullToRefreshController.endRefreshing();
    }
  }

  /// Show error message to user
  void _showErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: MyColors.errorColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Handle webview errors with proper error handling
  void _handleWebViewError(InAppWebViewController controller, WebResourceRequest request, WebResourceError error) {
    if (kDebugMode) {
      debugPrint('WebView Error: ${error.description}');
      debugPrint('URL: ${request.url}');
      debugPrint('Error Code: ${error.type}');
    }

    setState(() {
      _hasError = true;
      _errorMessage = error.description ?? 'Unknown error occurred';
    });

    // Handle specific error types
    if (error.description?.contains('ERR_INTERNET_DISCONNECTED') == true) {
      handleErrorCode(error.description!, context);
    }
  }

  /// Handle URL loading with proper external URL management
  Future<NavigationActionPolicy> _handleUrlLoading(
    InAppWebViewController controller,
    NavigationAction navigationAction,
  ) async {
    final url = navigationAction.request.url.toString();
    
    if (kDebugMode) {
      debugPrint('Attempting to load URL: $url');
    }

    // Allow navigation within our main domain
    if (url.contains(Changes.startPointUrl)) {
      return NavigationActionPolicy.ALLOW;
    }

    // Allow payment URLs to load within the app
    if (_isPaymentUrl(url)) {
      if (kDebugMode) {
        debugPrint('Allowing payment URL within app: $url');
      }
      return NavigationActionPolicy.ALLOW;
    }

    // Handle external URLs
    try {
      await _launchExternalUrl(url);
      return NavigationActionPolicy.CANCEL;
    } catch (e) {
      debugPrint('Failed to launch external URL: $e');
      return NavigationActionPolicy.ALLOW;
    }
  }

  /// Check if URL is a payment-related URL
  bool _isPaymentUrl(String url) {
    final paymentDomains = [
      'shop.app',
      'checkout.shopify.com',
      'pay.shopify.com',
      'shopify.com/checkout',
      'stripe.com',
      'paypal.com',
    ];
    
    return paymentDomains.any((domain) => url.contains(domain));
  }

  /// Launch external URL with proper error handling
  Future<void> _launchExternalUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  /// Handle file downloads with proper error handling
  Future<void> _handleFileDownload(
    InAppWebViewController controller,
    DownloadStartRequest downloadStartRequest,
  ) async {
    final url = downloadStartRequest.url.toString();
    final filename = downloadStartRequest.suggestedFilename;

    if (kDebugMode) {
      debugPrint('Download requested: $url');
      debugPrint('Filename: $filename');
    }

    try {
      await _downloadFile(url, filename);
    } catch (e) {
      debugPrint('Download error: $e');
      _showErrorSnackBar('Download failed: ${e.toString()}');
    }
  }

  /// Download file with proper headers and error handling
  Future<void> _downloadFile(String url, String? filename) async {
    final finalFilename = filename ?? url.split('/').last.split('?').first;
    final dio = Dio();

    final tempDir = await getTemporaryDirectory();
    final tempFilePath = path.join(tempDir.path, finalFilename);

    // Get cookies for authenticated downloads
    final cookieManager = CookieManager.instance();
    final cookies = await cookieManager.getCookies(url: WebUri(url));
    final cookieHeader = cookies.map((c) => "${c.name}=${c.value}").join("; ");

    final headers = {
      'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
      'Accept': '*/*',
      'Accept-Encoding': 'gzip, deflate, br',
      'Connection': 'keep-alive',
      'Referer': url,
      if (cookieHeader.isNotEmpty) 'Cookie': cookieHeader,
    };

    // Download file
    await dio.download(
      url,
      tempFilePath,
      options: Options(
        headers: headers,
        responseType: ResponseType.bytes,
        followRedirects: true,
        validateStatus: (status) => status! < 500,
      ),
    );

    // Verify downloaded content
    final file = File(tempFilePath);
    final firstBytes = await file.openRead(0, 10).first;
    final htmlHeader = utf8.decode(firstBytes).toLowerCase();
    
    if (htmlHeader.contains('<!doc') || htmlHeader.contains('<html')) {
      throw Exception("Downloaded content appears to be HTML. Login may be required.");
    }

    // Save file to appropriate location
    if (Platform.isAndroid) {
      await _saveFileAndroid(tempFilePath);
    } else if (Platform.isIOS) {
      await _saveFileIOS(tempFilePath, finalFilename);
    }
  }

  /// Save file on Android using MediaStore
  Future<void> _saveFileAndroid(String tempFilePath) async {
    final mediaStore = MediaStore();
    final saveInfo = await mediaStore.saveFile(
      tempFilePath: tempFilePath,
      dirType: DirType.download,
      dirName: DirName.download,
      relativePath: Changes.androidMediaStoreFolderName,
    );

    if (saveInfo != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("File saved to Downloads/${Changes.androidMediaStoreFolderName}"),
            backgroundColor: MyColors.successColor,
          ),
        );
      }
    } else {
      throw Exception("File save failed");
    }
  }

  /// Save file on iOS to app documents
  Future<void> _saveFileIOS(String tempFilePath, String filename) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final newPath = path.join(appDocDir.path, filename);
    final file = File(tempFilePath);
    await file.copy(newPath);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("File saved locally on iOS"),
          backgroundColor: MyColors.successColor,
        ),
      );
    }
  }

  /// Handle geolocation permission requests
  Future<GeolocationPermissionShowPromptResponse> _handleGeolocationPermission(
    InAppWebViewController controller,
    String origin,
  ) async {
    if (_hasGeolocationPermission) {
      return GeolocationPermissionShowPromptResponse(
        origin: origin,
        allow: true,
        retain: true,
      );
    }

    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _hasGeolocationPermission = true;
      return GeolocationPermissionShowPromptResponse(
        origin: origin,
        allow: true,
        retain: true,
      );
    } else {
      _showLocationPermissionDialog(controller);
      return GeolocationPermissionShowPromptResponse(
        origin: origin,
        allow: false,
        retain: true,
      );
    }
  }

  /// Show location permission dialog
  void _showLocationPermissionDialog(InAppWebViewController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'This app needs access to your location to show it on the map.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _hasGeolocationPermission = false;
              controller.evaluateJavascript(
                source: 'navigator.geolocation.getCurrentPosition = function(success, error) { error({code: 1}); };',
              );
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _hasGeolocationPermission = true;
              Geolocator.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _handleBackPress,
      child: Scaffold(
        backgroundColor: MyColors.backgroundColor,
        body: SafeArea(
          child: Stack(
            children: [
              // Main webview content
              _buildWebView(),
              
              // Loading indicator
              if (_isLoading && !_hasError) _buildLoadingIndicator(),
              
              // Error overlay
              if (_hasError) _buildErrorOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  /// Handle back button press with webview navigation
  Future<bool> _handleBackPress() async {
    if (_webViewController != null) {
      final canGoBack = await _webViewController!.canGoBack();
      if (canGoBack) {
        _webViewController!.goBack();
        return false;
      }
    }
    return true;
  }

  /// Build the main webview widget
  Widget _buildWebView() {
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(_productsUrl)),
      pullToRefreshController: _pullToRefreshController,
      onWebViewCreated: (controller) {
        _webViewController = controller;
      },
      onLoadStart: (controller, url) {
        setState(() {
          _isLoading = true;
          _hasError = false;
        });
      },
      onLoadStop: (controller, url) {
        setState(() {
          _isLoading = false;
          _hasError = false;
        });
      },
      onProgressChanged: (controller, progress) {
        setState(() {
          _progress = progress / 100;
        });
      },
      onReceivedError: _handleWebViewError,
      shouldOverrideUrlLoading: _handleUrlLoading,
      onDownloadStartRequest: _handleFileDownload,
      onPermissionRequest: (controller, request) async {
        return PermissionResponse(
          resources: request.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
      onGeolocationPermissionsShowPrompt: _handleGeolocationPermission,
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        cacheEnabled: true,
        mediaPlaybackRequiresUserGesture: false,
        supportZoom: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
        mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
        useShouldOverrideUrlLoading: true,
        useOnDownloadStart: true,
        useHybridComposition: true,
        sharedCookiesEnabled: true,
        thirdPartyCookiesEnabled: true,
        domStorageEnabled: true,
      ),
    );
  }

  /// Build loading indicator with SpinningLines
  Widget _buildLoadingIndicator() {
    return Container(
      color: MyColors.backgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SpinKitSpinningLines(
              color: MyColors.primaryColor,
              size: 50.0,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading Products...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MyColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build error overlay
  Widget _buildErrorOverlay() {
    return Container(
      color: MyColors.backgroundColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline_rounded,
                size: 64,
                color: MyColors.errorColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: MyColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _errorMessage,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: MyColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _isLoading = true;
                  });
                  _webViewController?.reload();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 