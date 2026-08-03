enum StockStatus { inStock, lowStock, outOfStock }

/// Model representing a grocery product with live stock confidence.
class ProductModel {
  final String id;
  final String name;
  final double price;
  final String unit; // e.g., 'lb', 'bag', 'ea', 'gal'
  final int stockCount;
  final int stockConfidenceScore; // e.g. 95%
  final String category;
  final StockStatus stockStatus;
  final String imageUrl;
  final bool isOrganic;
  final String? badgeText; // e.g. 'Popular', 'Local', 'Limited'

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.unit,
    required this.stockCount,
    required this.stockConfidenceScore,
    required this.category,
    required this.stockStatus,
    required this.imageUrl,
    this.isOrganic = false,
    this.badgeText,
  });

  /// Sample mock produce items for Screen 2
  static List<ProductModel> get sampleProducts => const [
        ProductModel(
          id: 'prod_1',
          name: 'Organic Honeycrisp Apples',
          price: 2.99,
          unit: 'lb',
          stockCount: 42,
          stockConfidenceScore: 95,
          category: 'Produce',
          stockStatus: StockStatus.inStock,
          imageUrl: 'assets/images/honeycrisp_apples.jpg',
          isOrganic: true,
          badgeText: 'High Demand',
        ),
        ProductModel(
          id: 'prod_2',
          name: 'Hass Avocados',
          price: 1.50,
          unit: 'ea',
          stockCount: 5,
          stockConfidenceScore: 60,
          category: 'Produce',
          stockStatus: StockStatus.lowStock,
          imageUrl: 'assets/images/hass_avocados.jpg',
          isOrganic: false,
          badgeText: 'Low Stock',
        ),
        ProductModel(
          id: 'prod_3',
          name: 'Organic Baby Spinach',
          price: 3.49,
          unit: 'bag (5 oz)',
          stockCount: 28,
          stockConfidenceScore: 99,
          category: 'Produce',
          stockStatus: StockStatus.inStock,
          imageUrl: 'assets/images/baby_spinach.jpg',
          isOrganic: true,
          badgeText: 'Organic',
        ),
        ProductModel(
          id: 'prod_4',
          name: 'Heirloom Tomatoes',
          price: 4.25,
          unit: 'lb',
          stockCount: 0,
          stockConfidenceScore: 20,
          category: 'Produce',
          stockStatus: StockStatus.outOfStock,
          imageUrl: 'assets/images/heirloom_tomatoes.jpg',
          isOrganic: true,
          badgeText: 'Restocking 2 PM',
        ),
        ProductModel(
          id: 'prod_5',
          name: 'Fresh Organic Bananas',
          price: 0.79,
          unit: 'lb',
          stockCount: 65,
          stockConfidenceScore: 98,
          category: 'Produce',
          stockStatus: StockStatus.inStock,
          imageUrl: 'assets/images/bananas.jpg',
          isOrganic: true,
        ),
        ProductModel(
          id: 'prod_6',
          name: 'Sweet Yellow Strawberries',
          price: 4.99,
          unit: 'pack (16 oz)',
          stockCount: 12,
          stockConfidenceScore: 84,
          category: 'Produce',
          stockStatus: StockStatus.inStock,
          imageUrl: 'assets/images/strawberries.jpg',
          isOrganic: false,
          badgeText: 'Local Farm',
        ),
      ];
}
