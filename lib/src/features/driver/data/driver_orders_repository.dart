import 'package:dio/dio.dart';
import 'driver_order_model.dart';

class DriverOrdersRepository {
  final Dio _dio;

  DriverOrdersRepository(this._dio);

  /// Get paginated list of orders
  /// GET /MalDashApi/Order
  Future<List<DriverOrder>> getOrders({
    int page = 1,
    int limit = 10,
    String? status,
  }) async {
    try {
      print('Getting orders - page: $page, limit: $limit, status: $status');

      final queryParams = <String, dynamic>{'page': page, 'limit': limit};

      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }

      final response = await _dio.get('/Order', queryParameters: queryParams);

      print('Get orders response status: ${response.statusCode}');
      print('Get orders response data type: ${response.data.runtimeType}');
      print('Get orders response data: ${response.data}');

      if (response.data != null) {
        if (response.data is List) {
          final data = response.data as List;
          print('Orders list length: ${data.length}');
          return data.map((order) => DriverOrder.fromJson(order)).toList();
        } else if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          print('Orders response keys: ${data.keys.toList()}');

          // Check for nested data structure
          if (data.containsKey('orders') && data['orders'] is List) {
            final orders = data['orders'] as List;
            return orders.map((order) => DriverOrder.fromJson(order)).toList();
          } else if (data.containsKey('data') && data['data'] is List) {
            final orders = data['data'] as List;
            return orders.map((order) => DriverOrder.fromJson(order)).toList();
          } else if (data.containsKey('items') && data['items'] is List) {
            final orders = data['items'] as List;
            return orders.map((order) => DriverOrder.fromJson(order)).toList();
          }
        }
      }

      return [];
    } catch (e) {
      print('Error getting orders: $e');
      return [];
    }
  }

  /// Get order by ID
  /// GET /MalDashApi/Order/{id}
  Future<DriverOrder?> getOrderById(int id) async {
    try {
      print('Getting order by ID: $id');

      final response = await _dio.get('/Order/$id');

      print('Get order response status: ${response.statusCode}');
      print('Get order response data type: ${response.data.runtimeType}');
      print('Get order response data: ${response.data}');

      if (response.data != null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        print('Order response keys: ${data.keys.toList()}');
        return DriverOrder.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error getting order by ID: $e');
      rethrow;
    }
  }

  /// Get order by order number
  /// GET /MalDashApi/Order/number/{orderNumber}
  Future<DriverOrder?> getOrderByNumber(String orderNumber) async {
    try {
      print('Getting order by number: $orderNumber');

      final response = await _dio.get('/Order/number/$orderNumber');

      print('Get order by number response status: ${response.statusCode}');
      print('Get order by number response data: ${response.data}');

      if (response.data != null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        print('Order by number response keys: ${data.keys.toList()}');
        return DriverOrder.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error getting order by number: $e');
      rethrow;
    }
  }

  /// Update order status
  /// PUT /MalDashApi/Order/{id}/status
  Future<bool> updateOrderStatus(int id, int status) async {
    try {
      print('Updating order status - ID: $id, Status: $status');

      final request = UpdateOrderStatusRequest(status: status);

      final response = await _dio.put(
        '/Order/$id/status',
        data: request.toJson(),
        options: Options(contentType: Headers.jsonContentType),
      );

      print('Update order status response status: ${response.statusCode}');
      print('Update order status response data: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating order status: $e');
      rethrow;
    }
  }
}
