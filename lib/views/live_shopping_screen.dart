import 'package:flutter/material.dart';
import '../models/live_order.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/live_shopper_card.dart';
import '../widgets/replacement_option_card.dart';

class LiveShoppingScreen extends StatelessWidget {
  final CartProvider provider;

  const LiveShoppingScreen({
    super.key,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final liveOrder = provider.liveOrder;
    final decision = provider.replacementDecision;
    final selectedId = provider.selectedReplacementId;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order #${liveOrder.orderId}',
              style: AppTypography.labelCaps.copyWith(color: AppColors.primary),
            ),
            Text(
              'Live Shopping Progress',
              style: AppTypography.headlineMobile.copyWith(fontSize: 20),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded, color: AppColors.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Live Shopper Card Component
              LiveShopperCard(liveOrder: liveOrder),
              const SizedBox(height: 20),

              // Out of Stock Replacement Action Banner / Alert
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer.withValues(alpha: 0.35),
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: AppColors.errorContainer),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: AppColors.error, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Action Required: Item Out of Stock',
                            style: AppTypography.titleMd.copyWith(
                              fontSize: 15,
                              color: AppColors.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Marcus noticed "${liveOrder.outOfStockItemName}" is out of stock in Aisle 4. Please approve a replacement below.',
                      style: AppTypography.bodySm.copyWith(fontSize: 13, color: AppColors.onSurface),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Text(
                'Recommended AI Replacements',
                style: AppTypography.titleMd.copyWith(fontSize: 18),
              ),
              const SizedBox(height: 4),
              Text(
                'Matches your saved preferences for Dairy & Milk',
                style: AppTypography.bodySm.copyWith(fontSize: 12),
              ),
              const SizedBox(height: 12),

              // Replacement Options Carousel / List
              ...liveOrder.replacementOptions.map(
                (option) => ReplacementOptionCard(
                  option: option,
                  isSelected: selectedId == option.id && decision == ReplacementDecisionStatus.approved,
                  onApprove: () {
                    provider.approveReplacement(option.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Approved "${option.title}" as replacement!'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 8),

              // Action Buttons Row (Decline / Custom / Refund)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        provider.declineReplacement();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Requested refund for out-of-stock item')),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.outline),
                      ),
                      child: Text(
                        'Don\'t Replace (Refund)',
                        style: AppTypography.bodySm.copyWith(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Order Items Activity Stream List
              Text(
                'Cart Item Status Stream',
                style: AppTypography.titleMd,
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  children: liveOrder.items.map((item) {
                    final isInCart = item.status == 'In Cart';
                    final isOutOfStock = item.status == 'Out of Stock';

                    return ListTile(
                      leading: Icon(
                        isInCart
                            ? Icons.check_circle_rounded
                            : isOutOfStock
                                ? Icons.cancel_rounded
                                : Icons.radio_button_unchecked_rounded,
                        color: isInCart
                            ? AppColors.confidenceHigh
                            : isOutOfStock
                                ? AppColors.error
                                : AppColors.primary,
                      ),
                      title: Text(
                        item.name,
                        style: AppTypography.titleMd.copyWith(fontSize: 14),
                      ),
                      subtitle: Text(
                        'Qty: ${item.quantity} • \$${(item.quantity * item.unitPrice).toStringAsFixed(2)}',
                        style: AppTypography.bodySm.copyWith(fontSize: 12),
                      ),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: isInCart
                              ? AppColors.surfaceContainerLow
                              : isOutOfStock
                                  ? AppColors.errorContainer.withValues(alpha: 0.5)
                                  : AppColors.primaryContainer.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.status,
                          style: AppTypography.labelCaps.copyWith(
                            fontSize: 10,
                            color: isOutOfStock ? AppColors.error : AppColors.onSurface,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                  },
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Back to Home / Navigation'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.outlineVariant),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
