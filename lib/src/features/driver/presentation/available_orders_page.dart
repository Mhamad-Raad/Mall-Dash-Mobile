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

class AvailableOrdersPage extends ConsumerWidget {
  const AvailableOrdersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(availableOrdersNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Available Orders')),
      body: ordersState.when(
        data: (orders) {
          if (orders.isEmpty) {
            return EmptyState(
              icon: Icons.notifications_active_outlined,
              title: 'Waiting for order assignments',
              subtitle: 'Orders are automatically assigned by the system.\nYou\'ll receive a notification when an order is assigned to you.',
              iconColor: Theme.of(context).colorScheme.primary,
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await ref
                  .read(availableOrdersNotifierProvider.notifier)
                  .refresh();
            },
            child: ListView.builder(
              padding: AppSpacing.allMd,
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return _OrderCard(order: order);
              },
            ),
          );
        },
        loading: () => const LoadingIndicator(),
        error: (error, stackTrace) => ErrorState(
          title: 'Error loading orders',
          message: error.toString(),
          onRetry: () {
            ref.read(availableOrdersNotifierProvider.notifier).refresh();
          },
        ),
      ),
    );
  }
}

class _OrderCard extends ConsumerWidget {
  final DriverOrder order;

  const _OrderCard({required this.order});

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
              builder: (context) => DeliveryDetailsPage(orderId: order.id),
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
                    'Order #${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  StatusBadgeSolid(
                    label: order.statusName,
                    statusCode: order.status,
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
                    order.customerName ?? 'Customer',
                    style: TextStyle(fontSize: 14, color: appTheme.textSecondary),
                  ),
                ],
              ),
              if (order.customerPhone != null) ...[
                AppSpacing.verticalGapXxs,
                Row(
                  children: [
                    Icon(Icons.phone_outlined, size: AppSpacing.iconSm + 2, color: appTheme.textTertiary),
                    AppSpacing.horizontalGapXs,
                    Text(
                      order.customerPhone!,
                      style: TextStyle(fontSize: 14, color: appTheme.textSecondary),
                    ),
                  ],
                ),
              ],
              AppSpacing.verticalGapXxs,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.location_on_outlined, size: AppSpacing.iconSm + 2, color: appTheme.textTertiary),
                  AppSpacing.horizontalGapXs,
                  Expanded(
                    child: Text(
                      _formatAddress(order),
                      style: TextStyle(fontSize: 14, color: appTheme.textSecondary),
                    ),
                  ),
                ],
              ),
              if (order.totalAmount != null) ...[
                AppSpacing.verticalGapXs,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Amount', style: TextStyle(fontSize: 14)),
                    Text(
                      '\$${order.totalAmount!.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: appTheme.successColor,
                      ),
                    ),
                  ],
                ),
              ],
              AppSpacing.verticalGapSm,
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: order.assignmentId != null
                          ? () =>
                                _rejectOrder(context, ref, order.assignmentId!)
                          : null,
                      icon: const Icon(Icons.close),
                      label: const Text('Reject'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: appTheme.errorColor,
                      ),
                    ),
                  ),
                  AppSpacing.horizontalGapSm,
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: order.assignmentId != null
                          ? () =>
                                _acceptOrder(context, ref, order)
                          : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatAddress(DriverOrder order) {
    final parts = <String>[];

    if (order.apartmentNumber != null)
      parts.add('Apt ${order.apartmentNumber}');
    if (order.floorNumber != null) parts.add('Floor ${order.floorNumber}');
    if (order.buildingName != null) parts.add(order.buildingName!);
    if (order.deliveryAddress != null) parts.add(order.deliveryAddress!);

    return parts.isEmpty ? 'No address provided' : parts.join(', ');
  }

  Future<void> _acceptOrder(
    BuildContext context,
    WidgetRef ref,
    DriverOrder order,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Order'),
        content: Text('Do you want to accept order #${order.orderNumber}?'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Order'),
        content: Text(
          'Are you sure you want to reject order #${order.orderNumber}?',
        ),
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
}
