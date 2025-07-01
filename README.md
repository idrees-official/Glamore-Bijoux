# Glamore Bijoux - Flutter Webview App

A professional Flutter webview application for Glamore Bijoux, featuring a modern UI design, robust error handling, and seamless web content integration.

## 🚀 Features

### Core Functionality
- **Professional Webview Integration**: Seamless web content display with advanced features
- **Pull-to-Refresh**: Smooth content refresh functionality
- **External URL Handling**: Intelligent handling of external links and payment URLs
- **File Download Support**: Secure file downloading with proper authentication
- **Geolocation Services**: Location-based features with proper permission handling

### User Experience
- **Modern Material Design**: Professional UI following Material Design 3 principles
- **Smooth Animations**: Elegant transitions and loading states
- **Responsive Design**: Optimized for various screen sizes and orientations
- **Dark/Light Theme Support**: Consistent theming across the application
- **Professional Error Handling**: User-friendly error messages and recovery options

### Navigation & State Management
- **Bottom Navigation**: Intuitive tab-based navigation with state preservation
- **Webview State Management**: Maintains webview state when switching tabs
- **Back Button Support**: Proper navigation handling with webview history
- **Loading States**: Professional loading indicators and progress tracking

### Error Handling & Connectivity
- **Internet Connectivity Check**: Real-time connection status monitoring
- **Offline Support**: Graceful handling of network issues
- **Error Recovery**: Multiple retry mechanisms and user guidance
- **Professional Error Screens**: Clear error messaging and action options

## 🎨 Design System

### Color Palette
- **Primary Colors**: Professional blue theme (#1976D2)
- **Secondary Colors**: Dark gray accents (#424242)
- **Status Colors**: Success, warning, error, and info indicators
- **Background Colors**: Clean white and light gray surfaces
- **Text Colors**: High contrast text with proper hierarchy

### Typography
- **Display Text**: Large, bold headings for main content
- **Body Text**: Readable body text with proper line height
- **Label Text**: Clear labels and captions
- **Button Text**: Prominent call-to-action text

### Components
- **Cards**: Elevated surfaces with subtle shadows
- **Buttons**: Consistent button styles with proper states
- **Input Fields**: Professional form inputs with validation
- **Navigation**: Clean bottom navigation with active states

## 📱 Screens

### Splash Screen
- Professional loading animation
- App branding and logo display
- Smooth transition to main content
- First-time user detection

### Home Screen (Webview)
- Full-featured webview implementation
- Pull-to-refresh functionality
- Progress indicators
- Error handling and recovery
- External URL management

### Bottom Navigation
- Home, Notifications, About Us, Contact Us
- State preservation between tabs
- Smooth page transitions
- Professional icon design

### Error Screens
- **Custom Error Screen**: General error handling
- **No Internet Screen**: Offline state management
- Clear error messaging
- Multiple recovery options

## 🛠 Technical Implementation

### Architecture
- **Clean Architecture**: Well-organized folder structure
- **State Management**: Proper state handling with StatefulWidget
- **Error Handling**: Comprehensive error management
- **Performance Optimization**: Efficient loading and caching

### Webview Features
- **JavaScript Support**: Full JavaScript execution
- **Cookie Management**: Session persistence
- **File Downloads**: Secure file handling
- **Permission Handling**: Geolocation and media permissions
- **URL Interception**: Smart external link handling

### Dependencies
- **flutter_inappwebview**: Advanced webview functionality
- **url_launcher**: External URL handling
- **shared_preferences**: Local data persistence
- **connectivity_plus**: Network connectivity monitoring
- **permission_handler**: Permission management
- **geolocator**: Location services
- **dio**: HTTP client for downloads
- **media_store_plus**: File storage management

## 📋 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- Android SDK / Xcode (for platform-specific features)

### Installation
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Configure platform-specific settings:
   - Android: Update `android/app/build.gradle`
   - iOS: Update `ios/Runner/Info.plist`
4. Run the application:
   ```bash
   flutter run
   ```

### Configuration
- Update `lib/constants/my_app_urls.dart` with your website URL
- Configure app icons in `assets/app_icons/`
- Update app name and bundle ID as needed

## 🔧 Customization

### Colors
Edit `lib/constants/my_app_colors.dart` to customize the color scheme:
```dart
class MyColors {
  static const Color primaryColor = Color(0xFF1976D2);
  static const Color secondaryColor = Color(0xFF424242);
  // ... more colors
}
```

### Theme
Modify `lib/constants/app_theme.dart` to adjust the overall theme:
```dart
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      // ... theme configuration
    );
  }
}
```

### URLs
Update `lib/constants/my_app_urls.dart` with your website configuration:
```dart
class Changes {
  static String mainUrl = 'https://your-website.com/';
  static String startPointUrl = 'https://your-website.com';
  // ... more configuration
}
```

## 📱 Platform Support

### Android
- Minimum SDK: API 21 (Android 5.0)
- Target SDK: API 33+ (Android 13+)
- Permissions: Internet, Location, Storage
- Features: File downloads, geolocation, media store

### iOS
- Minimum iOS: 12.0
- Target iOS: 16.0+
- Permissions: Location, Camera, Microphone
- Features: File downloads, geolocation, app documents

## 🚀 Performance Features

### Optimization
- **Lazy Loading**: Efficient resource loading
- **Caching**: Webview content caching
- **Memory Management**: Proper resource cleanup
- **State Preservation**: Maintains webview state

### Monitoring
- **Error Tracking**: Comprehensive error logging
- **Performance Metrics**: Loading time optimization
- **User Analytics**: Usage pattern tracking
- **Crash Reporting**: Automatic error reporting

## 🔒 Security Features

### Webview Security
- **Content Security Policy**: Secure content loading
- **Mixed Content Handling**: Secure mixed content policy
- **JavaScript Security**: Safe JavaScript execution
- **Cookie Security**: Secure cookie management

### Data Protection
- **Local Storage**: Secure local data storage
- **Permission Management**: Granular permission control
- **Network Security**: Secure network communication
- **File Security**: Secure file handling

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## 📞 Support

For support and questions:
- Email: support@glamorebijoux.ch
- Website: https://www.glamorebijoux.ch/

## 🔄 Version History

### v2.0.0 (Current)
- Professional UI redesign
- Enhanced error handling
- Improved performance
- Better state management
- Material Design 3 implementation

### v1.0.0
- Initial release
- Basic webview functionality
- Simple navigation
- Basic error handling

---

**Glamore Bijoux** - Your Premium Jewelry Destination
