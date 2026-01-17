import 'package:dio/dio.dart';
import 'driver_shift_model.dart';

class DriverShiftRepository {
  final Dio _dio;

  DriverShiftRepository(this._dio);

  /// Start a new driver shift
  /// POST /MalDashApi/DriverShift/start
  Future<DriverShift?> startShift() async {
    try {
      print('Starting driver shift...');

      final response = await _dio.post('/DriverShift/start');

      print('Start shift response status: ${response.statusCode}');
      print('Start shift response data type: ${response.data.runtimeType}');
      print('Start shift response data: ${response.data}');

      if (response.data != null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        print('Start shift response keys: ${data.keys.toList()}');
        return DriverShift.fromJson(data);
      }

      // Return a default active shift if no data returned
      return DriverShift(isActive: true, startTime: DateTime.now());
    } catch (e) {
      print('Error starting shift: $e');
      rethrow;
    }
  }

  /// End the current driver shift
  /// POST /MalDashApi/DriverShift/end
  Future<bool> endShift() async {
    try {
      print('Ending driver shift...');

      final response = await _dio.post('/DriverShift/end');

      print('End shift response status: ${response.statusCode}');
      print('End shift response data: ${response.data}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error ending shift: $e');
      rethrow;
    }
  }

  /// Get current active shift
  /// GET /MalDashApi/DriverShift/current
  Future<DriverShift?> getCurrentShift() async {
    try {
      print('Getting current shift...');

      final response = await _dio.get('/DriverShift/current');

      print('Get current shift response status: ${response.statusCode}');
      print(
        'Get current shift response data type: ${response.data.runtimeType}',
      );
      print('Get current shift response data: ${response.data}');

      if (response.data != null && response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        print('Current shift response keys: ${data.keys.toList()}');
        return DriverShift.fromJson(data);
      }

      return null;
    } catch (e) {
      print('Error getting current shift: $e');
      // Return inactive shift on error
      return DriverShift(isActive: false);
    }
  }

  /// Get driver's queue position
  /// GET /MalDashApi/DriverShift/queue-position
  Future<QueuePosition?> getQueuePosition() async {
    try {
      print('Getting queue position...');

      final response = await _dio.get('/DriverShift/queue-position');

      print('Queue position response status: ${response.statusCode}');
      print('Queue position response data type: ${response.data.runtimeType}');
      print('Queue position response data: ${response.data}');

      if (response.data != null) {
        if (response.data is Map<String, dynamic>) {
          final data = response.data as Map<String, dynamic>;
          print('Queue position response keys: ${data.keys.toList()}');
          return QueuePosition.fromJson(data);
        } else if (response.data is int) {
          // If response is just a number, assume it's the position
          return QueuePosition(position: response.data as int, totalDrivers: 0);
        }
      }

      return null;
    } catch (e) {
      print('Error getting queue position: $e');
      return null;
    }
  }
}
