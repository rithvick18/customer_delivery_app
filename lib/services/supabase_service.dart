import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/store.dart';
import '../models/product.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://idiqnfrpbslnagkmuvck.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImlkaXFuZnJwYnNsbmFna211dmNrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODU3NDU4NzAsImV4cCI6MjEwMTMyMTg3MH0.SoL82AINtVf6LTGLS4VvOlXg0i1upjWb5bjversndk8';

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      // ignore: deprecated_member_use
      anonKey: supabaseAnonKey,
    );
  }

  SupabaseClient get client => Supabase.instance.client;

  Future<List<StoreModel>> fetchStores() async {
    try {
      final response = await client
          .from('stores')
          .select('*')
          .order('name', ascending: true);

      final list = (response as List).cast<Map<String, dynamic>>();
      return list.map((map) => StoreModel.fromMap(map)).toList();
    } catch (e) {
      // Fallback to sample stores if network error occurs
      return StoreModel.sampleStores;
    }
  }

  Future<List<ProductModel>> fetchProductsForStore(String storeId) async {
    try {
      final response = await client
          .from('store_inventory')
          .select('*, products(*)')
          .eq('store_id', storeId);

      final list = (response as List).cast<Map<String, dynamic>>();
      return list.map((map) => ProductModel.fromInventoryMap(map)).toList();
    } catch (e) {
      // Fallback to sample products if network error occurs
      return ProductModel.sampleProducts;
    }
  }
}
