import 'package:flutter/material.dart';
import 'package:webview_template/constants/my_app_colors.dart';
import 'package:webview_template/view/screens/webview_screens/home_screen.dart';
import 'package:webview_template/view/screens/webview_screens/products_screen.dart';
import 'package:webview_template/view/screens/webview_screens/cart_screen.dart';
import 'package:webview_template/view/screens/webview_screens/contact_screen.dart';
import 'package:webview_template/view/screens/webview_screens/account_screen.dart';

/// Bottom navigation screen that manages the main app navigation
/// 
/// This screen maintains webview state to avoid reloading when switching tabs
/// and provides a smooth navigation experience with proper state management.
/// Implements 5 tabs: Home, Products, Cart, Contact, Account as specified in coding standards.
class BottomNavigationScreen extends StatefulWidget {
  const BottomNavigationScreen({Key? key}) : super(key: key);

  @override
  State<BottomNavigationScreen> createState() => _BottomNavigationScreenState();
}

class _BottomNavigationScreenState extends State<BottomNavigationScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  // List of screens with proper state management
  final List<Widget> _pages = [
    HomeScreen(),
    const ProductsScreen(),
    const CartScreen(),
    const ContactScreen(),
    const AccountScreen(),
  ];

  // Navigation items configuration
  final List<BottomNavigationItem> _navigationItems = [
    const BottomNavigationItem(
      icon: Icons.home_rounded,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    const BottomNavigationItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag_rounded,
      label: 'Products',
    ),
    const BottomNavigationItem(
      icon: Icons.shopping_cart_outlined,
      activeIcon: Icons.shopping_cart_rounded,
      label: 'Cart',
    ),
    const BottomNavigationItem(
      icon: Icons.contact_support_outlined,
      activeIcon: Icons.contact_support_rounded,
      label: 'Contact',
    ),
    const BottomNavigationItem(
      icon: Icons.person_outline,
      activeIcon: Icons.person_rounded,
      label: 'Account',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  /// Handles navigation item selection with smooth transitions
  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      
      // Animate to the selected page
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  /// Handles page changes from swipe gestures
  void _onPageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.backgroundColor,
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        physics: const NeverScrollableScrollPhysics(), // Disable swipe navigation
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: MyColors.shadowColor,
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: MyColors.backgroundColor,
          selectedItemColor: MyColors.primaryColor,
          unselectedItemColor: MyColors.textSecondary,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          elevation: 0,
          selectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          items: _navigationItems.map((item) {
            return BottomNavigationBarItem(
              icon: Icon(
                _selectedIndex == _navigationItems.indexOf(item)
                    ? item.activeIcon
                    : item.icon,
              ),
              label: item.label,
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Configuration class for bottom navigation items
class BottomNavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const BottomNavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
