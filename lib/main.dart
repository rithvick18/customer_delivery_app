import 'package:flutter/material.dart';
import 'providers/cart_provider.dart';
import 'services/supabase_service.dart';
import 'theme/app_theme.dart';
import 'views/main_navigation_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const SolarisGroceryApp());
}

class SolarisGroceryApp extends StatefulWidget {
  const SolarisGroceryApp({super.key});

  @override
  State<SolarisGroceryApp> createState() => _SolarisGroceryAppState();
}

class _SolarisGroceryAppState extends State<SolarisGroceryApp> {
  late final CartProvider _cartProvider;

  @override
  void initState() {
    super.initState();
    _cartProvider = CartProvider();
    _cartProvider.fetchStores().then((_) {
      _cartProvider.fetchProductsForStore(_cartProvider.selectedStore.id);
    });
  }

  @override
  void dispose() {
    _cartProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solaris Gold Grocery',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainNavigationScreen(provider: _cartProvider),
    );
  }
}
