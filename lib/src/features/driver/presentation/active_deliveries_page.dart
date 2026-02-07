import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'driver_orders_notifier.dart';
import 'delivery_details_page.dart';
import '../data/driver_order_model.dart';

class ActiveDeliveriesPage extends ConsumerWidget {
  const ActiveDeliveriesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveriesState = ref.watch(activeDeliveriesNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Active Deliveries')),
      body: deliveriesState.when(
        data: (deliveries) {
          if (deliveries.isEmpty) {
            return EmptyState(
              icon: Icons.local_shipping_outlined,
              title: 'No active deliveries',
              subtitle: 'Accept an order to start delivering',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(activeDeliveriesNotifierProvider.notifier)
                  .refresh();
            },
            child: ListView.builder(
              padding: AppSpacing.allMd,
              itemCount: deliveries.length,
              itemBuilder: (context, index) {
                final delivery = deliveries[index];
                return _DeliveryCard(delivery: delivery);
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => ErrorState(
          title: 'Error loading deliveries',
          message: error.toString(),
          onRetry: () {
            ref.read(activeDeliveriesNotifierProvider.notifier).refresh();
          },
        ),
      ),
    );
  }
}

class _DeliveryCard extends ConsumerWidget {
  final DriverOrder delivery;

  const _DeliveryCard({required this.delivery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = context.appTheme;
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeliveryDetailsPage(orderId: delivery.id),
            ),
          );
        },
        child: Padding(
          padding: AppSpacing.allMd,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${delivery.orderNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StatusBadgeSolid(
                    label: delivery.statusName,
                    statusCode: delivery.status,
                    size: StatusBadgeSize.small,
                  ),
                ],
              ),
              AppSpacing.verticalGapSm,
              Row(
                children: [
                  Icon(Icons.person_outline, size: AppSpacing.iconSm + 2, color: appTheme.textTertiary),
                  AppSpacing.horizontalGapXs,
                  Text(
                    delivery.customerName ?? 'Customer',
                    style: TextStyle(fontSize: 14, color: appTheme.textSecondary),
                  ),
                ],
              ),
              if (delivery.customerPhone != null) ...[
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      delivery.customerPhone!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.location_on_outlined, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _formatAddress(delivery),
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              if (delivery.totalAmount != null) ...[
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 14)),
                    Text(
                      '\$${delivery.totalAmount!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              // Action buttons based on status
              if (delivery.status == 6) ...[
                // Picked up - show "Mark In Transit" button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _updateStatus(
                      context,
                      ref,
                      delivery.id,
                      DeliveryStatus.inTransit,
                      'Mark In Transit',
                    ),
                    icon: const Icon(Icons.local_shipping),
                    label: const Text('Mark In Transit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.infoColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ] else if (delivery.status == 7) ...[
                // In Transit - show "Mark Delivered" button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        _completeDelivery(context, ref, delivery.id),
                    icon: const Icon(Icons.check_circle),
                    label: const Text('Mark Delivered'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appTheme.successColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Status color now handled by StatusBadgeSolid widget

  String _formatAddress(DriverOrder delivery) {
    final parts = <String>[];

    if (delivery.apartmentNumber != null)
      parts.add('Apt ${delivery.apartmentNumber}');
    if (delivery.floorNumber != null)
      parts.add('Floor ${delivery.floorNumber}');
    if (delivery.buildingName != null) parts.add(delivery.buildingName!);
    if (delivery.deliveryAddress != null) parts.add(delivery.deliveryAddress!);

    return parts.isEmpty ? 'No address provided' : parts.join(', ');
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    int orderId,
    DeliveryStatus newStatus,
    String actionName,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(actionName),
        content: Text(
          'Update order #${delivery.orderNumber} to ${newStatus.displayName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(activeDeliveriesNotifierProvider.notifier)
            .updateOrderStatus(orderId, newStatus);

        if (context.mounted) {
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Status updated to ${newStatus.displayName}'),
              backgroundColor: appTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error updating status: $e'),
              backgroundColor: appTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _completeDelivery(
    BuildContext context,
    WidgetRef ref,
    int orderId,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Delivery'),
        content: Text(
          'Are you sure you want to mark order #${delivery.orderNumber} as delivered?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Complete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(activeDeliveriesNotifierProvider.notifier)
            .completeDelivery(orderId);

        if (context.mounted) {
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Delivery completed successfully!'),
              backgroundColor: appTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error completing delivery: $e'),
              backgroundColor: appTheme.errorColor,
            ),
          );
        }
      }
    }
  }
}
