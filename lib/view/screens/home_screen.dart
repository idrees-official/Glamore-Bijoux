import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_template/constants/my_app_colors.dart';
import 'package:webview_template/constants/my_app_urls.dart';
import 'package:webview_template/controllers/error_handle.dart';
import 'package:webview_template/controllers/internet_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({
    super.key,
  }) {}
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //web view
  late InAppWebViewController _webViewController;
  final InAppBrowser browser = InAppBrowser();
  double _progress = 0.0; // Variable to hold the progress percentage
  bool hasGeolocationPermission = false;
  bool _isLoading =
      true; // loading animation or whatever widget called in the Visible widget

  // FacebookBannerAd? facebookBannerAd;
  // bool _isInterstitialAdLoaded = false;
  bool _isLoaded = false;
  bool _isLightMode = false;
  //for loading progress
  // double? progress;
  // bool loader = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      CheckInternetConnection.checkInternetFunction();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _isLightMode = prefs.getBool("isLightMode") ?? true;
      // _createGoogleBannerAd();
      // _createGoogleInterstitialAd();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey _loaderKey = GlobalKey();
    double baseSize = 55.0;
    double scaleFactor = MediaQuery.of(context).size.shortestSide /
        360; // Adjust the divisor as needed
    double containerSize = baseSize * scaleFactor;

    return WillPopScope(
      onWillPop: () async {
        if (_webViewController != null) {
          final currentUrl = (await _webViewController.getUrl())?.toString();
          bool canGoBack = await _webViewController.canGoBack();
          if (canGoBack) {
            _webViewController.goBack();
            return false;
          }
        }
        //_showGoogleInterstitalAd();
        return true;
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar(
            backgroundColor: MyColors.kprimaryColor,
            elevation: 0,
          ),
        ),
        body: Stack(
          children: [
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri('${Changes.mainUrl}')),
              onWebViewCreated: (controller) {
                _webViewController = controller;

                // Inject JavaScript to listen for theme changes
                //_webViewController.evaluateJavascript(source: themeListenerJS);

                // // Listen for theme change events
                // _webViewController.addJavaScriptHandler(
                //   handlerName: "themeChangeHandler",
                //   callback: (args) async {
                //     bool isDarkTheme = args.first; // Get the dark mode status
                //     SharedPreferences prefs = await SharedPreferences.getInstance();
                //     print("State is changed to ${isDarkTheme}");
                //     await prefs.setBool("isLightMode", isDarkTheme);
                //   },
                // );
              },
              onLoadStart: (controller, url) {
                setState(() {
                  Changes.mainUrl = url?.toString() ?? '';
                  _isLoading = true;
                });
              },
              onLoadStop: (controller, url) async {
                setState(() {
                  Changes.mainUrl = url?.toString() ?? '';
                  _isLoading = false;
                });

                // Add JavaScript handler only once
                _webViewController.addJavaScriptHandler(
                  handlerName: "themeChangeHandler",
                  callback: (args) async {
                    bool isDarkTheme = args.first; // Get the dark mode status
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    bool currentTheme = prefs.getBool("isLightMode") ?? true;

                    if (currentTheme != isDarkTheme) {
                      print("State is changed to ${isDarkTheme}");
                      await prefs.setBool("isLightMode", isDarkTheme);
                    }
                  },
                );
              },
              onProgressChanged: (controller, progress) {
                setState(() {
                  // _progress = progress / 100;
                  // _progressText = progress;  // to show inside of loading
                  // if (_progress > 0.8) {
                  //   setState(() {
                  //     _isLoading = false;
                  //   });
                  //}
                });
              },
              onReceivedError: (controller, request, error) {
                if (kDebugMode) {
                  print(
                      ':::url: ${request.url} message ${error.description} code ${error.hashCode} type ${error.type} error ${error.toString()}');
                }

                print('error hashcode: ${error.hashCode}');
                //Navigator.pop(context);
                if (error.description == 'net::ERR_INTERNET_DISCONNECTED' ) {
                 handleErrorCode(error.description, context);
                }
              },
              initialSettings: InAppWebViewSettings(
                cacheEnabled: true,
                javaScriptEnabled: true,
                useOnDownloadStart: true,
                useShouldOverrideUrlLoading: true,
                useHybridComposition: true,
                loadsImagesAutomatically: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                allowContentAccess: true,
              ),
              onPermissionRequest: (controller, request) async {
                return PermissionResponse(
                  resources: request.resources,
                  action: PermissionResponseAction.GRANT,
                );
              },

              // Track if the website already asked for geolocation permission

              onGeolocationPermissionsShowPrompt: (controller, origin) async {
                if (hasGeolocationPermission) {
                  return GeolocationPermissionShowPromptResponse(
                      origin: origin, allow: true, retain: true);
                } else {
                  var status = await Permission.locationWhenInUse.request();
                  if (status.isGranted) {
                    hasGeolocationPermission = true;
                    return GeolocationPermissionShowPromptResponse(
                        origin: origin, allow: true, retain: true);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Location Permission Required'),
                        content: Text(
                            'This app needs access to your location to show it on the map.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              hasGeolocationPermission = false;
                              controller.evaluateJavascript(
                                source:
                                    'navigator.geolocation.getCurrentPosition = function(success, error) { error({code: 1}); };',
                              );
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              hasGeolocationPermission = true;
                              Geolocator.openAppSettings();
                            },
                            child: Text('Open Settings'),
                          ),
                        ],
                      ),
                    );
                    return GeolocationPermissionShowPromptResponse(
                        origin: origin, allow: false, retain: true);
                  }
                }
              },

              shouldOverrideUrlLoading: (controller, navigationAction) async {
                setState(() {
                  _isLoading = true;
                });

                _loaderKey.currentState?.setState(() {
                  // This is to trigger a rebuild of the loader widget
                });
                var uri = navigationAction.request.url;
                if (uri!.toString().startsWith(Changes.startPointUrl)) {
                  return NavigationActionPolicy.ALLOW;
                }
                // else if (uri!.toString().startsWith(Changes.startPointUrl2)) {
                //   if (kDebugMode) {
                //     print('opening phone $uri');
                //   }
                //   // _makePhoneCall(uri.toString());
                //   // setState(() {
                //   //   _isLoading=false;
                //   // });
                //   return NavigationActionPolicy.ALLOW;
                // }
                // else if (uri.toString().startsWith(Changes.openWhatsAppUrl)) {
                //   if (kDebugMode) {
                //     print('opening WhatsApp $uri');
                //   }
                //   _openWhatsApp('$uri');
                //    setState(() {
                //     _isLoading=false;
                //   });
                //   return NavigationActionPolicy.CANCEL;
                // }
                // else if (uri.toString().startsWith(Changes.blockNavigationUrl)) {
                //   if (kDebugMode) {
                //     print('Blocking navigation to $uri');
                //   }
                //   return NavigationActionPolicy.CANCEL;
                // }
                else {
                  if (kDebugMode) {
                    print('Opening else link: $uri');
                  }
                  setState(() {
                    _isLoading = false;
                  });
                  _launchExternalUrl(uri.toString());
                  // You can handle other links here and decide how to navigate to them
                  return NavigationActionPolicy.CANCEL;
                  // if (uri.toString() ==
                  //     'https://m.facebook.com/oauth/error/?error_code=PLATFORM__LOGIN_DISABLED_FROM_WEBVIEW_OLD_SDK_VERSION&display=touch') {
                  //   return NavigationActionPolicy.CANCEL;
                  // } else {
                  //   return NavigationActionPolicy.ALLOW;
                  // }
                }
              },
            ),
            // Positioned.fill(
            //   child: Visibility(
            //     visible: _isLoading,
            //     child: CircularProgressIndicator(
            //       // value: _progress,
            //       color: Colors.brown,
            //     ),
            //   ),
            // ),

            // Visibility(
            //   visible:
            //       _isLoading, // Show the progress indicator only when loading
            //   child: Center(
            //       child: CircularProgressIndicator(
            //     // value: _progress,
            //     color: Colors.green,
            //   )),
            // ),
          ],
        ),

        // // for banner ads
        // bottomNavigationBar: _isLoaded == true
        //     ? Container(
        //         decoration: BoxDecoration(color: Colors.transparent),
        //         height: _bannerGoogleAd.size.height.toDouble(),
        //         width: _bannerGoogleAd.size.width.toDouble(),
        //         child: AdWidget(ad: _bannerGoogleAd),
        //       )
        //     : SizedBox(),
        //for facebook ads
        // bottomNavigationBar: Container(
        //   child: facebookBannerAd,
        // ),
      ),
    );
  }

