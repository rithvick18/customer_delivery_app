import 'package:flutter/material.dart';
import '../models/store.dart';
import '../models/product.dart';
import '../models/live_order.dart';
import '../models/replacement_preference.dart';

/// Central state provider managing cart items, store selection, live order state, and replacement preferences.
class CartProvider extends ChangeNotifier {
  StoreModel _selectedStore = StoreModel.sampleStores.first;
  final Map<String, int> _cartQuantities = {};
  final LiveOrderModel _liveOrder = LiveOrderModel.sampleLiveOrder;
  ReplacementPreferenceModel _preferences = ReplacementPreferenceModel.samplePreferences;
  ReplacementDecisionStatus _replacementDecision = ReplacementDecisionStatus.pending;
  String? _selectedReplacementId;

  bool _hasActiveOrder = false;

  StoreModel get selectedStore => _selectedStore;
  Map<String, int> get cartQuantities => Map.unmodifiable(_cartQuantities);
  LiveOrderModel get liveOrder => _liveOrder;
  ReplacementPreferenceModel get preferences => _preferences;
  ReplacementDecisionStatus get replacementDecision => _replacementDecision;
  String? get selectedReplacementId => _selectedReplacementId;
  bool get hasActiveOrder => _hasActiveOrder;

  int get totalItemCount => _cartQuantities.values.fold(0, (sum, q) => sum + q);

  double get totalPrice {
    double total = 0.0;
    _cartQuantities.forEach((prodId, qty) {
      final prod = ProductModel.sampleProducts.firstWhere(
        (p) => p.id == prodId,
        orElse: () => ProductModel.sampleProducts.first,
      );
      total += prod.price * qty;
    });
    return total;
  }

  void selectStore(StoreModel store) {
    _selectedStore = store;
    notifyListeners();
  }

  int getQuantity(String productId) {
    return _cartQuantities[productId] ?? 0;
  }

  void incrementQuantity(String productId) {
    _cartQuantities[productId] = (_cartQuantities[productId] ?? 0) + 1;
    notifyListeners();
  }

  void decrementQuantity(String productId) {
    if (_cartQuantities.containsKey(productId)) {
      final current = _cartQuantities[productId]!;
      if (current > 1) {
        _cartQuantities[productId] = current - 1;
      } else {
        _cartQuantities.remove(productId);
      }
      notifyListeners();
    }
  }

  void approveReplacement(String replacementId) {
    _replacementDecision = ReplacementDecisionStatus.approved;
    _selectedReplacementId = replacementId;
    notifyListeners();
  }

  void declineReplacement() {
    _replacementDecision = ReplacementDecisionStatus.declined;
    _selectedReplacementId = null;
    notifyListeners();
  }

  void updateGlobalStrategy(GlobalReplacementStrategy strategy) {
    _preferences = ReplacementPreferenceModel(
      defaultStrategy: strategy,
      allowPriceIncreaseUpTo20Pct: _preferences.allowPriceIncreaseUpTo20Pct,
      preferOrganicIfOriginalOrganic: _preferences.preferOrganicIfOriginalOrganic,
      categoryPreferences: _preferences.categoryPreferences,
    );
    notifyListeners();
  }

  void toggleAllowPriceIncrease(bool val) {
    _preferences = ReplacementPreferenceModel(
      defaultStrategy: _preferences.defaultStrategy,
      allowPriceIncreaseUpTo20Pct: val,
      preferOrganicIfOriginalOrganic: _preferences.preferOrganicIfOriginalOrganic,
      categoryPreferences: _preferences.categoryPreferences,
    );
    notifyListeners();
  }

  void togglePreferOrganic(bool val) {
    _preferences = ReplacementPreferenceModel(
      defaultStrategy: _preferences.defaultStrategy,
      allowPriceIncreaseUpTo20Pct: _preferences.allowPriceIncreaseUpTo20Pct,
      preferOrganicIfOriginalOrganic: val,
      categoryPreferences: _preferences.categoryPreferences,
    );
    notifyListeners();
  }

  void placeOrder() {
    _hasActiveOrder = true;
    _cartQuantities.clear();
    notifyListeners();
  }

  void completeOrder() {
    _hasActiveOrder = false;
    notifyListeners();
  }

  void clearCart() {
    _cartQuantities.clear();
    notifyListeners();
  }
}
