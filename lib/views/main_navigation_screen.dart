import 'package:flutter/material.dart';
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
          border: Border(top: BorderSide(color: Colors.grey.shade300, width: 0.5)),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: _onTabSelect,
          backgroundColor: Colors.white,
          indicatorColor: AppColors.amazonOrange.withValues(alpha: 0.2),
          elevation: 0,
          height: 60,
          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home, color: AppColors.headerNavy),
              label: 'Home',
            ),
            const NavigationDestination(
              icon: Icon(Icons.grid_view_outlined),
              selectedIcon: Icon(Icons.grid_view_rounded, color: AppColors.headerNavy),
              label: 'Explore',
            ),
            NavigationDestination(
              icon: Badge(
                isLabelVisible: cartProvider.itemCount > 0,
                backgroundColor: AppColors.dealRed,
                label: Text('${cartProvider.itemCount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              selectedIcon: Badge(
                isLabelVisible: cartProvider.itemCount > 0,
                backgroundColor: AppColors.dealRed,
                label: Text('${cartProvider.itemCount}', style: const TextStyle(fontWeight: FontWeight.bold)),
                child: const Icon(Icons.shopping_cart, color: AppColors.headerNavy),
              ),
              label: 'Cart',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person, color: AppColors.headerNavy),
              label: 'You',
            ),
          ],
        ),
      ),
    );
  }
}
