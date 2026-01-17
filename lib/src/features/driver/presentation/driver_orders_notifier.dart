import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/driver_order_model.dart';
import '../data/driver_orders_repository.dart';
import '../data/driver_dispatch_repository.dart';
import '../../../core/network/dio_provider.dart';
import 'package:dio/dio.dart';

final driverOrdersRepositoryProvider = Provider<DriverOrdersRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return DriverOrdersRepository(dio);
});

final driverDispatchRepositoryProvider = Provider<DriverDispatchRepository>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return DriverDispatchRepository(dio);
});

// Available orders (status 4 or 5 - ready for pickup or assigned)
final availableOrdersNotifierProvider =
    AsyncNotifierProvider<AvailableOrdersNotifier, List<DriverOrder>>(
      AvailableOrdersNotifier.new,
    );

// Active deliveries (status 6 or 7 - picked up or in transit)
final activeDeliveriesNotifierProvider =
    AsyncNotifierProvider<ActiveDeliveriesNotifier, List<DriverOrder>>(
      ActiveDeliveriesNotifier.new,
    );

// Single order details
final orderDetailsProvider = FutureProvider.family<DriverOrder?, int>((
  ref,
  orderId,
) async {
  final repository = ref.watch(driverOrdersRepositoryProvider);
  return await repository.getOrderById(orderId);
});

class AvailableOrdersNotifier extends AsyncNotifier<List<DriverOrder>> {
  @override
  Future<List<DriverOrder>> build() async {
    return await _loadAvailableOrders();
  }

  Future<List<DriverOrder>> _loadAvailableOrders() async {
    final repository = ref.read(driverOrdersRepositoryProvider);

    // Get orders with status 4 (ready for pickup) or 5 (assigned to driver)
    final readyOrders = await repository.getOrders(
      page: 1,
      limit: 50,
      status: '4',
    );
    final assignedOrders = await repository.getOrders(
      page: 1,
      limit: 50,
      status: '5',
    );

    // Combine and deduplicate
    final allOrders = [...readyOrders, ...assignedOrders];
    final uniqueOrders = <int, DriverOrder>{};

    for (final order in allOrders) {
      uniqueOrders[order.id] = order;
    }

    // Sort by creation date (newest first)
    final sortedOrders = uniqueOrders.values.toList()
      ..sort(
        (a, b) => (b.createdAt ?? DateTime.now()).compareTo(
          a.createdAt ?? DateTime.now(),
        ),
      );

    return sortedOrders;
  }

  Future<void> acceptOrder(int assignmentId) async {
    final dispatchRepository = ref.read(driverDispatchRepositoryProvider);

    try {
      final success = await dispatchRepository.acceptOrder(assignmentId);

      if (success) {
        // Refresh both available and active deliveries
        await refresh();
        ref.invalidate(activeDeliveriesNotifierProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> rejectOrder(int assignmentId) async {
    final dispatchRepository = ref.read(driverDispatchRepositoryProvider);

    try {
      final success = await dispatchRepository.rejectOrder(assignmentId);

      if (success) {
        await refresh();
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadAvailableOrders());
  }
}

class ActiveDeliveriesNotifier extends AsyncNotifier<List<DriverOrder>> {
  @override
  Future<List<DriverOrder>> build() async {
    return await _loadActiveDeliveries();
  }

  Future<List<DriverOrder>> _loadActiveDeliveries() async {
    final repository = ref.read(driverOrdersRepositoryProvider);

    // Get orders with status 6 (picked up) or 7 (in transit)
    final pickedUpOrders = await repository.getOrders(
      page: 1,
      limit: 50,
      status: '6',
    );
    final inTransitOrders = await repository.getOrders(
      page: 1,
      limit: 50,
      status: '7',
    );

    // Combine and deduplicate
    final allOrders = [...pickedUpOrders, ...inTransitOrders];
    final uniqueOrders = <int, DriverOrder>{};

    for (final order in allOrders) {
      uniqueOrders[order.id] = order;
    }

    // Sort by delivery time or creation date
    final sortedOrders = uniqueOrders.values.toList()
      ..sort((a, b) {
        final aTime = a.deliveryTime ?? a.createdAt ?? DateTime.now();
        final bTime = b.deliveryTime ?? b.createdAt ?? DateTime.now();
        return aTime.compareTo(bTime);
      });

    return sortedOrders;
  }

  Future<void> updateOrderStatus(int orderId, DeliveryStatus status) async {
    final repository = ref.read(driverOrdersRepositoryProvider);

    try {
      final success = await repository.updateOrderStatus(orderId, status.value);

      if (success) {
        await refresh();

        // If status is delivered, also refresh available orders
        if (status == DeliveryStatus.delivered) {
          ref.invalidate(availableOrdersNotifierProvider);
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> completeDelivery(int orderId) async {
    final dispatchRepository = ref.read(driverDispatchRepositoryProvider);

    try {
      final success = await dispatchRepository.completeDelivery(orderId);

      if (success) {
        await refresh();
        ref.invalidate(availableOrdersNotifierProvider);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _loadActiveDeliveries());
  }
}
