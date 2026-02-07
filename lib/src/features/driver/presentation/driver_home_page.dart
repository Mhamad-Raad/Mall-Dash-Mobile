import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/design/design_system.dart';
import '../../../core/theme/custom_theme_extension.dart';
import '../../../core/widgets/loading_indicator.dart';
import 'driver_shift_notifier.dart';
import 'driver_orders_notifier.dart';
import 'available_orders_page.dart';
import 'active_deliveries_page.dart';
import 'driver_profile_page.dart';

class DriverHomePage extends ConsumerWidget {
  const DriverHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shiftState = ref.watch(driverShiftNotifierProvider);
    final queuePositionAsync = ref.watch(queuePositionProvider);
    final availableOrdersState = ref.watch(availableOrdersNotifierProvider);
    final activeDeliveriesState = ref.watch(activeDeliveriesNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DriverProfilePage(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(driverShiftNotifierProvider.notifier).refresh();
          await ref.read(availableOrdersNotifierProvider.notifier).refresh();
          await ref.read(activeDeliveriesNotifierProvider.notifier).refresh();
        },
        child: ListView(
          padding: AppSpacing.allMd,
          children: [
            // Shift Status Card
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
                        const Text(
                          'Shift Status',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Builder(
                          builder: (context) {
                            final appTheme = context.appTheme;
                            return shiftState.when(
                              data: (shift) => Container(
                                padding: AppSpacing.statusBadge,
                                decoration: BoxDecoration(
                                  color: shift.isActive
                                      ? appTheme.successColor
                                      : appTheme.textTertiary,
                                  borderRadius: AppRadius.radiusPill,
                                ),
                                child: Text(
                                  shift.isActive ? 'ACTIVE' : 'INACTIVE',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              loading: () => const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              error: (_, __) => Container(
                                padding: AppSpacing.statusBadge,
                                decoration: BoxDecoration(
                                  color: appTheme.errorColor,
                                  borderRadius: AppRadius.radiusPill,
                                ),
                                child: const Text(
                                  'ERROR',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    AppSpacing.verticalGapMd,
                    shiftState.when(
                      data: (shift) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (shift.isActive && shift.startTime != null) ...[
                            Text(
                              'Started: ${_formatTime(shift.startTime!)}',
                              style: const TextStyle(fontSize: 14),
                            ),
                            AppSpacing.verticalGapXs,
                          ],
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (shift.isActive) {
                                  await _endShift(context, ref);
                                } else {
                                  await _startShift(context, ref);
                                }
                              },
                              icon: Icon(
                                shift.isActive ? Icons.stop : Icons.play_arrow,
                              ),
                              label: Text(
                                shift.isActive ? 'End Shift' : 'Start Shift',
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: shift.isActive
                                    ? Theme.of(context).extension<CustomThemeExtension>()!.errorColor
                                    : Theme.of(context).extension<CustomThemeExtension>()!.successColor,
                                foregroundColor: Colors.white,
                                padding: AppSpacing.verticalSm,
                              ),
                            ),
                          ),
                        ],
                      ),
                      loading: () => const LoadingIndicator(),
                      error: (error, _) => Builder(
                        builder: (context) => Text(
                          'Error: $error',
                          style: TextStyle(color: context.appTheme.errorColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AppSpacing.verticalGapMd,

            // Queue Position Card
            queuePositionAsync.when(
              data: (position) {
                if (position != null) {
                  return Card(
                    elevation: 4,
                    child: Padding(
                      padding: AppSpacing.allMd,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Queue Position',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          AppSpacing.verticalGapXs,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Builder(
                                builder: (context) => Text(
                                  '#${position.position}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ),
                              if (position.totalDrivers > 0)
                                Text(
                                  'of ${position.totalDrivers} drivers',
                                  style: const TextStyle(fontSize: 14),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
              loading: () => const Card(
                elevation: 4,
                child: Padding(
                  padding: AppSpacing.allMd,
                  child: LoadingIndicator(),
                ),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),
            AppSpacing.verticalGapMd,

            // Available Orders Card
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AvailableOrdersPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: AppSpacing.allMd,
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          final appTheme = context.appTheme;
                          return Container(
                            padding: AppSpacing.allSm,
                            decoration: BoxDecoration(
                              color: appTheme.warningColor.withOpacity(0.15),
                              borderRadius: AppRadius.radiusMd,
                            ),
                            child: Icon(
                              Icons.shopping_bag_outlined,
                              color: appTheme.warningColor,
                              size: AppSpacing.iconLg,
                            ),
                          );
                        },
                      ),
                      AppSpacing.horizontalGapMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Available Orders',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppSpacing.verticalGapXxs,
                            availableOrdersState.when(
                              data: (orders) => Builder(
                                builder: (context) => Text(
                                  '${orders.length} order${orders.length != 1 ? 's' : ''} waiting',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: context.appTheme.textSecondary,
                                  ),
                                ),
                              ),
                              loading: () => const Text('Loading...'),
                              error: (_, __) => const Text('Error loading'),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
            AppSpacing.verticalGapSm,

            // Active Deliveries Card
            Card(
              elevation: 4,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ActiveDeliveriesPage(),
                    ),
                  );
                },
                child: Padding(
                  padding: AppSpacing.allMd,
                  child: Row(
                    children: [
                      Builder(
                        builder: (context) {
                          final appTheme = context.appTheme;
                          return Container(
                            padding: AppSpacing.allSm,
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                              borderRadius: AppRadius.radiusMd,
                            ),
                            child: Icon(
                              Icons.local_shipping_outlined,
                              color: Theme.of(context).colorScheme.primary,
                              size: AppSpacing.iconLg,
                            ),
                          );
                        },
                      ),
                      AppSpacing.horizontalGapMd,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Active Deliveries',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            AppSpacing.verticalGapXxs,
                            activeDeliveriesState.when(
                              data: (deliveries) => Builder(
                                builder: (context) => Text(
                                  '${deliveries.length} active',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: context.appTheme.textSecondary,
                                  ),
                                ),
                              ),
                              loading: () => const Text('Loading...'),
                              error: (_, __) => const Text('Error loading'),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _startShift(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Shift'),
        content: const Text(
          'Are you sure you want to start your shift? You will start receiving delivery notifications.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appTheme.successColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Start'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(driverShiftNotifierProvider.notifier).startShift();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Shift started successfully'),
            backgroundColor: context.appTheme.successColor,
          ),
        );
      }
    }
  }

  Future<void> _endShift(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Shift'),
        content: const Text(
          'Are you sure you want to end your shift? You will stop receiving delivery notifications.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: context.appTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('End'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await ref.read(driverShiftNotifierProvider.notifier).endShift();

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Shift ended successfully'),
            backgroundColor: context.appTheme.warningColor,
          ),
        );
      }
    }
  }
}