// call this in init so you can create it
  // void _createGoogleBannerAd() {
  //   _bannerGoogleAd = BannerAd(
  //     size: AdSize.banner,
  //     adUnitId: AdsMobServices.BannerAdUnitId!,
  //     listener: BannerAdListener(
  //       onAdLoaded: (Ad) {
  //         setState(() {
  //           _isLoaded = true;
  //         });
  //       },
  //       onAdFailedToLoad: (Ad, Error) {
  //         print('My Add failed Error: //////////// $Error');
  //       },
  //     ),
  //     //AdsMobServices.bannerAdListener,
  //     request: AdRequest(),
  //   );
  //   _bannerGoogleAd.load();
  // }

// call this in init so you can create it
  // void _createGoogleInterstitialAd() {
  //   InterstitialAd.load(
  //       adUnitId: AdsMobServices.InterstitialAdId!,
  //       request: AdRequest(),
  //       adLoadCallback: InterstitialAdLoadCallback(
  //           onAdLoaded: (ad) => _interstialGoogleAd = ad,
  //           onAdFailedToLoad: (LoadAdError loadAdError) =>
  //               _interstialGoogleAd = null));
  // }

// call this to show where every in the app you want to show google interstitalAd
  // void _showGoogleInterstitalAd() {
  //   if (_interstialGoogleAd != null) {
  //     _interstialGoogleAd!.fullScreenContentCallback =
  //         FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
  //       ad.dispose();
  //       _createGoogleInterstitialAd();
  //     }, onAdFailedToShowFullScreenContent: (ad, error) {
  //       ad.dispose();
  //       _createGoogleInterstitialAd();
  //     });
  //     _interstialGoogleAd!.show();
  //     _interstialGoogleAd = null;
  //   }
  // }

  Future<void> _launchExternalUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _openWhatsApp(String url) async {
    // String url = 'https://wa.me/$phoneNumber';
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _makePhoneCall(String phoneNumber) async {
    final telScheme = 'tel:';
    if (phoneNumber.startsWith(telScheme)) {
      final Uri uri = Uri.parse(phoneNumber);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        print('Could not launch $phoneNumber');

        // Handle the error gracefully (e.g., show an error message to the user).
      }
    } else {
      print('Invalid phone number format: $phoneNumber');
      // Handle the error gracefully (e.g., show an error message to the user).
    }
  }

  // // facebook add
  // void _loadBannerAdd() {
  //   facebookBannerAd = FacebookBannerAd(
  //     placementId: Platform.isAndroid
  //         ? "323745273316409_323745829983020"
  //         : "1450991599021523_1450992009021482",
  //     bannerSize: BannerSize.STANDARD,
  //     listener: (result, vale) {
  //       print("lister:");
  //     },
  //   );
  // }
  // void _loadInterstitialAd() {
  //   FacebookInterstitialAd.loadInterstitialAd(
  //     // placementId: "YOUR_PLACEMENT_ID",
  //     placementId: Platform.isAndroid
  //         ? "323745273316409_323745926649677"
  //         : "1450991599021523_1451005752353441",
  //     listener: (result, value) {
  //       print(">> FAN > Interstitial Ad: $result --> $value");
  //       if (result == InterstitialAdResult.LOADED)
  //         _isInterstitialAdLoaded = true;
  //       /// Once an Interstitial Ad has been dismissed and becomes invalidated,
  //       /// load a fresh Ad by calling this function.
  //       if (result == InterstitialAdResult.DISMISSED &&
  //           value["invalidated"] == true) {
  //         _isInterstitialAdLoaded = false;
  //         _loadInterstitialAd();
  //       }
  //     },
  //   );
  // }
// }
}
