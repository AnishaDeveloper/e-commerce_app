import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import '../core/theme/app_theme.dart';
import '../providers/cart_provider.dart';
import 'home/home_screen.dart';
import 'products/product_list_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _onTabSelect(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    final pages = [
      HomeScreen(onNavigateTab: _onTabSelect),
      const ProductListScreen(),
      const CartScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Colors.grey.shade200, width: 0.8)),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey.shade200,
              hoverColor: Colors.grey.shade100,
              haptic: true,
              tabBorderRadius: 24,
              tabActiveBorder: Border.all(color: AppColors.headerNavy, width: 1),
              curve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 300),
              gap: 8,
              color: Colors.grey.shade600,
              activeColor: Colors.white,
              iconSize: 22,
              textStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              tabBackgroundColor: AppColors.headerNavy,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              selectedIndex: _currentIndex,
              onTabChange: _onTabSelect,
              tabs: [
                const GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                const GButton(
                  icon: Icons.grid_view_outlined,
                  text: 'Explore',
                ),
                GButton(
                  icon: Icons.shopping_cart_outlined,
                  text: 'Cart',
                  leading: cartProvider.itemCount > 0
                      ? Badge(
                          backgroundColor: AppColors.dealRed,
                          label: Text(
                            '${cartProvider.itemCount}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          child: Icon(
                            _currentIndex == 2 ? Icons.shopping_cart : Icons.shopping_cart_outlined,
                            size: 22,
                            color: _currentIndex == 2 ? Colors.white : Colors.grey.shade600,
                          ),
                        )
                      : null,
                ),
                const GButton(
                  icon: Icons.person_outline,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
