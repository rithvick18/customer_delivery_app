/// Model representing a grocery store in Solaris Gold.
class StoreModel {
  final String id;
  final String name;
  final String address;
  final double distanceMiles;
  final int pickupTimeMins;
  final int deliveryTimeMins;
  final int stockConfidenceScore; // e.g. 98%
  final String imageUrl;
  final bool isPrimary;
  final bool isOpen;
  final List<String> tags; // e.g., ['Organic', 'Live Stock Tracking', 'Pickup Available']

  const StoreModel({
    required this.id,
    required this.name,
    required this.address,
    required this.distanceMiles,
    required this.pickupTimeMins,
    required this.deliveryTimeMins,
    required this.stockConfidenceScore,
    required this.imageUrl,
    this.isPrimary = false,
    this.isOpen = true,
    required this.tags,
  });

  /// Sample mock stores for the app
  static List<StoreModel> get sampleStores => const [
        StoreModel(
          id: 'store_1',
          name: 'Solaris Supercenter',
          address: '742 Evergreen Terrace, Springfield',
          distanceMiles: 0.8,
          pickupTimeMins: 15,
          deliveryTimeMins: 30,
          stockConfidenceScore: 98,
          imageUrl: 'assets/images/store_supercenter.jpg',
          isPrimary: true,
          isOpen: true,
          tags: ['Open Now', 'Live Stock Sync', '30 Min Delivery', 'Curbside Pickup'],
        ),
        StoreModel(
          id: 'store_2',
          name: 'Solaris Market & Bakery',
          address: '120 Oakridge Blvd, Springfield',
          distanceMiles: 1.5,
          pickupTimeMins: 20,
          deliveryTimeMins: 45,
          stockConfidenceScore: 92,
          imageUrl: 'assets/images/store_market.jpg',
          isPrimary: false,
          isOpen: true,
          tags: ['Open Now', 'Artisanal Bakery', 'Local Produce'],
        ),
        StoreModel(
          id: 'store_3',
          name: 'Solaris Organic Express',
          address: '405 Pine Street, Springfield',
          distanceMiles: 2.3,
          pickupTimeMins: 25,
          deliveryTimeMins: 50,
          stockConfidenceScore: 89,
          imageUrl: 'assets/images/store_organic.jpg',
          isPrimary: false,
          isOpen: true,
          tags: ['100% Organic', 'Farm Direct', 'Live Stock Tracking'],
        ),
      ];
}
