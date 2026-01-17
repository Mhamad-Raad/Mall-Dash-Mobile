import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_repository.dart';
import '../data/notification_model.dart';
import '../../driver/data/driver_order_model.dart';
import '../../driver/data/driver_orders_repository.dart';
import '../../driver/presentation/driver_orders_notifier.dart';
import '../../../core/network/dio_provider.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return NotificationRepository(dio);
});

final driverNotificationServiceProvider = Provider<DriverNotificationService>((ref) {
  return DriverNotificationService(ref);
});

/// Service that polls for notifications every 5 seconds when driver is on shift
class DriverNotificationService {
  final Ref _ref;
  Timer? _pollingTimer;
  int _lastCheckedCount = 0;

  DriverNotificationService(this._ref);

  /// Start polling for notifications every 5 seconds
  void startPolling() {
    if (_pollingTimer != null && _pollingTimer!.isActive) {
      print('ℹ️ Notification polling already active');
      return;
    }

    print('🔔 Starting notification polling (every 5 seconds)');
    
    // Check immediately
    _checkForNewNotifications();
    
    // Then check every 5 seconds
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      _checkForNewNotifications();
    });
  }

  /// Stop polling for notifications
  void stopPolling() {
    if (_pollingTimer != null) {
      print('🔕 Stopping notification polling');
      _pollingTimer?.cancel();
      _pollingTimer = null;
      _lastCheckedCount = 0;
    }
  }

  /// Check if there are new notifications
  Future<void> _checkForNewNotifications() async {
    try {
      final repository = _ref.read(notificationRepositoryProvider);
      
      // First, check unread count (lightweight request)
      final unreadCount = await repository.getUnreadCount();
      
      print('📬 Unread notifications: $unreadCount');

      // Only fetch full notifications if there are new ones
      if (unreadCount > 0 && unreadCount != _lastCheckedCount) {
        _lastCheckedCount = unreadCount;
        
        // Fetch the latest unread notifications
        final notifications = await repository.getNotifications(
          skip: 0,
          take: unreadCount,
        );

        print('📨 Fetched ${notifications.length} notifications');

        // Handle each notification
        for (final notification in notifications) {
          if (!notification.isRead) {
            await _handleNotification(notification);
          }
        }
      }
    } catch (e) {
      print('❌ Error checking notifications: $e');
    }
  }

  /// Handle a notification based on its type
  Future<void> _handleNotification(AppNotification notification) async {
    print('🔔 Handling notification: ${notification.title}');
    print('   Type: ${notification.type}');
    print('   Message: ${notification.message}');
    print('   Data: ${notification.data}');

    final type = notification.type?.toLowerCase() ?? '';

    if (type.contains('order') && type.contains('assign')) {
      // This is an order assignment notification
      await _handleOrderAssignment(notification);
    } else if (type.contains('order') && type.contains('cancel')) {
      // Order cancellation
      print('⚠️ Order cancelled');
    }

    // Mark notification as read
    final repository = _ref.read(notificationRepositoryProvider);
    await repository.markAsRead(notification.id);
  }

  /// Handle order assignment notification
  Future<void> _handleOrderAssignment(AppNotification notification) async {
    try {
      // Extract assignmentId and orderId from notification data
      final data = notification.data;
      
      if (data == null) {
        print('⚠️ Order assignment notification missing data');
        return;
      }

      final assignmentId = data['assignmentId'] as int?;
      final orderId = data['orderId'] as int?;

      print('📦 Order assignment received:');
      print('   Assignment ID: $assignmentId');
      print('   Order ID: $orderId');

      if (orderId == null) {
        print('⚠️ Missing orderId in notification data');
        return;
      }

      // Fetch the full order details
      final orderRepository = _ref.read(driverOrdersRepositoryProvider);
      final order = await orderRepository.getOrderById(orderId);

      if (order == null) {
        print('⚠️ Could not fetch order $orderId');
        return;
      }

      // If we have assignmentId from notification, update the order
      DriverOrder orderWithAssignment = order;
      if (assignmentId != null && order.assignmentId == null) {
        orderWithAssignment = DriverOrder(
          id: order.id,
          orderNumber: order.orderNumber,
          customerId: order.customerId,
          customerName: order.customerName,
          customerPhone: order.customerPhone,
          deliveryAddress: order.deliveryAddress,
          buildingName: order.buildingName,
          floorNumber: order.floorNumber,
          apartmentNumber: order.apartmentNumber,
          status: order.status,
          statusName: order.statusName,
          totalAmount: order.totalAmount,
          createdAt: order.createdAt,
          deliveryTime: order.deliveryTime,
          items: order.items,
          assignmentId: assignmentId, // Add assignmentId
          isAssigned: true,
        );
      }

      // Add to available orders in UI
      print('✅ Adding order to available orders list');
      _ref
          .read(availableOrdersNotifierProvider.notifier)
          .addAssignment(orderWithAssignment);

      print('🎉 Order assignment handled successfully!');
    } catch (e) {
      print('❌ Error handling order assignment: $e');
    }
  }

  /// Dispose and clean up
  void dispose() {
    stopPolling();
  }
}
