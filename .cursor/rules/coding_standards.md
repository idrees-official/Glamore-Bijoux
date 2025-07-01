# Cursor Rules for Glamore Bijoux Flutter Webview App

## Project Structure
- Follow the existing folder structure in `lib/`
- Keep webview screens in `lib/view/screens/webview_screens/`
- Keep other screens in `lib/view/screens/others_screens/`
- Use proper naming conventions: snake_case for files and variables

## Bottom Navigation Requirements
- Implement 4 tabs in bottom navigation: Home, Products, Cart, Contact
- Each tab should have its own separate webview screen to maintain state
- URLs for each tab:
  - **Home**: `https://www.glamorebijoux.ch`
  - **Products**: `https://www.glamorebijoux.ch/collections/gold-18-carat`
  - **Cart**: `https://www.glamorebijoux.ch/cart`
  - **Contact**: `https://www.glamorebijoux.ch/pages/contact`
- When switching between tabs, do not reload the webview if it's already loaded
- Maintain webview state to avoid unnecessary reloading

## Loading Requirements
- Use **SpinningLines** loading animation throughout the entire app
- **DO NOT** use simple CircularProgressIndicator
- Add flutter_spinkit dependency: `flutter_spinkit: ^5.2.1`
- Import: `import 'package:flutter_spinkit/flutter_spinkit.dart';`
- Use: `SpinningLines(color: MyColors.kmainColor, size: 50.0)`

## Code Standards
- Use proper Flutter/Dart conventions
- Add proper error handling for webview operations
- Implement loading states for better UX
- Use the existing color scheme from `MyColors` class
- Follow the existing webview implementation pattern from `home_screen.dart`

## Webview Implementation Guidelines
- Always implement proper loading states
- Handle navigation properly with back button support
- Implement pull-to-refresh functionality
- Handle external URL launches appropriately
- Maintain webview state to avoid reloading when switching tabs
- Use proper error handling for network issues
- Create separate webview screens for each tab to handle loading issues

## State Management
- Use StatefulWidget for screens that need to maintain state
- Implement proper dispose methods to clean up resources
- Use setState for UI updates when needed
- Maintain individual webview controllers for each tab

## Performance
- Avoid unnecessary webview reloads
- Implement proper caching strategies
- Use efficient navigation patterns
- Keep webview instances alive when switching tabs

## Error Handling
- Always handle network errors gracefully
- Provide user-friendly error messages
- Implement proper fallback mechanisms

## UI/UX Guidelines
- Maintain consistent design across all screens
- Use proper loading indicators
- Implement smooth transitions between tabs
- Follow Material Design principles
- Show loading state only when webview is actually loading
- Use SpinningLines for all loading states

## File Naming
- Use descriptive names for all files
- Follow the pattern: `screen_name_screen.dart`
- Use proper casing: `snake_case` for files, `PascalCase` for classes
- Create separate files: `home_screen.dart`, `products_screen.dart`, `cart_screen.dart`, `contact_screen.dart`

## Comments and Documentation
- Add meaningful comments for complex logic
- Document important functions and methods
- Keep code self-explanatory where possible 