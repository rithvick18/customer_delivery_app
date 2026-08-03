import 'package:flutter/material.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import 'store_selection_screen.dart';
import 'product_listings_screen.dart';
import 'live_shopping_screen.dart';
import 'replacement_preferences_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  final CartProvider provider;

  const MainNavigationScreen({
    super.key,
    required this.provider,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  void _navigateToTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.provider,
      builder: (context, _) {
        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: [
              StoreSelectionScreen(
                provider: widget.provider,
                onNavigateToCatalog: () => _navigateToTab(1),
              ),
              ProductListingsScreen(provider: widget.provider),
              LiveShoppingScreen(provider: widget.provider),
              ReplacementPreferencesScreen(provider: widget.provider),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: _navigateToTab,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.onSurfaceVariant,
            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.storefront_rounded),
                activeIcon: Icon(Icons.storefront_rounded, color: AppColors.primary),
                label: 'Stores',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.grid_view_rounded),
                activeIcon: Icon(Icons.grid_view_rounded, color: AppColors.primary),
                label: 'Catalog',
              ),
              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_bag_outlined),
                    Positioned(
                      right: -4,
                      top: -4,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                activeIcon: const Icon(Icons.shopping_bag, color: AppColors.primary),
                label: 'Live Order',
              ),
              const BottomNavigationBarItem(
                icon: Icon(Icons.tune_rounded),
                activeIcon: Icon(Icons.tune_rounded, color: AppColors.primary),
                label: 'Preferences',
              ),
            ],
          ),
        );
      },
    );
  }
}
