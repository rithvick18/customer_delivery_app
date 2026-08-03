import 'package:flutter/material.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/product_card.dart';

class ProductListingsScreen extends StatefulWidget {
  final CartProvider provider;

  const ProductListingsScreen({
    super.key,
    required this.provider,
  });

  @override
  State<ProductListingsScreen> createState() => _ProductListingsScreenState();
}

class _ProductListingsScreenState extends State<ProductListingsScreen> {
  String _selectedCategory = 'All Produce';
  String _searchQuery = '';

  final List<String> _categories = [
    'All Produce',
    'Organic',
    'Local Farms',
    'On Sale',
    'In Stock'
  ];

  @override
  Widget build(BuildContext context) {
    final selectedStore = widget.provider.selectedStore;
    final allProducts = ProductModel.sampleProducts;

    final filteredProducts = allProducts.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      if (!matchesSearch) return false;

      if (_selectedCategory == 'All Produce') return true;
      if (_selectedCategory == 'Organic') return p.isOrganic;
      if (_selectedCategory == 'Local Farms') return p.badgeText?.contains('Local') ?? false;
      if (_selectedCategory == 'On Sale') return p.badgeText != null;
      if (_selectedCategory == 'In Stock') return p.stockStatus != StockStatus.outOfStock;
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              selectedStore.name,
              style: AppTypography.labelCaps.copyWith(color: AppColors.primary),
            ),
            Text(
              'Stock Confidence Produce',
              style: AppTypography.headlineMobile.copyWith(fontSize: 20),
            ),
          ],
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined, color: AppColors.onSurface),
                onPressed: () {},
              ),
              if (widget.provider.totalItemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primaryContainer,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Text(
                      '${widget.provider.totalItemCount}',
                      textAlign: TextAlign.center,
                      style: AppTypography.badgeText.copyWith(
                        fontSize: 10,
                        color: AppColors.onPrimaryContainer,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Live Stock Banner & Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomSearchBar(
                    hintText: 'Search produce catalog...',
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val;
                      });
                    },
                  ),
                  const SizedBox(height: 12),

                  // Live Sync Status Banner
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.surfaceContainerHigh),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.confidenceHigh,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Live Stock Sync Active • Inventory verified 2 mins ago',
                            style: AppTypography.labelCaps.copyWith(
                              fontSize: 11,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Category Pills Horizontal List
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _categories.length,
                itemBuilder: (context, index) {
                  final cat = _categories[index];
                  final isSelected = _selectedCategory == cat;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: ChoiceChip(
                      label: Text(cat),
                      selected: isSelected,
                      onSelected: (val) {
                        if (val) {
                          setState(() {
                            _selectedCategory = cat;
                          });
                        }
                      },
                      selectedColor: AppColors.primaryContainer,
                      backgroundColor: AppColors.surfaceContainerLowest,
                      labelStyle: AppTypography.bodySm.copyWith(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryContainer : AppColors.outlineVariant,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),

            // Product Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.63,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  final qty = widget.provider.getQuantity(product.id);
                  return ProductCard(
                    product: product,
                    cartQuantity: qty,
                    onAdd: () {
                      widget.provider.incrementQuantity(product.id);
                    },
                    onRemove: () {
                      widget.provider.decrementQuantity(product.id);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
