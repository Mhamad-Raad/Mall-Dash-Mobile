import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/status_badge.dart';
import 'driver_orders_notifier.dart';
import '../data/driver_order_model.dart';

class DeliveryDetailsPage extends ConsumerWidget {
  final int orderId;

  const DeliveryDetailsPage({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderAsync = ref.watch(orderDetailsProvider(orderId));
    final liveOrderAsync = ref.watch(driverOrderSocketProvider(orderId));

    return Scaffold(
      appBar: AppBar(title: const Text('Delivery Details')),
      body: orderAsync.when(
        data: (initialOrder) {
          final liveOrder = liveOrderAsync.when(
            data: (value) => value,
            loading: () => null,
            error: (_, __) => null,
          );

          final order = liveOrder ?? initialOrder;
          if (order == null) {
            return Center(
              child: Builder(
                builder: (context) {
                  final appTheme = context.appTheme;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error_outline, size: 64, color: appTheme.textTertiary),
                      const SizedBox(height: 16),
                      Text(
                        'Order not found',
                        style: TextStyle(fontSize: 18, color: appTheme.textSecondary),
                      ),
                    ],
                  );
                },
              ),
            );
          }

          return SingleChildScrollView(
            padding: AppSpacing.allMd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Header
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: AppSpacing.allMd,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.orderNumber}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            StatusBadgeSolid(
                              label: order.statusName,
                              statusCode: order.status,
                              size: StatusBadgeSize.medium,
                            ),
                          ],
                        ),
                        if (order.totalAmount != null) ...[
                          const SizedBox(height: 12),
                          Builder(
                            builder: (context) {
                              final appTheme = context.appTheme;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  Text(
                                    '\$${order.totalAmount!.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: appTheme.successColor,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Customer Information
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Customer Information',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.person_outline),
                            const SizedBox(width: 12),
                            Text(
                              order.customerName ?? 'Customer',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        if (order.customerPhone != null) ...[
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              const Icon(Icons.phone_outlined),
                              const SizedBox(width: 12),
                              Text(
                                order.customerPhone!,
                                style: const TextStyle(fontSize: 16),
                              ),
                              const Spacer(),
                              Builder(
                                builder: (context) {
                                  final appTheme = context.appTheme;
                                  return IconButton(
                                    icon: const Icon(Icons.call),
                                    color: appTheme.successColor,
                                    onPressed: () {
                                      // TODO: Implement phone call functionality
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'Call functionality coming soon',
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Delivery Address
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Delivery Address',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.map),
                              color: Theme.of(context).colorScheme.primary,
                              onPressed: () {
                                // TODO: Implement map navigation
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Map navigation coming soon'),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (order.buildingName != null) ...[
                          _AddressRow(
                            icon: Icons.business,
                            label: 'Building',
                            value: order.buildingName!,
                          ),
                        ],
                        if (order.floorNumber != null) ...[
                          _AddressRow(
                            icon: Icons.layers,
                            label: 'Floor',
                            value: order.floorNumber!,
                          ),
                        ],
                        if (order.apartmentNumber != null) ...[
                          _AddressRow(
                            icon: Icons.door_front_door,
                            label: 'Apartment',
                            value: order.apartmentNumber!,
                          ),
                        ],
                        if (order.deliveryAddress != null) ...[
                          _AddressRow(
                            icon: Icons.location_on,
                            label: 'Address',
                            value: order.deliveryAddress!,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Order Items
                if (order.items != null && order.items!.isNotEmpty) ...[
                  Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Items',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          ...order.items!.map(
                            (item) => _OrderItemRow(item: item),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Action Buttons
                _buildActionButtons(context, ref, order),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Builder(
            builder: (context) {
              final appTheme = context.appTheme;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: appTheme.errorColor),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading order',
                    style: TextStyle(fontSize: 18, color: appTheme.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(fontSize: 14, color: appTheme.textTertiary),
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    DriverOrder order,
  ) {
    if (order.status == 4 || order.status == 5) {
      // Ready for pickup or assigned - show accept/reject buttons
      final appTheme = context.appTheme;
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: order.assignmentId != null
                  ? () => _rejectOrder(context, ref, order.assignmentId!)
                  : null,
              icon: const Icon(Icons.close),
              label: const Text('Reject'),
              style: OutlinedButton.styleFrom(
                foregroundColor: appTheme.errorColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: order.assignmentId != null
                  ? () => _acceptOrder(context, ref, order)
                  : null,
              icon: const Icon(Icons.check),
              label: const Text('Accept'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      );
    } else if (order.status == 6) {
      // Picked up - show mark in transit button
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () =>
              _updateStatus(context, ref, order.id, DeliveryStatus.inTransit),
          icon: const Icon(Icons.local_shipping),
          label: const Text('Mark In Transit'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    } else if (order.status == 7) {
      // In transit - show mark delivered button
      final appTheme = context.appTheme;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () => _completeDelivery(context, ref, order.id),
          icon: const Icon(Icons.check_circle),
          label: const Text('Mark Delivered'),
          style: ElevatedButton.styleFrom(
            backgroundColor: appTheme.successColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  // Status colors now handled by StatusBadgeSolid widget
  Color _getStatusColorLegacy(int status, CustomThemeExtension appTheme) {
    switch (status) {
      case 4:
        return appTheme.warningColor;
      case 5:
        return appTheme.infoColor;
      case 6:
        return appTheme.warningColor;
      case 7:
        return appTheme.infoColor;
      case 8:
        return appTheme.successColor;
      default:
        return appTheme.textTertiary;
    }
  }

  Future<void> _acceptOrder(
    BuildContext context,
    WidgetRef ref,
    DriverOrder order,
  ) async {
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Order'),
        content: const Text('Do you want to accept this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(availableOrdersNotifierProvider.notifier)
            .acceptOrder(order.assignmentId!, order);

        if (context.mounted) {
          Navigator.pop(context);
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order accepted successfully'),
              backgroundColor: appTheme.successColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error accepting order: $e'),
              backgroundColor: appTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _rejectOrder(
    BuildContext context,
    WidgetRef ref,
    int assignmentId,
  ) async {
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Order'),
        content: const Text('Are you sure you want to reject this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        await ref
            .read(availableOrdersNotifierProvider.notifier)
            .rejectOrder(assignmentId);

        if (context.mounted) {
          Navigator.pop(context);
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Order rejected'),
              backgroundColor: appTheme.warningColor,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          final appTheme = context.appTheme;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error rejecting order: $e'),
              backgroundColor: appTheme.errorColor,
            ),
          );
        }
      }
    }
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    int orderId,
    DeliveryStatus newStatus,
  ) async {
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status'),
        content: Text('Mark order as ${newStatus.displayName}?'),
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

        // Invalidate to refresh the details
        ref.invalidate(orderDetailsProvider(orderId));

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
    if (!context.mounted) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Delivery'),
        content: const Text(
          'Are you sure you want to mark this delivery as completed?',
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
          Navigator.pop(context);
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

class _AddressRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _AddressRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(fontSize: 12, color: appTheme.textSecondary),
                ),
                Text(value, style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderItemRow extends StatelessWidget {
  final OrderItem item;

  const _OrderItemRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final appTheme = context.appTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: appTheme.surfaceVariant,
              borderRadius: AppRadius.radiusSm,
            ),
            child: item.imageUrl != null
                ? ClipRRect(
                    borderRadius: AppRadius.radiusSm,
                    child: Image.network(
                      item.imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image);
                      },
                    ),
                  )
                : const Icon(Icons.shopping_bag_outlined),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Qty: ${item.quantity}',
                  style: TextStyle(fontSize: 12, color: appTheme.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
